// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taskwarrior/config/app_settings.dart';
import 'package:taskwarrior/config/taskwarriorcolors.dart';
import 'package:taskwarrior/widgets/pallete.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool syncOnStart = false;
  bool syncOnTaskCreate = false;

  checkAutoSync() async {
    ///check if auto sync is on or off
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      syncOnStart = prefs.getBool('sync-onStart') ?? false;
      syncOnTaskCreate = prefs.getBool('sync-OnTaskCreate') ?? false;
    });
  }

  @override
  void initState() {
    super.initState();
    checkAutoSync();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        backgroundColor: Palette.kToDark.shade200,
        title: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Settings',
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 20,
              ),
            ),
            Text(
              'Configure your preferences',
              style: GoogleFonts.poppins(
                color: Colors.white70,
                fontSize: 14,
              ),
            ),
          ],
        ),
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.chevron_left,
            color: Appcolors.white,
          ),
        ),
      ),
      backgroundColor:
          AppSettings.isDarkMode ? Palette.kToDark.shade200 : Colors.white,
      body: ListView(
        children: [
          ListTile(
            title: Text(
              'Sync on Start',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: AppSettings.isDarkMode ? Colors.white : Colors.black,
              ),
            ),
            subtitle: Text(
              'Automatically sync data on app startup',
              style: GoogleFonts.poppins(
                color: Colors.grey,
                fontSize: 14,
              ),
            ),
            trailing: Switch(
                value: syncOnStart,
                onChanged: (bool value) async {
                  setState(() {
                    syncOnStart = !syncOnStart;
                  });

                  final SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  await prefs.setBool('sync-onStart', syncOnStart);
                }),
          ),
          const Divider(), // Add a divider between settings
          ListTile(
            title: Text(
              'Sync on Task Create',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: AppSettings.isDarkMode ? Colors.white : Colors.black,
              ),
            ),
            subtitle: Text(
              'Enable automatic syncing when creating a new task',
              style: GoogleFonts.poppins(
                color: Colors.grey,
                fontSize: 14,
              ),
            ),
            trailing: Switch(
                value: syncOnTaskCreate,
                onChanged: (bool value) async {
                  setState(() {
                    syncOnTaskCreate = !syncOnTaskCreate;
                  });

                  final SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  await prefs.setBool('sync-OnTaskCreate', syncOnTaskCreate);
                }),
          ),
          // Add more settings here
        ],
      ),
    );
  }
}
