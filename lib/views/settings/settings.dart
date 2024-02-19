// ignore_for_file: library_private_types_in_public_api, must_be_immutable

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taskwarrior/config/app_settings.dart';
import 'package:taskwarrior/config/taskwarriorcolors.dart';

class SettingsPage extends StatefulWidget {
  SettingsPage({
    super.key,
    required this.isSyncOnStartActivel,
    required this.isSyncOnTaskCreateActivel,
    required this.delaytask,
  });
  bool isSyncOnStartActivel;
  bool isSyncOnTaskCreateActivel;
  bool delaytask;

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        backgroundColor: TaskWarriorColors.kprimaryBackgroundColor,
        title: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Settings',
              style: GoogleFonts.poppins(
                color: TaskWarriorColors.white,
                fontSize: 20,
              ),
            ),
            Text(
              'Configure your preferences',
              style: GoogleFonts.poppins(
                color: TaskWarriorColors.white,
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
            color: TaskWarriorColors.white,
          ),
        ),
      ),
      backgroundColor: AppSettings.isDarkMode
          ? TaskWarriorColors.kprimaryBackgroundColor
          : TaskWarriorColors.white,
      body: ListView(
        children: [
          ListTile(
            title: Text(
              'Sync on Start',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: AppSettings.isDarkMode
                    ? TaskWarriorColors.white
                    : TaskWarriorColors.black,
              ),
            ),
            subtitle: Text(
              'Automatically sync data on app startup',
              style: GoogleFonts.poppins(
                color: TaskWarriorColors.grey,
                fontSize: 14,
              ),
            ),
            trailing: Switch(
              value: widget.isSyncOnStartActivel,
              onChanged: (bool value) async {
                setState(() {
                  widget.isSyncOnStartActivel = value;
                });

                final SharedPreferences prefs =
                    await SharedPreferences.getInstance();
                await prefs.setBool('sync-onStart', value);
              },
            ),
          ),
          const Divider(),
          ListTile(
            title: Text(
              'Sync on Task Create',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: AppSettings.isDarkMode
                    ? TaskWarriorColors.white
                    : TaskWarriorColors.black,
              ),
            ),
            subtitle: Text(
              'Enable automatic syncing when creating a new task',
              style: GoogleFonts.poppins(
                color: TaskWarriorColors.grey,
                fontSize: 14,
              ),
            ),
            trailing: Switch(
              value: widget.isSyncOnTaskCreateActivel,
              onChanged: (bool value) async {
                setState(() {
                  widget.isSyncOnTaskCreateActivel = value;
                });

                final SharedPreferences prefs =
                    await SharedPreferences.getInstance();
                await prefs.setBool('sync-OnTaskCreate', value);
              },
            ),
          ),
          const Divider(),
          ListTile(
            title: Text(
              'Highlight the task',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: AppSettings.isDarkMode
                    ? TaskWarriorColors.white
                    : TaskWarriorColors.black,
              ),
            ),
            subtitle: Text(
              'Make the border of task if only one day left',
              style: GoogleFonts.poppins(
                color: TaskWarriorColors.grey,
                fontSize: 14,
              ),
            ),
            trailing: Switch(
              value: widget.delaytask,
              onChanged: (bool value) async {
                setState(() {
                  widget.delaytask = value;
                });

                final SharedPreferences prefs =
                    await SharedPreferences.getInstance();
                await prefs.setBool('delaytask', value);
              },
            ),
          ),
        ],
      ),
    );
  }
}
