import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taskwarrior/app/modules/splash/controllers/splash_controller.dart';
import 'package:taskwarrior/app/utils/constants/utilites.dart';
import 'package:taskwarrior/app/utils/app_settings/app_settings.dart';
import 'package:taskwarrior/app/utils/language/sentence_manager.dart';
import 'package:taskwarrior/app/utils/themes/theme_extension.dart';

class DeleteProfileDialog extends StatelessWidget {
  const DeleteProfileDialog({
    required this.profile,
    required this.context,
    super.key,
  });

  final String profile;
  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    TaskwarriorColorTheme tColors = Theme.of(context).extension<TaskwarriorColorTheme>()!;
    return Center(
      child: SingleChildScrollView(
        child: Center(
          child: Utils.showAlertDialog(
            scrollable: true,
            title: Text(
              SentenceManager(
                          currentLanguage: AppSettings.selectedLanguage)
                      .sentences
                      .profilePageDeleteProfile,
              style: TextStyle(
                color: tColors.primaryTextColor,
              ),
            ),
            // content: TextField(controller: controller),
            actions: [
              TextButton(
                onPressed: () {
                  // Navigator.of(context).pop();
                  Get.back();
                },
                child: Text(
                  'Cancel',
                  style: TextStyle(
                    color: tColors.primaryTextColor,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  try {
                    Get.find<SplashController>().deleteProfile(profile);
                    // Navigator.of(context).pop();
                    Get.back();
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(
                          'Profile: ${profile.characters} Deleted Successfully',
                          style: TextStyle(
                            color: tColors.primaryTextColor,
                          ),
                        ),
                        backgroundColor: tColors.secondaryBackgroundColor,
                        duration: const Duration(seconds: 2)));
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(
                          'Profile: ${profile.characters} Deletion Failed',
                          style: TextStyle(
                            color: tColors.primaryTextColor,
                          ),
                        ),
                        backgroundColor: tColors.secondaryBackgroundColor,
                        duration: const Duration(seconds: 2)));
                  }
                },
                child: const Text(
                  'Confirm'
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
