import 'package:flutter_test/flutter_test.dart';
import 'package:taskwarrior/app/utils/taskfunctions/taskparser.dart';

void main() {
  group('Task Parser', () {
    test('taskParser correctly parses description', () {
      var taskString = 'This is a task description';
      var task = taskParser(taskString);
      expect(task.description, 'This is a task description');
      expect(task.status, 'pending');
    });

    test('taskParser throws FormatException for empty description', () {
      var taskString = '+tag1 +tag2';
      expect(() => taskParser(taskString), throwsFormatException);
    });

    test('taskParser correctly parses tags', () {
      var taskString = '+tag1 +tag2 This is a task description';
      var task = taskParser(taskString);
      expect(task.tags, containsAll(['tag1', 'tag2']));
      expect(task.description, 'This is a task description');
    });

    test('taskParser correctly parses attributes', () {
      var taskString =
          'status:completed project:Project1 priority:H due:2024-12-25 wait:2024-12-20 until:2024-12-30 This is a task description';
      var task = taskParser(taskString);
      expect(task.status, 'completed');
      expect(task.project, 'Project1');
      expect(task.priority, 'H');
      expect(task.description, 'This is a task description');
    });

    test('taskParser handles mixed input', () {
      var taskString =
          'status:completed +tag1 +tag2 This is a task description project:Project1';
      var task = taskParser(taskString);
      expect(task.status, 'completed');
      expect(task.tags, containsAll(['tag1', 'tag2']));
      expect(task.description, 'This is a task description');
      expect(task.project, 'Project1');
    });

    test('taskParser handles single quotes in attributes', () {
      var taskString =
          "status:'completed' project:'Project1' This is a task description";
      var task = taskParser(taskString);
      expect(task.status, 'completed');
      expect(task.project, 'Project1');
      expect(task.description, 'This is a task description');
    });

    test('taskParser assigns unique UUID and timestamps', () {
      var taskString = 'This is a task description';
      var task = taskParser(taskString);
      expect(task.uuid, isNotEmpty);
      expect(task.entry, isNotNull);
      expect(task.start, isNotNull);
      expect(task.modified, isNotNull);
    });
  });
}
