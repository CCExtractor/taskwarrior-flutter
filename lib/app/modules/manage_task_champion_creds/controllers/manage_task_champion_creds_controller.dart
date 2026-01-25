import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taskwarrior/app/modules/splash/controllers/splash_controller.dart';
import 'package:taskwarrior/app/utils/taskchampion/credentials_storage.dart';
import 'package:taskwarrior/app/v3/net/origin.dart';
import 'package:http/http.dart' as http;

class ManageTaskChampionCredsController extends GetxController {
  final encryptionSecretController = TextEditingController();
  final clientIdController = TextEditingController();
  final ccsyncBackendUrlController = TextEditingController();
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
    ccsyncBackendUrlController.text =
        await CredentialsStorage.getApiUrl() ?? '';
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    taskReplica.value = prefs.getBool('settings_taskr_repl') ?? false;
  }

  Future<int> saveCredentials() async {
    if (taskReplica.value) {
      profilesWidget.setTaskcCreds(
          profilesWidget.currentProfile.value,
          clientIdController.text,
          encryptionSecretController.text,
          ccsyncBackendUrlController.text);
      return 0;
    }
    isCheckingCreds.value = true;
    String baseUrl = ccsyncBackendUrlController.text;
    String uuid = clientIdController.text;
    String encryptionSecret = encryptionSecretController.text;
    try {
      String url =
          '$baseUrl/tasks?email=email&origin=$origin&UUID=$uuid&encryptionSecret=$encryptionSecret';

      var response = await http.get(Uri.parse(url), headers: {
        "Content-Type": "application/json",
      }).timeout(const Duration(seconds: 10000));
      debugPrint("Fetch tasks response: ${response.statusCode}");
      debugPrint("Fetch tasks body: ${response.body}");
      if (response.statusCode == 200) {
        List<dynamic> allTasks = jsonDecode(response.body);
        debugPrint(allTasks.toString());
        profilesWidget.setTaskcCreds(
            profilesWidget.currentProfile.value,
            clientIdController.text,
            encryptionSecretController.text,
            ccsyncBackendUrlController.text);

        isCheckingCreds.value = false;
        return 0;
      } else {
        throw Exception('Failed to load tasks');
      }
    } catch (e, s) {
      debugPrint('Error fetching tasks: $e\n $s');
      isCheckingCreds.value = false;
      return 1;
    }
  }

  @override
  void onClose() {
    encryptionSecretController.dispose();
    clientIdController.dispose();
    ccsyncBackendUrlController.dispose();
    super.onClose();
  }
}
