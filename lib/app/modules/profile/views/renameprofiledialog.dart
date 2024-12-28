import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taskwarrior/app/modules/splash/controllers/splash_controller.dart';
import 'package:taskwarrior/app/utils/constants/utilites.dart';

import 'package:taskwarrior/app/utils/app_settings/app_settings.dart';
import 'package:taskwarrior/app/utils/language/sentence_manager.dart';
import 'package:taskwarrior/app/utils/themes/theme_extension.dart';

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
    TaskwarriorColorTheme tColors = Theme.of(context).extension<TaskwarriorColorTheme>()!;
    return SingleChildScrollView(
      child: Center(
        child: Utils.showAlertDialog(
          scrollable: true,
          title: Text(
            SentenceManager(
                          currentLanguage: AppSettings.selectedLanguage)
                      .sentences
                      .profilePageRenameAliasDialogueBoxTitle,
            style: TextStyle(
              color: tColors.primaryTextColor,
            ),
          ),
          content: TextField(
              style: TextStyle(
                color: tColors.primaryTextColor,
              ),
              controller: controller),
          actions: [
            TextButton(
              onPressed: () {
                // Navigator.of(context).pop();
                Get.back();
              },
              child: Text(
                SentenceManager(currentLanguage: AppSettings.selectedLanguage)
              .sentences
              .profilePageRenameAliasDialogueBoxCancel,
                style: TextStyle(
                  color: tColors.primaryTextColor,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Get.find<SplashController>().renameProfile(
                  profile: profile,
                  alias: controller.text,
                );
                // Navigator.of(context).pop();
                Get.back();
              },
              child: Text(
                SentenceManager(currentLanguage: AppSettings.selectedLanguage)
              .sentences
              .profilePageRenameAliasDialogueBoxSubmit,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
