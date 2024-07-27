import 'package:taskwarrior/app/utils/taskfunctions/taskparser.dart';
import 'package:test/test.dart';

void main() {
  group('taskParser', () {
    test('parses a task with multiple attributes and tags', () {
      const taskString =
          '+tag1 status:completed project:work priority:high due:2024-12-31T23:59:59Z This is a complex task';
      final task = taskParser(taskString);
      expect(task.description, 'This is a complex task');
      expect(task.status, 'completed');
      expect(task.project, 'work');
      expect(task.priority, 'high');
      expect(task.due, DateTime.parse('2024-12-31T23:59:59Z').toUtc());
      expect(task.wait, isNull);
      expect(task.until, isNull);
      expect(task.tags, ['tag1']);
    });

    test('parses a task with long description and tags', () {
      const taskString = '+longtag1 +longtag2 '
          'This is a very long description that goes on and on, potentially including special characters and a very long string to test how the parser handles such cases';
      final task = taskParser(taskString);
      expect(task.description,
          'This is a very long description that goes on and on, potentially including special characters and a very long string to test how the parser handles such cases');
      expect(task.status, 'pending');
      expect(task.project, isNull);
      expect(task.priority, isNull);
      expect(task.due, isNull);
      expect(task.wait, isNull);
      expect(task.until, isNull);
      expect(task.tags, ['longtag1', 'longtag2']);
    });

    test('parses a task with mixed attribute formats', () {
      const taskString =
          'status:completed prio:high project:work +tag1 This is a task with mixed attribute formats';
      final task = taskParser(taskString);
      expect(task.description, 'This is a task with mixed attribute formats');
      expect(task.status, 'completed');
      expect(task.project, 'work');
      expect(task.priority, 'high');
      expect(task.due, isNull);
      expect(task.wait, isNull);
      expect(task.until, isNull);
      expect(task.tags, ['tag1']);
    });

    test('parses a task with overlapping attributes and tags', () {
      const taskString =
          '+tag1 status:completed project:work +tag2 This is a task with overlapping attributes and tags';
      final task = taskParser(taskString);
      expect(task.description,
          'This is a task with overlapping attributes and tags');
      expect(task.status, 'completed');
      expect(task.project, 'work');
      expect(task.priority, isNull);
      expect(task.due, isNull);
      expect(task.wait, isNull);
      expect(task.until, isNull);
      expect(task.tags, ['tag1', 'tag2']);
    });
  });
}
