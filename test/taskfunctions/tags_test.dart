import 'package:flutter_test/flutter_test.dart';
import 'package:taskwarrior/app/models/models.dart';
import 'package:taskwarrior/app/utils/taskfunctions/tags.dart';

void main() {
  group('tagSet', () {
    test('should return all unique tags from tasks', () {
      final tasks = [
        Task((b) => b
          ..id = 1
          ..description = 'Task 1'
          ..status = 'pending'
          ..tags.replace(['tag1', 'tag2'])
          ..start = DateTime.now()
          ..entry = DateTime.now()
          ..modified = DateTime.now()
          ..due = DateTime.now()
          ..project = 'Project A'
          ..uuid = 'uuid1'),
        Task((b) => b
          ..id = 2
          ..description = 'Task 2'
          ..status = 'pending'
          ..tags.replace(['tag2', 'tag3'])
          ..start = DateTime.now()
          ..entry = DateTime.now()
          ..modified = DateTime.now()
          ..due = DateTime.now()
          ..project = 'Project B'
          ..uuid = 'uuid2'),
      ];

      final result = tagSet(tasks);
      expect(result, {'tag1', 'tag2', 'tag3'});
    });

    test('should return an empty set if no tasks', () {
      final tasks = <Task>[];

      final result = tagSet(tasks);
      expect(result, <String>{});
    });

    test('should return an empty set if tasks have no tags', () {
      final tasks = [
        Task((b) => b
          ..id = 1
          ..description = 'Task 1'
          ..status = 'pending'
          ..start = DateTime.now()
          ..entry = DateTime.now()
          ..modified = DateTime.now()
          ..due = DateTime.now()
          ..project = 'Project A'
          ..uuid = 'uuid1'),
        Task((b) => b
          ..id = 2
          ..description = 'Task 2'
          ..status = 'pending'
          ..start = DateTime.now()
          ..entry = DateTime.now()
          ..modified = DateTime.now()
          ..due = DateTime.now()
          ..project = 'Project B'
          ..uuid = 'uuid2'),
      ];

      final result = tagSet(tasks);
      expect(result, <String>{});
    });
  });

  group('tagFrequencies', () {
    test('should count the frequency of each tag correctly', () {
      final tasks = [
        Task((b) => b
          ..id = 1
          ..description = 'Task 1'
          ..status = 'pending'
          ..tags.replace(['tag1', 'tag2'])
          ..start = DateTime.now()
          ..entry = DateTime.now()
          ..modified = DateTime.now()
          ..due = DateTime.now()
          ..project = 'Project A'
          ..uuid = 'uuid1'),
        Task((b) => b
          ..id = 2
          ..description = 'Task 2'
          ..status = 'pending'
          ..tags.replace(['tag2', 'tag3'])
          ..start = DateTime.now()
          ..entry = DateTime.now()
          ..modified = DateTime.now()
          ..due = DateTime.now()
          ..project = 'Project B'
          ..uuid = 'uuid2'),
        Task((b) => b
          ..id = 3
          ..description = 'Task 3'
          ..status = 'pending'
          ..tags.replace(['tag2'])
          ..start = DateTime.now()
          ..entry = DateTime.now()
          ..modified = DateTime.now()
          ..due = DateTime.now()
          ..project = 'Project C'
          ..uuid = 'uuid3'),
      ];

      final result = tagFrequencies(tasks);
      expect(result, {'tag1': 1, 'tag2': 3, 'tag3': 1});
    });

    test('should return an empty map if no tasks', () {
      final tasks = <Task>[];

      final result = tagFrequencies(tasks);
      expect(result, <String, int>{});
    });

    test('should return an empty map if tasks have no tags', () {
      final tasks = [
        Task((b) => b
          ..id = 1
          ..description = 'Task 1'
          ..status = 'pending'
          ..start = DateTime.now()
          ..entry = DateTime.now()
          ..modified = DateTime.now()
          ..due = DateTime.now()
          ..project = 'Project A'
          ..uuid = 'uuid1'),
        Task((b) => b
          ..id = 2
          ..description = 'Task 2'
          ..status = 'pending'
          ..start = DateTime.now()
          ..entry = DateTime.now()
          ..modified = DateTime.now()
          ..due = DateTime.now()
          ..project = 'Project B'
          ..uuid = 'uuid2'),
      ];

      final result = tagFrequencies(tasks);
      expect(result, <String, int>{});
    });

    test('should count tags correctly with overlapping tasks', () {
      final tasks = [
        Task((b) => b
          ..id = 1
          ..description = 'Task 1'
          ..status = 'pending'
          ..tags.replace(['tag1', 'tag2'])
          ..start = DateTime.now()
          ..entry = DateTime.now()
          ..modified = DateTime.now()
          ..due = DateTime.now()
          ..project = 'Project A'
          ..uuid = 'uuid1'),
        Task((b) => b
          ..id = 2
          ..description = 'Task 2'
          ..status = 'pending'
          ..tags.replace(['tag1', 'tag2', 'tag3'])
          ..start = DateTime.now()
          ..entry = DateTime.now()
          ..modified = DateTime.now()
          ..due = DateTime.now()
          ..project = 'Project B'
          ..uuid = 'uuid2'),
        Task((b) => b
          ..id = 3
          ..description = 'Task 3'
          ..status = 'pending'
          ..tags.replace(['tag2', 'tag3'])
          ..start = DateTime.now()
          ..entry = DateTime.now()
          ..modified = DateTime.now()
          ..due = DateTime.now()
          ..project = 'Project C'
          ..uuid = 'uuid3'),
      ];

      final result = tagFrequencies(tasks);
      expect(result, {'tag1': 2, 'tag2': 3, 'tag3': 2});
    });
  });

  group('tagsLastModified', () {
    test('should return the latest modification date for each tag', () {
      final tasks = [
        Task((b) => b
          ..id = 1
          ..description = 'Task 1'
          ..status = 'pending'
          ..tags.replace(['tag1'])
          ..modified = DateTime.utc(2024, 1, 1)
          ..start = DateTime.now()
          ..entry = DateTime.now()
          ..due = DateTime.now()
          ..project = 'Project A'
          ..uuid = 'uuid1'),
        Task((b) => b
          ..id = 2
          ..description = 'Task 2'
          ..status = 'pending'
          ..tags.replace(['tag2'])
          ..modified = DateTime.utc(2024, 2, 1)
          ..start = DateTime.now()
          ..entry = DateTime.now()
          ..due = DateTime.now()
          ..project = 'Project B'
          ..uuid = 'uuid2'),
        Task((b) => b
          ..id = 3
          ..description = 'Task 3'
          ..status = 'pending'
          ..tags.replace(['tag1', 'tag3'])
          ..modified = DateTime.utc(2024, 3, 1)
          ..start = DateTime.now()
          ..entry = DateTime.now()
          ..due = DateTime.now()
          ..project = 'Project C'
          ..uuid = 'uuid3'),
      ];

      final result = tagsLastModified(tasks);
      expect(result, {
        'tag1': DateTime.utc(2024, 3, 1),
        'tag2': DateTime.utc(2024, 2, 1),
        'tag3': DateTime.utc(2024, 3, 1),
      });
    });

    test('should return an empty map if no tasks', () {
      final tasks = <Task>[];

      final result = tagsLastModified(tasks);
      expect(result, <String, DateTime>{});
    });

    test('should return an empty map if tasks have no tags', () {
      final tasks = [
        Task((b) => b
          ..id = 1
          ..description = 'Task 1'
          ..status = 'pending'
          ..start = DateTime.now()
          ..entry = DateTime.now()
          ..modified = DateTime.now()
          ..due = DateTime.now()
          ..project = 'Project A'
          ..uuid = 'uuid1'),
        Task((b) => b
          ..id = 2
          ..description = 'Task 2'
          ..status = 'pending'
          ..start = DateTime.now()
          ..entry = DateTime.now()
          ..modified = DateTime.now()
          ..due = DateTime.now()
          ..project = 'Project B'
          ..uuid = 'uuid2'),
      ];

      final result = tagsLastModified(tasks);
      expect(result, <String, DateTime>{});
    });

    test('should return correct modification dates with overlapping tags', () {
      final tasks = [
        Task((b) => b
          ..id = 1
          ..description = 'Task 1'
          ..status = 'pending'
          ..tags.replace(['tag1', 'tag2'])
          ..modified = DateTime.utc(2024, 1, 1)
          ..start = DateTime.now()
          ..entry = DateTime.now()
          ..due = DateTime.now()
          ..project = 'Project A'
          ..uuid = 'uuid1'),
        Task((b) => b
          ..id = 2
          ..description = 'Task 2'
          ..status = 'pending'
          ..tags.replace(['tag2', 'tag3'])
          ..modified = DateTime.utc(2024, 2, 1)
          ..start = DateTime.now()
          ..entry = DateTime.now()
          ..due = DateTime.now()
          ..project = 'Project B'
          ..uuid = 'uuid2'),
        Task((b) => b
          ..id = 3
          ..description = 'Task 3'
          ..status = 'pending'
          ..tags.replace(['tag3'])
          ..modified = DateTime.utc(2024, 3, 1)
          ..start = DateTime.now()
          ..entry = DateTime.now()
          ..due = DateTime.now()
          ..project = 'Project C'
          ..uuid = 'uuid3'),
      ];

      final result = tagsLastModified(tasks);
      expect(result, {
        'tag1': DateTime.utc(2024, 1, 1),
        'tag2': DateTime.utc(2024, 2, 1),
        'tag3': DateTime.utc(2024, 3, 1),
      });
    });
  });
}
