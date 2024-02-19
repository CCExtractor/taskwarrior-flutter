// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:taskwarrior/config/app_settings.dart';
import 'package:taskwarrior/model/chart.dart';
import 'dart:io';

import 'package:taskwarrior/model/json/task.dart';
import 'package:taskwarrior/model/storage.dart';
import 'package:taskwarrior/model/storage/storage_widget.dart';
import 'package:taskwarrior/utility/utilities.dart';
import 'package:taskwarrior/views/reports/widgets/commonChartIndicator.dart';
import 'package:taskwarrior/widgets/taskdetails/profiles_widget.dart';

class BurnDownMonthlt extends StatefulWidget {
  const BurnDownMonthlt({super.key});

  @override
  State<BurnDownMonthlt> createState() => _BurnDownMonthltState();
}

class _BurnDownMonthltState extends State<BurnDownMonthlt>
    with TickerProviderStateMixin {
  late Storage storage;
  List<Task> taskData = [];
  Map<String, Map<String, int>> monthlyInfo = {};
  Directory? baseDirectory;
  List<Task> allData = [];
  List<Task> completedTasks = [];
  List<Task> pendingTasks = [];
  List<Task> startedTasks = [];

  late TooltipBehavior _weeklyBurndownTooltipBehaviour;
  var storageWidget;

  @override
  void initState() {
    super.initState();

    _weeklyBurndownTooltipBehaviour = TooltipBehavior(
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
                'Month-Year: $monthYear',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
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

    ///initialize the storage widget
    Future.delayed(Duration.zero, () {
      storageWidget = StorageWidget.of(context);
      var currentProfile = ProfilesWidget.of(context).currentProfile;

      Directory baseDirectory = ProfilesWidget.of(context).getBaseDirectory();
      setState(() {
        storage = Storage(
          Directory('${baseDirectory.path}/profiles/$currentProfile'),
        );
      });

      ///fetch all data contains all the tasks
      allData = storage.data.allData();

      ///check if allData is not empty
      if (allData.isNotEmpty) {
        ///sort the data by weekly burn down
        sortBurnDownMonthly();
      }
    });
  }

  void sortBurnDownMonthly() {
    monthlyInfo = {};

    allData.sort((a, b) => a.entry.compareTo(b.entry));

    for (int i = 0; i < allData.length; i++) {
      final DateTime entryDate = allData[i].entry;
      final String monthYear =
          '${Utils.getMonthName(entryDate.month)} ${entryDate.year}';

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
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
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
                  text: 'Month - Year',
                  textStyle: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    color: AppSettings.isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
              ),
              primaryYAxis: NumericAxis(
                title: AxisTitle(
                  text: 'Tasks',
                  textStyle: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    color: AppSettings.isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
              ),
              tooltipBehavior: _weeklyBurndownTooltipBehaviour,
              series: <ChartSeries>[
                StackedColumnSeries<ChartData, String>(
                  groupName: 'Group A',
                  enableTooltip: true,
                  color: Colors.green,
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
                  color: Colors.yellow,
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
          title: 'Monthly Burndown Chart',
        )
      ],
    );
  }
}
