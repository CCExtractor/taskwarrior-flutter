// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:taskwarrior/config/app_settings.dart';
import 'package:taskwarrior/config/taskwarriorcolors.dart';
import 'package:taskwarrior/config/taskwarriorfonts.dart';
import 'package:taskwarrior/model/storage/storage_widget.dart';
import 'package:taskwarrior/views/about/about.dart';
import 'package:taskwarrior/views/profile/profile.dart';
import 'package:taskwarrior/views/reports/reports_home.dart';
import 'package:taskwarrior/config/theme_switcher_clipper.dart';
import 'package:taskwarrior/views/settings/settings.dart';

class NavDrawer extends StatefulWidget {
  final InheritedStorage storageWidget;
  final Function() notifyParent;

  const NavDrawer({
    super.key,
    required this.storageWidget,
    required this.notifyParent,
  });

  @override
  _NavDrawerState createState() => _NavDrawerState();
}

class _NavDrawerState extends State<NavDrawer> {
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
                        setState(() {});
                        await SelectedTheme.saveMode(AppSettings.isDarkMode);
                        widget.notifyParent();
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
              height: 3.h,
            ),
            buildMenuItem(
              icon: Icons.person_rounded,
              text: 'Profile',
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const ProfilePage(),
                  ),
                );
                // Navigator.pushNamed(context, PageRoutes.profile);
              },
            ),
            buildMenuItem(
              icon: Icons.summarize,
              text: 'Reports',
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const ReportsHome(),
                  ),
                );
              },
            ),
            buildMenuItem(
              icon: Icons.info,
              text: 'About',
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const AboutPage(),
                  ),
                );
              },
            ),
            buildMenuItem(
              icon: Icons.settings,
              text: 'Settings',
              onTap: () async {
                bool syncOnStart = false;
                bool syncOnTaskCreate = false;
                bool delaytask = false;

                ///check if auto sync is on or off
                final SharedPreferences prefs =
                    await SharedPreferences.getInstance();
                setState(() {
                  syncOnStart = prefs.getBool('sync-onStart') ?? false;
                  syncOnTaskCreate =
                      prefs.getBool('sync-OnTaskCreate') ?? false;
                  delaytask = prefs.getBool('delaytask') ?? false;
                });
                // print(syncOnStart);
                // print(syncOnTaskCreate);
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => SettingsPage(
                      isSyncOnStartActivel: syncOnStart,
                      isSyncOnTaskCreateActivel: syncOnTaskCreate,
                      delaytask: delaytask,
                    ),
                  ),
                );
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

Future<void> _showExitConfirmationDialog(BuildContext context) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // Prevents closing the dialog by tapping outside
    builder: (BuildContext context) {
      return AlertDialog(
        surfaceTintColor: AppSettings.isDarkMode
            ? TaskWarriorColors.kdialogBackGroundColor
            : TaskWarriorColors.kLightDialogBackGroundColor,
        shadowColor: AppSettings.isDarkMode
            ? TaskWarriorColors.kdialogBackGroundColor
            : TaskWarriorColors.kLightDialogBackGroundColor,
        backgroundColor: AppSettings.isDarkMode
            ? TaskWarriorColors.kdialogBackGroundColor
            : TaskWarriorColors.kLightDialogBackGroundColor,
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
