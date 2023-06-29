// ignore_for_file: depend_on_referenced_packages, prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taskwarrior/config/app_settings.dart';
import 'package:taskwarrior/config/taskwarriorcolors.dart';
import 'dart:io';

import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:taskwarrior/model/chart.dart';
import 'package:taskwarrior/model/json/task.dart';
import 'package:taskwarrior/model/storage.dart';
import 'package:taskwarrior/model/storage/storage_widget.dart';
import 'package:taskwarrior/utility/utilities.dart';
import 'package:taskwarrior/views/home/home.dart';
import 'package:taskwarrior/views/reports/widgets/commonChartIndicator.dart';
import 'package:taskwarrior/widgets/taskdetails/profiles_widget.dart';
import 'package:path_provider/path_provider.dart';

class BurnDownWeekly extends StatefulWidget {
  const BurnDownWeekly({Key? key}) : super(key: key);

  @override
  State<BurnDownWeekly> createState() => _BurnDownWeeklyState();
}

class _BurnDownWeeklyState extends State<BurnDownWeekly>
    with TickerProviderStateMixin {
  var storageWidget;
  late Storage storage;
  late final Filters filters;
  List<Task> taskData = [];
  List<ChartSeries> weeklyBurnDown = [];
  Directory? baseDirectory;
  List<Task> allData = [];
  List<Task> completedTasks = [];
  List<Task> pendingTasks = [];
  List<Task> startedTasks = [];
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

      getApplicationDocumentsDirectory().then((directory) {
        setState(() {
          baseDirectory = directory;
          storage = Storage(
            Directory('${baseDirectory!.path}/profiles/$currentProfile'),
          );
        });

        ///fetch all data contains all the tasks
        allData = storage.data.allData();

        ///check if allData is not empty
        if (allData.isNotEmpty) {
          ///sort the data by weekly burn down
          sortBurnDownWeekLy();
        }
      });
    });
  }

  ///weeklyInfo is a map that contains the weekly burn down data
  ///first int holds the week value
  ///the second map holds the pending and completed tasks
  ///the key is the status and the value is the count
  Map<int, Map<String, int>> weeklyInfo = {};

  void sortBurnDownWeekLy() {
    // Initialize weeklyInfo map
    weeklyInfo = {};

    // Sort allData by entry date in ascending order
    allData.sort((a, b) => a.entry.compareTo(b.entry));

    ///loop through allData and get the week number
    for (int i = 0; i < allData.length; i++) {
      final int weekNumber = Utils.getWeekNumbertoInt(allData[i].entry);

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
  }

  ///this method is used to get the weekly burn down data
  late TooltipBehavior _weeklyBurndownTooltipBehaviour;
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height; // Screen height
    // double width = MediaQuery.of(context).size.width; // Screen width
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
                  textStyle: GoogleFonts.firaMono(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    color: AppSettings.isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
              ),
              primaryYAxis: NumericAxis(
                title: AxisTitle(
                  text: 'Tasks',
                  textStyle: GoogleFonts.firaMono(
                    fontWeight: FontWeight.bold,
                    color: AppSettings.isDarkMode ? Colors.white : Colors.black,
                    fontSize: 12,
                  ),
                ),
              ),
              tooltipBehavior: _weeklyBurndownTooltipBehaviour,
              series: <ChartSeries>[
                ///this is the completed tasks
                StackedColumnSeries<ChartData, String>(
                  groupName: 'Group A',
                  enableTooltip: true,
                  color: Appcolors.green,
                  dataSource: allData
                      .map((task) => ChartData(
                            'Week ${Utils.getWeekNumbertoInt(task.entry)}, ${task.entry.year}',
                            weeklyInfo[Utils.getWeekNumbertoInt(task.entry)]
                                    ?['pending'] ??
                                0,
                            weeklyInfo[Utils.getWeekNumbertoInt(task.entry)]
                                    ?['completed'] ??
                                0,
                          ))
                      .toList(),
                  xValueMapper: (ChartData data, _) => data.x,
                  yValueMapper: (ChartData data, _) => data.y2,
                  name: 'Completed',
                ),

                ///this is the pending tasks
                StackedColumnSeries<ChartData, String>(
                  groupName: 'Group A',
                  color: Appcolors.yellow,
                  enableTooltip: true,
                  dataSource: allData
                      .map((task) => ChartData(
                            'Week ${Utils.getWeekNumbertoInt(task.entry)}, ${task.entry.year}',
                            weeklyInfo[Utils.getWeekNumbertoInt(task.entry)]
                                    ?['pending'] ??
                                0,
                            weeklyInfo[Utils.getWeekNumbertoInt(task.entry)]
                                    ?['completed'] ??
                                0,
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
