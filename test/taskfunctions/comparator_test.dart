import 'package:test/test.dart';
import 'package:taskwarrior/app/utils/taskfunctions/comparator.dart';
import 'package:taskwarrior/app/models/json/task.dart';

void main() {
  final task1 = Task((builder) => builder
    ..entry = DateTime(2024, 7, 20)
    ..modified = DateTime(2024, 7, 21)
    ..start = DateTime(2024, 7, 22)
    ..due = DateTime(2024, 7, 23)
    ..priority = 'H'
    ..project = 'Project A'
    ..tags.replace(['tag1', 'tag2'])
    ..status = 'pending'
    ..uuid = 'uuid1'
    ..description = 'Task 1 Description'
  );

  final task2 = Task((builder) => builder
    ..entry = DateTime(2024, 7, 19)
    ..modified = DateTime(2024, 7, 18)
    ..start = DateTime(2024, 7, 21)
    ..due = DateTime(2024, 7, 22)
    ..priority = 'L'
    ..project = 'Project B'
    ..tags.replace(['tag1'])
    ..status = 'pending'
    ..uuid = 'uuid2'
    ..description = 'Task 2 Description'
  );

  test('Test compareTasks for Created column', () {
    final compare = compareTasks('Created');
    expect(compare(task1, task2), greaterThan(0));
  });

  test('Test compareTasks for Modified column', () {
    final compare = compareTasks('Modified');
    expect(compare(task1, task2), greaterThan(0));
  });

  test('Test compareTasks for Start Time column', () {
    final compare = compareTasks('Start Time');
    expect(compare(task1, task2), greaterThan(0));
  });

  test('Test compareTasks for Priority column', () {
    final compare = compareTasks('Priority');
    expect(compare(task1, task2), greaterThan(0));
  });

  test('Test compareTasks for Project column', () {
    final compare = compareTasks('Project');
    expect(compare(task1, task2), lessThan(0));
  });

  test('Test compareTasks for Tags column', () {
    final compare = compareTasks('Tags');
    expect(compare(task1, task2), greaterThan(0));
  });

  test('Test compareTasks for Urgency column', () {
    final compare = compareTasks('Urgency');
    expect(compare(task1, task2), lessThan(0));
  });
}
