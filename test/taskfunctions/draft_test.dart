import 'package:flutter_test/flutter_test.dart';
import 'package:taskwarrior/app/models/models.dart';
import 'package:taskwarrior/app/utils/taskfunctions/draft.dart';

void main() {
  group('Draft Tests', () {
    test('Setting status to completed updates end date', () {
      Task original = Task(
        (b) => b
          ..id = 1
          ..description = 'Task 1'
          ..status = 'pending'
          ..start = DateTime.utc(2023, 1, 1)
          ..priority = 'H'
          ..project = 'Project A'
          ..tags.replace(['tag1', 'tag2'])
          ..uuid = 'uuid1'
          ..description = 'Task 1 Description'
          ..entry = DateTime(2024, 7, 20)
          ..modified = DateTime(2024, 7, 21)
          ..start = DateTime(2024, 7, 22)
          ..due = DateTime(2024, 7, 23),
      );

      Draft draft = Draft(original);

      draft.set('status', 'completed');

      expect(draft.draft.status, 'completed');

      expect(draft.draft.end, isNotNull);
    });

    test('Setting status to pending does not update end date', () {
      Task original = Task(
        (b) => b
          ..id = 2
          ..description = 'Task 2'
          ..status = 'completed'
          ..start = DateTime.utc(2023, 1, 1)
          ..priority = 'H'
          ..project = 'Project A'
          ..tags.replace(['tag1', 'tag2'])
          ..uuid = 'uuid2'
          ..description = 'Task 2 Description'
          ..entry = DateTime(2024, 7, 20)
          ..modified = DateTime(2024, 7, 21)
          ..start = DateTime(2024, 7, 22)
          ..due = DateTime(2024, 7, 23),
      );

      Draft draft = Draft(original);

      draft.set('status', 'pending');

      expect(draft.draft.status, 'pending');

      expect(draft.draft.end, isNull);
    });

    test('Setting other properties updates correctly', () {
      Task original = Task(
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

      Draft draft = Draft(original);

      draft.set('priority', 'L');

      expect(draft.draft.priority, 'L');

      expect(draft.draft.id, original.id);

      expect(draft.draft.description, original.description);
	  
      expect(draft.draft.status, original.status);
    });
  });
}
