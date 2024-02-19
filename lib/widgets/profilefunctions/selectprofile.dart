import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

import 'package:taskwarrior/config/app_settings.dart';
import 'package:taskwarrior/config/taskwarriorcolors.dart';

class SelectProfile extends StatelessWidget {
  const SelectProfile(
    this.currentProfile,
    this.profilesMap,
    this.selectProfile, {
    super.key,
  });

  final String currentProfile;
  final Map profilesMap;
  final void Function(String) selectProfile;

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      key: const PageStorageKey<String>('task-list'),
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
            'Current Profile:',
            overflow: TextOverflow.fade,
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.bold,
              fontSize: 15,
              color: AppSettings.isDarkMode
                  ? TaskWarriorColors.white
                  : TaskWarriorColors.black,
            ),
          ),
          SizedBox(
            height: 1.h,
          ),
          Text(currentProfile,
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: AppSettings.isDarkMode
                    ? TaskWarriorColors.grey
                    : TaskWarriorColors.lightGrey,
              ))
        ],
      ),
      children: [
        SizedBox(
          height: 1.h,
        ),
        Padding(
          padding: EdgeInsets.only(left: 4.w),
          child: Row(
            children: [
              Text(
                'All Profiles:',
                overflow: TextOverflow.fade,
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: AppSettings.isDarkMode
                      ? TaskWarriorColors.white
                      : TaskWarriorColors.black,
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 1.h,
        ),
        for (var entry in profilesMap.entries)
          SelectProfileListTile(
            currentProfile,
            entry.key,
            () => selectProfile(entry.key),
            entry.value,
          )
      ],
    );
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
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('Switched to Profile ${alias ?? uuid}'),
            ));
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
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
