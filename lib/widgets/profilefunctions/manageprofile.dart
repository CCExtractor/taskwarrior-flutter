import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:tuple/tuple.dart';

import 'package:taskwarrior/config/app_settings.dart';

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
      Tuple3(Icons.file_download, 'Export tasks', export),
      Tuple3(Icons.copy, 'Copy config to new profile', copy),
      Tuple3(Icons.delete, 'Delete profile', delete),
    ];

    return ExpansionTile(
      backgroundColor: AppSettings.isDarkMode
          ? const Color.fromARGB(255, 48, 46, 46)
          : const Color.fromARGB(255, 220, 216, 216),
      iconColor: AppSettings.isDarkMode ? Colors.white : Colors.black,
      collapsedIconColor: AppSettings.isDarkMode ? Colors.white : Colors.black,
      collapsedTextColor: AppSettings.isDarkMode
          ? Colors.white
          : const Color.fromARGB(255, 48, 46, 46),
      textColor: AppSettings.isDarkMode ? Colors.white : Colors.black,
      key: const PageStorageKey<String>('manage-profile'),
      title: Text(
        'Manage selected profile',
        style: GoogleFonts.poppins(
          fontWeight: FontWeight.bold,
          fontSize: 15,
          color: AppSettings.isDarkMode ? Colors.white : Colors.black,
        ),
      ),
      children: [
        for (var triple in triples)
          ListTile(
            textColor: AppSettings.isDarkMode
                ? Colors.white
                : const Color.fromARGB(255, 48, 46, 46),
            iconColor: AppSettings.isDarkMode
                ? Colors.white
                : const Color.fromARGB(255, 48, 46, 46),
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
