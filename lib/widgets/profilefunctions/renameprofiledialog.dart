import 'package:flutter/material.dart';
import 'package:taskwarrior/config/app_settings.dart';
import 'package:taskwarrior/config/taskwarriorcolors.dart';

import 'package:taskwarrior/widgets/taskdetails.dart';

class RenameProfileDialog extends StatelessWidget {
  const RenameProfileDialog({
    required this.profile,
    required this.alias,
    required this.context,
    super.key,
  });

  final String profile;
  final String? alias;
  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    var controller = TextEditingController(text: alias);

    return SingleChildScrollView(
      child: Center(
        child: AlertDialog(
          surfaceTintColor: AppSettings.isDarkMode
              ? TaskWarriorColors.kdialogBackGroundColor
              : TaskWarriorColors.kLightDialogBackGroundColor,
          shadowColor: AppSettings.isDarkMode
              ? TaskWarriorColors.kdialogBackGroundColor
              : TaskWarriorColors.kLightDialogBackGroundColor,
          backgroundColor: AppSettings.isDarkMode
              ? TaskWarriorColors.kdialogBackGroundColor
              : TaskWarriorColors.kLightDialogBackGroundColor,
          scrollable: true,
          title: Text(
            'Rename Alias',
            style: TextStyle(
              color: AppSettings.isDarkMode
                  ? TaskWarriorColors.white
                  : TaskWarriorColors.black,
            ),
          ),
          content: TextField(
              style: TextStyle(
                color: AppSettings.isDarkMode
                    ? TaskWarriorColors.white
                    : TaskWarriorColors.black,
              ),
              controller: controller),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: AppSettings.isDarkMode
                      ? TaskWarriorColors.white
                      : TaskWarriorColors.black,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                ProfilesWidget.of(context).renameProfile(
                  profile: profile,
                  alias: controller.text,
                );
                Navigator.of(context).pop();
              },
              child: Text(
                'Submit',
                style: TextStyle(
                  color: AppSettings.isDarkMode
                      ? TaskWarriorColors.black
                      : TaskWarriorColors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
