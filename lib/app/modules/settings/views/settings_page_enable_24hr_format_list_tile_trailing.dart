import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:taskwarrior/app/utils/app_settings/app_settings.dart';

import '../controllers/settings_controller.dart';

class SettingsPageEnable24hrFormatListTileTrailing extends StatelessWidget {
  final SettingsController controller;
  const SettingsPageEnable24hrFormatListTileTrailing(
      {required this.controller, super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Switch(
        value: AppSettings.use24HourFormatRx.value,
        onChanged: (bool value) async {
          AppSettings.use24HourFormatRx.value = value;
          AppSettings.saveSettings(
            AppSettings.isDarkMode,
            AppSettings.selectedLanguage,
            value,
          );
        },
      ),
    );
  }
}
