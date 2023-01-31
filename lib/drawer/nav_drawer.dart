import 'package:flutter/material.dart';
import 'package:taskwarrior/config/app_settings.dart';
import 'package:taskwarrior/model/storage/storage_widget.dart';
import 'package:taskwarrior/routes/pageroute.dart';

class NavDrawer extends StatefulWidget {
  InheritedStorage storageWidget;
  final Function() notifyParent;

  NavDrawer({Key? key, required this.storageWidget, required this.notifyParent})
      : super(key: key);

  @override
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
              title: const Text(
                'Menu',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onTap: () => Navigator.pop(context),
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
              leading: AppSettings.isDarkMode
                  ? const Icon(
                      Icons.light_mode,
                      color: Color.fromARGB(255, 216, 196, 15),
                      size: 25,
                    )
                  : const Icon(
                      Icons.dark_mode,
                      color: Colors.black,
                      size: 25,
                    ),
              title: const Text("Switch Theme"),
              onTap: () async {
                AppSettings.isDarkMode = !AppSettings.isDarkMode;
                setState(() {});
                await selectedTheme.saveMode(AppSettings.isDarkMode);
                widget.notifyParent();
              },
            )
          ],
        ));
  }
}
