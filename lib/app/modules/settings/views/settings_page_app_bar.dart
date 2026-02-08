// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:taskwarrior/app/utils/constants/taskwarrior_fonts.dart';

import 'package:taskwarrior/app/utils/language/sentence_manager.dart';

import '../controllers/settings_controller.dart';

import 'package:taskwarrior/app/utils/constants/palette.dart';
import 'package:taskwarrior/app/utils/constants/taskwarrior_colors.dart';

class SettingsPageAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final SettingsController controller;
  const SettingsPageAppBar({required this.controller, super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: false,
      backgroundColor: Palette.kToDark.shade200,
      title: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Obx(
            () => Text(
              SentenceManager(
                      currentLanguage: controller.selectedLanguage.value)
                  .sentences
                  .settingsPageTitle,
              style: GoogleFonts.poppins(
                color: TaskWarriorColors.white,
                fontSize: TaskWarriorFonts.fontSizeLarge,
              ),
            ),
          ),
          Obx(
            () => Text(
              SentenceManager(
                      currentLanguage: controller.selectedLanguage.value)
                  .sentences
                  .settingsPageSubtitle,
              style: GoogleFonts.poppins(
                color: TaskWarriorColors.white,
                fontSize: TaskWarriorFonts.fontSizeSmall,
              ),
            ),
          ),
        ],
      ),
      leading: GestureDetector(
        onTap: () {
          //   Get.toNamed(Routes.b)
          // ;
          Get.back();
        },
        child: Icon(
          Icons.chevron_left,
          color: TaskWarriorColors.white,
          size: 35,
        ),
      ),
    );
  }

  @override
  Size get preferredSize => AppBar().preferredSize;
}
