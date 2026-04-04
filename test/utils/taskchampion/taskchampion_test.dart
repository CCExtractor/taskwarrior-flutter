import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taskwarrior/app/modules/manage_task_champion_creds/controllers/manage_task_champion_creds_controller.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('ManageTaskChampionCredsController Test', () {
    late ManageTaskChampionCredsController controller;

    setUp(() {
      // Start with empty SharedPreferences
      SharedPreferences.setMockInitialValues({});
      controller = ManageTaskChampionCredsController();
    });

    test('should load empty credentials initially', () async {
      // Wait for onInit() to complete
      await Future.delayed(Duration(milliseconds: 10));

      expect(controller.encryptionSecretController.text, '');
      expect(controller.clientIdController.text, '');
      expect(controller.syncBackendUrlController.text, '');
    });

    test('should load empty credentials when no credential files exist',
        () async {
      // CredentialsStorage reads from file system paths like:
      //   ${base.path}/profiles/$profile/taskc_client_secret
      //   ${base.path}/profiles/$profile/taskc_client_id
      //   ${base.path}/profiles/$profile/backend_url_tc
      // In the test environment, these files do not exist, so all values
      // should return null and the controllers should remain empty.
      controller = ManageTaskChampionCredsController();
      await controller.loadCredentials();

      expect(controller.encryptionSecretController.text, '');
      expect(controller.clientIdController.text, '');
      expect(controller.syncBackendUrlController.text, '');
    });

    test('should attempt save and return error without network', () async {
      // saveCredentials() makes an HTTP request to verify credentials.
      // In the test environment there is no network, so it should return 1
      // (error) and not throw an unhandled exception.
      controller.encryptionSecretController.text = 'secret123';
      controller.clientIdController.text = 'clientABC';
      controller.syncBackendUrlController.text = 'https://backend.url';

      final result = await controller.saveCredentials();

      // Returns 1 when the HTTP call fails (no network in test environment)
      expect(result, 1);
    });
  });
}
