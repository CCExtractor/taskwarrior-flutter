
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taskwarrior/app/modules/home/controllers/home_controller.dart';
import 'package:taskwarrior/app/utils/constants/taskwarrior_fonts.dart';
import 'package:taskwarrior/app/utils/theme/app_settings.dart';

import '../controllers/settings_controller.dart';

import 'package:taskwarrior/app/utils/constants/taskwarrior_colors.dart';

class SettingsPageHighlistTaskListTile extends StatelessWidget {
  final SettingsController controller;
  const SettingsPageHighlistTaskListTile({required this.controller, super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        'Highlight the task',
        style: GoogleFonts.poppins(
          fontWeight: FontWeight.bold,
          fontSize: TaskWarriorFonts.fontSizeMedium,
          color: AppSettings.isDarkMode
              ? TaskWarriorColors.white
              : TaskWarriorColors.black,
        ),
      ),
      subtitle: Text(
        'Make the border of task if only one day left',
        style: GoogleFonts.poppins(
          color: TaskWarriorColors.grey,
          fontSize: TaskWarriorFonts.fontSizeSmall,
        ),
      ),
      trailing: Obx(
        () => Switch(
          value: controller.delaytask.value,
          onChanged: (bool value) async {
            controller.delaytask.value = value;
            final SharedPreferences prefs =
                await SharedPreferences.getInstance();
            await prefs.setBool('delaytask', value);
            Get.find<HomeController>().useDelayTask.value = value;
          },
        ),
      ),
    );
  }
}
