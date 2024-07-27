// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taskwarrior/app/modules/splash/controllers/splash_controller.dart';
import 'package:taskwarrior/app/utils/constants/taskwarrior_fonts.dart';
import 'package:taskwarrior/app/utils/constants/utilites.dart';
import 'package:taskwarrior/app/utils/language/sentence_manager.dart';
import 'package:taskwarrior/app/utils/app_settings/app_settings.dart';

import '../controllers/settings_controller.dart';

import 'package:taskwarrior/app/utils/constants/taskwarrior_colors.dart';

class SettingsPageSelectDirectoryListTile extends StatelessWidget {
  final SettingsController controller;
  const SettingsPageSelectDirectoryListTile(
      {required this.controller, super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        SentenceManager(currentLanguage: AppSettings.selectedLanguage)
            .sentences
            .settingsPageSelectDirectoryTitle,
        style: GoogleFonts.poppins(
          fontWeight: FontWeight.bold,
          fontSize: TaskWarriorFonts.fontSizeMedium,
          color: AppSettings.isDarkMode
              ? TaskWarriorColors.white
              : TaskWarriorColors.black,
        ),
      ),
      subtitle: Column(
        children: [
          Obx(
            () => Text(
              '${SentenceManager(currentLanguage: AppSettings.selectedLanguage).sentences.settingsPageSelectDirectoryTitle}: ${controller.baseDirectory.value}',
              style: GoogleFonts.poppins(
                color: TaskWarriorColors.grey,
                fontSize: TaskWarriorFonts.fontSizeSmall,
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            children: [
              //Reset to default
              TextButton(
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all<Color>(
                    AppSettings.isDarkMode
                        ? TaskWarriorColors.ksecondaryBackgroundColor
                        : TaskWarriorColors.kLightSecondaryBackgroundColor,
                  ),
                ),
                onPressed: () async {
                  if (await controller.getBaseDirectory() == "Default") {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(
                          'Already default',
                          style: TextStyle(
                            color: AppSettings.isDarkMode
                                ? TaskWarriorColors.kprimaryTextColor
                                : TaskWarriorColors.kLightPrimaryTextColor,
                          ),
                        ),
                        backgroundColor: AppSettings.isDarkMode
                            ? TaskWarriorColors.ksecondaryBackgroundColor
                            : TaskWarriorColors.kLightSecondaryBackgroundColor,
                        duration: const Duration(seconds: 2)));
                  } else {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return Utils.showAlertDialog(
                          title: Text(
                            'Reset to default',
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.bold,
                              fontSize: TaskWarriorFonts.fontSizeMedium,
                              color: AppSettings.isDarkMode
                                  ? TaskWarriorColors.white
                                  : TaskWarriorColors.black,
                            ),
                          ),
                          content: Text(
                            "Are you sure you want to reset the directory to the default?",
                            style: GoogleFonts.poppins(
                              color: TaskWarriorColors.grey,
                              fontSize: TaskWarriorFonts.fontSizeMedium,
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text(
                                'No',
                                style: GoogleFonts.poppins(
                                  color: AppSettings.isDarkMode
                                      ? TaskWarriorColors.white
                                      : TaskWarriorColors.black,
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: () async {
                                Navigator.pop(context);
                                controller.isMovingDirectory.value = true;

                                // InheritedProfiles profilesWidget =
                                //     ProfilesWidget.of(context);
                                var profilesWidget =
                                    Get.find<SplashController>();

                                Directory source =
                                    profilesWidget.baseDirectory();
                                Directory destination =
                                    await profilesWidget.getDefaultDirectory();
                                controller
                                    .moveDirectory(
                                        source.path, destination.path)
                                    .then((value) async {
                                  profilesWidget.setBaseDirectory(destination);
                                  SharedPreferences prefs =
                                      await SharedPreferences.getInstance();
                                  await prefs.remove('baseDirectory');
                                  controller.isMovingDirectory.value = false;
                                });
                              },
                              child: Text(
                                'Yes',
                                style: GoogleFonts.poppins(
                                  color: AppSettings.isDarkMode
                                      ? TaskWarriorColors.white
                                      : TaskWarriorColors.black,
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  }
                },
                child: Text(
                  SentenceManager(
                          currentLanguage: controller.selectedLanguage.value)
                      .sentences
                      .settingsPageSetToDefault,
                  style: TextStyle(
                    color: AppSettings.isDarkMode
                        ? TaskWarriorColors.white
                        : TaskWarriorColors.deepPurple,
                  ),
                ),
              ),
              const Spacer(),
              //Change directory
              TextButton(
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all<Color>(
                    AppSettings.isDarkMode
                        ? TaskWarriorColors.ksecondaryBackgroundColor
                        : TaskWarriorColors.kLightSecondaryBackgroundColor,
                  ),
                ),
                onPressed: () {
                  controller.pickDirectory(context);
                },
                child: Text(
                  SentenceManager(
                          currentLanguage: controller.selectedLanguage.value)
                      .sentences
                      .settingsPageChangeDirectory,
                  style: TextStyle(
                    color: AppSettings.isDarkMode
                        ? TaskWarriorColors.white
                        : TaskWarriorColors.deepPurple,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
