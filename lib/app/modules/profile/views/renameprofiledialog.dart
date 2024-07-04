import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taskwarrior/app/modules/splash/controllers/splash_controller.dart';
import 'package:taskwarrior/app/utils/constants/taskwarrior_colors.dart';
import 'package:taskwarrior/app/utils/constants/utilites.dart';
import 'package:taskwarrior/app/utils/theme/app_settings.dart';

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
        child: Utils.showAlertDialog(
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
                // Navigator.of(context).pop();
                Get.back();
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
                Get.find<SplashController>().renameProfile(
                  profile: profile,
                  alias: controller.text,
                );
                // Navigator.of(context).pop();
                Get.back();
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
