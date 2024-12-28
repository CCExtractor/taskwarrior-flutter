import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taskwarrior/app/models/storage/savefile.dart';
import 'package:taskwarrior/app/modules/profile/views/deleteprofiledialog.dart';
import 'package:taskwarrior/app/modules/profile/views/manageprofile.dart';
import 'package:taskwarrior/app/modules/profile/views/renameprofiledialog.dart';
import 'package:taskwarrior/app/modules/profile/views/selectprofile.dart';
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
    controller.initProfilePageTour();
    controller.showProfilePageTour(context);
    TaskwarriorColorTheme tColors = Theme.of(context).extension<TaskwarriorColorTheme>()!;
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
            // Navigator.pushReplacementNamed(context, PageRoutes.home);
            // Navigator.of(context).pop();
            Get.back();
          },
          icon: Icon(
            Icons.chevron_left,
            color: TaskWarriorColors.white,
            size: 30,
          ),
        ),
      ),
      //primary: false,
      backgroundColor: tColors.primaryBackgroundColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Obx(
              () => ProfilesColumn(
                currentProfileKey: controller.currentProfileKey,
                addNewProfileKey: controller.addNewProfileKey,
                manageSelectedProfileKey: controller.manageSelectedProfileKey,
                controller.profilesMap,
                controller.currentProfile.value,
                controller.profilesWidget.addProfile,
                controller.profilesWidget.selectProfile,
                () => showDialog(
                  context: context,
                  builder: (context) => Center(
                    child: RenameProfileDialog(
                      profile: controller.currentProfile.value,
                      alias: controller
                          .profilesMap[controller.currentProfile.value],
                      context: context,
                    ),
                  ),
                ),
                // () => Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     // builder: (_) => const ConfigureTaskserverRoute(),
                //     builder: (_) => const ManageTaskServerView(),
                //   ),
                // ),
                () => Get.toNamed(Routes.MANAGE_TASK_SERVER),
                () {
                  var tasks = controller.profilesWidget
                      .getStorage(controller.currentProfile.value)
                      .data
                      .export();
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
                () {
                  try {
                    controller.profilesWidget.copyConfigToNewProfile(
                      controller.currentProfile.value,
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
                        backgroundColor: tColors.secondaryBackgroundColor,
                        duration: const Duration(seconds: 2)));
                  }
                },
                () => showDialog(
                  context: context,
                  builder: (context) => DeleteProfileDialog(
                    profile: controller.currentProfile.value,
                    context: context,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProfilesColumn extends StatelessWidget {
  const ProfilesColumn(
    this.profilesMap,
    this.currentProfile,
    this.addProfile,
    this.selectProfile,
    this.rename,
    this.configure,
    this.export,
    this.copy,
    this.delete, {
    required this.currentProfileKey,
    required this.addNewProfileKey,
    required this.manageSelectedProfileKey,
    super.key,
  });

  final Map profilesMap;
  final String currentProfile;
  final void Function() addProfile;
  final void Function(String) selectProfile;
  final void Function() rename;
  final void Function() configure;
  final void Function() export;
  final void Function() copy;
  final void Function() delete;
  final GlobalKey currentProfileKey;
  final GlobalKey addNewProfileKey;
  final GlobalKey manageSelectedProfileKey;

  @override
  Widget build(BuildContext context) {
    TaskwarriorColorTheme tColors = Theme.of(context).extension<TaskwarriorColorTheme>()!;
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SelectProfile(
            currentProfile,
            profilesMap,
            selectProfile,
            currentProfileKey: currentProfileKey,
          ),
          const SizedBox(
            height: 6,
          ),
          ManageProfile(
            rename,
            configure,
            export,
            copy,
            delete,
            manageSelectedProfileKey: manageSelectedProfileKey,
          ),
          const SizedBox(
            height: 6,
          ),
          ElevatedButton.icon(
            key: addNewProfileKey,
            onPressed: () {
              try {
                addProfile();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content: Text(
                        'Profile Added Successfully',
                        style: TextStyle(
                          color: tColors.primaryTextColor,
                        ),
                      ),
                      backgroundColor: tColors.secondaryBackgroundColor,
                      duration: const Duration(seconds: 2)),
                );
                // Get.find<ProfileController>().update();
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Profile Additon Failed',
                      style: TextStyle(
                        color: tColors.primaryTextColor,
                      ),
                    ),
                    backgroundColor: tColors.secondaryBackgroundColor,
                    duration: const Duration(seconds: 2),
                  ),
                );
              }
            },
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all<Color>(
                tColors.secondaryBackgroundColor!,
              ),
            ),
            icon: Icon(Icons.add,
                color: tColors.purpleShade
              ),
            label: Text(
              SentenceManager(
                          currentLanguage: AppSettings.selectedLanguage)
                      .sentences
                      .profilePageAddNewProfile,

              style: TextStyle(
                color: tColors.primaryTextColor,
              ),
            ),
          )
        ],
      ),
    );
  }
}
