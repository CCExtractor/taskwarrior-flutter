// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taskwarrior/app/modules/splash/controllers/splash_controller.dart';
import 'package:taskwarrior/app/utils/constants/taskwarrior_fonts.dart';
import 'package:taskwarrior/app/utils/constants/utilites.dart';

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
      body: (controller.isMovingDirectory.value)
          ? Center(
              child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircularProgressIndicator(),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  'Moving data to new directory',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    fontSize: TaskWarriorFonts.fontSizeMedium,
                    color: AppSettings.isDarkMode
                        ? TaskWarriorColors.white
                        : TaskWarriorColors.black,
                  ),
                )
              ],
            ))
          : ListView(
              children: [
                ListTile(
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
                  trailing: Switch(
                    value: controller.isSyncOnStartActivel.value,
                    onChanged: (bool value) async {
                      controller.isSyncOnStartActivel.value = value;

                      final SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      await prefs.setBool('sync-onStart', value);
                    },
                  ),
                ),
                const Divider(),
                ListTile(
                  title: Text(
                    'Sync on Task Create',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      fontSize: TaskWarriorFonts.fontSizeMedium,
                      color: AppSettings.isDarkMode
                          ? TaskWarriorColors.white
                          : TaskWarriorColors.black,
                    ),
                  ),
                  subtitle: Text(
                    'Enable automatic syncing when creating a new task',
                    style: GoogleFonts.poppins(
                      color: TaskWarriorColors.grey,
                      fontSize: TaskWarriorFonts.fontSizeSmall,
                    ),
                  ),
                  trailing: Obx(
                    () => Switch(
                      value: controller.isSyncOnTaskCreateActivel.value,
                      onChanged: (bool value) async {
                        controller.isSyncOnTaskCreateActivel.value = value;
                        final SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        await prefs.setBool('sync-OnTaskCreate', value);
                      },
                    ),
                  ),
                ),
                const Divider(),
                ListTile(
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
                        },
                      ),
                    )),
                const Divider(),
                ListTile(
                  title: Text(
                    'Select directory',
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
                      Text(
                        'Select the directory where the TaskWarrior data is stored\nCurrent directory: ${controller.getBaseDirectory()}',
                        style: GoogleFonts.poppins(
                          color: TaskWarriorColors.grey,
                          fontSize: TaskWarriorFonts.fontSizeSmall,
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
                                    ? TaskWarriorColors
                                        .ksecondaryBackgroundColor
                                    : TaskWarriorColors
                                        .kLightSecondaryBackgroundColor,
                              ),
                            ),
                            onPressed: () async {
                              if (await controller.getBaseDirectory() ==
                                  "Default") {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text(
                                          'Already default',
                                          style: TextStyle(
                                            color: AppSettings.isDarkMode
                                                ? TaskWarriorColors
                                                    .kprimaryTextColor
                                                : TaskWarriorColors
                                                    .kLightPrimaryTextColor,
                                          ),
                                        ),
                                        backgroundColor: AppSettings.isDarkMode
                                            ? TaskWarriorColors
                                                .ksecondaryBackgroundColor
                                            : TaskWarriorColors
                                                .kLightSecondaryBackgroundColor,
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
                                          fontSize:
                                              TaskWarriorFonts.fontSizeMedium,
                                          color: AppSettings.isDarkMode
                                              ? TaskWarriorColors.white
                                              : TaskWarriorColors.black,
                                        ),
                                      ),
                                      content: Text(
                                        "Are you sure you want to reset the directory to the default?",
                                        style: GoogleFonts.poppins(
                                          color: TaskWarriorColors.grey,
                                          fontSize:
                                              TaskWarriorFonts.fontSizeMedium,
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
                                            controller.isMovingDirectory.value =
                                                true;

                                            // InheritedProfiles profilesWidget =
                                            //     ProfilesWidget.of(context);
                                            var profilesWidget =
                                                Get.find<SplashController>();

                                            Directory source =
                                                profilesWidget.baseDirectory();
                                            Directory destination =
                                                await profilesWidget
                                                    .getDefaultDirectory();
                                            controller
                                                .moveDirectory(source.path,
                                                    destination.path)
                                                .then((value) async {
                                              profilesWidget.setBaseDirectory(
                                                  destination);
                                              SharedPreferences prefs =
                                                  await SharedPreferences
                                                      .getInstance();
                                              await prefs
                                                  .remove('baseDirectory');
                                              controller.isMovingDirectory
                                                  .value = false;
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
                              'Reset to default',
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
                                    ? TaskWarriorColors
                                        .ksecondaryBackgroundColor
                                    : TaskWarriorColors
                                        .kLightSecondaryBackgroundColor,
                              ),
                            ),
                            onPressed: () {
                              controller.pickDirectory(context);
                            },
                            child: Text(
                              'Change directory',
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
                ),
                const Divider(),
                ListTile(
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
                        },
                      ),
                    )),
              ],
            ),
    );
  }
}
