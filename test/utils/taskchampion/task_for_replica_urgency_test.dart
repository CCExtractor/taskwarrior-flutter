import 'package:flutter_test/flutter_test.dart';
import 'package:taskwarrior/app/v3/champion/models/task_for_replica.dart';
import 'package:taskwarrior/app/v3/models/annotation.dart';

/// Verifies [TaskForReplica.computeUrgency] against Taskwarrior's documented
/// default urgency coefficients. A fixed [now] makes the age/due/waiting terms
/// deterministic.
void main() {
  final DateTime now = DateTime.utc(2024, 6, 1, 12);
  int epoch(DateTime d) => d.millisecondsSinceEpoch ~/ 1000;
  double u(TaskForReplica t) => t.computeUrgency(clock: now);

  group('TaskForReplica.computeUrgency', () {
    test('an empty task has zero urgency', () {
      expect(u(TaskForReplica(uuid: 'u')), 0.0);
    });

    test('priority H / M / L → 6.0 / 3.9 / 1.8', () {
      expect(u(TaskForReplica(uuid: 'u', priority: 'H')), closeTo(6.0, 1e-9));
      expect(u(TaskForReplica(uuid: 'u', priority: 'M')), closeTo(3.9, 1e-9));
      expect(u(TaskForReplica(uuid: 'u', priority: 'L')), closeTo(1.8, 1e-9));
    });

    test('belonging to a project adds 1.0', () {
      expect(u(TaskForReplica(uuid: 'u', project: 'Home')), closeTo(1.0, 1e-9));
    });

    test('an active (started) task adds 4.0', () {
      expect(u(TaskForReplica(uuid: 'u', start: now.toIso8601String())),
          closeTo(4.0, 1e-9));
    });

    test('tag counts 1 / 2 / 3 → 0.8 / 0.9 / 1.0', () {
      expect(u(TaskForReplica(uuid: 'u', tags: ['a'])), closeTo(0.8, 1e-9));
      expect(u(TaskForReplica(uuid: 'u', tags: ['a', 'b'])), closeTo(0.9, 1e-9));
      expect(
          u(TaskForReplica(uuid: 'u', tags: ['a', 'b', 'c'])), closeTo(1.0, 1e-9));
    });

    test('the "next" tag adds 15.0 on top of its tag-count term', () {
      expect(u(TaskForReplica(uuid: 'u', tags: ['next'])), closeTo(15.8, 1e-9));
    });

    test('annotation counts 1 / 2 / 3 → 0.8 / 0.9 / 1.0', () {
      Annotation a(String d) => Annotation(description: d);
      expect(u(TaskForReplica(uuid: 'u', annotations: [a('1')])),
          closeTo(0.8, 1e-9));
      expect(u(TaskForReplica(uuid: 'u', annotations: [a('1'), a('2')])),
          closeTo(0.9, 1e-9));
      expect(u(TaskForReplica(uuid: 'u', annotations: [a('1'), a('2'), a('3')])),
          closeTo(1.0, 1e-9));
    });

    test('blocking adds 8.0, blocked subtracts 5.0', () {
      expect(u(TaskForReplica(uuid: 'u', isBlocking: true)), closeTo(8.0, 1e-9));
      expect(u(TaskForReplica(uuid: 'u', isBlocked: true)), closeTo(-5.0, 1e-9));
    });

    test('a future wait date subtracts 3.0', () {
      expect(
          u(TaskForReplica(
              uuid: 'u',
              wait: now.add(const Duration(days: 1)).toIso8601String())),
          closeTo(-3.0, 1e-9));
    });

    test('due ≥7 days overdue → full 12.0', () {
      final due = now.subtract(const Duration(days: 10)).toIso8601String();
      expect(u(TaskForReplica(uuid: 'u', due: due)), closeTo(12.0, 1e-9));
    });

    test('due exactly now → 8.8', () {
      expect(u(TaskForReplica(uuid: 'u', due: now.toIso8601String())),
          closeTo(8.8, 1e-9));
    });

    test('due more than 14 days out → 2.4', () {
      final due = now.add(const Duration(days: 20)).toIso8601String();
      expect(u(TaskForReplica(uuid: 'u', due: due)), closeTo(2.4, 1e-9));
    });

    test('entry 365 days ago → full age term 2.0', () {
      final e = epoch(now.subtract(const Duration(days: 365)));
      expect(u(TaskForReplica(uuid: 'u', entry: e)), closeTo(2.0, 1e-9));
    });

    test('terms combine additively (H + project + 2 tags + overdue)', () {
      final due = now.subtract(const Duration(days: 8)).toIso8601String();
      final task = TaskForReplica(
        uuid: 'u',
        priority: 'H', // 6.0
        project: 'X', // 1.0
        tags: ['a', 'b'], // 0.9
        due: due, // 12.0
      );
      expect(u(task), closeTo(19.9, 1e-9));
    });
  });
}
