// ignore_for_file: unnecessary_getters_setters

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taskwarrior/app/utils/constants/constants.dart';
import 'package:taskwarrior/app/utils/themes/theme_extension.dart';


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
    TaskwarriorColorTheme tColors = Theme.of(context).extension<TaskwarriorColorTheme>()!;
    return Card(
      color: tColors.secondaryBackgroundColor,
      child: ListTile(
        textColor: tColors.primaryTextColor,
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
                        color: tColors.primaryTextColor,
                      ),
                    ),
                    TextSpan(
                      text: value ?? "not selected",
                      style: GoogleFonts.poppins(
                        fontSize: TaskWarriorFonts.fontSizeMedium,
                        color: tColors.primaryTextColor,
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
