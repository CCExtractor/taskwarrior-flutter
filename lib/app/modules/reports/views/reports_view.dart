import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taskwarrior/app/modules/reports/views/burn_down_daily.dart';
import 'package:taskwarrior/app/modules/reports/views/burn_down_monthly.dart';
import 'package:taskwarrior/app/modules/reports/views/burn_down_weekly.dart';
import 'package:taskwarrior/app/utils/constants/constants.dart';
import 'package:taskwarrior/app/utils/gen/fonts.gen.dart';
import 'package:taskwarrior/app/utils/language/sentence_manager.dart';
import 'package:taskwarrior/app/utils/app_settings/app_settings.dart';
import 'package:taskwarrior/app/utils/themes/theme_extension.dart';

import '../controllers/reports_controller.dart';

class ReportsView extends GetView<ReportsController> {
  const ReportsView({super.key});

  @override
  Widget build(BuildContext context) {
    controller.initReportsTour();
    controller.showReportsTour(context);
    double height = MediaQuery.of(context).size.height;
    TaskwarriorColorTheme tColors = Theme.of(context).extension<TaskwarriorColorTheme>()!;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: TaskWarriorColors.kprimaryBackgroundColor,
        title: Text(
          SentenceManager(currentLanguage: AppSettings.selectedLanguage)
              .sentences
              .reportsPageTitle,
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
          preferredSize: Size.fromHeight(height * 0.1),
          child: TabBar(
            controller: controller.tabController,
            unselectedLabelStyle: GoogleFonts.poppins(
              fontWeight: TaskWarriorFonts.light,
              color: TaskWarriorColors.appBarUnSelectedIconsColorForReports
            ),
            indicatorColor: tColors.purpleShade,
            labelColor: TaskWarriorColors.white,
            onTap: (value) {
              controller.selectedIndex.value = value;
            },
            tabs: <Widget>[
              Tab(
                key: controller.daily,
                icon: const Icon(Icons.schedule),
                text: SentenceManager(
                        currentLanguage: AppSettings.selectedLanguage)
                    .sentences
                    .reportsPageDaily,
                iconMargin: const EdgeInsets.only(bottom: 0.0),
              ),
              Tab(
                key: controller.weekly,
                icon: const Icon(Icons.today),
                text: SentenceManager(
                        currentLanguage: AppSettings.selectedLanguage)
                    .sentences
                    .reportsPageWeekly,
                iconMargin: const EdgeInsets.only(bottom: 0.0),
              ),
              Tab(
                key: controller.monthly,
                icon: const Icon(Icons.date_range),
                text: SentenceManager(
                        currentLanguage: AppSettings.selectedLanguage)
                    .sentences
                    .reportsPageMonthly,
                iconMargin: const EdgeInsets.only(bottom: 0.0),
              ),
            ],
          ),
        ),
      ),
      backgroundColor: tColors.primaryBackgroundColor,
      body: Obx(
        () => controller.allData.isEmpty
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Icons.heart_broken,
                    color: tColors.primaryTextColor,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        SentenceManager(
                                currentLanguage: AppSettings.selectedLanguage)
                            .sentences
                            .reportsPageNoTasksFound,
                        style: TextStyle(
                          fontFamily: FontFamily.poppins,
                          fontWeight: TaskWarriorFonts.medium,
                          fontSize: TaskWarriorFonts.fontSizeSmall,
                          color: tColors.primaryTextColor,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        SentenceManager(
                                currentLanguage: AppSettings.selectedLanguage)
                            .sentences
                            .reportsPageAddTasksToSeeReports,
                        style: TextStyle(
                          fontFamily: FontFamily.poppins,
                          fontWeight: TaskWarriorFonts.light,
                          fontSize: TaskWarriorFonts.fontSizeSmall,
                          color: tColors.primaryTextColor,
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
