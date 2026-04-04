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

    test('should load existing credentials', () async {
      SharedPreferences.setMockInitialValues({
        'encryptionSecret': 'mysecret',
        'clientId': 'client123',
        'syncBackendUrl': 'https://example.com',
      });

      controller = ManageTaskChampionCredsController();
      await controller.loadCredentials();
      expect(controller.encryptionSecretController.text, 'mysecret');
      expect(controller.clientIdController.text, 'client123');
      expect(controller.syncBackendUrlController.text, 'https://example.com');
    });

    test('should save credentials', () async {
      controller.encryptionSecretController.text = 'secret123';
      controller.clientIdController.text = 'clientABC';
      controller.syncBackendUrlController.text = 'https://backend.url';

      await controller.saveCredentials();

      final prefs = await SharedPreferences.getInstance();

      expect(prefs.getString('encryptionSecret'), 'secret123');
      expect(prefs.getString('clientId'), 'clientABC');
      expect(prefs.getString('syncBackendUrl'), 'https://backend.url');
    });
  });
}
