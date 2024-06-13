// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:taskwarrior/app/modules/settings/views/settings_page_enable_24hr_format_list_tile_trailing.dart';
import 'package:taskwarrior/app/modules/settings/views/settings_page_highlist_task_list_tile_trailing.dart';
import 'package:taskwarrior/app/modules/settings/views/settings_page_list_tile.dart';
import 'package:taskwarrior/app/modules/settings/views/settings_page_on_task_create_list_tile_trailing.dart';
import 'package:taskwarrior/app/modules/settings/views/settings_page_on_task_start_list_tile_trailing.dart';
import 'package:taskwarrior/app/modules/settings/views/settings_page_select_directory_list_tile.dart';
import 'package:taskwarrior/app/modules/settings/views/settings_page_select_the_language_trailing.dart';
import 'package:taskwarrior/app/utils/constants/taskwarrior_fonts.dart';

import '../controllers/settings_controller.dart';

import 'package:taskwarrior/app/utils/constants/taskwarrior_colors.dart';
import 'package:taskwarrior/app/utils/theme/app_settings.dart';

class SettingsPageBody extends StatelessWidget {
  final SettingsController controller;
  const SettingsPageBody({required this.controller, super.key});

  @override
  Widget build(BuildContext context) {
    return (controller.isMovingDirectory.value)
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
              SettingsPageListTile(
                title: "Sync on Start",
                subTitle: "Automatically sync data on app start",
                trailing: SettingsPageOnTaskStartListTileTrailing(
                  controller: controller,
                ),
              ),
              const Divider(),
              SettingsPageListTile(
                title: "Sync on Task Create",
                subTitle: "Enable automatic syncing when creating a new task",
                trailing: SettingsPageOnTaskCreateListTileTrailing(
                  controller: controller,
                ),
              ),
              const Divider(),
              SettingsPageListTile(
                title: "Highlight the task",
                subTitle: "Make the border of task if only 1 day left",
                trailing: SettingsPageHighlistTaskListTileTrailing(
                  controller: controller,
                ),
              ),
              const Divider(),
              SettingsPageSelectDirectoryListTile(controller: controller),
              const Divider(),
              SettingsPageListTile(
                title: "Enable 24hr format",
                subTitle: "Switch right to enable 24 hr format",
                trailing: SettingsPageEnable24hrFormatListTileTrailing(
                  controller: controller,
                ),
              ),
              SettingsPageListTile(
                title: "Select the langauge",
                subTitle: "Toggle between your native langauge",
                trailing: SettingsPageSelectTheLanguageTrailing(
                  controller: controller,
                ),
              ),
            ],
          );
  }
}
