import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taskwarrior/app/utils/app_settings/app_settings.dart';
import 'package:taskwarrior/app/modules/home/controllers/home_controller.dart';
import 'package:taskwarrior/app/modules/home/views/home_page_nav_drawer_menu_item.dart';
import 'package:taskwarrior/app/modules/home/views/theme_clipper.dart';
import 'package:taskwarrior/app/modules/reports/views/reports_view_taskc.dart';
import 'package:taskwarrior/app/routes/app_pages.dart';
import 'package:taskwarrior/app/utils/constants/constants.dart';
import 'package:taskwarrior/app/utils/constants/taskwarrior_fonts.dart';
import 'package:taskwarrior/app/utils/constants/utilites.dart';
import 'package:taskwarrior/app/utils/language/sentence_manager.dart';
import 'package:taskwarrior/app/utils/taskchampion/taskchampion.dart';
import 'package:taskwarrior/app/utils/themes/theme_extension.dart';
import 'package:taskwarrior/app/utils/themes/dark_theme.dart';
import 'package:taskwarrior/app/utils/themes/light_theme.dart';

class NavDrawer extends StatelessWidget {
  final HomeController homeController;
  const NavDrawer({super.key, required this.homeController});

  @override
  Widget build(BuildContext context) {
    TaskwarriorColorTheme tColors = Theme.of(context).extension<TaskwarriorColorTheme>()!;
    return Drawer(
      backgroundColor: tColors.dialogBackgroundColor,
      surfaceTintColor: tColors.dialogBackgroundColor,
      child: Container(
        color: tColors.dialogBackgroundColor,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            Container(
              color: tColors.dialogBackgroundColor,
              padding: const EdgeInsets.only(top: 50, left: 15, right: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    SentenceManager(
                            currentLanguage:
                                homeController.selectedLanguage.value)
                        .sentences
                        .homePageMenu,
                    style: TextStyle(
                      fontSize: TaskWarriorFonts.fontSizeExtraLarge,
                      fontWeight: TaskWarriorFonts.bold,
                      color: tColors.primaryTextColor,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: ThemeSwitcherClipper(
                      isDarkMode: AppSettings.isDarkMode,
                      onTap: (bool newMode) async {
                        Get.changeThemeMode(newMode ? ThemeMode.dark : ThemeMode.light);
                        AppSettings.isDarkMode = newMode;
                        await SelectedTheme.saveMode(AppSettings.isDarkMode);
                        // Get.back();
                        homeController.initLanguageAndDarkMode();
                        Get.changeTheme(AppSettings.isDarkMode ? darkTheme : lightTheme);
                      },
                      child: Icon(
                        tColors.icons,
                        color: tColors.primaryTextColor,
                        size: 15,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              color: tColors.dialogBackgroundColor,
              height: Get.height * 0.03,
            ),
            Visibility(
              visible: homeController.taskchampion.value,
              child: NavDrawerMenuItem(
                icon: Icons.task_alt,
                text: SentenceManager(
                  currentLanguage: homeController.selectedLanguage.value,
                ).sentences.ccsyncCredentials,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => ManageTaskChampionCreds(),
                    ),
                  );
                },
              ),
            ),
            Visibility(
              visible: homeController.taskchampion.value,
              child: NavDrawerMenuItem(
                  icon: Icons.delete,
                  text: SentenceManager(
                    currentLanguage: homeController.selectedLanguage.value,
                  ).sentences.deleteTaskTitle,
                  onTap: () {
                    showDialog<void>(
                      context: context,
                      builder: (BuildContext context) {
                        return Utils.showAlertDialog(
                          title: Text(
                            SentenceManager(
                              currentLanguage:
                                  homeController.selectedLanguage.value,
                            ).sentences.deleteTaskConfirmation,
                            style: TextStyle(
                              color: tColors.primaryTextColor,
                            ),
                          ),
                          content: Text(
                            SentenceManager(
                              currentLanguage:
                                  homeController.selectedLanguage.value,
                            ).sentences.deleteTaskWarning,
                            style: TextStyle(
                              color: tColors.primaryDisabledTextColor,
                            ),
                          ),
                          actions: <Widget>[
                            TextButton(
                              child: Text(
                                'Cancel',
                                style: TextStyle(
                                  color: tColors.primaryTextColor,
                                ),
                              ),
                              onPressed: () {
                                Navigator.of(context).pop(); // Close the dialog
                              },
                            ),
                            TextButton(
                              child: Text(
                                'Confirm',
                                style: TextStyle(
                                  color: tColors.primaryTextColor,
                                ),
                              ),
                              onPressed: () {
                                homeController.deleteAllTasksInDB();
                                Navigator.of(context).pop(); // Close the dialog
                              },
                            ),
                          ],
                        );
                      },
                    );
                  }),
            ),
            Visibility(
              visible: !homeController.taskchampion.value,
              child: Obx(
                () => NavDrawerMenuItem(
                  icon: Icons.person_rounded,
                  text: SentenceManager(
                    currentLanguage: homeController.selectedLanguage.value,
                  ).sentences.navDrawerProfile,
                  onTap: () {
                    Get.toNamed(Routes.PROFILE);
                  },
                ),
              ),
            ),
            Visibility(
              visible: !homeController.taskchampion.value,
              child: Obx(
                () => NavDrawerMenuItem(
                  icon: Icons.summarize,
                  text: SentenceManager(
                    currentLanguage: homeController.selectedLanguage.value,
                  ).sentences.navDrawerReports,
                  onTap: () {
                    Get.toNamed(Routes.REPORTS);
                  },
                ),
              ),
            ),
            Visibility(
              visible: homeController.taskchampion.value,
              child: Obx(
                () => NavDrawerMenuItem(
                  icon: Icons.summarize,
                  text: SentenceManager(
                    currentLanguage: homeController.selectedLanguage.value,
                  ).sentences.navDrawerReports,
                  onTap: () {
                    Get.to(() => ReportsHomeTaskc());
                  },
                ),
              ),
            ),
            Obx(
              () => NavDrawerMenuItem(
                icon: Icons.info,
                text: SentenceManager(
                  currentLanguage: homeController.selectedLanguage.value,
                ).sentences.navDrawerAbout,
                onTap: () {
                  Get.toNamed(Routes.ABOUT);
                },
              ),
            ),
            Obx(
              () => NavDrawerMenuItem(
                icon: Icons.settings,
                text: SentenceManager(
                  currentLanguage: homeController.selectedLanguage.value,
                ).sentences.navDrawerSettings,
                onTap: () async {
                  final SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  homeController.syncOnStart.value =
                      prefs.getBool('sync-onStart') ?? false;
                  homeController.syncOnTaskCreate.value =
                      prefs.getBool('sync-OnTaskCreate') ?? false;
                  homeController.delaytask.value =
                      prefs.getBool('delaytask') ?? false;
                  homeController.change24hr.value =
                      prefs.getBool('24hourformate') ?? false;

                  Get.toNamed(Routes.SETTINGS);
                },
              ),
            ),
            Obx(
              () => NavDrawerMenuItem(
                icon: Icons.exit_to_app,
                text: SentenceManager(
                  currentLanguage: homeController.selectedLanguage.value,
                ).sentences.navDrawerExit,
                onTap: () {
                  _showExitConfirmationDialog(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showExitConfirmationDialog(BuildContext context) async {
    TaskwarriorColorTheme tColors = Theme.of(context).extension<TaskwarriorColorTheme>()!;
    return showDialog<void>(
      context: context,
      barrierDismissible:
          false, // Prevents closing the dialog by tapping outside
      builder: (BuildContext context) {
        return Utils.showAlertDialog(
          title: Text(
            SentenceManager(
                    currentLanguage: homeController.selectedLanguage.value)
                .sentences
                .homePageExitApp,
            style: TextStyle(
              color: tColors.primaryTextColor,
            ),
          ),
          content: Text(
            SentenceManager(
                    currentLanguage: homeController.selectedLanguage.value)
                .sentences
                .homePageAreYouSureYouWantToExit,
            style: TextStyle(
              color: tColors.primaryTextColor,
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                SentenceManager(
                        currentLanguage: homeController.selectedLanguage.value)
                    .sentences
                    .homePageCancel,
                style: TextStyle(
                  color: tColors.primaryTextColor,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            TextButton(
              child: Text(
                SentenceManager(
                        currentLanguage: homeController.selectedLanguage.value)
                    .sentences
                    .homePageExit,
                style: TextStyle(
                  color: tColors.primaryTextColor,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                SystemNavigator.pop(); // Exit the app
              },
            ),
          ],
        );
      },
    );
  }
}
