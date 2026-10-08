import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taskwarrior/app/modules/splash/controllers/splash_controller.dart';
import 'package:taskwarrior/app/utils/constants/taskwarrior_colors.dart';
import 'package:taskwarrior/app/utils/app_settings/app_settings.dart';
import 'package:taskwarrior/app/utils/language/sentence_manager.dart';

/// The list of profiles. Every action the tile can trigger is passed in as a
/// named callback, so the call site reads as intent rather than argument order.
class ProfilesList extends StatelessWidget {
  const ProfilesList({
    super.key,
    required this.profilesMap,
    required this.currentProfile,
    required this.onAddProfile,
    required this.onSelectProfile,
    required this.onRename,
    required this.onConfigure,
    required this.onExport,
    required this.onCopy,
    required this.onDelete,
    required this.onChangeMode,
    required this.currentProfileKey,
    required this.addNewProfileKey,
    required this.manageSelectedProfileKey,
  });

  final RxMap<dynamic, dynamic> profilesMap;
  final String currentProfile;
  final void Function() onAddProfile;
  final void Function(String) onSelectProfile;
  final void Function(String) onRename;
  final void Function() onConfigure;
  final void Function(String) onExport;
  final void Function(String) onCopy;

  /// Deletes the profile. Returns true only when it was actually deleted, which
  /// lets the swipe gesture decide whether to dismiss the row.
  final Future<bool> Function(String) onDelete;

  final void Function(String) onChangeMode;
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
            final String profileId =
                pid[index] as String; // Store pid[index] for clarity

            return Dismissible(
              key: Key(profileId),
              direction: DismissDirection.endToStart,
              // Route the swipe through the same confirmation dialog as the
              // list tile. Returning false (cancel) snaps the row back; true
              // dismisses it, and by then the deletion has already removed it
              // from profilesMap.
              confirmDismiss: (direction) => onDelete(profileId),
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
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start, // Aligns text to the left
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
                    // This Row holds the action buttons, keeping them separate from the tile's default trailing arrow
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit,
                              color: AppSettings.isDarkMode
                                  ? TaskWarriorColors.kprimaryTextColor
                                  : TaskWarriorColors.kLightPrimaryTextColor),
                          onPressed: () => onRename(profileId),
                        ),
                        if (currentProfile != profileId)
                          IconButton(
                            onPressed: () {
                              onSelectProfile(profileId);
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
                        // Label the config option for the profile's actual sync
                        // mode: a Taskchampion (v3) profile configures
                        // Taskchampion, not the Taskserver.
                        Get.find<SplashController>().getMode(profileId) ==
                                'TW3C'
                            ? SentenceManager(
                                    currentLanguage:
                                        AppSettings.selectedLanguage)
                                .sentences
                                .configureTaskchampion
                            : SentenceManager(
                                    currentLanguage:
                                        AppSettings.selectedLanguage)
                                .sentences
                                .profilePageConfigureTaskserver,
                        style: TextStyle(
                          color: AppSettings.isDarkMode
                              ? TaskWarriorColors.kprimaryTextColor
                              : TaskWarriorColors.kLightPrimaryTextColor,
                        ),
                      ),
                      onTap: () {
                        onConfigure();
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
                      onExport(profileId);
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
                      onCopy(profileId);
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
                      onChangeMode(profileId);
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
                      onDelete(profileId);
                    },
                  ),
                ],
              ),
            );
          },
        ));
  }
}
