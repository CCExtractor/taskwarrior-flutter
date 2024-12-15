import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:taskwarrior/app/models/json/task.dart';

void main() {
  group('Task', () {
    late Task task;
    late DateTime entry;
    late String uuid;
    late String description;

    setUp(() {
      entry = DateTime.now().toUtc();
      uuid = '123e4567-e89b-12d3-a456-426614174000';
      description = 'Test task';

      task = Task((b) => b
        ..entry = entry
        ..uuid = uuid
        ..status = 'pending'
        ..description = description);
    });

    test('should correctly initialize with given parameters', () {
      expect(task.entry, entry);
      expect(task.uuid, uuid);
      expect(task.description, description);
    });

    test('should correctly convert to JSON', () {
      final json = task.toJson();
      expect(DateFormat("yyyyMMdd'T'HH").format(DateTime.parse(json['entry'])),
          DateFormat("yyyyMMdd'T'HH").format(entry));
      expect(json['uuid'], uuid);
      expect(json['description'], description);
    });

    test('should correctly create from JSON', () {
      final json = {
        'entry': entry.toIso8601String(),
        'uuid': uuid,
        'status': 'pending',
        'description': description,
      };
      final newTask = Task.fromJson(json);
      expect(newTask.entry, entry);
      expect(newTask.uuid, uuid);
      expect(newTask.description, description);
    });
  });
}
