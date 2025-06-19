// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:taskwarrior/app/modules/settings/views/settings_page_app_bar.dart';
import 'package:taskwarrior/app/modules/settings/views/settings_page_body.dart';
import 'package:taskwarrior/app/utils/themes/theme_extension.dart';

import '../controllers/settings_controller.dart';

class SettingsView extends GetView<SettingsController> {
  const SettingsView({super.key});
  @override
  Widget build(BuildContext context) {
    TaskwarriorColorTheme tColors =
        Theme.of(context).extension<TaskwarriorColorTheme>()!;
    return Scaffold(
      appBar: SettingsPageAppBar(
        controller: controller,
      ),
      backgroundColor: tColors.primaryBackgroundColor,
      body: SettingsPageBody(
        controller: controller,
      ),
    );
  }
}
