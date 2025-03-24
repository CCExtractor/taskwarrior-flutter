import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taskwarrior/app/modules/home/controllers/home_controller.dart';

import '../controllers/settings_controller.dart';

class SettingsPageTaskchampionTileListTileTrailing extends StatelessWidget {
  final SettingsController controller;
  const SettingsPageTaskchampionTileListTileTrailing(
      {required this.controller, super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Switch(
        value: controller.taskchampion.value,
        onChanged: (bool value) async {
          controller.taskchampion.value = value;

          final SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setBool('settings_taskc', value);
          Get.find<HomeController>().taskchampion.value = value;
        },
      ),
    );
  }
}
