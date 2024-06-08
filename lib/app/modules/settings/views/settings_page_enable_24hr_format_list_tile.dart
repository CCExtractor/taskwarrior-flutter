import 'dart:io';

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taskwarrior/app/modules/home/controllers/home_controller.dart';
import 'package:taskwarrior/app/modules/splash/controllers/splash_controller.dart';
import 'package:taskwarrior/app/utils/constants/taskwarrior_fonts.dart';
import 'package:taskwarrior/app/utils/constants/utilites.dart';
import 'package:taskwarrior/app/utils/theme/app_settings.dart';

import '../controllers/settings_controller.dart';

import 'package:taskwarrior/app/utils/constants/palette.dart';
import 'package:taskwarrior/app/utils/constants/taskwarrior_colors.dart';
import 'package:flutter/material.dart';

class SettingsPageEnable24hrFormatListTile extends StatelessWidget {
  final SettingsController controller;
  const SettingsPageEnable24hrFormatListTile(
      {required this.controller, super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        'Enable 24HR formte',
        style: GoogleFonts.poppins(
          fontWeight: FontWeight.bold,
          fontSize: TaskWarriorFonts.fontSizeMedium,
          color: AppSettings.isDarkMode
              ? TaskWarriorColors.white
              : TaskWarriorColors.black,
        ),
      ),
      subtitle: Text(
        'Switch to Right to convert in 24hr formate',
        style: GoogleFonts.poppins(
          color: TaskWarriorColors.grey,
          fontSize: TaskWarriorFonts.fontSizeSmall,
        ),
      ),
      trailing: Obx(
        () => Switch(
          value: controller.change24hr.value,
          onChanged: (bool value) async {
            controller.change24hr.value = value;

            final SharedPreferences prefs =
                await SharedPreferences.getInstance();
            await prefs.setBool('24hourformate', value);
            Get.find<HomeController>().change24hr.value = value;
          },
        ),
      ),
    );
  }
}
