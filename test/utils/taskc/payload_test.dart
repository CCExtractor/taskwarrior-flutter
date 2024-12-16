import 'package:flutter_test/flutter_test.dart';
import 'package:taskwarrior/app/utils/taskc/payload.dart';

void main() {
  group('Payload', () {
    test('should create Payload instance with tasks and userKey', () {
      final payload = Payload(tasks: ['task1', 'task2'], userKey: 'userKey123');
      expect(payload.tasks, ['task1', 'task2']);
      expect(payload.userKey, 'userKey123');
    });

    test('should create Payload instance from string', () {
      const payloadString = 'task1\ntask2\nuserKey123';
      final payload = Payload.fromString(payloadString);
      expect(payload.tasks, ['task1', 'task2']);
      expect(payload.userKey, 'userKey123');
    });

    test('should convert Payload instance to string', () {
      final payload = Payload(tasks: ['task1', 'task2'], userKey: 'userKey123');
      final payloadString = payload.toString();
      expect(payloadString, 'task1\ntask2\nuserKey123');
    });

    test('should handle Payload instance with null userKey', () {
      final payload = Payload(tasks: ['task1', 'task2']);
      expect(payload.userKey, isNull);
      final payloadString = payload.toString();
      expect(payloadString, 'task1\ntask2');
    });

    test('should handle Payload.fromString with empty userKey', () {
      const payloadString = 'task1\ntask2\n';
      final payload = Payload.fromString(payloadString);
      expect(payload.tasks, ['task1']);
      expect(payload.userKey, 'task2');
    });

    test('should handle Payload.toString with empty userKey', () {
      final payload = Payload(tasks: ['task1', 'task2'], userKey: '');
      final payloadString = payload.toString();
      expect(payloadString, 'task1\ntask2');
    });
  });
}
