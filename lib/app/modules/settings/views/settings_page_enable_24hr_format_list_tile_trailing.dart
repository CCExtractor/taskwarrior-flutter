import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taskwarrior/app/modules/home/controllers/home_controller.dart';

import '../controllers/settings_controller.dart';


class SettingsPageEnable24hrFormatListTileTrailing extends StatelessWidget {
  final SettingsController controller;
  const SettingsPageEnable24hrFormatListTileTrailing(
      {required this.controller, super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Switch(
        value: controller.change24hr.value,
        onChanged: (bool value) async {
          controller.change24hr.value = value;

          final SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setBool('24hourformate', value);
          Get.find<HomeController>().change24hr.value = value;
        },
      ),
    );
  }
}
