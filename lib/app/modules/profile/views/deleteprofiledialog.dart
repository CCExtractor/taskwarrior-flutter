import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taskwarrior/app/modules/home/controllers/home_controller.dart';
import 'package:taskwarrior/app/modules/splash/controllers/splash_controller.dart';
import 'package:taskwarrior/app/utils/constants/utilites.dart';
import 'package:taskwarrior/app/utils/app_settings/app_settings.dart';
import 'package:taskwarrior/app/utils/language/sentence_manager.dart';
import 'package:taskwarrior/app/utils/themes/theme_extension.dart';

class DeleteProfileDialog extends StatelessWidget {
  const DeleteProfileDialog({
    required this.profile,
    required this.context,
    required this.profiles,
    required this.profileName,
    super.key,
  });

  final String profile;
  final BuildContext context;
  final RxMap<dynamic, dynamic> profiles;
  final String? profileName;
  @override
  Widget build(BuildContext context) {
    TaskwarriorColorTheme tColors = Theme.of(context).extension<TaskwarriorColorTheme>()!;
    return Center(
      child: SingleChildScrollView(
        child: Center(
          child: Utils.showAlertDialog(
            scrollable: true,
            title: Text(
              SentenceManager(currentLanguage: AppSettings.selectedLanguage)
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
                  debugPrint("PROFILE$profile${profileName!}");
                  profiles[profile] = profileName;
                  Get.back();
                },
                child: Text(
                  SentenceManager(currentLanguage: AppSettings.selectedLanguage)
                      .sentences
                      .cancel,
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
                    Get.find<HomeController>().refreshTaskWithNewProfile();
                    Get.back();
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(
                          '${SentenceManager(currentLanguage: AppSettings.selectedLanguage).sentences.profilePageProfile}: ${profile.characters} ${SentenceManager(currentLanguage: AppSettings.selectedLanguage).sentences.profileDeletedSuccessfully}',
                          style: TextStyle(
                            color: tColors.primaryTextColor,
                          ),
                        ),
                        backgroundColor: tColors.secondaryBackgroundColor,
                        duration: const Duration(seconds: 2)));
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(
                          '${SentenceManager(currentLanguage: AppSettings.selectedLanguage).sentences.profilePageProfile}: ${profile.characters} ${SentenceManager(currentLanguage: AppSettings.selectedLanguage).sentences.profileDeletionFailed}',
                          style: TextStyle(
                            color: tColors.primaryTextColor,
                          ),
                        ),
                        backgroundColor: tColors.secondaryBackgroundColor,
                        duration: const Duration(seconds: 2)));
                  }
                },
                child: Text(
                  SentenceManager(currentLanguage: AppSettings.selectedLanguage)
                      .sentences
                      .profileDeleteConfirmation,
                  style: TextStyle(
                    color: tColors.primaryTextColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
