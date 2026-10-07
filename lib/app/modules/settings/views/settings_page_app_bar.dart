// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:taskwarrior/app/utils/language/sentence_manager.dart';
import 'package:taskwarrior/app/widgets/taskwarrior_page_app_bar.dart';

import '../controllers/settings_controller.dart';

/// The reference app bar style. It now delegates to the shared
/// [TaskWarriorPageAppBar], which is what every other page uses too.
class SettingsPageAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final SettingsController controller;
  const SettingsPageAppBar({required this.controller, super.key});

  @override
  Widget build(BuildContext context) {
    return TaskWarriorPageAppBar(
      title: Obx(
        () => TaskWarriorPageAppBar.titleText(
          SentenceManager(
                  currentLanguage: controller.selectedLanguage.value)
              .sentences
              .settingsPageTitle,
        ),
      ),
      subtitle: Obx(
        () => TaskWarriorPageAppBar.subtitleText(
          SentenceManager(
                  currentLanguage: controller.selectedLanguage.value)
              .sentences
              .settingsPageSubtitle,
        ),
      ),
      onLeadingPressed: () {
        if (Get.isSnackbarOpen == true) {
          Get.closeCurrentSnackbar();
        }
        Navigator.of(context).pop();
      },
    );
  }

  @override
  Size get preferredSize => AppBar().preferredSize;
}
