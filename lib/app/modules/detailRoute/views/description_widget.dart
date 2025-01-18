import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:loggy/loggy.dart';
import 'package:taskwarrior/app/utils/constants/constants.dart';
import 'package:taskwarrior/app/utils/constants/utilites.dart';
import 'package:taskwarrior/app/utils/gen/fonts.gen.dart';
import 'package:taskwarrior/app/utils/app_settings/app_settings.dart';

class DescriptionWidget extends StatelessWidget {
  const DescriptionWidget(
      {required this.name,
      required this.value,
      required this.callback,
      super.key});

  final String name;
  final dynamic value;
  final void Function(dynamic) callback;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppSettings.isDarkMode
          ? const Color.fromARGB(255, 57, 57, 57)
          : Colors.white,
      child: ListTile(
        textColor: AppSettings.isDarkMode
            ? Colors.white
            : const Color.fromARGB(255, 48, 46, 46),
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
                        color: AppSettings.isDarkMode
                            ? TaskWarriorColors.white
                            : TaskWarriorColors.black,
                      ),
                    ),
                    TextSpan(
                      text: value ?? "",
                      // style: GoogleFonts.poppins(
                      //   fontSize: TaskWarriorFonts.fontSizeMedium,
                      //   color: AppSettings.isDarkMode
                      //       ? Colors.white
                      //       : Colors.black,
                      // ),
                      style: TextStyle(
                        fontFamily: FontFamily.poppins,
                        fontSize: TaskWarriorFonts.fontSizeMedium,
                        color: AppSettings.isDarkMode
                            ? TaskWarriorColors.white
                            : TaskWarriorColors.black,
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
                'Edit description',
                style: TextStyle(
                  color: AppSettings.isDarkMode
                      ? TaskWarriorColors.white
                      : TaskWarriorColors.black,
                ),
              ),
              content: TextField(
                style: TextStyle(
                  color: AppSettings.isDarkMode
                      ? TaskWarriorColors.white
                      : TaskWarriorColors.black,
                ),
                autofocus: true,
                maxLines: null,
                controller: controller,
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    // Navigator.of(context).pop();
                    Get.back();
                  },
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                      color: AppSettings.isDarkMode
                          ? TaskWarriorColors.white
                          : TaskWarriorColors.black,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    try {
                      callback(controller.text);
                      // Navigator.of(context).pop();
                      Get.back();
                    } on FormatException catch (e, trace) {
                      logError(e, trace);
                    }
                  },
                  child: Text(
                    'Submit',
                    style: TextStyle(
                      color: AppSettings.isDarkMode
                          ? TaskWarriorColors.black
                          : TaskWarriorColors.black,
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
  const ProjectWidget(
      {required this.name,
      required this.value,
      required this.callback,
      super.key});

  final String name;
  final dynamic value;
  final void Function(dynamic) callback;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppSettings.isDarkMode
          ? const Color.fromARGB(255, 57, 57, 57)
          : Colors.white,
      child: ListTile(
        textColor: AppSettings.isDarkMode
            ? Colors.white
            : const Color.fromARGB(255, 48, 46, 46),
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
                        color: AppSettings.isDarkMode
                            ? TaskWarriorColors.white
                            : TaskWarriorColors.black,
                      ),
                    ),
                    TextSpan(
                      text: value ?? "",
                      // style: GoogleFonts.poppins(
                      //   fontSize: TaskWarriorFonts.fontSizeMedium,
                      //   color: AppSettings.isDarkMode
                      //       ? Colors.white
                      //       : Colors.black,
                      // ),
                      style: TextStyle(
                        fontFamily: FontFamily.poppins,
                        fontSize: TaskWarriorFonts.fontSizeMedium,
                        color: AppSettings.isDarkMode
                            ? TaskWarriorColors.white
                            : TaskWarriorColors.black,
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
                'Edit project',
                style: TextStyle(
                  color: AppSettings.isDarkMode
                      ? TaskWarriorColors.white
                      : TaskWarriorColors.black,
                ),
              ),
              content: TextField(
                style: TextStyle(
                  color: AppSettings.isDarkMode
                      ? TaskWarriorColors.white
                      : TaskWarriorColors.black,
                ),
                autofocus: true,
                maxLines: null,
                controller: controller,
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    // Navigator.of(context).pop();
                    Get.back();
                  },
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                      color: AppSettings.isDarkMode
                          ? TaskWarriorColors.white
                          : TaskWarriorColors.black,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    try {
                      callback(
                          (controller.text == '') ? null : controller.text);
                      // Navigator.of(context).pop();
                      Get.back();
                    } on FormatException catch (e, trace) {
                      logError(e, trace);
                    }
                  },
                  child: Text(
                    'Submit',
                    style: TextStyle(
                      color: AppSettings.isDarkMode
                          ? TaskWarriorColors.black
                          : TaskWarriorColors.black,
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
