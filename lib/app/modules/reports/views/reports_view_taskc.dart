import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:taskwarrior/app/modules/reports/controllers/reports_controller.dart';
import 'package:taskwarrior/app/modules/reports/views/burn_down_daily_taskc.dart';
import 'package:taskwarrior/app/modules/reports/views/burn_down_monthly_taskc.dart';
import 'package:taskwarrior/app/modules/reports/views/burn_down_weekly_taskc.dart';
import 'package:taskwarrior/app/utils/app_settings/app_settings.dart';
import 'package:taskwarrior/app/utils/constants/taskwarrior_colors.dart';
import 'package:taskwarrior/app/utils/constants/taskwarrior_fonts.dart';
import 'package:taskwarrior/api_service.dart';
import 'package:taskwarrior/app/utils/language/sentence_manager.dart';
import 'package:taskwarrior/app/utils/themes/theme_extension.dart';

class ReportsHomeTaskc extends StatelessWidget {
  final ReportsController reportsController = Get.put(ReportsController());
  final TaskDatabase taskDatabase = TaskDatabase();

  ReportsHomeTaskc({super.key});

  Future<List<Tasks>> fetchTasks() async {
    await taskDatabase.open();
    return await taskDatabase.fetchTasksFromDatabase();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    reportsController.initReportsTour();
    reportsController.showReportsTour(context);
    return FutureBuilder<List<Tasks>>(
      future: fetchTasks(),
      builder: (context, snapshot) {
        List<Tasks> allTasks = snapshot.data ?? [];
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
                onTap: (value) {
                  reportsController.selectedIndex.value = value;
                },
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
                  : Obx(
                      () => IndexedStack(
                        index: reportsController.selectedIndex.value,
                        children: [
                          BurnDownDailyTaskc(),
                          BurnDownWeeklyTask(),
                          BurnDownMonthlyTaskc(),
                        ],
                      ),
                    ),
        );
      },
    );
  }
}
