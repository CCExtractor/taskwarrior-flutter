// ignore_for_file: file_names, unused_import, library_private_types_in_public_api
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:taskwarrior/config/app_settings.dart';
import 'package:taskwarrior/model/storage/savefile.dart';
import 'package:taskwarrior/taskserver/configure_taskserver.dart';
import 'package:taskwarrior/widgets/pallete.dart';
import 'package:taskwarrior/widgets/profilefunctions.dart';
import 'package:taskwarrior/widgets/taskdetails.dart';
import 'package:taskwarrior/routes/pageroute.dart';
import 'package:taskwarrior/widgets/taskfunctions/taskparser.dart';

class ProfilePage extends StatefulWidget {
  static const String routeName = '/profile';

  const ProfilePage({Key? key}) : super(key: key);
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    var profilesWidget = ProfilesWidget.of(context);

    var profilesMap = ProfilesWidget.of(context).profilesMap;
    var currentProfile = ProfilesWidget.of(context).currentProfile;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Palette.kToDark,
        leading: IconButton(
          onPressed: () {
            Navigator.pushReplacementNamed(context, PageRoutes.home);
          },
          icon: const Icon(Icons.home_filled, color: Colors.white),
        ),
      ),
      //primary: false,
      backgroundColor:
          AppSettings.isDarkMode ? Palette.kToDark.shade200 : Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            ProfilesColumn(
              profilesMap,
              currentProfile,
              profilesWidget.addProfile,
              profilesWidget.selectProfile,
              () => showDialog(
                context: context,
                builder: (context) => Center(
                  child: RenameProfileDialog(
                    profile: currentProfile,
                    alias: profilesMap[currentProfile],
                    context: context,
                  ),
                ),
              ),
              () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const ConfigureTaskserverRoute(),
                ),
              ),
              () {
                var tasks =
                    profilesWidget.getStorage(currentProfile).data.export();
                var now = DateTime.now()
                    .toIso8601String()
                    .replaceAll(RegExp(r'[-:]'), '')
                    .replaceAll(RegExp(r'\..*'), '');
                exportTasks(
                  contents: tasks,
                  suggestedName: 'tasks-$now.txt',
                );
              },
              () {
                try {
                  profilesWidget.copyConfigToNewProfile(currentProfile);
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: const Text('Profile Config Copied'),
                      backgroundColor: AppSettings.isDarkMode
                          ? const Color.fromARGB(255, 61, 61, 61)
                          : const Color.fromARGB(255, 39, 39, 39),
                      duration: const Duration(seconds: 2)));
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: const Text('Profile Config Copy Failed'),
                      backgroundColor: AppSettings.isDarkMode
                          ? const Color.fromARGB(255, 61, 61, 61)
                          : const Color.fromARGB(255, 39, 39, 39),
                      duration: const Duration(seconds: 2)));
                }
              },
              () => showDialog(
                context: context,
                builder: (context) => DeleteProfileDialog(
                  profile: currentProfile,
                  context: context,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProfilesColumn extends StatelessWidget {
  const ProfilesColumn(
    this.profilesMap,
    this.currentProfile,
    this.addProfile,
    this.selectProfile,
    this.rename,
    this.configure,
    this.export,
    this.copy,
    this.delete, {
    Key? key,
  }) : super(key: key);

  final Map profilesMap;
  final String currentProfile;
  final void Function() addProfile;
  final void Function(String) selectProfile;
  final void Function() rename;
  final void Function() configure;
  final void Function() export;
  final void Function() copy;
  final void Function() delete;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SelectProfile(currentProfile, profilesMap, selectProfile),
          const SizedBox(
            height: 6,
          ),
          ManageProfile(rename, configure, export, copy, delete),
          const SizedBox(
            height: 6,
          ),
          ElevatedButton.icon(
            onPressed: () {
              try {
                addProfile();
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: const Text('Profile Added Successfully'),
                    backgroundColor: AppSettings.isDarkMode
                        ? const Color.fromARGB(255, 61, 61, 61)
                        : const Color.fromARGB(255, 39, 39, 39),
                    duration: const Duration(seconds: 2)));
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: const Text('Profile Additon Failed'),
                    backgroundColor: AppSettings.isDarkMode
                        ? const Color.fromARGB(255, 61, 61, 61)
                        : const Color.fromARGB(255, 39, 39, 39),
                    duration: const Duration(seconds: 2)));
              }
            },
            icon: const Icon(
              Icons.add,
              color: Colors.black,
            ),
            label: const Text(
              'Add new Profile',
              style: TextStyle(fontSize: 18, color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }
}
