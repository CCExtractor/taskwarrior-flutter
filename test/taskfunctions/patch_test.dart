import 'package:flutter_test/flutter_test.dart';
import 'package:taskwarrior/app/models/models.dart';
import 'package:taskwarrior/app/utils/taskfunctions/patch.dart';

void main() {
  group('patch function', () {
    test('should patch description', () {
      Task initialTask = Task(
        (b) => b
          ..id = 1
          ..description = 'Task 3'
          ..status = 'pending'
          ..start = DateTime.utc(2023, 1, 1)
          ..priority = 'H'
          ..project = 'Project A'
          ..tags.replace(['tag1', 'tag2'])
          ..uuid = 'uuid3'
          ..description = 'Task 3 Description'
          ..entry = DateTime(2024, 7, 20)
          ..modified = DateTime(2024, 7, 21)
          ..start = DateTime(2024, 7, 22)
          ..due = DateTime(2024, 7, 23),
      );
      Map<String, dynamic> updates = {'description': 'Updated description'};

      Task patchedTask = patch(initialTask, updates);

      expect(patchedTask.description, 'Updated description');
    });

    test('should handle unknown keys gracefully', () {
      Task initialTask = Task(
        (b) => b
          ..id = 1
          ..description = 'Task 3'
          ..status = 'pending'
          ..start = DateTime.utc(2023, 1, 1)
          ..priority = 'H'
          ..project = 'Project A'
          ..tags.replace(['tag1', 'tag2'])
          ..uuid = 'uuid3'
          ..description = 'Task 3 Description'
          ..entry = DateTime(2024, 7, 20)
          ..modified = DateTime(2024, 7, 21)
          ..start = DateTime(2024, 7, 22)
          ..due = DateTime(2024, 7, 23),
      );
      Map<String, dynamic> updates = {'unknownField': 'some value'};

      Task patchedTask = patch(initialTask, updates);

      expect(patchedTask, initialTask);
    });
  });
}
