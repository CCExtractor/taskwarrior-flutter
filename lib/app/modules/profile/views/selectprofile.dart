import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:taskwarrior/app/modules/home/controllers/home_controller.dart';
import 'package:taskwarrior/app/utils/constants/taskwarrior_colors.dart';
import 'package:taskwarrior/app/utils/constants/taskwarrior_fonts.dart';

import 'package:taskwarrior/app/utils/app_settings/app_settings.dart';
import 'package:taskwarrior/app/utils/language/sentence_manager.dart';

class SelectProfile extends StatelessWidget {
  const SelectProfile(
    this.currentProfile,
    this.profilesMap,
    this.selectProfile, {
    required this.currentProfileKey,
    super.key,
  });

  final String currentProfile;
  final Map profilesMap;
  final void Function(String) selectProfile;
  final GlobalKey currentProfileKey;

  @override
  Widget build(BuildContext context) {
    return Obx(() => ExpansionTile(
          // key: currentProfileKey,
          backgroundColor: AppSettings.isDarkMode
              ? TaskWarriorColors.ksecondaryBackgroundColor
              : TaskWarriorColors.kLightSecondaryBackgroundColor,
          iconColor: AppSettings.isDarkMode
              ? TaskWarriorColors.white
              : TaskWarriorColors.black,
          collapsedIconColor: AppSettings.isDarkMode
              ? TaskWarriorColors.white
              : TaskWarriorColors.black,
          collapsedTextColor: AppSettings.isDarkMode
              ? TaskWarriorColors.ksecondaryTextColor
              : TaskWarriorColors.kLightSecondaryTextColor,
          textColor: AppSettings.isDarkMode
              ? TaskWarriorColors.white
              : TaskWarriorColors.black,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                SentenceManager(
                          currentLanguage: AppSettings.selectedLanguage)
                      .sentences
                      .profilePageCurrentProfile,
                key : currentProfileKey,
                overflow: TextOverflow.fade,
                style: GoogleFonts.poppins(
                  fontWeight: TaskWarriorFonts.bold,
                  fontSize: TaskWarriorFonts.fontSizeMedium,
                  color: AppSettings.isDarkMode
                      ? TaskWarriorColors.white
                      : TaskWarriorColors.black,
                ),
              ),
              SizedBox(
                height: Get.height * 0.01,
              ),
              Text(currentProfile,
                  style: GoogleFonts.poppins(
                    fontSize: TaskWarriorFonts.fontSizeSmall,
                    color: AppSettings.isDarkMode
                        ? TaskWarriorColors.grey
                        : TaskWarriorColors.lightGrey,
                  ))
            ],
          ),
          children: [
            SizedBox(
              height: Get.height * 0.01,
            ),
            Padding(
              padding: EdgeInsets.only(left: Get.height * 0.04),
              child: Row(
                children: [
                  Text(
                    'All Profiles:',
                    overflow: TextOverflow.fade,
                    style: GoogleFonts.poppins(

                      fontWeight: TaskWarriorFonts.bold,
                      fontSize: TaskWarriorFonts.fontSizeMedium,
                      color: AppSettings.isDarkMode
                          ? TaskWarriorColors.white
                          : TaskWarriorColors.black,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: Get.height * 0.01,
            ),
            for (var entry in profilesMap.entries)
              SelectProfileListTile(
                currentProfile,
                entry.key,
                () => selectProfile(entry.key),
                entry.value,
              )
          ],
        ));
  }
}

class SelectProfileListTile extends StatelessWidget {
  const SelectProfileListTile(
    this.selectedUuid,
    this.uuid,
    this.select, [
    this.alias,
    Key? key,
  ]) : super(key: key);

  final String selectedUuid;
  final String uuid;
  final void Function() select;
  final String? alias;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Radio<String>(
          value: uuid,
          groupValue: selectedUuid,
          onChanged: (_) {
            select();
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Switched to Profile ${alias ?? uuid}',
                  style: TextStyle(
                    color: AppSettings.isDarkMode
                        ? TaskWarriorColors.kprimaryTextColor
                        : TaskWarriorColors.kLightPrimaryTextColor,
                  ),
                ),
                backgroundColor: AppSettings.isDarkMode
                    ? TaskWarriorColors.ksecondaryBackgroundColor
                    : TaskWarriorColors.kLightSecondaryBackgroundColor,
                duration: const Duration(seconds: 2),
              ),
            );
            Get.find<HomeController>().refreshTaskWithNewProfile();
          },
          activeColor: AppSettings.isDarkMode
              ? TaskWarriorColors.white
              : TaskWarriorColors.ksecondaryBackgroundColor,
          focusColor: AppSettings.isDarkMode
              ? TaskWarriorColors.white
              : TaskWarriorColors.ksecondaryBackgroundColor,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            if (alias != null && alias!.isNotEmpty)
              SizedBox(
                // height: 100,
                width: 300,
                child: SingleChildScrollView(
                  key: PageStorageKey<String>('scroll-title-$uuid'),
                  scrollDirection: Axis.horizontal,
                  child: Text(
                    alias!,
                    overflow: TextOverflow.fade,
                    style: GoogleFonts.poppins(
                      color: AppSettings.isDarkMode
                          ? TaskWarriorColors.ksecondaryTextColor
                          : TaskWarriorColors.kLightSecondaryTextColor,
                      fontSize: TaskWarriorFonts.fontSizeMedium
                    ),
                  ),
                ),
              ),
            SingleChildScrollView(
              key: PageStorageKey<String>('scroll-subtitle-$uuid'),
              scrollDirection: Axis.horizontal,
              child: Text(
                uuid,
                style: GoogleFonts.poppins(
                  color: AppSettings.isDarkMode
                      ? TaskWarriorColors.ksecondaryTextColor
                      : TaskWarriorColors.kLightSecondaryTextColor,
                  fontSize: TaskWarriorFonts.fontSizeSmall
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
