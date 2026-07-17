import 'package:flutter_test/flutter_test.dart';
import 'package:taskwarrior/app/models/report.dart';
import 'package:taskwarrior/app/services/report_service.dart';
import 'package:taskwarrior/app/utils/taskc/taskrc_parser.dart';
import 'package:taskwarrior/app/utils/taskc/virtual_filter_engine.dart';
import 'package:taskwarrior/app/v3/champion/models/task_for_replica.dart';

void main() {
  final DateTime now = DateTime.utc(2024, 6, 1, 12);

  TaskForReplica task(
    String uuid, {
    String status = 'pending',
    String? start,
    String? wait,
    String? due,
    String? priority,
    String? project,
    bool? isBlocked,
    bool? isBlocking,
    List<String>? tags,
  }) =>
      TaskForReplica(
        uuid: uuid,
        status: status,
        start: start,
        wait: wait,
        due: due,
        priority: priority,
        project: project,
        isBlocked: isBlocked,
        isBlocking: isBlocking,
        tags: tags,
      );

  final active = task('active', start: now.toIso8601String(), priority: 'H');
  final ready = task('ready', priority: 'M');
  final blocked = task('blocked', isBlocked: true);
  final overdue =
      task('overdue', due: now.subtract(const Duration(days: 2)).toIso8601String());
  final waiting =
      task('waiting', wait: now.add(const Duration(days: 5)).toIso8601String());
  final completed = task('completed', status: 'completed');
  final recurring = task('recurring', status: 'recurring');
  final work = task('work', project: 'work', tags: ['office']);

  final all = [
    active,
    ready,
    blocked,
    overdue,
    waiting,
    completed,
    recurring,
    work
  ];

  Set<String> ids(List<TaskForReplica> list) =>
      list.map((t) => t.uuid).toSet();

  group('VirtualFilterEngine — virtual tags', () {
    test('+ACTIVE = pending with a start date', () {
      expect(ids(VirtualFilterEngine.applyFilter(all, '+ACTIVE', now: now)),
          {'active'});
    });

    test('+BLOCKED = has unresolved dependencies', () {
      expect(ids(VirtualFilterEngine.applyFilter(all, '+BLOCKED', now: now)),
          {'blocked'});
    });

    test('+OVERDUE = due date in the past', () {
      expect(ids(VirtualFilterEngine.applyFilter(all, '+OVERDUE', now: now)),
          {'overdue'});
    });

    test('+WAITING = a future wait date', () {
      expect(ids(VirtualFilterEngine.applyFilter(all, '+WAITING', now: now)),
          {'waiting'});
    });

    test('+READY = pending, not blocked, not waiting', () {
      // active/ready/overdue/work are all pending, unblocked, no future wait.
      expect(ids(VirtualFilterEngine.applyFilter(all, '+READY', now: now)),
          {'active', 'ready', 'overdue', 'work'});
    });
  });

  group('VirtualFilterEngine — attributes, negation, compound', () {
    test('status: attribute', () {
      expect(
          ids(VirtualFilterEngine.applyFilter(all, 'status:completed', now: now)),
          {'completed'});
    });

    test('project: prefix match', () {
      expect(ids(VirtualFilterEngine.applyFilter(all, 'project:work', now: now)),
          {'work'});
    });

    test('priority: attribute', () {
      expect(
          ids(VirtualFilterEngine.applyFilter(all, 'priority:H', now: now)),
          {'active'});
    });

    test('negation excludes matches', () {
      expect(
          VirtualFilterEngine.applyFilter(all, '-BLOCKED', now: now)
              .any((t) => t.uuid == 'blocked'),
          isFalse);
    });

    test('compound expression is AND of all tokens', () {
      expect(
          ids(VirtualFilterEngine.applyFilter(all, 'status:pending +ACTIVE',
              now: now)),
          {'active'});
    });

    test('a real user tag matches', () {
      expect(ids(VirtualFilterEngine.applyFilter(all, '+office', now: now)),
          {'work'});
    });

    test('empty/blank filter matches everything', () {
      expect(VirtualFilterEngine.applyFilter(all, '', now: now).length,
          all.length);
      expect(VirtualFilterEngine.applyFilter(all, null, now: now).length,
          all.length);
    });
  });

  group('ReportService.execute', () {
    ReportDefinition report(String name) =>
        ReportService.defaultReports.firstWhere((r) => r.name == name);

    test('next → all pending tasks', () {
      final result = ReportService.execute(report('next'), all, clock: now);
      // 'waiting' has status:pending (a future wait, not a separate status), so
      // it is included by the status:pending filter.
      expect(ids(result),
          {'active', 'ready', 'blocked', 'overdue', 'waiting', 'work'});
    });

    test('overdue → only past-due pending tasks', () {
      final result = ReportService.execute(report('overdue'), all, clock: now);
      expect(ids(result), {'overdue'});
    });

    test('completed → only completed tasks', () {
      final result = ReportService.execute(report('completed'), all, clock: now);
      expect(ids(result), {'completed'});
    });

    test('all → every task, sorted urgency- (highest first)', () {
      final result = ReportService.execute(report('all'), all, clock: now);
      expect(result.length, all.length);
      // urgency descending: each task's urgency >= the next.
      for (var i = 0; i + 1 < result.length; i++) {
        expect(result[i].computeUrgency(clock: now),
            greaterThanOrEqualTo(result[i + 1].computeUrgency(clock: now)));
      }
    });

    test('multi-key sort respects criterion order', () {
      final r = ReportDefinition(
        name: 'x',
        description: 'x',
        filterExpression: 'status:pending',
        sortCriteria: SortCriterion.parseList('priority-,description+'),
      );
      final result = ReportService.execute(r, all, clock: now);
      // 'active' is the only H-priority pending task → sorts first.
      expect(result.first.uuid, 'active');
    });
  });

  group('ReportService.availableReports', () {
    test('custom reports come first', () {
      final custom = [
        const ReportDefinition(
            name: 'mine', description: 'Mine', isCustom: true),
      ];
      final list = ReportService.availableReports(custom);
      expect(list.first.name, 'mine');
      expect(list.length, ReportService.defaultReports.length + 1);
    });

    test('a custom report overrides a same-named default', () {
      final custom = [
        const ReportDefinition(
            name: 'next', description: 'Custom next', isCustom: true),
      ];
      final list = ReportService.availableReports(custom);
      final nexts = list.where((r) => r.name == 'next').toList();
      expect(nexts.length, 1);
      expect(nexts.first.isCustom, isTrue);
      expect(list.length, ReportService.defaultReports.length);
    });
  });

  group('TaskrcParser', () {
    test('extracts reports that have a .sort, ignores those without', () {
      final parser = TaskrcParser();
      parser.parse('''
# a comment
report.mine.description=My active work
report.mine.filter=status:pending +ACTIVE
report.mine.sort=due+,urgency-
report.mine.columns=id,description,due

report.nosort.filter=status:pending
''');
      final reports = parser.customReports();
      expect(reports.length, 1);
      final mine = reports.single;
      expect(mine.name, 'mine');
      expect(mine.description, 'My active work');
      expect(mine.filterExpression, 'status:pending +ACTIVE');
      expect(mine.isCustom, isTrue);
      expect(mine.sortCriteria.map((s) => '${s.field}${s.ascending ? '+' : '-'}'),
          ['due+', 'urgency-']);
      expect(mine.columns.map((c) => c.field), ['id', 'description', 'due']);
    });

    test('ignores comments and blank lines', () {
      final parser = TaskrcParser();
      parser.parse('\n\n#only comments\n# report.x.sort=due\n');
      expect(parser.customReports(), isEmpty);
    });
  });

  group('SortCriterion.parseList', () {
    test('parses direction suffixes and chains', () {
      final list = SortCriterion.parseList('urgency-,due+,project');
      expect(list.map((s) => s.field), ['urgency', 'due', 'project']);
      expect(list.map((s) => s.ascending), [false, true, true]);
    });
  });
}
