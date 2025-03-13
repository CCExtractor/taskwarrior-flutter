import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taskwarrior/app/utils/constants/taskwarrior_fonts.dart';

import 'package:taskwarrior/app/utils/app_settings/app_settings.dart';
import 'package:taskwarrior/app/utils/language/sentence_manager.dart';

import 'package:tuple/tuple.dart';
import 'package:taskwarrior/app/utils/themes/theme_extension.dart';

class ManageProfile extends StatelessWidget {
  const ManageProfile(
    this.rename,
    this.configure,
    this.export,
    this.copy,
    this.delete, {
    required this.manageSelectedProfileKey,
    super.key,
  });

  final void Function() rename;
  final void Function() configure;
  final void Function() export;
  final void Function() copy;
  final void Function() delete;
  final GlobalKey manageSelectedProfileKey;

  @override
  Widget build(BuildContext context) {
    TaskwarriorColorTheme tColors = Theme.of(context).extension<TaskwarriorColorTheme>()!;
    var triples = [
      Tuple3(
        Icons.edit,
        SentenceManager(currentLanguage: AppSettings.selectedLanguage)
            .sentences
            .profilePageRenameAlias,
        rename,
      ),
      Tuple3(
        Icons.link,
        SentenceManager(currentLanguage: AppSettings.selectedLanguage)
            .sentences
            .profilePageConfigureTaskserver,
        configure,
      ),
      Tuple3(
        Icons.upload,
        SentenceManager(currentLanguage: AppSettings.selectedLanguage)
            .sentences
            .profilePageExportTasks,
        export,
      ),
      Tuple3(
        Icons.copy,
        SentenceManager(currentLanguage: AppSettings.selectedLanguage)
            .sentences
            .profilePageCopyConfigToNewProfile,
        copy,
      ),
      Tuple3(
        Icons.delete,
        SentenceManager(currentLanguage: AppSettings.selectedLanguage)
            .sentences
            .profilePageDeleteProfile,
        delete,
      ),
    ];

    return ExpansionTile(
      key: manageSelectedProfileKey,
      backgroundColor: tColors.secondaryBackgroundColor,
      iconColor: tColors.primaryTextColor,
      collapsedIconColor: tColors.primaryTextColor,
      collapsedTextColor: tColors.primaryTextColor,
      textColor: tColors.primaryTextColor,
      title: Text(
        SentenceManager(currentLanguage: AppSettings.selectedLanguage)
            .sentences
            .profilePageManageSelectedProfile,
        style: GoogleFonts.poppins(
          fontWeight: TaskWarriorFonts.bold,
          fontSize: TaskWarriorFonts.fontSizeMedium,
          color: tColors.primaryTextColor,
        ),
      ),
      children: [
        for (var triple in triples)
          ListTile(
            textColor: tColors.secondaryTextColor,
            iconColor: tColors.secondaryTextColor,
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
