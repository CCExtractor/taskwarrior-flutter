
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../controllers/settings_controller.dart';


class SettingsPageOnTaskStartListTileTrailing extends StatelessWidget {
  final SettingsController controller;
  const SettingsPageOnTaskStartListTileTrailing({required this.controller, super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
        () => Switch(
          value: controller.isSyncOnStartActivel.value,
          onChanged: (bool value) async {
            controller.isSyncOnStartActivel.value = value;

            final SharedPreferences prefs =
                await SharedPreferences.getInstance();
            await prefs.setBool('sync-onStart', value);
          },
        ),
    );
  }
}
