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
import 'package:taskwarrior/app/utils/constants/taskwarrior_colors.dart';
import 'package:taskwarrior/app/utils/constants/taskwarrior_fonts.dart';
import 'package:taskwarrior/app/utils/constants/utilites.dart';
import 'package:taskwarrior/app/utils/language/sentence_manager.dart';
import 'package:taskwarrior/app/utils/taskchampion/taskchampion.dart';

class NavDrawer extends StatelessWidget {
  final HomeController homeController;
  const NavDrawer({super.key, required this.homeController});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppSettings.isDarkMode
          ? TaskWarriorColors.kprimaryBackgroundColor
          : TaskWarriorColors.kLightPrimaryBackgroundColor,
      child: Container(
        color: AppSettings.isDarkMode
            ? TaskWarriorColors.kprimaryBackgroundColor
            : TaskWarriorColors.kLightPrimaryBackgroundColor,
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(child: _buildMenuItems(context)),
            _buildExitButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      color: AppSettings.isDarkMode
          ? TaskWarriorColors.kprimaryBackgroundColor
          : TaskWarriorColors.kLightPrimaryBackgroundColor,
      padding: const EdgeInsets.only(top: 50, left: 15, right: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            SentenceManager(
                    currentLanguage: homeController.selectedLanguage.value)
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
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return ScaleTransition(scale: animation, child: child);
              },
              child: IconButton(
                key: ValueKey<bool>(AppSettings.isDarkMode),
                icon: Icon(
                  AppSettings.isDarkMode ? Icons.dark_mode : Icons.light_mode,
                  color: AppSettings.isDarkMode
                      ? TaskWarriorColors.white
                      : TaskWarriorColors.black,
                ),
                onPressed: () async {
                  AppSettings.isDarkMode = !AppSettings.isDarkMode;
                  await SelectedTheme.saveMode(AppSettings.isDarkMode);
                  homeController.initLanguageAndDarkMode();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItems(BuildContext context) {
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        SizedBox(height: Get.height * 0.03),
        Visibility(
          visible: homeController.taskchampion.value,
          child: Column(
            children: [
              NavDrawerMenuItem(
                icon: Icons.task_alt,
                text: SentenceManager(
                  currentLanguage: homeController.selectedLanguage.value,
                ).sentences.ccsyncCredentials,
                onTap: () {
                  Navigator.of(context).pop(); // Close the drawer
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => ManageTaskChampionCreds(),
                    ),
                  );
                },
              ),
              Divider(color: Colors.grey.shade700),
            ],
          ),
        ),
        Visibility(
          visible: homeController.taskchampion.value,
          child: Column(
            children: [
              NavDrawerMenuItem(
                icon: Icons.delete,
                text: SentenceManager(
                  currentLanguage: homeController.selectedLanguage.value,
                ).sentences.deleteTaskTitle,
                onTap: () {
                  Navigator.of(context).pop(); // Close the drawer
                  _showDeleteConfirmationDialog(context);
                },
              ),
              Divider(color: Colors.grey.shade700),
            ],
          ),
        ),
        Visibility(
          visible: !homeController.taskchampion.value,
          child: Obx(
            () => Column(
              children: [
                NavDrawerMenuItem(
                  icon: Icons.person_rounded,
                  text: SentenceManager(
                    currentLanguage: homeController.selectedLanguage.value,
                  ).sentences.navDrawerProfile,
                  onTap: () {
                    Navigator.of(context).pop(); // Close the drawer
                    Get.toNamed(Routes.PROFILE);
                  },
                ),
                Divider(color: Colors.grey.shade700),
              ],
            ),
          ),
        ),
        Visibility(
          visible: !homeController.taskchampion.value,
          child: Obx(
            () => Column(
              children: [
                NavDrawerMenuItem(
                  icon: Icons.summarize,
                  text: SentenceManager(
                    currentLanguage: homeController.selectedLanguage.value,
                  ).sentences.navDrawerReports,
                  onTap: () {
                    Navigator.of(context).pop(); // Close the drawer
                    Get.toNamed(Routes.REPORTS);
                  },
                ),
                Divider(color: Colors.grey.shade700),
              ],
            ),
          ),
        ),
        Visibility(
          visible: homeController.taskchampion.value,
          child: Obx(
            () => Column(
              children: [
                NavDrawerMenuItem(
                  icon: Icons.summarize,
                  text: SentenceManager(
                    currentLanguage: homeController.selectedLanguage.value,
                  ).sentences.navDrawerReports,
                  onTap: () {
                    Navigator.of(context).pop(); // Close the drawer
                    Get.to(() => ReportsHomeTaskc());
                  },
                ),
                Divider(color: Colors.grey.shade700),
              ],
            ),
          ),
        ),
        Obx(
          () => Column(
            children: [
              NavDrawerMenuItem(
                icon: Icons.info,
                text: SentenceManager(
                  currentLanguage: homeController.selectedLanguage.value,
                ).sentences.navDrawerAbout,
                onTap: () {
                  Navigator.of(context).pop(); // Close the drawer
                  Get.toNamed(Routes.ABOUT);
                },
              ),
              Divider(color: Colors.grey.shade700),
            ],
          ),
        ),
        Obx(
          () => Column(
            children: [
              NavDrawerMenuItem(
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

                  Navigator.of(context).pop(); // Close the drawer
                  Get.toNamed(Routes.SETTINGS);
                },
              ),
              Divider(color: Colors.grey.shade700),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildExitButton(BuildContext context) {
    return Obx(
      () => Column(
        children: [
          Divider(color: Colors.grey.shade700),
          NavDrawerMenuItem(
            icon: Icons.exit_to_app,
            text: SentenceManager(
              currentLanguage: homeController.selectedLanguage.value,
            ).sentences.navDrawerExit,
            onTap: () {
              Navigator.of(context).pop(); // Close the drawer
              _showExitConfirmationDialog(context);
            },
          ),
        ],
      ),
    );
  }

  Future<void> _showDeleteConfirmationDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return Utils.showAlertDialog(
          title: Text(
            SentenceManager(
                    currentLanguage: homeController.selectedLanguage.value)
                .sentences
                .deleteTaskConfirmation,
            style: TextStyle(
              color: AppSettings.isDarkMode
                  ? TaskWarriorColors.white
                  : TaskWarriorColors.black,
            ),
          ),
          content: Text(
            SentenceManager(
                    currentLanguage: homeController.selectedLanguage.value)
                .sentences
                .deleteTaskWarning,
            style: TextStyle(
              color: AppSettings.isDarkMode
                  ? TaskWarriorColors.white
                  : TaskWarriorColors.black,
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'Cancel',
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
                'Confirm',
                style: TextStyle(
                  color: AppSettings.isDarkMode
                      ? TaskWarriorColors.white
                      : TaskWarriorColors.black,
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
  }

  Future<void> _showExitConfirmationDialog(BuildContext context) async {
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
              color: AppSettings.isDarkMode
                  ? TaskWarriorColors.white
                  : TaskWarriorColors.black,
            ),
          ),
          content: Text(
            SentenceManager(
                    currentLanguage: homeController.selectedLanguage.value)
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
                SentenceManager(
                        currentLanguage: homeController.selectedLanguage.value)
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
                SentenceManager(
                        currentLanguage: homeController.selectedLanguage.value)
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
