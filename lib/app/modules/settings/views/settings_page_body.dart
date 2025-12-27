// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taskwarrior/app/routes/app_pages.dart';
import 'package:taskwarrior/app/utils/app_settings/app_settings.dart';
import 'package:taskwarrior/app/utils/constants/taskwarrior_fonts.dart';
import 'package:taskwarrior/app/utils/constants/utilites.dart';
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

  Future<bool> _getFlag() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool("settings_taskc") ?? false;
  }

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
        return ListView(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          children: [
            _buildSectionHeader(
              context,
              SentenceManager(
                      currentLanguage: controller.selectedLanguage.value)
                  .sentences
                  .syncSetting,
              Icons.sync,
              tColors,
            ),
            _buildSettingsCard(
              context,
              tColors,
              [
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
                Divider(
                    height: 1,
                    color: tColors.primaryDisabledTextColor?.withOpacity(0.1)),
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
              ],
            ),
            const SizedBox(height: 16),
            _buildSectionHeader(
              context,
              SentenceManager(
                      currentLanguage: controller.selectedLanguage.value)
                  .sentences
                  .displaySettings,
              Icons.display_settings,
              tColors,
            ),
            _buildSettingsCard(
              context,
              tColors,
              [
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
                Divider(
                    height: 1,
                    color: tColors.primaryDisabledTextColor?.withOpacity(0.1)),
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
                Divider(
                    height: 1,
                    color: tColors.primaryDisabledTextColor?.withOpacity(0.1)),
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
            ),
            const SizedBox(height: 16),
            _buildSectionHeader(
              context,
              SentenceManager(
                      currentLanguage: controller.selectedLanguage.value)
                  .sentences
                  .storageAndData,
              Icons.folder_outlined,
              tColors,
            ),
            _buildSettingsCard(
              context,
              tColors,
              [
                SettingsPageSelectDirectoryListTile(controller: controller),
              ],
            ),
            const SizedBox(height: 16),
            _buildSectionHeader(
              context,
              SentenceManager(
                      currentLanguage: controller.selectedLanguage.value)
                  .sentences
                  .advanced,
              Icons.settings_suggest,
              tColors,
            ),
            _buildSettingsCard(
              context,
              tColors,
              [
                SettingsPageListTile(
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
                FutureBuilder<bool>(
                  future: _getFlag(),
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                        return const SizedBox.shrink();
                      case ConnectionState.done:
                        final show = snapshot.data ?? false;
                        if (!show) return const SizedBox.shrink();
                        return Column(
                          children: [
                            Divider(
                                height: 1,
                                color: tColors.primaryDisabledTextColor
                                    ?.withOpacity(0.1)),
                            SettingsPageListTile(
                              title: SentenceManager(
                                currentLanguage: AppSettings.selectedLanguage,
                              ).sentences.deleteTaskTitle,
                              subTitle: SentenceManager(
                                currentLanguage: AppSettings.selectedLanguage,
                              ).sentences.deleteAllTasksWillBeMarkedAsDeleted,
                              trailing: IconButton(
                                onPressed: () {
                                  showDialog<void>(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return Utils.showAlertDialog(
                                        title: Text(
                                          SentenceManager(
                                            currentLanguage:
                                                AppSettings.selectedLanguage,
                                          ).sentences.deleteTaskConfirmation,
                                          style: TextStyle(
                                            color: tColors.primaryTextColor,
                                          ),
                                        ),
                                        content: Text(
                                          SentenceManager(
                                            currentLanguage:
                                                AppSettings.selectedLanguage,
                                          ).sentences.deleteTaskWarning,
                                          style: TextStyle(
                                            color: tColors
                                                .primaryDisabledTextColor,
                                          ),
                                        ),
                                        actions: <Widget>[
                                          TextButton(
                                            child: Text(
                                              SentenceManager(
                                                currentLanguage: AppSettings
                                                    .selectedLanguage,
                                              ).sentences.homePageCancel,
                                              style: TextStyle(
                                                color: tColors.primaryTextColor,
                                              ),
                                            ),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                          TextButton(
                                            child: Text(
                                              SentenceManager(
                                                currentLanguage: AppSettings
                                                    .selectedLanguage,
                                              ).sentences.navDrawerConfirm,
                                              style: TextStyle(
                                                color: tColors.primaryTextColor,
                                              ),
                                            ),
                                            onPressed: () {
                                              controller.deleteAllTasksInDB();
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                                icon: const Icon(Icons.delete),
                              ),
                            ),
                          ],
                        );
                      default:
                        return const SizedBox.shrink();
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],
        );
      }
    });
  }

  Widget _buildSectionHeader(
    BuildContext context,
    String title,
    IconData icon,
    TaskwarriorColorTheme tColors,
  ) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
      child: Row(
        children: [
          Icon(
            icon,
            size: 20,
            color: tColors.primaryTextColor?.withOpacity(0.7),
          ),
          const SizedBox(width: 8),
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: tColors.primaryTextColor?.withOpacity(0.7),
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsCard(
    BuildContext context,
    TaskwarriorColorTheme tColors,
    List<Widget> children,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12.0),
      decoration: BoxDecoration(
        color: tColors.primaryBackgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: tColors.primaryDisabledTextColor?.withOpacity(0.1) ??
              Colors.grey.withOpacity(0.1),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: children,
      ),
    );
  }
}
