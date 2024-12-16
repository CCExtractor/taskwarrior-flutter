import 'package:flutter_test/flutter_test.dart';
import 'package:taskwarrior/app/models/models.dart';
import 'package:taskwarrior/app/utils/taskfunctions/modify.dart';

void main() {
  group('Modify', () {
    late Task originalTask;
    late Modify modify;
    late Task Function(String) getTask;
    late void Function(Task) mergeTask;
    late String uuid;

    setUp(() {
      uuid = '1';
      originalTask = Task((b) => b
        ..uuid = uuid
        ..description = 'Original Task'
        ..status = 'pending'
        ..entry = DateTime.now());

      getTask = (String id) => originalTask;
      mergeTask = (Task task) {
        originalTask = task;
      };

      modify = Modify(getTask: getTask, mergeTask: mergeTask, uuid: uuid);
    });

    test('should initialize with original task', () {
      expect(modify.draft, originalTask);
    });

    test('should update draft with new values', () {
      modify.set('description', 'Updated Task');
      expect(modify.draft.description, 'Updated Task');
    });

    test('should save changes correctly', () {
      final now = DateTime.now();
      modify.set('description', 'Updated Task');
      modify.save(modified: () => now);

      expect(modify.draft.description, 'Updated Task');
      expect(modify.draft.modified, now);
    });
  });
}
