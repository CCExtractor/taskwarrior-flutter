import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taskwarrior/app/modules/home/controllers/home_controller.dart';

import '../controllers/settings_controller.dart';


class SettingsPageHighlistTaskListTileTrailing extends StatelessWidget {
  final SettingsController controller;
  const SettingsPageHighlistTaskListTileTrailing(
      {required this.controller, super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Switch(
        value: controller.delaytask.value,
        onChanged: (bool value) async {
          controller.delaytask.value = value;
          final SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setBool('delaytask', value);
          Get.find<HomeController>().useDelayTask.value = value;
        },
      ),
    );
  }
}
