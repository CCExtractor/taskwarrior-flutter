// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taskwarrior/config/app_settings.dart';
import 'package:taskwarrior/config/taskwarriorcolors.dart';

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
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: AppSettings.isDarkMode ? Colors.white : Colors.black,
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
                  decoration: BoxDecoration(color: Appcolors.green),
                ),
                Text(
                  "Completed",
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                    color: AppSettings.isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
              ],
            ),
            Column(
              children: [
                Container(
                  height: 20,
                  width: 80,
                  decoration: BoxDecoration(color: Appcolors.yellow),
                ),
                Text(
                  "Pending",
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                    color: AppSettings.isDarkMode ? Colors.white : Colors.black,
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
