import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:taskwarrior/api_service.dart';
import 'package:taskwarrior/app/models/chart.dart';
import 'package:taskwarrior/app/modules/reports/views/common_chart_indicator.dart';
import 'package:taskwarrior/app/utils/constants/taskwarrior_colors.dart';
import 'package:taskwarrior/app/utils/constants/taskwarrior_fonts.dart';
import 'package:taskwarrior/app/utils/constants/utilites.dart';
import 'package:taskwarrior/app/utils/theme/app_settings.dart';

class BurnDownWeeklyTask extends StatefulWidget {
  const BurnDownWeeklyTask({super.key});

  @override
  State<BurnDownWeeklyTask> createState() => _BurnDownWeeklyTaskState();
}

class _BurnDownWeeklyTaskState extends State<BurnDownWeeklyTask>
    with TickerProviderStateMixin {
  late TaskDatabase taskDatabase;
  late TooltipBehavior _weeklyBurndownTooltipBehaviour;
  Map<int, Map<String, int>> weeklyInfo = {};

  @override
  void initState() {
    super.initState();

    ///initialize the _weeklyBurndownTooltipBehaviour tooltip behavior
    _weeklyBurndownTooltipBehaviour = TooltipBehavior(
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
                'Pending: $pendingCount',
              ),
              Text(
                'Completed: $completedCount',
              ),
            ],
          ),
        );
      },
    );

    taskDatabase = TaskDatabase();

    ///fetch all data from the database
    fetchAllData();
  }

  void fetchAllData() async {
    List<Tasks> allData = await taskDatabase.fetchTasksFromDatabase();
    if (allData.isNotEmpty) {
      sortBurnDownWeekly(allData);
    }
  }

  void sortBurnDownWeekly(List<Tasks> allData) {
    // Initialize weeklyInfo map
    weeklyInfo = {};

    // Sort allData by entry date in ascending order
    allData.sort((a, b) => a.entry.compareTo(b.entry));

    ///loop through allData and get the week number
    for (int i = 0; i < allData.length; i++) {
      final int weekNumber =
          Utils.getWeekNumbertoInt(DateTime.parse(allData[i].entry));

      ///check if weeklyInfo contains the week number
      if (weeklyInfo.containsKey(weekNumber)) {
        ///check if the status is pending or completed
        if (allData[i].status == 'pending') {
          ///if the status is pending then add 1 to the pending count
          weeklyInfo[weekNumber]!['pending'] =
              (weeklyInfo[weekNumber]!['pending'] ?? 0) + 1;
        } else if (allData[i].status == 'completed') {
          ///if the status is completed then add 1 to the completed count
          weeklyInfo[weekNumber]!['completed'] =
              (weeklyInfo[weekNumber]!['completed'] ?? 0) + 1;
        }
      } else {
        ///if weeklyInfo does not contain the week number
        weeklyInfo[weekNumber] = {
          'pending': allData[i].status == 'pending' ? 1 : 0,
          'completed': allData[i].status == 'completed' ? 1 : 0,
        };
      }
    }

    debugPrint("weeklyInfo $weeklyInfo");

    // Update the state to refresh the chart
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height; // Screen height

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
                  text: 'Weeks - Year',
                  textStyle: GoogleFonts.poppins(
                    fontWeight: TaskWarriorFonts.bold,
                    fontSize: TaskWarriorFonts.fontSizeSmall,
                    color: AppSettings.isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
              ),
              primaryYAxis: NumericAxis(
                title: AxisTitle(
                  text: 'Tasks',
                  textStyle: GoogleFonts.poppins(
                    fontWeight: TaskWarriorFonts.bold,
                    color: AppSettings.isDarkMode ? Colors.white : Colors.black,
                    fontSize: TaskWarriorFonts.fontSizeSmall,
                  ),
                ),
              ),
              tooltipBehavior: _weeklyBurndownTooltipBehaviour,
              series: <ChartSeries>[
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
          title: 'Weekly Burndown Chart',
        ),
      ],
    );
  }
}
