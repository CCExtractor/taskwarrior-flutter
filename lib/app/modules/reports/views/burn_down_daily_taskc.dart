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

class BurnDownDailyTaskc extends StatefulWidget {
  const BurnDownDailyTaskc({super.key});

  @override
  State<BurnDownDailyTaskc> createState() => _BurnDownDailyTaskcState();
}

class _BurnDownDailyTaskcState extends State<BurnDownDailyTaskc>
    with TickerProviderStateMixin {
  late TaskDatabase taskDatabase;
  late TooltipBehavior _dailyBurndownTooltipBehaviour;
  Map<String, Map<String, int>> dailyInfo = {};

  @override
  void initState() {
    super.initState();

    // Initialize the tooltip behavior for the chart
    _dailyBurndownTooltipBehaviour = TooltipBehavior(
      enable: true,
      builder: (dynamic data, dynamic point, dynamic series, int pointIndex,
          int seriesIndex) {
        final String date = data.x;
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
                'Date: $date',
                style: GoogleFonts.poppins(
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

    // Initialize the database and fetch data
    taskDatabase = TaskDatabase();
    taskDatabase.open().then((_) {
      taskDatabase.fetchTasksFromDatabase().then((tasks) {
        setState(() {
          // Process the data and update the chart
          _processData(tasks);
        });
      });
    });
  }

  void _processData(List<Tasks> tasks) {
    dailyInfo = {};

    // Sort tasks by entry date in ascending order
    tasks.sort((a, b) => a.entry.compareTo(b.entry));

    for (var task in tasks) {
      final String date = Utils.formatDate(DateTime.parse(task.entry), 'MM-dd');

      if (dailyInfo.containsKey(date)) {
        if (task.status == 'pending') {
          dailyInfo[date]!['pending'] = (dailyInfo[date]!['pending'] ?? 0) + 1;
        } else if (task.status == 'completed') {
          dailyInfo[date]!['completed'] =
              (dailyInfo[date]!['completed'] ?? 0) + 1;
        }
      } else {
        dailyInfo[date] = {
          'pending': task.status == 'pending' ? 1 : 0,
          'completed': task.status == 'completed' ? 1 : 0,
        };
      }
    }
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
                  text: 'Day - Month',
                  textStyle: GoogleFonts.poppins(
                    fontWeight: TaskWarriorFonts.bold,
                    color: AppSettings.isDarkMode ? Colors.white : Colors.black,
                    fontSize: TaskWarriorFonts.fontSizeSmall,
                  ),
                ),
              ),
              primaryYAxis: NumericAxis(
                title: AxisTitle(
                  text: 'Tasks',
                  textStyle: GoogleFonts.poppins(
                    fontWeight: TaskWarriorFonts.bold,
                    fontSize: TaskWarriorFonts.fontSizeSmall,
                    color: AppSettings.isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
              ),
              tooltipBehavior: _dailyBurndownTooltipBehaviour,
              series: <ChartSeries>[
                StackedColumnSeries<ChartData, String>(
                  groupName: 'Group A',
                  enableTooltip: true,
                  color: TaskWarriorColors.green,
                  dataSource: dailyInfo.entries
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
                  dataSource: dailyInfo.entries
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
          title: 'Daily Burndown Chart',
        ),
      ],
    );
  }
}
