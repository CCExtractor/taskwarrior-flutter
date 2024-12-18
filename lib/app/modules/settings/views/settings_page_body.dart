// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:taskwarrior/app/modules/settings/views/settings_page_taskchampion.dart';
import 'package:taskwarrior/app/utils/constants/taskwarrior_fonts.dart';
import 'package:taskwarrior/app/utils/language/sentence_manager.dart';
import 'package:taskwarrior/app/utils/themes/theme_extension.dart';
import '../controllers/settings_controller.dart';
import 'package:taskwarrior/app/modules/settings/views/settings_page_enable_24hr_format_list_tile_trailing.dart';
import 'package:taskwarrior/app/modules/settings/views/settings_page_highlist_task_list_tile_trailing.dart';
import 'package:taskwarrior/app/modules/settings/views/settings_page_list_tile.dart';
import 'package:taskwarrior/app/modules/settings/views/settings_page_on_task_create_list_tile_trailing.dart';
import 'package:taskwarrior/app/modules/settings/views/settings_page_on_task_start_list_tile_trailing.dart';
import 'package:taskwarrior/app/modules/settings/views/settings_page_select_directory_list_tile.dart';
import 'package:taskwarrior/app/modules/settings/views/settings_page_select_the_language_trailing.dart';

class SettingsPageBody extends StatelessWidget {
  final SettingsController controller;

  const SettingsPageBody({required this.controller, super.key});

  @override
  Widget build(BuildContext context) {
    TaskwarriorColorTheme tColors = Theme.of(context).extension<TaskwarriorColorTheme>()!;
    return Obx(() {
      if (controller.isMovingDirectory.value) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 10),
              Text(
                SentenceManager(
                  currentLanguage: controller.selectedLanguage.value,
                ).sentences.settingsPageMovingDataToNewDirectory,
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  fontSize: TaskWarriorFonts.fontSizeMedium,
                  color: tColors.primaryTextColor,
                ),
              ),
            ],
          ),
        );
      } else {
        return ListView(
          children: [
            Obx(
              () => SettingsPageListTile(
                title: SentenceManager(
                        currentLanguage: controller.selectedLanguage.value)
                    .sentences
                    .settingsPageSyncOnStartTitle,
                subTitle: SentenceManager(
                        currentLanguage: controller.selectedLanguage.value)
                    .sentences
                    .settingsPageSyncOnStartDescription,
                trailing: SettingsPageOnTaskStartListTileTrailing(
                  controller: controller,
                ),
              ),
            ),
            const Divider(),
            Obx(
              () => SettingsPageListTile(
                title: SentenceManager(
                        currentLanguage: controller.selectedLanguage.value)
                    .sentences
                    .settingsPageEnableSyncOnTaskCreateTitle,
                subTitle: SentenceManager(
                        currentLanguage: controller.selectedLanguage.value)
                    .sentences
                    .settingsPageEnableSyncOnTaskCreateDescription,
                trailing: SettingsPageOnTaskCreateListTileTrailing(
                  controller: controller,
                ),
              ),
            ),
            const Divider(),
            SettingsPageListTile(
              title: SentenceManager(
                      currentLanguage: controller.selectedLanguage.value)
                  .sentences
                  .settingsPageHighlightTaskTitle,
              subTitle: SentenceManager(
                      currentLanguage: controller.selectedLanguage.value)
                  .sentences
                  .settingsPageHighlightTaskDescription,
              trailing: SettingsPageHighlistTaskListTileTrailing(
                controller: controller,
              ),
            ),
            const Divider(),
            SettingsPageSelectDirectoryListTile(controller: controller),
            const Divider(),
            SettingsPageListTile(
              title: SentenceManager(
                      currentLanguage: controller.selectedLanguage.value)
                  .sentences
                  .settingsPageEnable24hrFormatTitle,
              subTitle: SentenceManager(
                      currentLanguage: controller.selectedLanguage.value)
                  .sentences
                  .settingsPageEnable24hrFormatDescription,
              trailing: SettingsPageEnable24hrFormatListTileTrailing(
                controller: controller,
              ),
            ),
            const Divider(),
            SettingsPageListTile(
              title: SentenceManager(
                      currentLanguage: controller.selectedLanguage.value)
                  .sentences
                  .taskchampionTileTitle,
              subTitle: SentenceManager(
                      currentLanguage: controller.selectedLanguage.value)
                  .sentences
                  .taskchampionTileDescription,
              trailing: SettingsPageTaskchampionTileListTileTrailing(
                controller: controller,
              ),
            ),
            const Divider(),
            SettingsPageListTile(
              title: SentenceManager(
                      currentLanguage: controller.selectedLanguage.value)
                  .sentences
                  .settingsPageSelectLanguage,
              subTitle: SentenceManager(
                      currentLanguage: controller.selectedLanguage.value)
                  .sentences
                  .settingsPageToggleNativeLanguage,
              trailing: SettingsPageSelectTheLanguageTrailing(
                controller: controller,
              ),
            ),
          ],
        );
      }
    });
  }
}
