import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taskwarrior/app/utils/app_settings/app_settings.dart';
import 'package:taskwarrior/app/modules/home/controllers/home_controller.dart';
import 'package:taskwarrior/app/modules/home/views/home_page_nav_drawer_menu_item.dart';
import 'package:taskwarrior/app/modules/home/views/theme_clipper.dart';
import 'package:taskwarrior/app/routes/app_pages.dart';
import 'package:taskwarrior/app/utils/constants/taskwarrior_colors.dart';
import 'package:taskwarrior/app/utils/constants/taskwarrior_fonts.dart';
import 'package:taskwarrior/app/utils/constants/utilites.dart';
import 'package:taskwarrior/app/utils/language/sentence_manager.dart';

class NavDrawer extends StatelessWidget {
  final HomeController homeController;
  const NavDrawer({super.key, required this.homeController});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppSettings.isDarkMode
          ? TaskWarriorColors.kprimaryBackgroundColor
          : TaskWarriorColors.kLightPrimaryBackgroundColor,
      surfaceTintColor: AppSettings.isDarkMode
          ? TaskWarriorColors.kprimaryBackgroundColor
          : TaskWarriorColors.kLightPrimaryBackgroundColor,
      child: Container(
        color: AppSettings.isDarkMode
            ? TaskWarriorColors.kprimaryBackgroundColor
            : TaskWarriorColors.kLightPrimaryBackgroundColor,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            Container(
              color: AppSettings.isDarkMode
                  ? TaskWarriorColors.kprimaryBackgroundColor
                  : TaskWarriorColors.kLightPrimaryBackgroundColor,
              padding: const EdgeInsets.only(top: 50, left: 15, right: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    SentenceManager(currentLanguage: homeController.selectedLanguage.value)
                .sentences
                .homePageMenu,
                    style: TextStyle(
                      fontSize: TaskWarriorFonts.fontSizeExtraLarge,
                      fontWeight: TaskWarriorFonts.bold,
                      color: AppSettings.isDarkMode
                          ? TaskWarriorColors.white
                          : TaskWarriorColors.black,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: ThemeSwitcherClipper(
                      isDarkMode: AppSettings.isDarkMode,
                      onTap: (bool newMode) async {
                        AppSettings.isDarkMode = newMode;
                        await SelectedTheme.saveMode(AppSettings.isDarkMode);
                        Get.back();
                        homeController.initLanguageAndDarkMode();
                      },
                      child: Icon(
                        AppSettings.isDarkMode
                            ? Icons.dark_mode
                            : Icons.light_mode,
                        color: AppSettings.isDarkMode
                            ? TaskWarriorColors.white
                            : TaskWarriorColors.black,
                        size: 15,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              color: AppSettings.isDarkMode
                  ? TaskWarriorColors.kprimaryBackgroundColor
                  : TaskWarriorColors.kLightPrimaryBackgroundColor,
              height: Get.height * 0.03,
            ),
            Obx(
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
            Obx(
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
    return showDialog<void>(
      context: context,
      barrierDismissible:
          false, // Prevents closing the dialog by tapping outside
      builder: (BuildContext context) {
        return Utils.showAlertDialog(
          title: Text(
             SentenceManager(currentLanguage: homeController.selectedLanguage.value)
                .sentences
                .homePageExitApp,
            style: TextStyle(
              color: AppSettings.isDarkMode
                  ? TaskWarriorColors.white
                  : TaskWarriorColors.black,
            ),
          ),
          content: Text(
            SentenceManager(currentLanguage: homeController.selectedLanguage.value)
                .sentences
                .homePageAreYouSureYouWantToExit,
            style: TextStyle(
              color: AppSettings.isDarkMode
                  ? TaskWarriorColors.white
                  : TaskWarriorColors.black,
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                SentenceManager(currentLanguage: homeController.selectedLanguage.value)
                .sentences
                .homePageCancel,
                style: TextStyle(
                  color: AppSettings.isDarkMode
                      ? TaskWarriorColors.white
                      : TaskWarriorColors.black,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            TextButton(
              child: Text(
                SentenceManager(currentLanguage: homeController.selectedLanguage.value)
                .sentences
                .homePageExit,
                style: TextStyle(
                  color: AppSettings.isDarkMode
                      ? TaskWarriorColors.white
                      : TaskWarriorColors.black,
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
