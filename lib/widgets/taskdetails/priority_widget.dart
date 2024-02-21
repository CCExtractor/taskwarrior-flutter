import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:taskwarrior/config/app_settings.dart';
import 'package:taskwarrior/config/taskwarriorfonts.dart';

class PriorityWidget extends StatelessWidget {
  const PriorityWidget(
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
                        fontSize: 15,
                        color: AppSettings.isDarkMode
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
                    TextSpan(
                      text: value ?? "not selected",
                      style: GoogleFonts.poppins(
                        fontSize: 15,
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
          switch (value) {
            case 'H':
              return callback('M');
            case 'M':
              return callback('L');
            case 'L':
              return callback(null);
            default:
              return callback('H');
          }
        },
      ),
    );
  }
}
