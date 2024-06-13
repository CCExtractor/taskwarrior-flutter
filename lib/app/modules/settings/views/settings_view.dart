// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taskwarrior/app/modules/settings/views/settings_page_body.dart';
import 'package:taskwarrior/app/utils/constants/taskwarrior_fonts.dart';

import '../controllers/settings_controller.dart';

import 'package:taskwarrior/app/utils/constants/palette.dart';
import 'package:taskwarrior/app/utils/constants/taskwarrior_colors.dart';
import 'package:taskwarrior/app/utils/theme/app_settings.dart';

class SettingsView extends GetView<SettingsController> {
  const SettingsView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        backgroundColor: Palette.kToDark.shade200,
        title: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Settings',
              style: GoogleFonts.poppins(
                color: TaskWarriorColors.white,
                fontSize: TaskWarriorFonts.fontSizeLarge,
              ),
            ),
            Text(
              'Configure your preferences',
              style: GoogleFonts.poppins(
                color: TaskWarriorColors.white,
                fontSize: TaskWarriorFonts.fontSizeSmall,
              ),
            ),
          ],
        ),
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.chevron_left,
            color: TaskWarriorColors.white,
          ),
        ),
      ),
      backgroundColor: AppSettings.isDarkMode
          ? TaskWarriorColors.kprimaryBackgroundColor
          : TaskWarriorColors.white,
      body: SettingsPageBody(controller: controller),
    );
  }
}
