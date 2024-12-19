import 'package:flutter_test/flutter_test.dart';
import 'package:taskwarrior/app/models/models.dart';
import 'package:taskwarrior/app/utils/taskfunctions/tags.dart';
import 'package:built_collection/built_collection.dart';

void main() {
  group('Tags Utils', () {
    late Task task1;
    late Task task2;
    late Task task3;

    setUp(() {
      task1 = Task((b) => b
        ..uuid = '1'
        ..description = 'Task 1'
        ..status = 'pending'
        ..entry = DateTime.parse('2023-12-01T12:00:00Z')
        ..tags = ListBuilder<String>(['tag1', 'tag2'])
        ..modified = DateTime.parse('2023-12-01T12:00:00Z'));

      task2 = Task((b) => b
        ..uuid = '2'
        ..description = 'Task 2'
        ..status = 'pending'
        ..entry = DateTime.parse('2023-12-01T12:00:00Z')
        ..tags = ListBuilder<String>(['tag2', 'tag3'])
        ..modified = DateTime.parse('2023-12-02T12:00:00Z'));

      task3 = Task((b) => b
        ..uuid = '3'
        ..description = 'Task 3'
        ..status = 'pending'
        ..entry = DateTime.parse('2023-12-01T12:00:00Z')
        ..tags = ListBuilder<String>(['tag1', 'tag3'])
        ..modified = DateTime.parse('2023-12-03T12:00:00Z'));
    });

    test('tagSet returns correct set of tags', () {
      var tasks = [task1, task2, task3];
      var expectedTags = {'tag1', 'tag2', 'tag3'};
      expect(tagSet(tasks), expectedTags);
    });

    test('tagFrequencies returns correct tag frequencies', () {
      var tasks = [task1, task2, task3];
      var expectedFrequencies = {
        'tag1': 2,
        'tag2': 2,
        'tag3': 2,
      };
      expect(tagFrequencies(tasks), expectedFrequencies);
    });

    test('tagsLastModified returns correct last modified dates for tags', () {
      var tasks = [task1, task2, task3];
      var expectedLastModified = {
        'tag1': DateTime.parse('2023-12-03T12:00:00Z'),
        'tag2': DateTime.parse('2023-12-02T12:00:00Z'),
        'tag3': DateTime.parse('2023-12-03T12:00:00Z'),
      };
      expect(tagsLastModified(tasks), expectedLastModified);
    });
  });
}
