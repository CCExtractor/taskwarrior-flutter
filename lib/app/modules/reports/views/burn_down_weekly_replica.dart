import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:taskwarrior/app/models/chart.dart';
import 'package:taskwarrior/app/modules/reports/views/common_chart_indicator.dart';
import 'package:taskwarrior/app/utils/app_settings/app_settings.dart';
import 'package:taskwarrior/app/utils/constants/taskwarrior_colors.dart';
import 'package:taskwarrior/app/utils/constants/taskwarrior_fonts.dart';
import 'package:taskwarrior/app/utils/constants/utilites.dart';
import 'package:taskwarrior/app/utils/themes/theme_extension.dart';
import 'package:taskwarrior/app/utils/language/sentence_manager.dart';
import 'package:taskwarrior/app/v3/champion/models/task_for_replica.dart';
import 'package:taskwarrior/app/v3/champion/replica.dart';

class BurnDownWeeklyReplica extends StatelessWidget {
  BurnDownWeeklyReplica({super.key});

  final TooltipBehavior _weeklyBurndownTooltipBehaviour = TooltipBehavior(
    enable: true,
    builder: (dynamic data, dynamic point, dynamic series, int pointIndex,
        int seriesIndex) {
      final String weekNumber = data.x;
      final int pendingCount = data.y1;
      final int completedCount = data.y2;

      return Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              weekNumber,
              style: const TextStyle(
                fontWeight: TaskWarriorFonts.bold,
              ),
            ),
            Text(
              '${SentenceManager(currentLanguage: AppSettings.selectedLanguage).sentences.reportsPending}: $pendingCount',
            ),
            Text(
              '${SentenceManager(currentLanguage: AppSettings.selectedLanguage).sentences.reportsCompleted}: $completedCount',
            ),
          ],
        ),
      );
    },
  );

  Future<Map<String, Map<String, int>>> fetchWeeklyInfo() async {
    // Use the Replica class to fetch tasks
    List<TaskForReplica> tasks = await Replica.getAllTasksFromReplica();
    return sortBurnDownWeekly(tasks);
  }

  Map<String, Map<String, int>> sortBurnDownWeekly(
      List<TaskForReplica> allData) {
    Map<String, Map<String, int>> weeklyInfo = {};

    // Sort allData by modified date in ascending order
    allData.sort((a, b) => (a.modified ?? 0).compareTo(b.modified ?? 0));

    for (int i = 0; i < allData.length; i++) {
      final int? modifiedTimestamp = allData[i].modified;
      if (modifiedTimestamp == null) continue;

      final DateTime modifiedDate = DateTime.fromMillisecondsSinceEpoch(
          modifiedTimestamp * 1000,
          isUtc: true);

      final int weekNumber = Utils.getWeekNumbertoInt(modifiedDate.toLocal());

      if (weeklyInfo.containsKey(weekNumber.toString())) {
        if (allData[i].status == 'pending') {
          weeklyInfo[weekNumber.toString()]!['pending'] =
              (weeklyInfo[weekNumber.toString()]!['pending'] ?? 0) + 1;
        } else if (allData[i].status == 'completed') {
          weeklyInfo[weekNumber.toString()]!['completed'] =
              (weeklyInfo[weekNumber.toString()]!['completed'] ?? 0) + 1;
        }
      } else {
        weeklyInfo[weekNumber.toString()] = {
          'pending': allData[i].status == 'pending' ? 1 : 0,
          'completed': allData[i].status == 'completed' ? 1 : 0,
        };
      }
    }

    debugPrint("weeklyInfo $weeklyInfo");
    return weeklyInfo;
  }

  @override
  Widget build(BuildContext context) {
    TaskwarriorColorTheme tColors =
        Theme.of(context).extension<TaskwarriorColorTheme>()!;
    double height = MediaQuery.of(context).size.height; // Screen height
    return FutureBuilder<Map<String, Map<String, int>>>(
        future: fetchWeeklyInfo(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
                child: Text(
                    '${SentenceManager(currentLanguage: AppSettings.selectedLanguage).sentences.reportsError}: ${snapshot.error}'));
          }

          Map<String, Map<String, int>> weeklyInfo = snapshot.data ?? {};

          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: SizedBox(
                  height: height * 0.6,
                  child: SfCartesianChart(
                    primaryXAxis: CategoryAxis(
                      title: AxisTitle(
                        text: 'Weeks - Year (Modified Date)',
                        textStyle: GoogleFonts.poppins(
                          fontWeight: TaskWarriorFonts.bold,
                          fontSize: TaskWarriorFonts.fontSizeSmall,
                          color: tColors.primaryTextColor,
                        ),
                      ),
                    ),
                    primaryYAxis: NumericAxis(
                      title: AxisTitle(
                        text: 'Tasks',
                        textStyle: GoogleFonts.poppins(
                          fontWeight: TaskWarriorFonts.bold,
                          color: tColors.primaryTextColor,
                          fontSize: TaskWarriorFonts.fontSizeSmall,
                        ),
                      ),
                    ),
                    tooltipBehavior: _weeklyBurndownTooltipBehaviour,
                    series: <CartesianSeries>[
                      ///this is the completed tasks
                      StackedColumnSeries<ChartData, String>(
                        groupName: 'Group A',
                        enableTooltip: true,
                        color: TaskWarriorColors.green,
                        dataSource: weeklyInfo.entries
                            .map((entry) => ChartData(
                                  'Week ${entry.key}',
                                  entry.value['pending'] ?? 0,
                                  entry.value['completed'] ?? 0,
                                ))
                            .toList(),
                        xValueMapper: (ChartData data, _) => data.x,
                        yValueMapper: (ChartData data, _) => data.y2,
                        name: 'Completed',
                      ),

                      ///this is the pending tasks
                      StackedColumnSeries<ChartData, String>(
                        groupName: 'Group A',
                        color: TaskWarriorColors.yellow,
                        enableTooltip: true,
                        dataSource: weeklyInfo.entries
                            .map((entry) => ChartData(
                                  'Week ${entry.key}',
                                  entry.value['pending'] ?? 0,
                                  entry.value['completed'] ?? 0,
                                ))
                            .toList(),
                        xValueMapper: (ChartData data, _) => data.x,
                        yValueMapper: (ChartData data, _) => data.y1,
                        name: 'Pending',
                      ),
                    ],
                  ),
                ),
              ),
              const CommonChartIndicator(
                title: 'Weekly Burndown Chart (Replica)',
              ),
            ],
          );
        });
  }
}
