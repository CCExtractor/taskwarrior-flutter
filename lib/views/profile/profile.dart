import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:taskwarrior/config/app_settings.dart';
import 'package:taskwarrior/model/storage/savefile.dart';
import 'package:taskwarrior/taskserver/ntaskserver.dart';
import 'package:taskwarrior/utility/utilities.dart';
import 'package:taskwarrior/widgets/pallete.dart';
import 'package:taskwarrior/widgets/profilefunctions.dart';
import 'package:taskwarrior/widgets/taskdetails.dart';

class ProfilePage extends StatefulWidget {
  static const String routeName = '/profile';

  const ProfilePage({Key? key}) : super(key: key);
  @override
  // ignore: library_private_types_in_public_api
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
        backgroundColor: Palette.kToDark.shade200,
        title: Text(
          profilesMap.length == 1 ? 'Profile' : 'Profiles',
          style: GoogleFonts.poppins(color: Colors.white),
        ),
        leading: IconButton(
          onPressed: () {
            // Navigator.pushReplacementNamed(context, PageRoutes.home);
            Navigator.of(context).pop();
          },
          icon: const Icon(
            Icons.chevron_left,
            color: Colors.white,
            size: 30,
          ),
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
                  // builder: (_) => const ConfigureTaskserverRoute(),
                  builder: (_) => const ManageTaskServer(),
                ),
              ),
              () {
                var tasks =
                    profilesWidget.getStorage(currentProfile).data.export();
                var now = DateTime.now()
                    .toIso8601String()
                    .replaceAll(RegExp(r'[-:]'), '')
                    .replaceAll(RegExp(r'\..*'), '');

                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text("Export Format"),
                      content: const Text("Choose the export format:"),
                      actions: <Widget>[
                        TextButton(
                          child: const Text("JSON"),
                          onPressed: () {
                            Navigator.of(context).pop();
                            exportTasks(
                              contents: tasks,
                              suggestedName: 'tasks-$now.json',
                            );
                          },
                        ),
                        TextButton(
                          child: const Text("TXT"),
                          onPressed: () {
                            Navigator.of(context).pop();
                            exportTasks(
                              contents: tasks,
                              suggestedName: 'tasks-$now.txt',
                            );
                          },
                        ),
                      ],
                    );
                  },
                );
              },
              () {
                try {
                  profilesWidget.copyConfigToNewProfile(currentProfile);
                  Utils.showSnakbar('Profile Config Copied', context);
                } catch (e) {
                  Utils.showSnakbar('Profile Config Copied Failed', context);
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
                Utils.showSnakbar('Profile Added Scuccessfully', context);
              } catch (e) {
                Utils.showSnakbar('Profile Addition Failed', context);
              }
            },
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(
                AppSettings.isDarkMode
                    ? const Color.fromARGB(255, 61, 61, 61)
                    : Colors.white,
              ),
            ),
            icon: Icon(Icons.add,
                color: AppSettings.isDarkMode
                    ? Colors.deepPurpleAccent
                    : Colors.deepPurple),
            label: Text(
              'Add new Profile',
              style: TextStyle(
                color:
                    AppSettings.isDarkMode ? Colors.white : Colors.deepPurple,
              ),
            ),
          )
        ],
      ),
    );
  }
}
