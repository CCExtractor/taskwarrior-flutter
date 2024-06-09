import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taskwarrior/app/utils/constants/taskwarrior_colors.dart';
import 'package:taskwarrior/app/utils/constants/taskwarrior_fonts.dart';
import 'package:taskwarrior/app/utils/theme/app_settings.dart';

import 'package:tuple/tuple.dart';

class ManageProfile extends StatelessWidget {
  const ManageProfile(
    this.rename,
    this.configure,
    this.export,
    this.copy,
    this.delete, {
    super.key,
  });

  final void Function() rename;
  final void Function() configure;
  final void Function() export;
  final void Function() copy;
  final void Function() delete;

  @override
  Widget build(BuildContext context) {
    var triples = [
      Tuple3(Icons.edit, 'Rename Alias', rename),
      Tuple3(Icons.link, 'Configure Taskserver', configure),
      Tuple3(Icons.upload, 'Export tasks', export),
      Tuple3(Icons.copy, 'Copy config to new profile', copy),
      Tuple3(Icons.delete, 'Delete profile', delete),
    ];

    return ExpansionTile(
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
          ? TaskWarriorColors.white
          : TaskWarriorColors.ksecondaryBackgroundColor,
      textColor: AppSettings.isDarkMode
          ? TaskWarriorColors.white
          : TaskWarriorColors.black,
      key: const PageStorageKey<String>('manage-profile'),
      title: Text(
        'Manage selected profile',
        style: GoogleFonts.poppins(
          fontWeight: TaskWarriorFonts.bold,
          fontSize: TaskWarriorFonts.fontSizeMedium,
          color: AppSettings.isDarkMode
              ? TaskWarriorColors.white
              : TaskWarriorColors.black,
        ),
      ),
      children: [
        for (var triple in triples)
          ListTile(
            textColor: AppSettings.isDarkMode
                ? TaskWarriorColors.ksecondaryTextColor
                : TaskWarriorColors.kLightSecondaryTextColor,
            iconColor: AppSettings.isDarkMode
                ? TaskWarriorColors.white
                : TaskWarriorColors.kLightSecondaryTextColor,
            leading: Padding(
              padding: const EdgeInsets.all(12),
              child: Icon(triple.item1),
            ),
            title: Text(triple.item2),
            onTap: triple.item3,
          )
      ],
    );
  }
}
