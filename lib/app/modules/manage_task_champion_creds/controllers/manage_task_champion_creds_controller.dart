import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ManageTaskChampionCredsController extends GetxController {
  final encryptionSecretController = TextEditingController();
  final clientIdController = TextEditingController();
  final ccsyncBackendUrlController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    loadCredentials();
  }

  Future<void> loadCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    encryptionSecretController.text = prefs.getString('encryptionSecret') ?? '';
    clientIdController.text = prefs.getString('clientId') ?? '';
    ccsyncBackendUrlController.text = prefs.getString('ccsyncBackendUrl') ?? '';
  }

  Future<void> saveCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('encryptionSecret', encryptionSecretController.text);
    await prefs.setString('clientId', clientIdController.text);
    await prefs.setString('ccsyncBackendUrl', ccsyncBackendUrlController.text);
  }

  @override
  void onClose() {
    encryptionSecretController.dispose();
    clientIdController.dispose();
    ccsyncBackendUrlController.dispose();
    super.onClose();
  }
}
