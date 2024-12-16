import 'package:flutter_test/flutter_test.dart';
import 'package:taskwarrior/app/models/models.dart';
import 'package:taskwarrior/app/utils/taskfunctions/patch.dart';
import 'package:built_collection/built_collection.dart';

void main() {
  group('patch', () {
    late Task originalTask;

    setUp(() {
      originalTask = Task((b) => b
        ..uuid = '1'
        ..description = 'Original Task'
        ..status = 'pending'
        ..entry = DateTime.now()
        ..tags = ListBuilder<String>(['tag1', 'tag2']));
    });

    test('should update description', () {
      final updatedTask = patch(originalTask, {'description': 'Updated Task'});
      expect(updatedTask.description, 'Updated Task');
    });

    test('should update status', () {
      final updatedTask = patch(originalTask, {'status': 'completed'});
      expect(updatedTask.status, 'completed');
    });

    test('should update start date', () {
      final newStart = DateTime.now().add(const Duration(days: 1));
      final updatedTask = patch(originalTask, {'start': newStart});
      expect(updatedTask.start, newStart);
    });

    test('should update end date', () {
      final newEnd = DateTime.now().add(const Duration(days: 1));
      final updatedTask = patch(originalTask, {'end': newEnd});
      expect(updatedTask.end, newEnd);
    });

    test('should update due date', () {
      final newDue = DateTime.now().add(const Duration(days: 1));
      final updatedTask = patch(originalTask, {'due': newDue});
      expect(updatedTask.due, newDue);
    });

    test('should update wait date', () {
      final newWait = DateTime.now().add(const Duration(days: 1));
      final updatedTask = patch(originalTask, {'wait': newWait});
      expect(updatedTask.wait, newWait);
    });

    test('should update until date', () {
      final newUntil = DateTime.now().add(const Duration(days: 1));
      final updatedTask = patch(originalTask, {'until': newUntil});
      expect(updatedTask.until, newUntil);
    });

    test('should update modified date', () {
      final newModified = DateTime.now().add(const Duration(days: 1));
      final updatedTask = patch(originalTask, {'modified': newModified});
      expect(updatedTask.modified, newModified);
    });

    test('should update priority', () {
      final updatedTask = patch(originalTask, {'priority': 'H'});
      expect(updatedTask.priority, 'H');
    });

    test('should update project', () {
      final updatedTask = patch(originalTask, {'project': 'New Project'});
      expect(updatedTask.project, 'New Project');
    });

    test('should update tags', () {
      final newTags = ListBuilder<String>(['tag3', 'tag4']);
      final updatedTask = patch(originalTask, {'tags': newTags});
      expect(updatedTask.tags?.rebuild((b) => b).toList(), ['tag3', 'tag4']);
    });
  });
}
