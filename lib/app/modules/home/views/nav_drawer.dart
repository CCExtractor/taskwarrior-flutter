import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taskwarrior/app/modules/about/views/about_view.dart';
import 'package:taskwarrior/app/modules/home/controllers/home_controller.dart';
import 'package:taskwarrior/app/modules/home/views/theme_clipper.dart';
import 'package:taskwarrior/app/routes/app_pages.dart';
import 'package:taskwarrior/app/utils/constants/taskwarrior_colors.dart';
import 'package:taskwarrior/app/utils/constants/taskwarrior_fonts.dart';
import 'package:taskwarrior/app/utils/constants/utilites.dart';
import 'package:taskwarrior/app/utils/theme/app_settings.dart';

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
                    'Menu',
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
                        homeController.initDarkMode();
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
            buildMenuItem(
              icon: Icons.person_rounded,
              text: 'Profile',
              onTap: () {
                // Navigator.of(context).push(
                //   MaterialPageRoute(
                //     builder: (context) => const ProfileView(),
                //   ),
                // );
                Get.toNamed(Routes.PROFILE);
                // Navigator.pushNamed(context, PageRoutes.profile);
              },
            ),
            buildMenuItem(
              icon: Icons.summarize,
              text: 'Reports',
              onTap: () {
                Get.toNamed(Routes.REPORTS);
                // Navigator.of(context).push(
                //   MaterialPageRoute(
                //     builder: (context) => const ReportsHome(),
                //   ),
                // );
              },
            ),
            buildMenuItem(
              icon: Icons.info,
              text: 'About',
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const AboutView(),
                  ),
                );
              },
            ),
            buildMenuItem(
              icon: Icons.settings,
              text: 'Settings',
              onTap: () async {
                ///check if auto sync is on or off
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
                // syncOnStart = prefs.getBool('sync-onStart') ?? false;
                // syncOnTaskCreate =
                //     prefs.getBool('sync-OnTaskCreate') ?? false;
                // delaytask = prefs.getBool('delaytask') ?? false;
                // change24hr = prefs.getBool('24hourformate') ?? false;

                // print(syncOnStart);
                // print(syncOnTaskCreate);
                // Navigator.of(context).push(
                //   MaterialPageRoute(
                //     builder: (context) => SettingsPage(
                //       isSyncOnStartActivel: homeController.syncOnStart.value,
                //       isSyncOnTaskCreateActivel:
                //           homeController.syncOnTaskCreate.value,
                //       delaytask: homeController.delaytask.value,
                //       change24hr: homeController.change24hr.value,
                //     ),
                //   ),
                // );
                Get.toNamed(Routes.SETTINGS);
              },
            ),
            buildMenuItem(
              icon: Icons.exit_to_app,
              text: 'Exit',
              onTap: () {
                _showExitConfirmationDialog(context);
              },
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
            'Exit App',
            style: TextStyle(
              color: AppSettings.isDarkMode
                  ? TaskWarriorColors.white
                  : TaskWarriorColors.black,
            ),
          ),
          content: Text(
            'Are you sure you want to exit the app?',
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
                'Exit',
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

  Widget buildMenuItem(
      {required IconData icon,
      required String text,
      required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        color: AppSettings.isDarkMode
            ? TaskWarriorColors.kprimaryBackgroundColor
            : TaskWarriorColors.kLightPrimaryBackgroundColor,
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 10),
        child: Row(
          children: [
            Icon(
              icon,
              color: AppSettings.isDarkMode
                  ? TaskWarriorColors.white
                  : TaskWarriorColors.black,
            ),
            const SizedBox(width: 10),
            Text(
              text,
              style: TextStyle(
                color: AppSettings.isDarkMode
                    ? TaskWarriorColors.white
                    : TaskWarriorColors.black,
                fontSize: TaskWarriorFonts.fontSizeMedium,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
