// ignore_for_file: unnecessary_getters_setters

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taskwarrior/app/utils/constants/constants.dart';
import 'package:taskwarrior/app/utils/app_settings/app_settings.dart';


class StatusWidget extends StatelessWidget {
  const StatusWidget(
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
                      style: GoogleFonts.poppins(
                        fontWeight: TaskWarriorFonts.bold,
                        fontSize: TaskWarriorFonts.fontSizeMedium,
                        color: AppSettings.isDarkMode
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
                    TextSpan(
                      text: value ?? "",
                      style: GoogleFonts.poppins(
                        fontSize: TaskWarriorFonts.fontSizeMedium,
                        color: AppSettings.isDarkMode
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        onTap: () {
          if (kDebugMode) {
            print(value);
          }
          switch (value) {
            case 'pending':
              return callback('completed');
            case 'completed':
              return callback('deleted');
            case 'deleted':
              return callback('pending');
          }
        },
      ),
    );
  }
}

class StatusWidgetData {
  //for accessing the value of the status widget from another class or another dart file
  static dynamic _value;
  static dynamic get value => _value;
  static set value(dynamic newValue) => _value = newValue;
}
