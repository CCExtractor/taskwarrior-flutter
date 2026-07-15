import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taskwarrior/app/modules/splash/controllers/splash_controller.dart';
import 'package:taskwarrior/app/utils/taskchampion/credentials_storage.dart';
import 'package:taskwarrior/app/v3/champion/replica.dart';
import 'package:taskwarrior/rust_bridge/api.dart';

class ManageTaskChampionCredsController extends GetxController {
  final encryptionSecretController = TextEditingController();
  final clientIdController = TextEditingController();
  final syncServerUrlController = TextEditingController();
  var profilesWidget = Get.find<SplashController>();
  RxBool isCheckingCreds = false.obs;
  RxBool taskReplica = false.obs;
  @override
  void onInit() {
    super.onInit();
    loadCredentials();
  }

  Future<void> loadCredentials() async {
    encryptionSecretController.text =
        await CredentialsStorage.getEncryptionSecret() ?? '';
    clientIdController.text = await CredentialsStorage.getClientId() ?? '';
    syncServerUrlController.text =
        await CredentialsStorage.getApiUrl() ?? '';
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    taskReplica.value = prefs.getBool('settings_taskr_repl') ?? false;
  }

  /// Validates and persists sync credentials through a single path: the native
  /// TaskChampion sync via the Rust FFI bridge.
  ///
  /// The entered credentials are validated with a real [sync_] *before* they
  /// are persisted — a successful sync confirms they are valid, while invalid
  /// credentials raise a Rust-level exception that surfaces here as a thrown
  /// error. This ordering guarantees we never write unverified credentials into
  /// the active profile. (Because validation is a live sync, saving requires
  /// connectivity to the sync server.)
  Future<int> saveCredentials() async {
    isCheckingCreds.value = true;
    try {
      final String replicaPath = await Replica.getReplicaPath();
      await sync_(
        taskdbDirPath: replicaPath,
        url: syncServerUrlController.text,
        clientId: clientIdController.text,
        encryptionSecret: encryptionSecretController.text,
      );
      // Only persist after the sync has confirmed the credentials are valid.
      profilesWidget.setTaskcCreds(
        profilesWidget.currentProfile.value,
        clientIdController.text,
        encryptionSecretController.text,
        syncServerUrlController.text,
      );
      isCheckingCreds.value = false;
      return 0;
    } catch (err) {
      debugPrint('Credential check failed: $err');
      isCheckingCreds.value = false;
      return 1;
    }
  }

  @override
  void onClose() {
    encryptionSecretController.dispose();
    clientIdController.dispose();
    syncServerUrlController.dispose();
    super.onClose();
  }
}
