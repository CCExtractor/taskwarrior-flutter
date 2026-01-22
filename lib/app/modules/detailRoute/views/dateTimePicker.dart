// ignore_for_file: file_names, use_build_context_synchronously

import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:taskwarrior/app/utils/app_settings/app_settings.dart';

import 'package:taskwarrior/app/utils/constants/constants.dart';
import 'package:taskwarrior/app/utils/gen/fonts.gen.dart';
import 'package:taskwarrior/app/utils/themes/theme_extension.dart';
import 'package:taskwarrior/app/utils/language/sentence_manager.dart';

class DateTimeWidget extends StatelessWidget {
  const DateTimeWidget({
    super.key,
    required this.name,
    required this.value,
    required this.callback,
    required this.globalKey,
    this.isEditable = true,
  });

  final String name;

  final dynamic value;
  final void Function(dynamic) callback;
  final GlobalKey globalKey;
  final bool isEditable;

  @override
  Widget build(BuildContext context) {
    TaskwarriorColorTheme tColors =
        Theme.of(context).extension<TaskwarriorColorTheme>()!;
    return Card(
      key: globalKey,
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
        onTap: () async {
          var parsedDate = DateFormat("E, M/d/y h:mm:ss a").parse(
              value?.replaceAll(RegExp(r'\s+'), ' ') ??
                  DateFormat("E, M/d/y h:mm:ss a").format(DateTime.now()));

          var now = DateTime.now();
          var initialDate = parsedDate.isBefore(now) ? now : parsedDate;

          var date = await showDatePicker(
            context: context,
            initialDate: initialDate,
            firstDate: now,
            lastDate: DateTime(2037, 12, 31), // < 2038-01-19T03:14:08.000Z
          );

          if (date != null) {
            var time = await showTimePicker(
              context: context,
              initialTime: TimeOfDay.now(),
            );
            if (time != null) {
              var dateTime = date.add(
                Duration(
                  hours: time.hour,
                  minutes: time.minute,
                ),
              );

              if (dateTime.isBefore(DateTime.now())) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      SentenceManager(
                        currentLanguage: AppSettings.selectedLanguage,
                      ).sentences.cantSetTimeinPast,
                      style: TextStyle(
                        color: tColors.primaryTextColor,
                      ),
                    ),
                    backgroundColor: tColors.primaryBackgroundColor,
                    duration: const Duration(seconds: 2),
                  ),
                );
              } else {
                return callback(dateTime.toUtc());
              }
            }
          }
        },
        onLongPress: () => callback(null),
      ),
    );
  }
}

class StartWidget extends StatelessWidget {
  const StartWidget({
    required this.name,
    required this.value,
    required this.callback,
    this.isEditable = true,
    super.key,
  });

  final String name;
  final dynamic value;
  final bool isEditable;
  final void Function(dynamic) callback;

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
          if (value != null) {
            callback(null);
          } else {
            var now = DateTime.now().toUtc();
            callback(DateTime.utc(
              now.year,
              now.month,
              now.day,
              now.hour,
              now.minute,
              now.second,
            ));
          }
        },
      ),
    );
  }
}
