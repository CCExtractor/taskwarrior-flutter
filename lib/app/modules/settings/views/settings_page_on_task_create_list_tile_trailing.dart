import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../controllers/settings_controller.dart';


class SettingsPageOnTaskCreateListTileTrailing extends StatelessWidget {
  final SettingsController controller;
  const SettingsPageOnTaskCreateListTileTrailing(
      {required this.controller, super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Switch(
        value: controller.isSyncOnTaskCreateActivel.value,
        onChanged: (bool value) async {
          controller.isSyncOnTaskCreateActivel.value = value;
          final SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setBool('sync-OnTaskCreate', value);
        },
      ),
    );
  }
}
