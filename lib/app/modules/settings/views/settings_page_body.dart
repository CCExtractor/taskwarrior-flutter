// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taskwarrior/app/routes/app_pages.dart';
import 'package:taskwarrior/app/utils/constants/taskwarrior_colors.dart';
import 'package:taskwarrior/app/utils/constants/taskwarrior_fonts.dart';
import 'package:taskwarrior/app/utils/constants/utilites.dart';
import 'package:taskwarrior/app/utils/language/sentence_manager.dart';
import 'package:taskwarrior/app/utils/language/sentences.dart';
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

  Future<bool> _getFlag() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool("settings_taskc") ?? false;
  }

  @override
  Widget build(BuildContext context) {
    TaskwarriorColorTheme tColors =
        Theme.of(context).extension<TaskwarriorColorTheme>()!;
    return Obx(() {
      final Sentences sentences = SentenceManager(
        currentLanguage: controller.selectedLanguage.value,
      ).sentences;

      if (controller.isMovingDirectory.value) {
        return _movingDirectory(tColors, sentences);
      }

      return ListView(
        padding: const EdgeInsets.only(top: 8, bottom: 24),
        children: [
          _sectionHeader(sentences.syncSetting, Icons.sync, tColors),
          _card(tColors, [
            SettingsPageListTile(
              title: sentences.settingsPageSyncOnStartTitle,
              subTitle: sentences.settingsPageSyncOnStartDescription,
              trailing: SettingsPageOnTaskStartListTileTrailing(
                controller: controller,
              ),
            ),
            _divider(tColors),
            SettingsPageListTile(
              title: sentences.settingsPageEnableSyncOnTaskCreateTitle,
              subTitle: sentences.settingsPageEnableSyncOnTaskCreateDescription,
              trailing: SettingsPageOnTaskCreateListTileTrailing(
                controller: controller,
              ),
            ),
          ]),
          const SizedBox(height: 20),
          _sectionHeader(sentences.displaySettings, Icons.display_settings, tColors),
          _card(tColors, [
            SettingsPageListTile(
              title: sentences.settingsPageHighlightTaskTitle,
              subTitle: sentences.settingsPageHighlightTaskDescription,
              trailing: SettingsPageHighlistTaskListTileTrailing(
                controller: controller,
              ),
            ),
            _divider(tColors),
            SettingsPageListTile(
              title: sentences.settingsPageEnable24hrFormatTitle,
              subTitle: sentences.settingsPageEnable24hrFormatDescription,
              trailing: SettingsPageEnable24hrFormatListTileTrailing(
                controller: controller,
              ),
            ),
            _divider(tColors),
            SettingsPageListTile(
              title: sentences.settingsPageSelectLanguage,
              subTitle: sentences.settingsPageToggleNativeLanguage,
              trailing: SettingsPageSelectTheLanguageTrailing(
                controller: controller,
              ),
            ),
          ]),
          const SizedBox(height: 20),
          _sectionHeader(sentences.storageAndData, Icons.folder_outlined, tColors),
          _card(tColors, [
            SettingsPageSelectDirectoryListTile(controller: controller),
          ]),
          const SizedBox(height: 20),
          _sectionHeader(sentences.advanced, Icons.settings_suggest, tColors),
          _card(tColors, [
            SettingsPageListTile(
              title: sentences.logs,
              subTitle: sentences.checkAllDebugLogsHere,
              onTap: () => Get.toNamed(Routes.LOGS),
              trailing: Icon(
                Icons.chevron_right,
                color: tColors.primaryDisabledTextColor,
              ),
            ),
            FutureBuilder<bool>(
              future: _getFlag(),
              builder: (context, snapshot) {
                if (snapshot.connectionState != ConnectionState.done) {
                  return const SizedBox.shrink();
                }
                if (!(snapshot.data ?? false)) return const SizedBox.shrink();
                return Column(
                  children: [
                    _divider(tColors),
                    SettingsPageListTile(
                      title: sentences.deleteTaskTitle,
                      subTitle: sentences.deleteAllTasksWillBeMarkedAsDeleted,
                      onTap: () =>
                          _confirmDeleteAllTasks(context, tColors, sentences),
                      trailing: Icon(
                        Icons.delete_outline,
                        color: TaskWarriorColors.red,
                      ),
                    ),
                  ],
                );
              },
            ),
          ]),
        ],
      );
    });
  }

  Widget _movingDirectory(TaskwarriorColorTheme tColors, Sentences sentences) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Text(
              sentences.settingsPageMovingDataToNewDirectory,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontWeight: TaskWarriorFonts.medium,
                fontSize: TaskWarriorFonts.fontSizeMedium,
                color: tColors.primaryTextColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionHeader(
    String title,
    IconData icon,
    TaskwarriorColorTheme tColors,
  ) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 10),
      child: Row(
        children: [
          Icon(
            icon,
            size: 18,
            color: tColors.primaryTextColor,
          ),
          const SizedBox(width: 8),
          Text(
            title.toUpperCase(),
            style: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: TaskWarriorFonts.semiBold,
              letterSpacing: 0.8,
              color: tColors.primaryDisabledTextColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _card(TaskwarriorColorTheme tColors, List<Widget> children) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12.0),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: tColors.secondaryBackgroundColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: (tColors.dividerColor ?? TaskWarriorColors.grey)
              .withValues(alpha: 0.12),
        ),
      ),
      child: Column(
        children: children,
      ),
    );
  }

  Widget _divider(TaskwarriorColorTheme tColors) {
    return Divider(
      height: 1,
      thickness: 1,
      indent: 16,
      endIndent: 16,
      color: (tColors.dividerColor ?? TaskWarriorColors.grey)
          .withValues(alpha: 0.12),
    );
  }

  void _confirmDeleteAllTasks(
    BuildContext context,
    TaskwarriorColorTheme tColors,
    Sentences sentences,
  ) {
    showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) {
        return Utils.showAlertDialog(
          title: Text(
            sentences.deleteTaskConfirmation,
            style: TextStyle(color: tColors.primaryTextColor),
          ),
          content: Text(
            sentences.deleteTaskWarning,
            style: TextStyle(color: tColors.primaryDisabledTextColor),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text(
                sentences.homePageCancel,
                style: TextStyle(color: tColors.primaryTextColor),
              ),
            ),
            TextButton(
              onPressed: () {
                controller.deleteAllTasksInDB();
                Navigator.of(dialogContext).pop();
              },
              child: Text(
                sentences.navDrawerConfirm,
                style: TextStyle(color: TaskWarriorColors.red),
              ),
            ),
          ],
        );
      },
    );
  }
}
