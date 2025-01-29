import 'package:flutter_test/flutter_test.dart';
import 'package:taskwarrior/app/models/models.dart';
import 'package:taskwarrior/app/utils/taskfunctions/draft.dart';

void main() {
  group('Draft', () {
    late Task originalTask;
    late Draft draft;

    setUp(() {
      originalTask = Task((b) => b
        ..uuid = '1'
        ..description = 'Original Task'
        ..status = 'pending'
        ..entry = DateTime.now());
      draft = Draft(originalTask);
    });

    test('should initialize with original task', () {
      expect(draft.original, originalTask);
      expect(draft.draft, originalTask);
    });

    test('should update draft with new values', () {
      draft.set('description', 'Updated Task');
      expect(draft.draft.description, 'Updated Task');
    });

    test('should set start and end dates based on status', () {
      final now = DateTime.now();

      draft.set('status', 'completed');
      expect(draft.draft.status, 'completed');
      expect(draft.draft.start, originalTask.start);
      expect(draft.draft.end?.isAfter(now), isTrue);

      draft.set('status', 'pending');
      expect(draft.draft.status, 'pending');
      expect(draft.draft.end, isNull);
    });
  });
}
