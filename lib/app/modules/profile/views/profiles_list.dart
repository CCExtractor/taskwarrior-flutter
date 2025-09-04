import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taskwarrior/app/utils/constants/taskwarrior_colors.dart';
import 'package:taskwarrior/app/utils/app_settings/app_settings.dart';

class ProfilesList extends StatelessWidget {
  const ProfilesList(
    this.profilesMap,
    this.currentProfile,
    this.addProfile,
    this.selectProfile,
    this.rename,
    this.configure,
    this.export,
    this.copy,
    this.delete,
    this.changeMode, {
    required this.currentProfileKey,
    required this.addNewProfileKey,
    required this.manageSelectedProfileKey,
    super.key,
  });

  final RxMap<dynamic, dynamic> profilesMap;
  final String currentProfile;
  final void Function() addProfile;
  final void Function(String) selectProfile;
  final void Function(String) rename;
  final void Function() configure;
  final void Function(String) export;
  final void Function(String) copy;
  final void Function(dynamic) delete;
  final void Function(String) changeMode;
  final GlobalKey currentProfileKey;
  final GlobalKey addNewProfileKey;
  final GlobalKey manageSelectedProfileKey;

  @override
  Widget build(BuildContext context) {
    return Obx(() => ListView.builder(
          itemCount: profilesMap.values.toList().length,
          itemBuilder: (context, index) {
            List pnames = profilesMap.values.toList();
            List pid = profilesMap.keys.toList();
            final item = pnames[index];
            final profileId =
                pid[index]; // Store pid[index] in a variable for clarity

            return Dismissible(
              key: Key(profileId),
              direction: DismissDirection.endToStart,
              onDismissed: (direction) {
                delete(profileId);
              },
              background: Container(
                color: Colors.red,
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.only(right: 20.0),
                child: const Icon(Icons.delete, color: Colors.white),
              ),
              child: ExpansionTile(
                // Use ExpansionTile here
                title: Text(
                  item,
                  style: TextStyle(
                    color: AppSettings.isDarkMode
                        ? TaskWarriorColors.kprimaryTextColor
                        : TaskWarriorColors.kLightPrimaryTextColor,
                  ),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit,
                          color: AppSettings.isDarkMode
                              ? TaskWarriorColors.kprimaryTextColor
                              : TaskWarriorColors.kLightPrimaryTextColor),
                      onPressed: () => rename(profileId),
                    ),
                    // The settings icon will now trigger the ExpansionTile's expansion/collapse
                    // No need for a separate IconButton for settings if ExpansionTile handles it
                    currentProfile != profileId
                        ? IconButton(
                            onPressed: () {
                              selectProfile(profileId);
                            },
                            icon: Icon(Icons.check,
                                color: AppSettings.isDarkMode
                                    ? TaskWarriorColors.kprimaryTextColor
                                    : TaskWarriorColors.kLightPrimaryTextColor),
                          )
                        : IconButton(
                            onPressed: () {
                              configure();
                            },
                            icon: Icon(Icons.key,
                                color: AppSettings.isDarkMode
                                    ? TaskWarriorColors.kprimaryTextColor
                                    : TaskWarriorColors.kLightPrimaryTextColor),
                          ),
                  ],
                ),
                children: <Widget>[
                  ListTile(
                    leading: Icon(Icons.file_copy,
                        color: AppSettings.isDarkMode
                            ? TaskWarriorColors.kprimaryTextColor
                            : TaskWarriorColors.kLightPrimaryTextColor),
                    title: Text('Export Tasks',
                        style: TextStyle(
                            color: AppSettings.isDarkMode
                                ? TaskWarriorColors.kprimaryTextColor
                                : TaskWarriorColors.kLightPrimaryTextColor)),
                    onTap: () {
                      export(profileId);
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.copy,
                        color: AppSettings.isDarkMode
                            ? TaskWarriorColors.kprimaryTextColor
                            : TaskWarriorColors.kLightPrimaryTextColor),
                    title: Text('Copy to new Profile',
                        style: TextStyle(
                            color: AppSettings.isDarkMode
                                ? TaskWarriorColors.kprimaryTextColor
                                : TaskWarriorColors.kLightPrimaryTextColor)),
                    onTap: () {
                      copy(profileId);
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.change_circle,
                        color: AppSettings.isDarkMode
                            ? TaskWarriorColors.kprimaryTextColor
                            : TaskWarriorColors.kLightPrimaryTextColor),
                    title: Text('Change Profile Mode',
                        style: TextStyle(
                            color: AppSettings.isDarkMode
                                ? TaskWarriorColors.kprimaryTextColor
                                : TaskWarriorColors.kLightPrimaryTextColor)),
                    onTap: () {
                      changeMode(profileId);
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.delete,
                        color: AppSettings.isDarkMode
                            ? TaskWarriorColors.kprimaryTextColor
                            : TaskWarriorColors.kLightPrimaryTextColor),
                    title: Text('Delete Profile',
                        style: TextStyle(
                            color: AppSettings.isDarkMode
                                ? TaskWarriorColors.kprimaryTextColor
                                : TaskWarriorColors.kLightPrimaryTextColor)),
                    onTap: () {
                      delete(profileId);
                    },
                  ),
                ],
              ),
            );
          },
        ));
  }
}
