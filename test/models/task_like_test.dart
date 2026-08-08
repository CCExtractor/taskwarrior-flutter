import 'package:flutter_test/flutter_test.dart';
import 'package:taskwarrior/app/models/report.dart';
import 'package:taskwarrior/app/models/task_like.dart';
import 'package:taskwarrior/app/models/task_urgency.dart';
import 'package:taskwarrior/app/services/report_service.dart';
import 'package:taskwarrior/app/utils/taskchampion/virtual_filter_engine.dart';
import 'package:taskwarrior/app/v3/champion/models/task_for_replica.dart';
import 'package:taskwarrior/app/v3/models/annotation.dart';
import 'package:taskwarrior/app/v3/models/task.dart';

/// Edge-case coverage for the unified task model (the [TaskLike] contract that
/// both TaskForC and TaskForReplica implement), the shared date normalization,
/// and the shared logic now generic over both models.
void main() {
  final DateTime now = DateTime.utc(2024, 6, 1, 12);
  int epoch(DateTime d) => d.millisecondsSinceEpoch ~/ 1000;

  /// Builds a local/Taskserver task. Every field is required on this model, so
  /// the helper supplies neutral defaults.
  TaskForC forC({
    int id = 1,
    String description = 'desc',
    String? project,
    String status = 'pending',
    String? uuid = 'u1',
    double? urgency,
    String? priority,
    String? due,
    String? end,
    String entry = '20240101T000000Z',
    String? modified,
    List<String>? tags,
    String? start,
    String? wait,
    String? rtype,
    String? recur,
    List<String>? depends,
    List<Annotation>? annotations,
  }) =>
      TaskForC(
        id: id,
        description: description,
        project: project,
        status: status,
        uuid: uuid,
        urgency: urgency,
        priority: priority,
        due: due,
        end: end,
        entry: entry,
        modified: modified,
        tags: tags,
        start: start,
        wait: wait,
        rtype: rtype,
        recur: recur,
        depends: depends,
        annotations: annotations,
      );

  group('parseTaskDate — format handling', () {
    test('parses ISO-8601 and normalizes to UTC', () {
      expect(parseTaskDate('2024-06-01T12:00:00Z'), DateTime.utc(2024, 6, 1, 12));
    });

    test('converts a non-UTC ISO offset to UTC', () {
      // 12:00+02:00 is 10:00 UTC.
      expect(parseTaskDate('2024-06-01T12:00:00+02:00'),
          DateTime.utc(2024, 6, 1, 10));
    });

    test("parses Taskwarrior's compact stamp", () {
      expect(parseTaskDate('20240701T161718Z'),
          DateTime.utc(2024, 7, 1, 16, 17, 18));
    });

    test('parses the compact stamp without a trailing Z', () {
      expect(parseTaskDate('20240701T161718'),
          DateTime.utc(2024, 7, 1, 16, 17, 18));
    });

    test('parses epoch seconds given as a string', () {
      final d = DateTime.utc(2024, 6, 1, 12);
      expect(parseTaskDate('${epoch(d)}'), d);
    });

    test('a short numeric string is not mistaken for epoch seconds', () {
      // Regression guard: without the minimum-digit check, '2024' would be
      // read as epoch seconds and silently become 1970-01-01T00:33:44Z.
      // Dart's ISO parser rejects a bare year, so the honest answer is null —
      // we never invent a date from an ambiguous value.
      expect(parseTaskDate('2024'), isNull);
      expect(parseTaskDate('2024'), isNot(DateTime.utc(1970, 1, 1, 0, 33, 44)));
    });

    test('surrounding whitespace is tolerated', () {
      expect(parseTaskDate('  2024-06-01T12:00:00Z  '),
          DateTime.utc(2024, 6, 1, 12));
    });

    test('returns null for null, empty, and unparseable input', () {
      expect(parseTaskDate(null), isNull);
      expect(parseTaskDate(''), isNull);
      expect(parseTaskDate('not-a-date'), isNull);
      expect(parseTaskDate('   '), isNull);
    });

    test('epochToDate handles null and zero', () {
      expect(epochToDate(null), isNull);
      expect(epochToDate(0), DateTime.utc(1970));
    });
  });

  group('TaskLike — both models satisfy the contract', () {
    test('TaskForReplica normalizes its epoch entry/modified', () {
      final d = DateTime.utc(2024, 3, 4, 5, 6, 7);
      final t = TaskForReplica(uuid: 'u', entry: epoch(d), modified: epoch(d));
      expect(t.entryDate, d);
      expect(t.modifiedDate, d);
    });

    test('TaskForC normalizes its string entry/modified', () {
      final t = forC(entry: '20240304T050607Z', modified: '20240304T050607Z');
      expect(t.entryDate, DateTime.utc(2024, 3, 4, 5, 6, 7));
      expect(t.modifiedDate, DateTime.utc(2024, 3, 4, 5, 6, 7));
    });

    test('TaskForC reports blocking state as unknown (null), not false', () {
      // The local path cannot resolve dependencies, so it must not claim a
      // definite answer — consumers treat null as "not blocked".
      final t = forC(depends: ['other-uuid']);
      expect(t.isBlocked, isNull);
      expect(t.isBlocking, isNull);
    });

    test('a null modified yields a null modifiedDate on both models', () {
      expect(forC(modified: null).modifiedDate, isNull);
      expect(TaskForReplica(uuid: 'u').modifiedDate, isNull);
    });

    test('both models are usable through the TaskLike contract', () {
      final List<TaskLike> mixed = [
        forC(uuid: 'c1', description: 'from local'),
        TaskForReplica(uuid: 'r1', description: 'from replica'),
      ];
      expect(mixed.map((t) => t.description),
          ['from local', 'from replica']);
    });
  });

  group('Cross-model equivalence — the point of the consolidation', () {
    // The same logical task, expressed in each model's own storage format.
    final DateTime entryAt = now.subtract(const Duration(days: 10));
    final DateTime dueAt = now.subtract(const Duration(days: 2));

    final replica = TaskForReplica(
      uuid: 'same',
      description: 'shared task',
      status: 'pending',
      project: 'work',
      priority: 'H',
      tags: ['a', 'b'],
      entry: epoch(entryAt),
      due: dueAt.toIso8601String(),
    );
    final local = forC(
      uuid: 'same',
      description: 'shared task',
      status: 'pending',
      project: 'work',
      priority: 'H',
      tags: ['a', 'b'],
      entry: entryAt.toIso8601String(),
      due: dueAt.toIso8601String(),
    );

    test('identical tasks get identical urgency across models', () {
      expect(computeTaskUrgency(local, clock: now),
          closeTo(computeTaskUrgency(replica, clock: now), 1e-9));
    });

    test('identical tasks match the same filters across models', () {
      for (final expr in [
        'status:pending',
        '+PENDING',
        '+OVERDUE',
        'project:work',
        'priority:H',
        '+a',
        '-BLOCKED',
        'status:pending +OVERDUE project:work',
      ]) {
        expect(VirtualFilterEngine.applyFilter([local], expr, now: now).length,
            VirtualFilterEngine.applyFilter([replica], expr, now: now).length,
            reason: 'filter "$expr" disagreed across models');
      }
    });

    test('a report yields the same verdict for either model', () {
      final overdue =
          ReportService.defaultReports.firstWhere((r) => r.name == 'overdue');
      expect(ReportService.execute(overdue, [local], clock: now).length, 1);
      expect(ReportService.execute(overdue, [replica], clock: now).length, 1);
    });
  });

  group('Shared logic now works for the local model', () {
    test('reports run over TaskForC and preserve its concrete type', () {
      final next =
          ReportService.defaultReports.firstWhere((r) => r.name == 'next');
      final List<TaskForC> result = ReportService.execute(
        next,
        [forC(uuid: 'a'), forC(uuid: 'b', status: 'completed')],
        clock: now,
      );
      // Generic execute() must return List<TaskForC>, not List<TaskLike>.
      expect(result, isA<List<TaskForC>>());
      expect(result.map((t) => t.uuid), ['a']);
    });

    test('+BLOCKED excludes local tasks, whose blocking state is unknown', () {
      final result = VirtualFilterEngine.applyFilter(
          [forC(depends: ['x'])], '+BLOCKED', now: now);
      expect(result, isEmpty);
    });

    test('+READY includes a local pending task (unknown block == not blocked)',
        () {
      expect(
          VirtualFilterEngine.applyFilter([forC()], '+READY', now: now).length,
          1);
    });

    test('urgency ranks local tasks by priority', () {
      final high = forC(priority: 'H');
      final low = forC(priority: 'L');
      expect(computeTaskUrgency(high, clock: now),
          greaterThan(computeTaskUrgency(low, clock: now)));
    });
  });

  group('Sorting edge cases', () {
    ReportDefinition sortBy(String spec) => ReportDefinition(
          name: 'x',
          description: 'x',
          sortCriteria: SortCriterion.parseList(spec),
        );

    test('entry sort works across both storage formats', () {
      final older = TaskForReplica(
          uuid: 'older', entry: epoch(now.subtract(const Duration(days: 5))));
      final newer = TaskForReplica(uuid: 'newer', entry: epoch(now));
      final asc =
          ReportService.execute(sortBy('entry+'), [newer, older], clock: now);
      expect(asc.map((t) => t.uuid), ['older', 'newer']);
    });

    test('tasks with a missing date sort before those that have one', () {
      final withDate = TaskForReplica(uuid: 'has', entry: epoch(now));
      final without = TaskForReplica(uuid: 'none');
      final asc = ReportService.execute(
          sortBy('entry+'), [withDate, without], clock: now);
      expect(asc.first.uuid, 'none');
    });

    test('a task with a null uuid does not break urgency caching', () {
      // The cache is keyed by uuid; null uuids must not collide with each
      // other, or two distinct tasks would share one urgency value.
      final a = forC(uuid: null, priority: 'H');
      final b = forC(uuid: null, priority: 'L');
      final sorted =
          ReportService.execute(sortBy('urgency-'), [b, a], clock: now);
      expect(sorted.first.priority, 'H');
    });

    test('an empty task list is handled everywhere', () {
      expect(ReportService.execute(sortBy('urgency-'), <TaskForC>[], clock: now),
          isEmpty);
      expect(VirtualFilterEngine.applyFilter(<TaskForC>[], '+READY', now: now),
          isEmpty);
    });

    test('an unknown sort field leaves the order untouched', () {
      final t1 = TaskForReplica(uuid: 'first');
      final t2 = TaskForReplica(uuid: 'second');
      final r = ReportService.execute(sortBy('nosuchfield+'), [t1, t2],
          clock: now);
      expect(r.map((t) => t.uuid), ['first', 'second']);
    });
  });

  group('Degenerate / all-null tasks', () {
    test('an all-null replica task has zero urgency and no dates', () {
      final t = TaskForReplica(uuid: 'bare');
      expect(computeTaskUrgency(t, clock: now), 0.0);
      expect(t.entryDate, isNull);
      expect(t.modifiedDate, isNull);
    });

    test('a task with an unparseable date is treated as having none', () {
      final t = forC(entry: 'garbage', due: 'also-garbage');
      expect(t.entryDate, isNull);
      // No due date parsed → no due term contributed to urgency.
      expect(computeTaskUrgency(t, clock: now), 0.0);
    });

    test('filters do not throw on tasks with null collections', () {
      final t = TaskForReplica(uuid: 'n');
      expect(() => VirtualFilterEngine.applyFilter([t], '+sometag', now: now),
          returnsNormally);
      expect(VirtualFilterEngine.applyFilter([t], '+sometag', now: now), isEmpty);
    });
  });
}
