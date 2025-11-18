import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taskwarrior/app/utils/constants/taskwarrior_colors.dart';
import 'package:taskwarrior/app/utils/app_settings/app_settings.dart';
import 'package:taskwarrior/app/utils/language/sentence_manager.dart';

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
                // The title is now a Row to hold the text and the icon buttons
                title: Row(
                  children: [
                    Expanded(
                      child: Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment
                              .start, // Aligns text to the left
                          children: [
                            Text(
                              item,
                              style: TextStyle(
                                decoration: profileId == currentProfile
                                    ? TextDecoration.underline
                                    : TextDecoration.none,
                                fontSize: 16.0, // Standard list tile title size
                                color: AppSettings.isDarkMode
                                    ? TaskWarriorColors.kprimaryTextColor
                                    : TaskWarriorColors.kLightPrimaryTextColor,
                              ),
                            ),
                            const SizedBox(
                                height:
                                    2.0), // Adds a small space between the texts
                            Text(
                              profileId,
                              style: TextStyle(
                                fontSize:
                                    10.0, // Smaller font size for the subtitle
                                color: AppSettings.isDarkMode
                                    ? Colors.grey[400]
                                    : Colors.grey[700],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // This Row holds the action buttons, keeping them separate from the tile's default trailing arrow
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit,
                              color: AppSettings.isDarkMode
                                  ? TaskWarriorColors.kprimaryTextColor
                                  : TaskWarriorColors.kLightPrimaryTextColor),
                          onPressed: () => rename(profileId),
                        ),
                        if (currentProfile != profileId)
                          IconButton(
                            onPressed: () {
                              selectProfile(profileId);
                            },
                            icon: Icon(Icons.check,
                                color: AppSettings.isDarkMode
                                    ? TaskWarriorColors.kprimaryTextColor
                                    : TaskWarriorColors.kLightPrimaryTextColor),
                          )
                      ],
                    ),
                  ],
                ),
                // By not specifying a 'trailing' widget, ExpansionTile uses its default arrow
                children: <Widget>[
                  // The 'configure' option is now the first item inside the expandable list
                  if (currentProfile == profileId)
                    ListTile(
                      leading: Icon(Icons.key,
                          color: AppSettings.isDarkMode
                              ? TaskWarriorColors.kprimaryTextColor
                              : TaskWarriorColors.kLightPrimaryTextColor),
                      title: Text(
                        SentenceManager(
                                currentLanguage: AppSettings.selectedLanguage)
                            .sentences
                            .profilePageConfigureTaskserver, // New descriptive text
                        style: TextStyle(
                          color: AppSettings.isDarkMode
                              ? TaskWarriorColors.kprimaryTextColor
                              : TaskWarriorColors.kLightPrimaryTextColor,
                        ),
                      ),
                      onTap: () {
                        configure();
                      },
                    ),
                  ListTile(
                    leading: Icon(Icons.file_copy,
                        color: AppSettings.isDarkMode
                            ? TaskWarriorColors.kprimaryTextColor
                            : TaskWarriorColors.kLightPrimaryTextColor),
                    title: Text(
                        SentenceManager(
                                currentLanguage: AppSettings.selectedLanguage)
                            .sentences
                            .profilePageExportTasks,
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
                    title: Text(
                        SentenceManager(
                                currentLanguage: AppSettings.selectedLanguage)
                            .sentences
                            .profilePageCopyConfigToNewProfile,
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
                    title: Text(
                        SentenceManager(
                                currentLanguage: AppSettings.selectedLanguage)
                            .sentences
                            .profilePageChangeProfileMode,
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
                    title: Text(
                        SentenceManager(
                                currentLanguage: AppSettings.selectedLanguage)
                            .sentences
                            .profilePageDeleteProfile,
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
