import 'package:flutter/material.dart';

import 'package:taskwarrior/config/app_settings.dart';
import 'package:taskwarrior/model/storage/storage_widget.dart';
import 'package:taskwarrior/routes/pageroute.dart';
import 'package:taskwarrior/views/about/about.dart';
import 'package:taskwarrior/views/reports/reports_home.dart';
import 'package:taskwarrior/config/theme_switcher_clipper.dart';

class NavDrawer extends StatefulWidget {
  final InheritedStorage storageWidget;
  final Function() notifyParent;

  const NavDrawer(
      {Key? key, required this.storageWidget, required this.notifyParent})
      : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _NavDrawerState createState() => _NavDrawerState();
}

class _NavDrawerState extends State<NavDrawer> {
  late InheritedStorage storageWidget = widget.storageWidget;

  @override
  Widget build(BuildContext context) {
    return Drawer(
        backgroundColor: AppSettings.isDarkMode ? Colors.black : Colors.white,
        child: ListView(
          padding: EdgeInsets.zero,
   children: [
      ListTile(
         tileColor: AppSettings.isDarkMode ? Colors.black : Colors.white,
         textColor: AppSettings.isDarkMode ? Colors.white : Colors.black,
         contentPadding: const EdgeInsets.only(top: 40, left: 10),
         title: Row(
             mainAxisAlignment: MainAxisAlignment.spaceBetween,
             children: [
        Text(
          'Menu',
          style: TextStyle(
          fontSize: 25,
          fontWeight: FontWeight.bold,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(right: 10), 
          child: ThemeSwitcherClipper(
            isDarkMode: AppSettings.isDarkMode,
            onTap: (bool newMode) async {
              AppSettings.isDarkMode = newMode;
              setState(() {});
              await SelectedTheme.saveMode(AppSettings.isDarkMode);
              widget.notifyParent();
            },
            child: Icon(
              AppSettings.isDarkMode ? Icons.dark_mode : Icons.light_mode,
              color: AppSettings.isDarkMode ? Colors.white : Colors.black,
              size: 15,
            ),
          ),
        ),
      ],
    ),
       onTap: () async {
         AppSettings.isDarkMode = !AppSettings.isDarkMode;
         setState(() {});
         await SelectedTheme.saveMode(AppSettings.isDarkMode);
         widget.notifyParent();
           },
         ),
             ListTile(
               tileColor: AppSettings.isDarkMode ? Colors.black : Colors.white,
               textColor: AppSettings.isDarkMode ? Colors.white : Colors.black,
               leading: Icon(
                 Icons.person_rounded,
                 color: AppSettings.isDarkMode ? Colors.white : Colors.black,
                ),
               title: const Text('Profile'),
               onTap: () {
                // Update the state of the app
                // ...
                Navigator.pushNamed(context, PageRoutes.profile);
                // Then close the drawer
                // Navigator.pop(context);
              },
            ),
            ListTile(
              tileColor: AppSettings.isDarkMode ? Colors.black : Colors.white,
              textColor: AppSettings.isDarkMode ? Colors.white : Colors.black,
              leading: Icon(
                Icons.refresh,
                color: AppSettings.isDarkMode ? Colors.white : Colors.black,
              ),
              onTap: () {
                storageWidget.synchronize(context);
                Navigator.pop(context);
              },
              title: const Text("Refresh"),
            ),
            ListTile(
              tileColor: AppSettings.isDarkMode ? Colors.black : Colors.white,
              textColor: AppSettings.isDarkMode ? Colors.white : Colors.black,
              leading: Icon(
                Icons.summarize,
                color: AppSettings.isDarkMode ? Colors.white : Colors.black,
              ),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const ReportsHome()));
              },
              title: const Text("Reports"),
            ),
            ListTile(
              tileColor: AppSettings.isDarkMode ? Colors.black : Colors.white,
              textColor: AppSettings.isDarkMode ? Colors.white : Colors.black,
              leading: Icon(
                Icons.info,
                color: AppSettings.isDarkMode ? Colors.white : Colors.black,
              ),
              onTap: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const AboutPage()));
              },
              title: const Text("About"),
            ),
          ],
        ));
  }
}
