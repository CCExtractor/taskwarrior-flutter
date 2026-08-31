// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:taskwarrior/app/modules/home/controllers/home_controller.dart';
import 'package:taskwarrior/app/routes/app_pages.dart';
import 'package:taskwarrior/app/utils/app_settings/app_settings.dart';
import 'package:taskwarrior/app/utils/constants/taskwarrior_fonts.dart';
import 'package:taskwarrior/app/utils/language/sentence_manager.dart';
import 'package:taskwarrior/app/utils/language/supported_language.dart';
import 'package:taskwarrior/app/utils/themes/theme_extension.dart';
import '../controllers/settings_controller.dart';
import 'package:taskwarrior/app/modules/settings/views/settings_group.dart';
import 'package:taskwarrior/app/modules/settings/views/settings_page_delete_tasks_tile.dart';
import 'package:taskwarrior/app/modules/settings/views/settings_page_list_tile.dart';
import 'package:taskwarrior/app/modules/settings/views/settings_page_select_directory_list_tile.dart';

class SettingsPageBody extends StatelessWidget {
  final SettingsController controller;

  const SettingsPageBody({required this.controller, super.key});

  @override
  Widget build(BuildContext context) {
    TaskwarriorColorTheme tColors =
        Theme.of(context).extension<TaskwarriorColorTheme>()!;
    return Obx(() {
      if (controller.isMovingDirectory.value) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Text(
                  SentenceManager(
                    currentLanguage: controller.selectedLanguage.value,
                  ).sentences.settingsPageMovingDataToNewDirectory,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w500,
                    fontSize: TaskWarriorFonts.fontSizeMedium,
                    color: tColors.primaryTextColor,
                  ),
                ),
              ),
            ],
          ),
        );
      } else {
        final sentences = SentenceManager(
          currentLanguage: controller.selectedLanguage.value,
        ).sentences;

        return ListView(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          children: [
            // Sync settings
            SettingsGroup(
              title: sentences.syncSetting,
              icon: Icons.sync,
              items: [
                SettingsToggleItem(
                  title: sentences.settingsPageSyncOnStartTitle,
                  subtitle: sentences.settingsPageSyncOnStartDescription,
                  value: controller.isSyncOnStartActivel,
                  prefsKey: 'sync-onStart',
                ),
                SettingsToggleItem(
                  title: sentences.settingsPageEnableSyncOnTaskCreateTitle,
                  subtitle:
                      sentences.settingsPageEnableSyncOnTaskCreateDescription,
                  value: controller.isSyncOnTaskCreateActivel,
                  prefsKey: 'sync-OnTaskCreate',
                ),
              ],
            ),

            // Display settings
            SettingsGroup(
              title: sentences.displaySettings,
              icon: Icons.display_settings,
              items: [
                SettingsToggleItem(
                  title: sentences.settingsPageHighlightTaskTitle,
                  subtitle: sentences.settingsPageHighlightTaskDescription,
                  value: controller.delaytask,
                  prefsKey: 'delaytask',
                  onChanged: (v) {
                    Get.find<HomeController>().useDelayTask.value = v;
                  },
                ),
                SettingsToggleItem(
                  title: sentences.settingsPageEnable24hrFormatTitle,
                  subtitle: sentences.settingsPageEnable24hrFormatDescription,
                  value: AppSettings.use24HourFormatRx,
                  onChanged: (v) {
                    AppSettings.saveSettings(
                      AppSettings.isDarkMode,
                      AppSettings.selectedLanguage,
                      v,
                    );
                  },
                ),
                SettingsDropdownItem<SupportedLanguage>(
                  title: sentences.settingsPageSelectLanguage,
                  subtitle: sentences.settingsPageToggleNativeLanguage,
                  value: controller.selectedLanguage,
                  options: SupportedLanguage.values,
                  labelBuilder: (lang) => lang.nativeName,
                  onChanged: (v) => controller.setSelectedLanguage(v),
                ),
              ],
            ),

            // Storage & Data
            SettingsGroup(
              title: sentences.storageAndData,
              icon: Icons.folder_outlined,
              items: [
                SettingsCustomItem(
                  child: SettingsPageSelectDirectoryListTile(
                    controller: controller,
                  ),
                ),
              ],
            ),

            // Advanced
            SettingsGroup(
              title: sentences.advanced,
              icon: Icons.settings_suggest,
              items: [
                SettingsCustomItem(
                  child: SettingsPageListTile(
                    title: SentenceManager(
                            currentLanguage: AppSettings.selectedLanguage)
                        .sentences
                        .logs,
                    subTitle: SentenceManager(
                            currentLanguage: AppSettings.selectedLanguage)
                        .sentences
                        .checkAllDebugLogsHere,
                    trailing: IconButton(
                      onPressed: () {
                        Get.toNamed(Routes.LOGS);
                      },
                      icon: const Icon(Icons.login),
                    ),
                  ),
                ),
                SettingsCustomItem(
                  child: SettingsPageDeleteTasksTile(
                    controller: controller,
                  ),
                ),
              ],
            ),
          ],
        );
      }
    });
  }

}
