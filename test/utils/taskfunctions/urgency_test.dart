import 'package:flutter_test/flutter_test.dart';
import 'package:taskwarrior/app/models/models.dart';
import 'package:taskwarrior/app/utils/taskfunctions/urgency.dart';
import 'package:built_collection/built_collection.dart';

void main() {
  group('Urgency Utils', () {
    late Task task;

    setUp(() {
      task = Task((b) => b
        ..uuid = '1'
        ..description = 'Test Task'
        ..entry = DateTime.now().subtract(const Duration(days: 30))
        ..modified = DateTime.now()
        ..status = 'pending'
        ..priority = 'M'
        ..tags = ListBuilder<String>(['next'])
        ..due = DateTime.now().subtract(
            const Duration(days: 8)) // Set due date to 8 days in the past
        ..scheduled = DateTime.now().subtract(const Duration(days: 2))
        ..wait = DateTime.now().add(const Duration(days: 1))
        ..project = 'Project1');
    });

    test('formatUrgency formats urgency correctly', () {
      expect(formatUrgency(15.0), '15');
      expect(formatUrgency(15.12345), '15.1');
      expect(formatUrgency(15.100), '15.1');
      expect(formatUrgency(15.10), '15.1');
    });

    test('urgencyProject calculates project urgency', () {
      expect(urgencyProject(task), 1.0);
    });

    test('urgencyScheduled calculates scheduled urgency', () {
      expect(urgencyScheduled(task), 1.0);
    });

    test('urgencyWaiting calculates waiting urgency', () {
      expect(urgencyWaiting(task), 1.0);
      task = task.rebuild(
          (b) => b..wait = DateTime.now().subtract(const Duration(days: 1)));
      expect(urgencyWaiting(task), 0.0);
    });

    test('urgencyTags calculates tags urgency', () {
      expect(urgencyTags(task), 0.8);
      task = task.rebuild((b) => b..tags = ListBuilder<String>(['tag1']));
      expect(urgencyTags(task), 0.8);
      task =
          task.rebuild((b) => b..tags = ListBuilder<String>(['tag1', 'tag2']));
      expect(urgencyTags(task), 0.9);
    });

    test('urgencyDue calculates due urgency', () {
      expect(urgencyDue(task), 1);
      task = task.rebuild(
          (b) => b..due = DateTime.now().subtract(const Duration(days: 10)));
      expect(urgencyDue(task), 1);
      task = task.rebuild(
          (b) => b..due = DateTime.now().add(const Duration(days: 10)));
      expect(urgencyDue(task), 0.352);
    });

    test('urgencyAge calculates age urgency', () {
      expect(urgencyAge(task), closeTo(0.082, 0.001));
      task = task.rebuild(
          (b) => b..entry = DateTime.now().subtract(const Duration(days: 365)));
      expect(urgencyAge(task), 1.0);
    });

    test('urgency calculates overall urgency', () {
      expect(urgency(task), closeTo(36.1, 2));
    });
  });
}
