import 'package:flutter_test/flutter_test.dart';
import 'package:taskwarrior/app/utils/taskserver/credentials.dart';

void main() {
  group('Credentials', () {
    test('Credentials constructor sets fields correctly', () {
      const credentials = Credentials(
        org: 'testOrg',
        user: 'testUser',
        key: 'testKey',
      );

      expect(credentials.org, 'testOrg');
      expect(credentials.user, 'testUser');
      expect(credentials.key, 'testKey');
    });

    test('Credentials.fromString parses string correctly', () {
      final credentials = Credentials.fromString('testOrg/testUser/testKey');

      expect(credentials.org, 'testOrg');
      expect(credentials.user, 'testUser');
      expect(credentials.key, 'testKey');
    });

    test('Credentials.fromString throws on invalid string format', () {
      expect(() => Credentials.fromString('invalidString'),
          throwsA(isA<RangeError>()));
      expect(() => Credentials.fromString('invalid/String'),
          throwsA(isA<RangeError>()));
    });
  });
}
