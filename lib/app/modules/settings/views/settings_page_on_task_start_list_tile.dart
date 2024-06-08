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

class SettingsPageOnTaskStartListTile extends StatelessWidget {
  final SettingsController controller;
  const SettingsPageOnTaskStartListTile({required this.controller, super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        'Sync on Start',
        style: GoogleFonts.poppins(
          fontWeight: FontWeight.bold,
          fontSize: TaskWarriorFonts.fontSizeMedium,
          color: AppSettings.isDarkMode
              ? TaskWarriorColors.white
              : TaskWarriorColors.black,
        ),
      ),
      subtitle: Text(
        'Automatically sync data on app startup',
        style: GoogleFonts.poppins(
          color: TaskWarriorColors.grey,
          fontSize: TaskWarriorFonts.fontSizeSmall,
        ),
      ),
      trailing: Obx(
        () => Switch(
          value: controller.isSyncOnStartActivel.value,
          onChanged: (bool value) async {
            controller.isSyncOnStartActivel.value = value;

            final SharedPreferences prefs =
                await SharedPreferences.getInstance();
            await prefs.setBool('sync-onStart', value);
          },
        ),
      ),
    );
  }
}
