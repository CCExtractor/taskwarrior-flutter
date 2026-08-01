import 'package:taskwarrior/app/models/report.dart';
import 'package:taskwarrior/app/utils/taskchampion/virtual_filter_engine.dart';
import 'package:taskwarrior/app/v3/champion/models/task_for_replica.dart';

/// The reporting engine (Issue #418): the default report catalogue plus the
/// executor that turns a [ReportDefinition] + a task list into a filtered,
/// sorted result.
class ReportService {
  /// Taskwarrior's core default reports (those with a `report.*.sort`).
  /// Filters use the [VirtualFilterEngine] vocabulary; note that under
  /// TaskChampion a "waiting" task is a pending task with a future `wait`
  /// (there is no distinct waiting status), so the waiting report uses the
  /// `+WAITING` virtual tag rather than `status:waiting`.
  static final List<ReportDefinition> defaultReports = <ReportDefinition>[
    ReportDefinition(
      name: 'next',
      description: 'Highest-urgency pending tasks',
      filterExpression: 'status:pending',
      sortCriteria: SortCriterion.parseList('urgency-'),
      columns: ColumnSpec.parseList('id,description,urgency'),
    ),
    ReportDefinition(
      name: 'active',
      description: 'Tasks with a start date set',
      filterExpression: 'status:pending +ACTIVE',
      sortCriteria: SortCriterion.parseList('urgency-'),
      columns: ColumnSpec.parseList('id,description,start'),
    ),
    ReportDefinition(
      name: 'ready',
      description: 'Pending, not waiting, not blocked',
      filterExpression: 'status:pending +READY',
      sortCriteria: SortCriterion.parseList('urgency-'),
      columns: ColumnSpec.parseList('id,description,urgency'),
    ),
    ReportDefinition(
      name: 'blocked',
      description: 'Tasks with unresolved dependencies',
      filterExpression: 'status:pending +BLOCKED',
      sortCriteria: SortCriterion.parseList('urgency-'),
      columns: ColumnSpec.parseList('id,description'),
    ),
    ReportDefinition(
      name: 'waiting',
      description: 'Deferred tasks with a wait date',
      filterExpression: '+WAITING',
      sortCriteria: SortCriterion.parseList('wait+'),
      columns: ColumnSpec.parseList('id,description,wait'),
    ),
    ReportDefinition(
      name: 'completed',
      description: 'Finished tasks',
      filterExpression: 'status:completed',
      sortCriteria: SortCriterion.parseList('modified-'),
      columns: ColumnSpec.parseList('id,description'),
    ),
    ReportDefinition(
      name: 'recurring',
      description: 'Recurrence templates',
      filterExpression: 'status:recurring',
      sortCriteria: SortCriterion.parseList('due+'),
      columns: ColumnSpec.parseList('id,description,recur'),
    ),
    ReportDefinition(
      name: 'overdue',
      description: 'Past-due tasks',
      filterExpression: 'status:pending +OVERDUE',
      sortCriteria: SortCriterion.parseList('due+'),
      columns: ColumnSpec.parseList('id,description,due'),
    ),
    ReportDefinition(
      name: 'all',
      description: 'Every task in the replica',
      filterExpression: null,
      sortCriteria: SortCriterion.parseList('urgency-'),
      columns: ColumnSpec.parseList('id,description,status'),
    ),
  ];

  /// Lists reports for the picker: user-defined (from `.taskrc`) first, then the
  /// defaults. A custom report with the same name as a default overrides it.
  static List<ReportDefinition> availableReports(
      [List<ReportDefinition> customReports = const []]) {
    final Set<String> customNames = customReports.map((r) => r.name).toSet();
    return <ReportDefinition>[
      ...customReports,
      ...defaultReports.where((r) => !customNames.contains(r.name)),
    ];
  }

  /// Runs a report over [tasks]: apply its filter, then its (multi-key) sort.
  /// [clock] anchors time-relative logic (urgency, `+OVERDUE`) for determinism.
  static List<TaskForReplica> execute(
    ReportDefinition report,
    List<TaskForReplica> tasks, {
    DateTime? clock,
  }) {
    final DateTime now = (clock ?? DateTime.now()).toUtc();

    final List<TaskForReplica> filtered = VirtualFilterEngine.applyFilter(
      tasks,
      report.filterExpression,
      now: now,
    );

    // Urgency is comparatively expensive; compute once per task.
    final Map<String, double> urgencyCache = <String, double>{};
    double urgencyOf(TaskForReplica t) =>
        urgencyCache.putIfAbsent(t.uuid, () => t.computeUrgency(clock: now));

    final List<TaskForReplica> sorted = List<TaskForReplica>.from(filtered);
    sorted.sort((a, b) {
      for (final SortCriterion c in report.sortCriteria) {
        final int cmp = _compareField(a, b, c.field, urgencyOf);
        if (cmp != 0) return c.ascending ? cmp : -cmp;
      }
      return 0;
    });
    return sorted;
  }

  static int _compareField(
    TaskForReplica a,
    TaskForReplica b,
    String field,
    double Function(TaskForReplica) urgencyOf,
  ) {
    switch (field) {
      case 'urgency':
        return urgencyOf(a).compareTo(urgencyOf(b));
      case 'due':
        return _s(a.due).compareTo(_s(b.due));
      case 'wait':
        return _s(a.wait).compareTo(_s(b.wait));
      case 'start':
        return _s(a.start).compareTo(_s(b.start));
      case 'entry':
        return (a.entry ?? 0).compareTo(b.entry ?? 0);
      case 'modified':
        return (a.modified ?? 0).compareTo(b.modified ?? 0);
      case 'priority':
        return _priorityRank(a.priority).compareTo(_priorityRank(b.priority));
      case 'project':
        return _s(a.project).compareTo(_s(b.project));
      case 'description':
        return _s(a.description).toLowerCase().compareTo(
              _s(b.description).toLowerCase(),
            );
      case 'status':
        return _s(a.status).compareTo(_s(b.status));
      default:
        return 0;
    }
  }

  static String _s(String? v) => v ?? '';

  static int _priorityRank(String? p) {
    switch (p) {
      case 'H':
        return 3;
      case 'M':
        return 2;
      case 'L':
        return 1;
      default:
        return 0;
    }
  }
}
