import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taskwarrior/app/models/storage/savefile.dart';
import 'package:taskwarrior/app/modules/profile/views/deleteprofiledialog.dart';
import 'package:taskwarrior/app/modules/profile/views/profiles_list.dart';
import 'package:taskwarrior/app/modules/profile/views/renameprofiledialog.dart';
import 'package:taskwarrior/app/routes/app_pages.dart';
import 'package:taskwarrior/app/utils/constants/taskwarrior_colors.dart';
import 'package:taskwarrior/app/utils/constants/utilites.dart';

import 'package:taskwarrior/app/utils/app_settings/app_settings.dart';
import 'package:taskwarrior/app/utils/language/sentence_manager.dart';
import 'package:taskwarrior/app/utils/themes/theme_extension.dart';

import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});
  @override
  Widget build(BuildContext context) {
    debugPrint("Controller Value: ${controller.currentProfile.value}");
    controller.initProfilePageTour();
    controller.showProfilePageTour(context);
    TaskwarriorColorTheme tColors =
        Theme.of(context).extension<TaskwarriorColorTheme>()!;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: TaskWarriorColors.appBarColor,
        title: Obx(() => Text(
              controller.profilesMap.length == 1
                  ? SentenceManager(
                          currentLanguage: AppSettings.selectedLanguage)
                      .sentences
                      .profilePageProfile
                  : SentenceManager(
                          currentLanguage: AppSettings.selectedLanguage)
                      .sentences
                      .profilePageProfiles,
              style: GoogleFonts.poppins(
                color: TaskWarriorColors.white,
              ),
            )),
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(
            Icons.chevron_left,
            color: TaskWarriorColors.white,
            size: 30,
          ),
        ),
        actions: [
          TextButton(
            onPressed: controller.profilesWidget.addProfile,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.add,
                  color: Colors.white,
                ),
                const SizedBox(
                  width: 10,
                ),
                Text('Add Profile', style: TextStyle(color: Colors.white)),
              ],
            ),
          ),
        ],
      ),
      backgroundColor: tColors.primaryBackgroundColor,
      body: Obx(() => ProfilesList(
            currentProfileKey: controller.currentProfileKey,
            addNewProfileKey: controller.addNewProfileKey,
            manageSelectedProfileKey: controller.manageSelectedProfileKey,
            controller.profilesMap,
            controller.currentProfile.value,
            controller.profilesWidget.addProfile,
            controller.profilesWidget.selectProfile,
            (profile) => showDialog(
              context: context,
              builder: (context) => Center(
                child: RenameProfileDialog(
                  profile: profile,
                  alias:
                      controller.profilesMap[controller.currentProfile.value],
                  context: context,
                ),
              ),
            ),
            () => Get.toNamed(Routes.MANAGE_TASK_SERVER),
            (profile) {
              var tasks =
                  controller.profilesWidget.getStorage(profile).data.export();
              var now = DateTime.now()
                  .toIso8601String()
                  .replaceAll(RegExp(r'[-:]'), '')
                  .replaceAll(RegExp(r'\..*'), '');

              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return Utils.showAlertDialog(
                    title: Text(
                      SentenceManager(
                              currentLanguage: AppSettings.selectedLanguage)
                          .sentences
                          .profilePageExportTasksDialogueTitle,
                      style: TextStyle(
                        color: tColors.primaryTextColor,
                      ),
                    ),
                    content: Text(
                      SentenceManager(
                              currentLanguage: AppSettings.selectedLanguage)
                          .sentences
                          .profilePageExportTasksDialogueSubtitle,
                      style: TextStyle(
                        color: tColors.primaryTextColor,
                      ),
                    ),
                    actions: <Widget>[
                      TextButton(
                        child: Text(
                          "JSON",
                          style: TextStyle(
                            color: tColors.primaryTextColor,
                          ),
                        ),
                        onPressed: () {
                          // Navigator.of(context).pop();
                          Get.back();
                          exportTasks(
                            contents: tasks,
                            suggestedName: 'tasks-$now.json',
                          );
                        },
                      ),
                      TextButton(
                        child: Text(
                          "TXT",
                          style: TextStyle(
                            color: tColors.primaryTextColor,
                          ),
                        ),
                        onPressed: () {
                          // Navigator.of(context).pop();
                          Get.back();
                          exportTasks(
                            contents: tasks,
                            suggestedName: 'tasks-$now.txt',
                          );
                        },
                      ),
                    ],
                  );
                },
              );
            },
            (profile) {
              try {
                controller.profilesWidget.copyConfigToNewProfile(
                  profile,
                );
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(
                      'Profile Config Copied',
                      style: TextStyle(
                        color: tColors.primaryTextColor,
                      ),
                    ),
                    backgroundColor: tColors.secondaryBackgroundColor,
                    duration: const Duration(seconds: 2)));
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(
                      'Profile Config Copy Failed',
                      style: TextStyle(
                        color: tColors.primaryTextColor,
                      ),
                    ),
                    backgroundColor: tColors.primaryBackgroundColor,
                    duration: const Duration(seconds: 2)));
              }
            },
            (profile) {
              String? profileName = controller.profilesMap[profile];
              controller.profilesMap.remove(profile);
              showDialog(
                context: context,
                builder: (context) => DeleteProfileDialog(
                  profile: profile,
                  context: context,
                  profiles: controller.profilesMap,
                  profileName: profileName,
                ),
              );
            },
          )),
    );
  }
}
