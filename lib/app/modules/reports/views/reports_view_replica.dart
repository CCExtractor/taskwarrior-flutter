import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:taskwarrior/app/modules/reports/controllers/reports_controller.dart';
import 'package:taskwarrior/app/modules/reports/views/burn_down_daily_replica.dart';
import 'package:taskwarrior/app/modules/reports/views/burn_down_monthly_replica.dart';
import 'package:taskwarrior/app/modules/reports/views/burn_down_weekly_replica.dart';
import 'package:taskwarrior/app/utils/app_settings/app_settings.dart';
import 'package:taskwarrior/app/utils/constants/taskwarrior_colors.dart';
import 'package:taskwarrior/app/utils/constants/taskwarrior_fonts.dart';
import 'package:taskwarrior/app/utils/language/sentence_manager.dart';
import 'package:taskwarrior/app/utils/themes/theme_extension.dart';
import 'package:taskwarrior/app/v3/champion/models/task_for_replica.dart';
import 'package:taskwarrior/app/v3/champion/replica.dart';

class ReportsHomeReplica extends StatelessWidget {
  // Assuming ReportsController is a singleton/shared controller
  final ReportsController reportsController = Get.put(ReportsController());

  ReportsHomeReplica({super.key});

  // Use the Replica method to fetch tasks
  Future<List<TaskForReplica>> fetchTasks() async {
    return await Replica.getAllTasksFromReplica();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    // You might want to call initReportsTour and showReportsTour only once
    // or manage a separate tour for the Replica section if needed.
    // reportsController.initReportsTour();
    // reportsController.showReportsTour(context);

    return FutureBuilder<List<TaskForReplica>>(
      future: fetchTasks(),
      builder: (context, snapshot) {
        List<TaskForReplica> allTasks = snapshot.data ?? [];
        TaskwarriorColorTheme tColors =
            Theme.of(context).extension<TaskwarriorColorTheme>()!;
        return Scaffold(
          appBar: AppBar(
            backgroundColor: TaskWarriorColors.kprimaryBackgroundColor,
            title: Text(
              // Title adapted for Replica reports
              SentenceManager(currentLanguage: AppSettings.selectedLanguage)
                  .sentences
                  .reportsPageTitle,
              style: GoogleFonts.poppins(color: TaskWarriorColors.white),
            ),
            leading: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(
                Icons.chevron_left,
                color: TaskWarriorColors.white,
              ),
            ),
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(height * 0.1),
              child: TabBar(
                controller: reportsController.tabController,
                labelColor: TaskWarriorColors.white,
                labelStyle: GoogleFonts.poppins(
                  fontWeight: TaskWarriorFonts.medium,
                  fontSize: TaskWarriorFonts.fontSizeSmall,
                ),
                unselectedLabelStyle: GoogleFonts.poppins(
                  fontWeight: TaskWarriorFonts.light,
                ),
                tabs: <Widget>[
                  Tab(
                    key: reportsController.daily,
                    icon: const Icon(Icons.schedule),
                    text: SentenceManager(
                            currentLanguage: AppSettings.selectedLanguage)
                        .sentences
                        .reportsPageDaily,
                    iconMargin: const EdgeInsets.only(bottom: 0.0),
                  ),
                  Tab(
                    key: reportsController.weekly,
                    icon: const Icon(Icons.today),
                    text: SentenceManager(
                            currentLanguage: AppSettings.selectedLanguage)
                        .sentences
                        .reportsPageWeekly,
                    iconMargin: const EdgeInsets.only(bottom: 0.0),
                  ),
                  Tab(
                    key: reportsController.monthly,
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
          body: snapshot.connectionState == ConnectionState.waiting
              ? const Center(child: CircularProgressIndicator())
              : allTasks.isEmpty
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
                                      currentLanguage:
                                          AppSettings.selectedLanguage)
                                  .sentences
                                  .reportsPageNoTasksFound,
                              style: GoogleFonts.poppins(
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
                                      currentLanguage:
                                          AppSettings.selectedLanguage)
                                  .sentences
                                  .reportsPageAddTasksToSeeReports,
                              style: GoogleFonts.poppins(
                                fontWeight: TaskWarriorFonts.light,
                                fontSize: TaskWarriorFonts.fontSizeSmall,
                                color: tColors.primaryTextColor,
                              ),
                            ),
                          ],
                        ),
                      ],
                    )
                  : TabBarView(
                      controller: reportsController.tabController,
                      children: [
                        BurnDownDailyReplica(),
                        BurnDownWeeklyReplica(),
                        BurnDownMonthlyReplica(),
                      ],
                    ),
        );
      },
    );
  }
}
