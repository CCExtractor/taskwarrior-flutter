import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taskwarrior/app/utils/app_settings/app_settings.dart';
import 'package:taskwarrior/app/utils/constants/utilites.dart';
import 'package:taskwarrior/app/utils/language/sentence_manager.dart';
import 'package:taskwarrior/app/utils/themes/theme_extension.dart';

import '../controllers/settings_controller.dart';
import 'settings_page_list_tile.dart';

class SettingsPageDeleteTasksTile extends StatelessWidget {
  final SettingsController controller;

  const SettingsPageDeleteTasksTile({required this.controller, super.key});

  Future<bool> _getFlag() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool("settings_taskc") ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final tColors = Theme.of(context).extension<TaskwarriorColorTheme>()!;
    final sentences = SentenceManager(
      currentLanguage: AppSettings.selectedLanguage,
    ).sentences;

    return FutureBuilder<bool>(
      future: _getFlag(),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const SizedBox.shrink();
        }
        final show = snapshot.data ?? false;
        if (!show) return const SizedBox.shrink();

        return SettingsPageListTile(
          title: sentences.deleteTaskTitle,
          subTitle: sentences.deleteAllTasksWillBeMarkedAsDeleted,
          trailing: IconButton(
            onPressed: () {
              showDialog<void>(
                context: context,
                builder: (BuildContext context) {
                  return Utils.showAlertDialog(
                    title: Text(
                      sentences.deleteTaskConfirmation,
                      style: TextStyle(color: tColors.primaryTextColor),
                    ),
                    content: Text(
                      sentences.deleteTaskWarning,
                      style: TextStyle(
                        color: tColors.primaryDisabledTextColor,
                      ),
                    ),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: Text(
                          sentences.homePageCancel,
                          style: TextStyle(color: tColors.primaryTextColor),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          controller.deleteAllTasksInDB();
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          sentences.navDrawerConfirm,
                          style: TextStyle(color: tColors.primaryTextColor),
                        ),
                      ),
                    ],
                  );
                },
              );
            },
            icon: const Icon(Icons.delete),
          ),
        );
      },
    );
  }
}
