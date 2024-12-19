import 'package:flutter_test/flutter_test.dart';
import 'package:taskwarrior/app/utils/taskc/message.dart';
import 'package:taskwarrior/app/utils/taskserver/credentials.dart';

void main() {
  group('message function', () {
    test('should construct message with all parameters', () {
      const credentials =
          Credentials(org: 'TestOrg', user: 'TestUser', key: 'TestKey');
      final result = message(
        client: 'TestClient',
        type: 'TestType',
        credentials: credentials,
        payload: 'TestPayload',
      );

      expect(result,
          'client: TestClient\ntype: TestType\norg: TestOrg\nuser: TestUser\nkey: TestKey\nprotocol: v1\n\nTestPayload');
    });

    test('should construct message without optional parameters', () {
      final result = message(
        type: 'TestType',
      );

      expect(
          result, 'type: TestType\norg: \nuser: \nkey: \nprotocol: v1\n\nnull');
    });

    test('should handle null client', () {
      const credentials =
          Credentials(org: 'TestOrg', user: 'TestUser', key: 'TestKey');
      final result = message(
        type: 'TestType',
        credentials: credentials,
        payload: 'TestPayload',
      );

      expect(result,
          'type: TestType\norg: TestOrg\nuser: TestUser\nkey: TestKey\nprotocol: v1\n\nTestPayload');
    });

    test('should handle null credentials', () {
      final result = message(
        client: 'TestClient',
        type: 'TestType',
        payload: 'TestPayload',
      );

      expect(result,
          'client: TestClient\ntype: TestType\norg: \nuser: \nkey: \nprotocol: v1\n\nTestPayload');
    });

    test('should handle null payload', () {
      const credentials =
          Credentials(org: 'TestOrg', user: 'TestUser', key: 'TestKey');
      final result = message(
        client: 'TestClient',
        type: 'TestType',
        credentials: credentials,
      );

      expect(result,
          'client: TestClient\ntype: TestType\norg: TestOrg\nuser: TestUser\nkey: TestKey\nprotocol: v1\n\nnull');
    });
  });
}
