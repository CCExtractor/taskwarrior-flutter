import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

import 'package:taskwarrior/config/app_settings.dart';

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
          ? const Color.fromARGB(255, 48, 46, 46)
          : const Color.fromARGB(255, 220, 216, 216),
      iconColor: AppSettings.isDarkMode ? Colors.white : Colors.black,
      collapsedIconColor: AppSettings.isDarkMode ? Colors.white : Colors.black,
      collapsedTextColor: AppSettings.isDarkMode
          ? Colors.white
          : const Color.fromARGB(255, 48, 46, 46),
      textColor: AppSettings.isDarkMode ? Colors.white : Colors.black,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Current Profile:',
            overflow: TextOverflow.fade,
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.bold,
              fontSize: 15,
              color: AppSettings.isDarkMode ? Colors.white : Colors.black,
            ),
          ),
          SizedBox(
            height: 1.h,
          ),
          Text(currentProfile,
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: AppSettings.isDarkMode ? Colors.grey : Colors.grey[600],
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
                  color: AppSettings.isDarkMode ? Colors.white : Colors.black,
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
          ),
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
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('Switched to Profile ${alias ?? uuid}'),
            ));
          },
          activeColor: AppSettings.isDarkMode
              ? Colors.white
              : const Color.fromARGB(255, 48, 46, 46),
          focusColor: AppSettings.isDarkMode
              ? Colors.white
              : const Color.fromARGB(255, 48, 46, 46),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            if (alias != null && alias!.isNotEmpty)
              SingleChildScrollView(
                key: PageStorageKey<String>('scroll-title-$uuid'),
                scrollDirection: Axis.horizontal,
                child: Text(
                  alias!,
                  style: GoogleFonts.poppins(
                    color: AppSettings.isDarkMode
                        ? Colors.white
                        : const Color.fromARGB(255, 48, 46, 46),
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
                      ? Colors.white
                      : const Color.fromARGB(255, 48, 46, 46),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
