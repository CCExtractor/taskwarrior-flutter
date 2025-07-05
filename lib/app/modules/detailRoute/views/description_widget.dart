import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:loggy/loggy.dart';
import 'package:taskwarrior/app/utils/app_settings/app_settings.dart';
import 'package:taskwarrior/app/utils/constants/constants.dart';
import 'package:taskwarrior/app/utils/constants/utilites.dart';
import 'package:taskwarrior/app/utils/gen/fonts.gen.dart';
import 'package:taskwarrior/app/utils/themes/theme_extension.dart';
import 'package:taskwarrior/app/utils/language/sentence_manager.dart';

class DescriptionWidget extends StatelessWidget {
  const DescriptionWidget({
    required this.name,
    required this.value,
    required this.callback,
    this.isEditable = true,
    super.key,
  });

  final String name;
  final dynamic value;
  final void Function(dynamic) callback;
  final bool isEditable;

  @override
  Widget build(BuildContext context) {
    TaskwarriorColorTheme tColors =
        Theme.of(context).extension<TaskwarriorColorTheme>()!;
    return Card(
      color: tColors.secondaryBackgroundColor,
      child: ListTile(
        enabled: isEditable,
        textColor: isEditable
            ? tColors.primaryTextColor
            : tColors.primaryDisabledTextColor,
        title: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              RichText(
                text: TextSpan(
                  children: <TextSpan>[
                    TextSpan(
                      text: '$name:'.padRight(13),
                      // style: GoogleFonts.poppins(
                      //   fontWeight: TaskWarriorFonts.bold,
                      //   fontSize: TaskWarriorFonts.fontSizeMedium,
                      //   color: AppSettings.isDarkMode
                      //       ? Colors.white
                      //       : Colors.black,
                      // ),
                      style: TextStyle(
                        fontFamily: FontFamily.poppins,
                        fontWeight: TaskWarriorFonts.bold,
                        fontSize: TaskWarriorFonts.fontSizeMedium,
                        color: isEditable
                            ? tColors.primaryTextColor
                            : tColors.primaryDisabledTextColor,
                      ),
                    ),
                    TextSpan(
                      text: value ??
                          SentenceManager(
                                  currentLanguage: AppSettings.selectedLanguage)
                              .sentences
                              .notSelected,
                      // style: GoogleFonts.poppins(
                      //   fontSize: TaskWarriorFonts.fontSizeMedium,
                      //   color: AppSettings.isDarkMode
                      //       ? Colors.white
                      //       : Colors.black,
                      // ),
                      style: TextStyle(
                        fontFamily: FontFamily.poppins,
                        fontSize: TaskWarriorFonts.fontSizeMedium,
                        color: isEditable
                            ? tColors.primaryTextColor
                            : tColors.primaryDisabledTextColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        onTap: () {
          var controller = TextEditingController(
            text: value,
          );
          showDialog(
            context: context,
            builder: (context) => Utils.showAlertDialog(
              scrollable: true,
              title: Text(
                SentenceManager(currentLanguage: AppSettings.selectedLanguage)
                    .sentences
                    .editDescription,
                style: TextStyle(
                  color: tColors.primaryTextColor,
                ),
              ),
              content: TextField(
                style: TextStyle(
                  color: tColors.primaryTextColor,
                ),
                autofocus: true,
                maxLines: null,
                controller: controller,
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Get.back();
                  },
                  child: Text(
                    SentenceManager(
                            currentLanguage: AppSettings.selectedLanguage)
                        .sentences
                        .cancel,
                    style: TextStyle(
                      color: tColors.primaryTextColor,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    try {
                      callback(controller.text);
                      Get.back();
                    } on FormatException catch (e, trace) {
                      logError(e, trace);
                    }
                  },
                  child: Text(
                    SentenceManager(
                            currentLanguage: AppSettings.selectedLanguage)
                        .sentences
                        .submit,
                    style: TextStyle(
                      color: tColors.primaryTextColor,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class ProjectWidget extends StatelessWidget {
  const ProjectWidget({
    required this.name,
    required this.value,
    required this.callback,
    this.isEditable = true,
    super.key,
  });

  final String name;
  final dynamic value;
  final void Function(dynamic) callback;
  final bool isEditable;

  @override
  Widget build(BuildContext context) {
    TaskwarriorColorTheme tColors =
        Theme.of(context).extension<TaskwarriorColorTheme>()!;
    return Card(
      color: tColors.secondaryBackgroundColor,
      child: ListTile(
        enabled: isEditable,
        textColor: isEditable
            ? tColors.primaryTextColor
            : tColors.primaryDisabledTextColor,
        title: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              RichText(
                text: TextSpan(
                  children: <TextSpan>[
                    TextSpan(
                      text: '$name:'.padRight(13),
                      // style: GoogleFonts.poppins(
                      //   fontWeight: TaskWarriorFonts.bold,
                      //   fontSize: TaskWarriorFonts.fontSizeMedium,
                      //   color: AppSettings.isDarkMode
                      //       ? Colors.white
                      //       : Colors.black,
                      // ),
                      style: TextStyle(
                        fontFamily: FontFamily.poppins,
                        fontWeight: TaskWarriorFonts.bold,
                        fontSize: TaskWarriorFonts.fontSizeMedium,
                        color: isEditable
                            ? tColors.primaryTextColor
                            : tColors.primaryDisabledTextColor,
                      ),
                    ),
                    TextSpan(
                      text: value ??
                          SentenceManager(
                                  currentLanguage: AppSettings.selectedLanguage)
                              .sentences
                              .notSelected,
                      // style: GoogleFonts.poppins(
                      //   fontSize: TaskWarriorFonts.fontSizeMedium,
                      //   color: AppSettings.isDarkMode
                      //       ? Colors.white
                      //       : Colors.black,
                      // ),
                      style: TextStyle(
                        fontFamily: FontFamily.poppins,
                        fontSize: TaskWarriorFonts.fontSizeMedium,
                        color: isEditable
                            ? tColors.primaryTextColor
                            : tColors.primaryDisabledTextColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        onTap: () {
          var controller = TextEditingController(
            text: value,
          );
          showDialog(
            context: context,
            builder: (context) => Utils.showAlertDialog(
              scrollable: true,
              title: Text(
                SentenceManager(currentLanguage: AppSettings.selectedLanguage)
                    .sentences
                    .editProject,
                style: TextStyle(
                  color: tColors.primaryTextColor,
                ),
              ),
              content: TextField(
                style: TextStyle(
                  color: tColors.primaryTextColor,
                ),
                autofocus: true,
                maxLines: null,
                controller: controller,
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Get.back();
                  },
                  child: Text(
                    SentenceManager(
                            currentLanguage: AppSettings.selectedLanguage)
                        .sentences
                        .cancel,
                    style: TextStyle(
                      color: tColors.primaryTextColor,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    try {
                      callback(
                          (controller.text == '') ? null : controller.text);
                      Get.back();
                    } on FormatException catch (e, trace) {
                      logError(e, trace);
                    }
                  },
                  child: Text(
                    SentenceManager(
                            currentLanguage: AppSettings.selectedLanguage)
                        .sentences
                        .submit,
                    style: TextStyle(
                      color: tColors.primaryTextColor,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
