import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taskwarrior/app/utils/taskchampion/credentials_storage.dart';

import 'credentials_storage_test.mocks.dart';

@GenerateMocks([SharedPreferences])
void main() {
  group('CredentialsStorage', () {
    late MockSharedPreferences mockSharedPreferences;

    setUp(() {
      mockSharedPreferences = MockSharedPreferences();
    });

    test('should return null when encryption secret is not set', () async {
      when(mockSharedPreferences.getString('encryptionSecret'))
          .thenReturn(null);
      SharedPreferences.setMockInitialValues({});

      final encryptionSecret = await CredentialsStorage.getEncryptionSecret();
      expect(encryptionSecret, isNull);
    });

    test('should return encryption secret when it is set', () async {
      when(mockSharedPreferences.getString('encryptionSecret'))
          .thenReturn('secret123');
      SharedPreferences.setMockInitialValues({
        'encryptionSecret': 'secret123',
      });

      final encryptionSecret = await CredentialsStorage.getEncryptionSecret();
      expect(encryptionSecret, 'secret123');
    });

    test('should return null when client ID is not set', () async {
      when(mockSharedPreferences.getString('clientId')).thenReturn(null);
      SharedPreferences.setMockInitialValues({});

      final clientId = await CredentialsStorage.getClientId();
      expect(clientId, isNull);
    });

    test('should return client ID when it is set', () async {
      when(mockSharedPreferences.getString('clientId')).thenReturn('client123');
      SharedPreferences.setMockInitialValues({
        'clientId': 'client123',
      });

      final clientId = await CredentialsStorage.getClientId();
      expect(clientId, 'client123');
    });
  });
}
