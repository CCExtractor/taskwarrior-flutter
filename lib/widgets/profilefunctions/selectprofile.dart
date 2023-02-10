import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';

import 'package:taskwarrior/config/app_settings.dart';

class SelectProfile extends StatelessWidget {
  const SelectProfile(
    this.currentProfile,
    this.profilesMap,
    this.selectProfile, {
    Key? key,
  }) : super(key: key);

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
          const Text(
            'Profile:',
            overflow: TextOverflow.fade,
          ),
          Text(currentProfile,
              style: TextStyle(
                color: AppSettings.isDarkMode ? Colors.grey : Colors.grey[600],
              ))
        ],
      ),
      children: [
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
    return ListTile(
      textColor: AppSettings.isDarkMode
          ? Colors.white
          : const Color.fromARGB(255, 48, 46, 46),
      iconColor: AppSettings.isDarkMode
          ? Colors.white
          : const Color.fromARGB(255, 48, 46, 46),
      leading: Radio<String>(
        value: uuid,
        groupValue: selectedUuid,
        onChanged: (_) => select(),
        activeColor: AppSettings.isDarkMode
            ? Colors.white
            : const Color.fromARGB(255, 48, 46, 46),
        focusColor: AppSettings.isDarkMode
            ? Colors.white
            : const Color.fromARGB(255, 48, 46, 46),
      ),
      title: SingleChildScrollView(
        key: PageStorageKey<String>('scroll-title-$uuid'),
        scrollDirection: Axis.horizontal,
        child: Text(
          alias ?? '',
          style: GoogleFonts.firaMono(),
        ),
      ),
      subtitle: SingleChildScrollView(
        key: PageStorageKey<String>('scroll-subtitle-$uuid'),
        scrollDirection: Axis.horizontal,
        child: Text(
          uuid,
          style: GoogleFonts.firaMono(),
        ),
      ),
    );
  }
}
