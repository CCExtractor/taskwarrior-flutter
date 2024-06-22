import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taskwarrior/app/modules/reports/views/burn_down_daily.dart';
import 'package:taskwarrior/app/modules/reports/views/burn_down_monthly.dart';
import 'package:taskwarrior/app/modules/reports/views/burn_down_weekly.dart';
import 'package:taskwarrior/app/utils/constants/constants.dart';
import 'package:taskwarrior/app/utils/gen/fonts.gen.dart';
import 'package:taskwarrior/app/utils/theme/app_settings.dart';

import '../controllers/reports_controller.dart';

class ReportsView extends GetView<ReportsController> {
  const ReportsView({super.key});

  @override
  Widget build(BuildContext context) {
    controller.initReportsTour();
    controller.showReportsTour(context);
    double height = MediaQuery.of(context).size.height; // Screen height

    return Scaffold(
      appBar: AppBar(
        backgroundColor: TaskWarriorColors.kprimaryBackgroundColor,
        title: Text(
          'Reports',
          style: GoogleFonts.poppins(color: TaskWarriorColors.white),
        ),
        leading: GestureDetector(
          onTap: () {
            Get.back();
          },
          child: Icon(
            Icons.chevron_left,
            color: TaskWarriorColors.white,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(
              height * 0.1), // Adjust the preferred height as needed
          child: TabBar(
            controller: controller.tabController,
            labelColor: TaskWarriorColors.white,
            labelStyle: GoogleFonts.poppins(
              fontWeight: TaskWarriorFonts.medium,
              fontSize: TaskWarriorFonts.fontSizeSmall,
            ),
            unselectedLabelStyle: GoogleFonts.poppins(
              fontWeight: TaskWarriorFonts.light,
            ),
            onTap: (value) {
              controller.selectedIndex.value = value;
            },
            tabs: <Widget>[
              Tab(
                key: controller.daily,
                icon: const Icon(Icons.schedule),
                text: 'Daily',
                iconMargin: const EdgeInsets.only(bottom: 0.0),
              ),
              Tab(
                key: controller.weekly,
                icon: const Icon(Icons.today),
                text: 'Weekly',
                iconMargin: const EdgeInsets.only(bottom: 0.0),
              ),
              Tab(
                key: controller.monthly,
                icon: const Icon(Icons.date_range),
                text: 'Monthly',
                iconMargin: const EdgeInsets.only(bottom: 0.0),
              ),
            ],
          ),
        ),
      ),
      backgroundColor: AppSettings.isDarkMode
          ? TaskWarriorColors.kprimaryBackgroundColor
          : TaskWarriorColors.white,
      body: Obx(
        () => controller.allData.isEmpty
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Icons.heart_broken,
                    color: AppSettings.isDarkMode
                        ? TaskWarriorColors.white
                        : TaskWarriorColors.black,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'No Task found',
                        // style: GoogleFonts.poppins(
                        //   fontWeight: TaskWarriorFonts.medium,
                        //   fontSize: TaskWarriorFonts.fontSizeSmall,
                        //   color: AppSettings.isDarkMode
                        //       ? TaskWarriorColors.white
                        //       : TaskWarriorColors.black,
                        // ),
                        style: TextStyle(
                          fontFamily: FontFamily.poppins,
                          fontWeight: TaskWarriorFonts.medium,
                          fontSize: TaskWarriorFonts.fontSizeSmall,
                          color: AppSettings.isDarkMode
                              ? TaskWarriorColors.white
                              : TaskWarriorColors.black,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Add a task to see reports',
                        // style: GoogleFonts.poppins(
                        //   fontWeight: TaskWarriorFonts.light,
                        //   fontSize: TaskWarriorFonts.fontSizeSmall,
                        //   color: AppSettings.isDarkMode
                        //       ? TaskWarriorColors.white
                        //       : TaskWarriorColors.black,
                        // ),
                        style: TextStyle(
                          fontFamily: FontFamily.poppins,
                          fontWeight: TaskWarriorFonts.light,
                          fontSize: TaskWarriorFonts.fontSizeSmall,
                          color: AppSettings.isDarkMode
                              ? TaskWarriorColors.white
                              : TaskWarriorColors.black,
                        ),
                      ),
                    ],
                  ),
                ],
              )
            : IndexedStack(
                index: controller.selectedIndex.value,
                children: [
                  BurnDownDaily(
                    reportsController: controller,
                  ),
                  BurnDownWeekly(
                    reportsController: controller,
                  ),
                  BurnDownMonthly(
                    reportsController: controller,
                  ),
                ],
              ),
      ),
    );
  }
}
