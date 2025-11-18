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

class BurnDownMonthlyReplica extends StatelessWidget {
  BurnDownMonthlyReplica({super.key});

  final _monthlyBurndownTooltipBehaviour = TooltipBehavior(
    enable: true,
    builder: (dynamic data, dynamic point, dynamic series, int pointIndex,
        int seriesIndex) {
      final String monthYear = data.x;
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
              '${SentenceManager(currentLanguage: AppSettings.selectedLanguage).sentences.reportsMonthYear}: $monthYear',
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

  Future<Map<String, Map<String, int>>> fetchMonthlyInfo() async {
    // Use the Replica class to fetch tasks
    List<TaskForReplica> tasks = await Replica.getAllTasksFromReplica();
    return sortBurnDownMonthly(tasks);
  }

  Map<String, Map<String, int>> sortBurnDownMonthly(
      List<TaskForReplica> allData) {
    Map<String, Map<String, int>> monthlyInfo = {};

    // Sort allData by modified date in ascending order
    allData.sort((a, b) => (a.modified ?? 0).compareTo(b.modified ?? 0));

    for (int i = 0; i < allData.length; i++) {
      final int? modifiedTimestamp = allData[i].modified;
      if (modifiedTimestamp == null) continue;

      final DateTime modifiedDate = DateTime.fromMillisecondsSinceEpoch(
          modifiedTimestamp * 1000,
          isUtc: true);

      // We use .toLocal() to get the date in the user's timezone for monthly grouping
      final String monthYear =
          '${Utils.getMonthName(modifiedDate.toLocal().month)} ${modifiedDate.toLocal().year}';

      if (monthlyInfo.containsKey(monthYear)) {
        if (allData[i].status == 'pending') {
          monthlyInfo[monthYear]!['pending'] =
              (monthlyInfo[monthYear]!['pending'] ?? 0) + 1;
        } else if (allData[i].status == 'completed') {
          monthlyInfo[monthYear]!['completed'] =
              (monthlyInfo[monthYear]!['completed'] ?? 0) + 1;
        }
      } else {
        monthlyInfo[monthYear] = {
          'pending': allData[i].status == 'pending' ? 1 : 0,
          'completed': allData[i].status == 'completed' ? 1 : 0,
        };
      }
    }

    debugPrint("monthlyInfo: $monthlyInfo");
    return monthlyInfo;
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    TaskwarriorColorTheme tColors =
        Theme.of(context).extension<TaskwarriorColorTheme>()!;
    return FutureBuilder<Map<String, Map<String, int>>>(
      future: fetchMonthlyInfo(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(
              child: Text(
                  '${SentenceManager(currentLanguage: AppSettings.selectedLanguage).sentences.reportsError}: ${snapshot.error}'));
        }

        Map<String, Map<String, int>> monthlyInfo = snapshot.data ?? {};
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
                      text: 'Month - Year (Modified Date)',
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
                        fontSize: TaskWarriorFonts.fontSizeSmall,
                        color: tColors.primaryTextColor,
                      ),
                    ),
                  ),
                  tooltipBehavior: _monthlyBurndownTooltipBehaviour,
                  series: <CartesianSeries>[
                    StackedColumnSeries<ChartData, String>(
                      groupName: 'Group A',
                      enableTooltip: true,
                      color: TaskWarriorColors.green,
                      dataSource: monthlyInfo.entries
                          .map((entry) => ChartData(
                                entry.key,
                                entry.value['pending'] ?? 0,
                                entry.value['completed'] ?? 0,
                              ))
                          .toList(),
                      xValueMapper: (ChartData data, _) => data.x,
                      yValueMapper: (ChartData data, _) => data.y2,
                      name: 'Completed',
                    ),
                    StackedColumnSeries<ChartData, String>(
                      groupName: 'Group A',
                      color: TaskWarriorColors.yellow,
                      enableTooltip: true,
                      dataSource: monthlyInfo.entries
                          .map((entry) => ChartData(
                                entry.key,
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
              title: 'Monthly Burndown Chart (Replica)',
            ),
          ],
        );
      },
    );
  }
}
