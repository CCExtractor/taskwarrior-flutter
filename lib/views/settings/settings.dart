// ignore_for_file: library_private_types_in_public_api, must_be_immutable, depend_on_referenced_packages

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path/path.dart' as path;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:file_picker/file_picker.dart';
import 'package:taskwarrior/config/app_settings.dart';
import 'package:taskwarrior/config/taskwarriorcolors.dart';
import 'package:taskwarrior/widgets/pallete.dart';
import 'package:taskwarrior/widgets/taskdetails/profiles_widget.dart';

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
  bool isMovingDirectory = false;

  String getBaseDirectory() {
    InheritedProfiles profilesWidget = ProfilesWidget.of(context);
    Directory baseDirectory = profilesWidget.getBaseDirectory();
    Directory defaultDirectory = profilesWidget.getDefaultDirectory();
    if (baseDirectory.path == defaultDirectory.path) {
      return 'Default';
    } else {
      return baseDirectory.path;
    }
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
      body: (isMovingDirectory)
          ? Center(
              child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircularProgressIndicator(),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  'Moving data to new directory',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: AppSettings.isDarkMode
                        ? TaskWarriorColors.white
                        : TaskWarriorColors.black,
                  ),
                )
              ],
            ))
          : ListView(
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
                const Divider(),
                ListTile(
                  title: Text(
                    'Select directory',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: AppSettings.isDarkMode
                          ? TaskWarriorColors.white
                          : TaskWarriorColors.black,
                    ),
                  ),
                  subtitle: Column(
                    children: [
                      Text(
                        'Select the directory where the TaskWarrior data is stored\nCurrent: ${getBaseDirectory()}',
                        style: GoogleFonts.poppins(
                          color: TaskWarriorColors.grey,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          //Reset to default
                          TextButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                AppSettings.isDarkMode
                                    ? TaskWarriorColors
                                        .ksecondaryBackgroundColor
                                    : TaskWarriorColors
                                        .kLightSecondaryBackgroundColor,
                              ),
                            ),
                            onPressed: () {
                              if (getBaseDirectory() == "Default") {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text(
                                          'Already default',
                                          style: TextStyle(
                                            color: AppSettings.isDarkMode
                                                ? TaskWarriorColors
                                                    .kprimaryTextColor
                                                : TaskWarriorColors
                                                    .kLightPrimaryTextColor,
                                          ),
                                        ),
                                        backgroundColor: AppSettings.isDarkMode
                                            ? TaskWarriorColors
                                                .ksecondaryBackgroundColor
                                            : TaskWarriorColors
                                                .kLightSecondaryBackgroundColor,
                                        duration: const Duration(seconds: 2)));
                              } else {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      surfaceTintColor: AppSettings.isDarkMode
                                          ? TaskWarriorColors
                                              .kdialogBackGroundColor
                                          : TaskWarriorColors
                                              .kLightDialogBackGroundColor,
                                      shadowColor: AppSettings.isDarkMode
                                          ? TaskWarriorColors
                                              .kdialogBackGroundColor
                                          : TaskWarriorColors
                                              .kLightDialogBackGroundColor,
                                      backgroundColor: AppSettings.isDarkMode
                                          ? TaskWarriorColors
                                              .kdialogBackGroundColor
                                          : TaskWarriorColors
                                              .kLightDialogBackGroundColor,
                                      title: Text(
                                        'Reset to default',
                                        style: GoogleFonts.poppins(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color: AppSettings.isDarkMode
                                              ? TaskWarriorColors.white
                                              : TaskWarriorColors.black,
                                        ),
                                      ),
                                      content: Text(
                                        "Are you sure you want to reset the directory to the default?",
                                        style: GoogleFonts.poppins(
                                          color: TaskWarriorColors.grey,
                                          fontSize: 14,
                                        ),
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: Text(
                                            'No',
                                            style: GoogleFonts.poppins(
                                              color: AppSettings.isDarkMode
                                                  ? TaskWarriorColors.white
                                                  : TaskWarriorColors.black,
                                            ),
                                          ),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                            isMovingDirectory = true;
                                            setState(() {});
                                            InheritedProfiles profilesWidget =
                                                ProfilesWidget.of(context);
                                            Directory source = profilesWidget
                                                .getBaseDirectory();
                                            Directory destination =
                                                profilesWidget
                                                    .getDefaultDirectory();
                                            moveDirectory(source.path,
                                                    destination.path)
                                                .then((value) async {
                                              profilesWidget.setBaseDirectory(
                                                  destination);
                                              SharedPreferences prefs =
                                                  await SharedPreferences
                                                      .getInstance();
                                              await prefs
                                                  .remove('baseDirectory');
                                              isMovingDirectory = false;
                                              setState(() {});
                                            });
                                          },
                                          child: Text(
                                            'Yes',
                                            style: GoogleFonts.poppins(
                                              color: AppSettings.isDarkMode
                                                  ? TaskWarriorColors.white
                                                  : TaskWarriorColors.black,
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              }
                            },
                            child: Text(
                              'Reset to default',
                              style: TextStyle(
                                color: AppSettings.isDarkMode
                                    ? TaskWarriorColors.white
                                    : TaskWarriorColors.deepPurple,
                              ),
                            ),
                          ),
                          const Spacer(),
                          //Change directory
                          TextButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                AppSettings.isDarkMode
                                    ? TaskWarriorColors
                                        .ksecondaryBackgroundColor
                                    : TaskWarriorColors
                                        .kLightSecondaryBackgroundColor,
                              ),
                            ),
                            onPressed: () {
                              pickDirectory();
                            },
                            child: Text(
                              'Change directory',
                              style: TextStyle(
                                color: AppSettings.isDarkMode
                                    ? TaskWarriorColors.white
                                    : TaskWarriorColors.deepPurple,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
    );
  }

  void pickDirectory() {
    FilePicker.platform.getDirectoryPath().then((value) async {
      if (value != null) {
        isMovingDirectory = true;
        setState(() {});
        InheritedProfiles profilesWidget = ProfilesWidget.of(context);
        Directory source = profilesWidget.getBaseDirectory();
        Directory destination = Directory(value);
        moveDirectory(source.path, destination.path).then((value) async {
          isMovingDirectory = false;
          setState(() {});
          if (value == "same") {
            return;
          } else if (value == "success") {
            profilesWidget.setBaseDirectory(destination);
            SharedPreferences prefs = await SharedPreferences.getInstance();
            prefs.setString('baseDirectory', destination.path);
          } else {
            showDialog(
              context: context,
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
                    'Error',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: AppSettings.isDarkMode
                          ? TaskWarriorColors.white
                          : TaskWarriorColors.black,
                    ),
                  ),
                  content: Text(
                    value == "nested"
                        ? "Cannot move to a nested directory"
                        : value == "not-empty"
                            ? "Destination directory is not empty"
                            : "An error occurred",
                    style: GoogleFonts.poppins(
                      color: TaskWarriorColors.grey,
                      fontSize: 14,
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        'OK',
                        style: GoogleFonts.poppins(
                          color: AppSettings.isDarkMode
                              ? TaskWarriorColors.white
                              : TaskWarriorColors.black,
                        ),
                      ),
                    )
                  ],
                );
              },
            );
          }
        });
      }
    });
  }

  Future<String> moveDirectory(String fromDirectory, String toDirectory) async {
    if (path.canonicalize(fromDirectory) == path.canonicalize(toDirectory)) {
      return "same";
    }

    if (path.isWithin(fromDirectory, toDirectory)) {
      return "nested";
    }

    Directory toDir = Directory(toDirectory);
    final length = await toDir.list().length;
    if (length > 0) {
      return "not-empty";
    }

    await moveDirectoryRecurse(fromDirectory, toDirectory);
    return "success";
  }

  Future<void> moveDirectoryRecurse(
      String fromDirectory, String toDirectory) async {
    Directory fromDir = Directory(fromDirectory);
    Directory toDir = Directory(toDirectory);

    // Create the toDirectory if it doesn't exist
    await toDir.create(recursive: true);

    // Loop through each file and directory and move it to the toDirectory
    await for (final entity in fromDir.list()) {
      if (entity is File) {
        // If it's a file, move it to the toDirectory
        File file = entity;
        String newPath = path.join(
            toDirectory, path.relative(file.path, from: fromDirectory));
        await File(newPath).writeAsBytes(await file.readAsBytes());
        await file.delete();
      } else if (entity is Directory) {
        // If it's a directory, create it in the toDirectory and recursively move its contents
        Directory dir = entity;
        String newPath = path.join(
            toDirectory, path.relative(dir.path, from: fromDirectory));
        Directory newDir = Directory(newPath);
        await newDir.create(recursive: true);
        await moveDirectoryRecurse(dir.path, newPath);
        await dir.delete();
      }
    }
  }
}
