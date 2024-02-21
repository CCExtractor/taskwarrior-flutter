// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taskwarrior/config/app_settings.dart';
import 'package:taskwarrior/config/taskwarriorcolors.dart';
import 'package:taskwarrior/config/taskwarriorfonts.dart';

///Common widget for Report chart indicator
class CommonChartIndicator extends StatelessWidget {
  final String title;
  const CommonChartIndicator({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: GoogleFonts.poppins(
                fontWeight: TaskWarriorFonts.bold,
                fontSize: TaskWarriorFonts.fontSizeMedium,
                color: AppSettings.isDarkMode
                    ? TaskWarriorColors.white
                    : TaskWarriorColors.black,
              ),
            )
          ],
        ),
        const SizedBox(
          height: 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              children: [
                Container(
                  height: 20,
                  width: 80,
                  decoration: BoxDecoration(color: TaskWarriorColors.green),
                ),
                Text(
                  "Completed",
                  style: GoogleFonts.poppins(
                    fontWeight: TaskWarriorFonts.regular,
                    fontSize: TaskWarriorFonts.fontSizeMedium,
                    color: AppSettings.isDarkMode
                        ? TaskWarriorColors.white
                        : TaskWarriorColors.black,
                  ),
                ),
              ],
            ),
            Column(
              children: [
                Container(
                  height: 20,
                  width: 80,
                  decoration: BoxDecoration(color: TaskWarriorColors.yellow),
                ),
                Text(
                  "Pending",
                  style: GoogleFonts.poppins(
                    fontWeight: TaskWarriorFonts.regular,
                    fontSize: TaskWarriorFonts.fontSizeMedium,
                    color: AppSettings.isDarkMode
                        ? TaskWarriorColors.white
                        : TaskWarriorColors.black,
                  ),
                ),
              ],
            )
          ],
        ),
      ],
    );
  }
}
