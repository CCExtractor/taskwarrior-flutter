import 'package:flutter_test/flutter_test.dart';
import 'package:taskwarrior/app/utils/taskc/response.dart';
import 'package:taskwarrior/app/utils/taskc/payload.dart';

void main() {
  group('Response', () {
    test('should create Response instance with header and payload', () {
      final payload = Payload(tasks: ['task1', 'task2'], userKey: 'userKey123');
      final header = {'type': 'response', 'version': '1.0'};
      final response = Response(header: header, payload: payload);

      expect(response.header, header);
      expect(response.payload, payload);
    });

    test('should create Response instance from string', () {
      const responseString =
          'type: response\nversion: 1.0\n\n' 'task1\ntask2\nuserKey123';
      final response = Response.fromString(responseString);

      expect(response.header, {
        'type': 'response',
        'version': '1.0',
      });
      expect(response.payload.tasks, ['task1', 'task2']);
      expect(response.payload.userKey, 'userKey123');
    });

    test('should handle Response.fromString with missing payload', () {
      const responseString = 'type: response\nversion: 1.0\n\n';
      final response = Response.fromString(responseString);

      expect(response.header, {
        'type': 'response',
        'version': '1.0',
      });
      expect(response.payload.tasks, []);
      expect(response.payload.userKey, '');
    });

    test('should handle Response.fromString with complex header', () {
      const responseString = 'type: response\nversion: 1.0\nextra: info\n\n'
          'task1\ntask2\nuserKey123';
      final response = Response.fromString(responseString);

      expect(response.header, {
        'type': 'response',
        'version': '1.0',
        'extra': 'info',
      });
      expect(response.payload.tasks, ['task1', 'task2']);
      expect(response.payload.userKey, 'userKey123');
    });

    test('should handle Response.fromString with empty header', () {
      const responseString = '\n\n' 'task1\ntask2\nuserKey123';
      final response = Response.fromString(responseString);

      expect(response.header, {'': ''});
      expect(response.payload.tasks, ['task1', 'task2']);
      expect(response.payload.userKey, 'userKey123');
    });
  });
}
