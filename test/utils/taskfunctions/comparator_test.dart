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

    test('should compare tasks with same priority by due date (earlier first)', () {
      final taskEarly = createTask(priority: 'H', due: DateTime(2024, 1, 1));
      final taskLate = createTask(priority: 'H', due: DateTime(2024, 1, 10));

      final comparator = compareTasks('Priority');
      final comparatorPlus = compareTasks('Priority+');
      final comparatorMinus = compareTasks('Priority-');

      expect(comparator(taskEarly, taskLate), lessThan(0));
      expect(comparator(taskLate, taskEarly), greaterThan(0));

      expect(comparatorPlus(taskEarly, taskLate), lessThan(0));
      expect(comparatorPlus(taskLate, taskEarly), greaterThan(0));

      expect(comparatorMinus(taskEarly, taskLate), lessThan(0));
      expect(comparatorMinus(taskLate, taskEarly), greaterThan(0));
    });

    test('should sort tasks without due date after tasks with due date for same priority', () {
      final taskWithDue = createTask(priority: 'M', due: DateTime(2024, 1, 1));
      final taskWithoutDue = createTask(priority: 'M', due: null);

      final comparator = compareTasks('Priority');
      final comparatorPlus = compareTasks('Priority+');
      final comparatorMinus = compareTasks('Priority-');

      expect(comparator(taskWithDue, taskWithoutDue), lessThan(0));
      expect(comparator(taskWithoutDue, taskWithDue), greaterThan(0));

      expect(comparatorPlus(taskWithDue, taskWithoutDue), lessThan(0));
      expect(comparatorPlus(taskWithoutDue, taskWithDue), greaterThan(0));

      expect(comparatorMinus(taskWithDue, taskWithoutDue), lessThan(0));
      expect(comparatorMinus(taskWithoutDue, taskWithDue), greaterThan(0));
    });

    test('should return 0 when same priority and both missing due date', () {
      final task1 = createTask(priority: 'L', due: null);
      final task2 = createTask(priority: 'L', due: null);

      final comparator = compareTasks('Priority');
      final comparatorPlus = compareTasks('Priority+');
      final comparatorMinus = compareTasks('Priority-');

      expect(comparator(task1, task2), equals(0));
      expect(comparatorPlus(task1, task2), equals(0));
      expect(comparatorMinus(task1, task2), equals(0));
    });

    test('should handle null priority safely and break ties with due date', () {
      final taskNoPriorityEarly = createTask(priority: null, due: DateTime(2024, 1, 1));
      final taskNoPriorityLate = createTask(priority: null, due: DateTime(2024, 1, 10));
      final taskNoPriorityUndated = createTask(priority: null, due: null);
      final taskWithPriority = createTask(priority: 'H', due: null);

      final comparator = compareTasks('Priority');
      final comparatorPlus = compareTasks('Priority+');
      final comparatorMinus = compareTasks('Priority-');

      // Null priorities compared to each other should order by due date (earlier first)
      expect(comparator(taskNoPriorityEarly, taskNoPriorityLate), lessThan(0));
      expect(comparator(taskNoPriorityLate, taskNoPriorityEarly), greaterThan(0));
      expect(comparator(taskNoPriorityEarly, taskNoPriorityUndated), lessThan(0));

      expect(comparatorPlus(taskNoPriorityEarly, taskNoPriorityLate), lessThan(0));
      expect(comparatorMinus(taskNoPriorityEarly, taskNoPriorityLate), lessThan(0));

      // Null priority vs non-null priority
      // In Priority-: H precedes null
      expect(comparatorMinus(taskWithPriority, taskNoPriorityEarly), lessThan(0));
      expect(comparatorMinus(taskNoPriorityEarly, taskWithPriority), greaterThan(0));

      // In Priority+: null precedes H
      expect(comparatorPlus(taskNoPriorityEarly, taskWithPriority), lessThan(0));
      expect(comparatorPlus(taskWithPriority, taskNoPriorityEarly), greaterThan(0));
    });

    test('should compare tasks correctly in both Priority+ and Priority- directions', () {
      final taskH = createTask(priority: 'H');
      final taskM = createTask(priority: 'M');
      final taskL = createTask(priority: 'L');

      final comparatorPlus = compareTasks('Priority+');
      final comparatorMinus = compareTasks('Priority-');

      // Priority+: ascending (L < M < H)
      expect(comparatorPlus(taskL, taskM), lessThan(0));
      expect(comparatorPlus(taskM, taskH), lessThan(0));
      expect(comparatorPlus(taskH, taskL), greaterThan(0));

      // Priority-: descending (H > M > L)
      expect(comparatorMinus(taskH, taskM), lessThan(0));
      expect(comparatorMinus(taskM, taskL), lessThan(0));
      expect(comparatorMinus(taskL, taskH), greaterThan(0));
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
