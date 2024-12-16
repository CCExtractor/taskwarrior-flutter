import 'package:flutter_test/flutter_test.dart';
import 'package:taskwarrior/app/models/json/task.dart';
import 'package:taskwarrior/app/utils/taskfunctions/comparator.dart';

void main() {
  group('compareTasks', () {
    Task createTask(
        {DateTime? entry,
        DateTime? modified,
        DateTime? start,
        DateTime? due,
        String? priority,
        String? project,
        List<String>? tags}) {
      return Task((b) => b
        ..uuid = '1'
        ..description = 'Task'
        ..entry = entry ?? DateTime.now()
        ..modified = modified
        ..start = start
        ..due = due
        ..priority = priority
        ..project = project
        ..status = 'pending');
    }

    test('should compare tasks by Created date', () {
      final task1 = createTask(entry: DateTime(2022, 1, 1));
      final task2 = createTask(entry: DateTime(2023, 1, 1));

      final comparator = compareTasks('Created');
      expect(comparator(task1, task2), lessThan(0));
      expect(comparator(task2, task1), greaterThan(0));
    });

    test('should compare tasks by Modified date', () {
      final task1 = createTask(modified: DateTime(2022, 1, 1));
      final task2 = createTask(modified: DateTime(2023, 1, 1));

      final comparator = compareTasks('Modified');
      expect(comparator(task1, task2), lessThan(0));
      expect(comparator(task2, task1), greaterThan(0));
      expect(comparator(task1, task1), equals(0));
    });

    test('should compare tasks by Start Time', () {
      final task1 = createTask(start: DateTime(2022, 1, 1));
      final task2 = createTask(start: DateTime(2023, 1, 1));

      final comparator = compareTasks('Start Time');
      expect(comparator(task1, task2), lessThan(0));
      expect(comparator(task2, task1), greaterThan(0));
    });

    test('should compare tasks by Due till', () {
      final task1 = createTask(due: DateTime(2022, 1, 1));
      final task2 = createTask(due: DateTime(2023, 1, 1));

      final comparator = compareTasks('Due till');
      expect(comparator(task1, task2), lessThan(0));
      expect(comparator(task2, task1), greaterThan(0));
    });

    test('should compare tasks by Priority', () {
      final task1 = createTask(priority: 'H');
      final task2 = createTask(priority: 'L');

      final comparator = compareTasks('Priority');
      expect(comparator(task1, task2), greaterThan(0));
      expect(comparator(task2, task1), lessThan(0));
    });

    test('should compare tasks by Project', () {
      final task1 = createTask(project: 'ProjectA');
      final task2 = createTask(project: 'ProjectB');

      final comparator = compareTasks('Project');
      expect(comparator(task1, task2), lessThan(0));
      expect(comparator(task2, task1), greaterThan(0));
    });

    test('should compare tasks by Tags', () {
      final task1 = createTask(tags: ['Tag1', 'Tag2']);
      final task2 = createTask(tags: ['Tag1', 'Tag3']);

      final comparator = compareTasks('Tags');
      expect(comparator(task1, task2), 0);
    });

    test('should compare tasks by Urgency', () {
      final task1 = createTask();
      final task2 = createTask();

      final comparator = compareTasks('Urgency');
      expect(comparator(task1, task2), equals(0));
    });

    test('should return 1 for unknown column', () {
      final task1 = createTask();
      final task2 = createTask();

      final comparator = compareTasks('Unknown');
      expect(comparator(task1, task2), equals(1));
    });
  });
}
