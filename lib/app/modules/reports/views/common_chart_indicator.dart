import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:taskwarrior/app/models/chart.dart';
import 'package:taskwarrior/app/modules/reports/controllers/reports_controller.dart';
import 'package:taskwarrior/app/utils/constants/taskwarrior_colors.dart';
import 'package:taskwarrior/app/utils/constants/taskwarrior_fonts.dart';
import 'package:taskwarrior/app/utils/gen/fonts.gen.dart';
import 'package:taskwarrior/app/utils/theme/app_settings.dart';

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
              // style: GoogleFonts.poppins(
              //   fontWeight: TaskWarriorFonts.bold,
              //   fontSize: TaskWarriorFonts.fontSizeMedium,
              //   color: AppSettings.isDarkMode
              //       ? TaskWarriorColors.white
              //       : TaskWarriorColors.black,
              // ),
              style: TextStyle(
                fontFamily: FontFamily.poppins,
                fontWeight: TaskWarriorFonts.bold,
                color: AppSettings.isDarkMode ? Colors.white : Colors.black,
                fontSize: TaskWarriorFonts.fontSizeMedium,
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
                  // style: GoogleFonts.poppins(
                  //   fontWeight: TaskWarriorFonts.regular,
                  //   fontSize: TaskWarriorFonts.fontSizeMedium,
                  //   color: AppSettings.isDarkMode
                  //       ? TaskWarriorColors.white
                  //       : TaskWarriorColors.black,
                  // ),
                  style: TextStyle(
                    fontFamily: FontFamily.poppins,
                    fontWeight: TaskWarriorFonts.regular,
                    color: AppSettings.isDarkMode ? Colors.white : Colors.black,
                    fontSize: TaskWarriorFonts.fontSizeSmall,
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
                  // style: GoogleFonts.poppins(
                  //   fontWeight: TaskWarriorFonts.regular,
                  //   fontSize: TaskWarriorFonts.fontSizeMedium,
                  //   color: AppSettings.isDarkMode
                  //       ? TaskWarriorColors.white
                  //       : TaskWarriorColors.black,
                  // ),
                  style: TextStyle(
                    fontFamily: FontFamily.poppins,
                    fontWeight: TaskWarriorFonts.regular,
                    color: AppSettings.isDarkMode ? Colors.white : Colors.black,
                    fontSize: TaskWarriorFonts.fontSizeSmall,
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
