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
import 'package:taskwarrior/app/v3/champion/replica.dart';
import 'package:taskwarrior/app/v3/db/task_database.dart';

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
    return Obx(
      () => PopScope(
        canPop: !controller.isProfileTourActive.value,
        onPopInvokedWithResult: (didPop, result) async {
          if (controller.isProfileTourActive.value) {
            Get.closeAllSnackbars();
            Get.snackbar(
              'Tour Active',
              'Please complete the tour before navigating back.',
              snackPosition: SnackPosition.BOTTOM,
            );
            return;
          }
        },
        child: Scaffold(
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
                // Navigator.pushReplacementNamed(context, PageRoutes.home);
                // Navigator.of(context).pop();
                Get.back();
              },
              icon: Icon(
                Icons.chevron_left,
                color: TaskWarriorColors.white,
                size: 35,
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
                    Text(
                        SentenceManager(
                                currentLanguage: AppSettings.selectedLanguage)
                            .sentences
                            .profilePageAddNewProfile,
                        style: TextStyle(color: Colors.white)),
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
                      alias: controller
                          .profilesMap[controller.currentProfile.value],
                      context: context,
                    ),
                  ),
                ),
                () {
                  if (controller.profilesWidget
                              .getMode(controller.currentProfile.value) ==
                          'TW3' ||
                      controller.profilesWidget
                              .getMode(controller.currentProfile.value) ==
                          'TW3C') {
                    Get.toNamed(Routes.MANAGE_TASK_CHAMPION_CREDS);
                    return;
                  }
                  Get.toNamed(Routes.MANAGE_TASK_SERVER);
                },
                (profile) async {
                  String tasks;
                  if (controller.profilesWidget.getMode(profile) == "TW2") {
                    tasks = controller.profilesWidget
                        .getStorage(profile)
                        .data
                        .export();
                  } else if (controller.profilesWidget.getMode(profile) ==
                      "TW3") {
                    TaskDatabase db = TaskDatabase();
                    await db.openForProfile(profile);
                    tasks = await db.exportAllTasks();
                  } else {
                    tasks = await Replica.getAllTasksFromReplica().then(
                        (taskList) => taskList
                            .map((e) => e.toJson())
                            .toList()
                            .toString());
                    debugPrint("Exported Tasks from Replica: $tasks");
                  }
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
                              style: TextStyle(color: tColors.primaryTextColor),
                            ),
                            // CCSync v3 is deprecated, so hiding it for now
                            // RadioListTile<String>(
                            //   title: const Text('CCSync (v3)'),
                            //   value: 'TW3',
                            //   groupValue: selectedMode,
                            //   onChanged: (String? value) {
                            //     setState(() {
                            //       selectedMode = value;
                            //     });
                            //   },
                            // ),
                            RadioListTile<String>(
                              title: const Text('TaskServer'),
                              value: 'TW2',
                              groupValue: selectedMode,
                              onChanged: (String? value) {
                                setState(() {
                                  selectedMode = value;
                                });
                              },
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
                (profile) async {
                  try {
                    await controller.profilesWidget.copyConfigToNewProfile(
                      profile,
                    );
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(
                          SentenceManager(
                                  currentLanguage: AppSettings.selectedLanguage)
                              .sentences
                              .profileConfigCopied,
                          style: TextStyle(
                            color: tColors.primaryTextColor,
                          ),
                        ),
                        backgroundColor: tColors.secondaryBackgroundColor,
                        duration: const Duration(seconds: 2)));
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(
                          SentenceManager(
                                  currentLanguage: AppSettings.selectedLanguage)
                              .sentences
                              .profileConfigCopyFailed,
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
                (profile) {
                  String currentMode =
                      controller.profilesWidget.getMode(profile);
                  String? selectedMode = currentMode;
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return Utils.showAlertDialog(
                        title: Text(
                          SentenceManager(
                                  currentLanguage: AppSettings.selectedLanguage)
                              .sentences
                              .profilePageChangeProfileMode,
                        ),
                        // Use StatefulBuilder to manage the state of the radio buttons inside the dialog
                        content: StatefulBuilder(
                          builder:
                              (BuildContext context, StateSetter setState) {
                            return Column(
                              mainAxisSize:
                                  MainAxisSize.min, // Use minimum space
                              children: <Widget>[
                                RadioListTile<String>(
                                  title: const Text('Taskchampion (v3)'),
                                  value: 'TW3C',
                                  groupValue: selectedMode,
                                  onChanged: (String? value) {
                                    setState(() {
                                      selectedMode = value;
                                    });
                                  },
                                ),
                                RadioListTile<String>(
                                  title: const Text('CCSync (v3)'),
                                  value: 'TW3',
                                  groupValue: selectedMode,
                                  onChanged: (String? value) {
                                    setState(() {
                                      selectedMode = value;
                                    });
                                  },
                                ),
                                RadioListTile<String>(
                                  title: const Text('TaskServer'),
                                  value: 'TW2',
                                  groupValue: selectedMode,
                                  onChanged: (String? value) {
                                    setState(() {
                                      selectedMode = value;
                                    });
                                  },
                                ),
                              ],
                            );
                          },
                        ),
                        actions: <Widget>[
                          // A button to cancel the operation
                          TextButton(
                            child: Text(
                              SentenceManager(
                                      currentLanguage:
                                          AppSettings.selectedLanguage)
                                  .sentences
                                  .cancel, // Assuming you have a 'cancel' string
                              style: TextStyle(color: tColors.primaryTextColor),
                            ),
                            onPressed: () {
                              Get.back(); // Dismiss the dialog
                            },
                          ),
                          // A button to submit the change
                          TextButton(
                            child: Text(
                              SentenceManager(
                                      currentLanguage:
                                          AppSettings.selectedLanguage)
                                  .sentences
                                  .submit, // Or use a translated string
                              style: TextStyle(color: tColors.primaryTextColor),
                            ),
                            onPressed: () {
                              Get.back();
                              if (selectedMode != null &&
                                  selectedMode != currentMode) {
                                controller.profilesWidget.changeModeTo(
                                  profile,
                                  selectedMode!,
                                );
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text(
                                          SentenceManager(
                                                      currentLanguage:
                                                          AppSettings
                                                              .selectedLanguage)
                                                  .sentences
                                                  .profilePageSuccessfullyChangedProfileModeTo +
                                              ((selectedMode ?? "") == "TW3"
                                                  ? "CCSync"
                                                  : "Taskserver"),
                                          style: TextStyle(
                                            color: tColors.primaryTextColor,
                                          ),
                                        ),
                                        backgroundColor:
                                            tColors.secondaryBackgroundColor,
                                        duration: const Duration(seconds: 2)));
                              }
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
              )),
        ),
      ),
    );
  }
}
