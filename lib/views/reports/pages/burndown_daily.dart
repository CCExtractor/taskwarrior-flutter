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

class BurnDownDaily extends StatefulWidget {
  const BurnDownDaily({Key? key}) : super(key: key);

  @override
  State<BurnDownDaily> createState() => _BurnDownDailyState();
}

class _BurnDownDailyState extends State<BurnDownDaily>
    with TickerProviderStateMixin {
  var storageWidget;
  late Storage storage;
  late final Filters filters;
  List<Task> taskData = [];
  List<ChartSeries> dailyBurnDown = [];
  Directory? baseDirectory;
  List<Task> allData = [];
  List<Task> completedTasks = [];
  List<Task> pendingTasks = [];
  List<Task> startedTasks = [];

  @override
  void initState() {
    super.initState();

    ///initialize the _dailyBurndownTooltipBehaviour tooltip behavior
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
          ///sort the data by daily burn down
          sortBurnDownDaily();
        }
      });
    });
  }

  /// dailyInfo is a map that contains the daily burn down data
  /// The key is the date (formatted as "MM-dd") and the value is a map
  /// containing the pending and completed tasks count for that day.
  Map<String, Map<String, int>> dailyInfo = {};

  void sortBurnDownDaily() {
    // Initialize dailyInfo map
    dailyInfo = {};

    // Sort allData by entry date in ascending order
    allData.sort((a, b) => a.entry.compareTo(b.entry));

    /// Loop through allData and get the date
    for (int i = 0; i < allData.length; i++) {
      final String date = Utils.formatDate(allData[i].entry, 'MM-dd');

      /// Check if dailyInfo contains the date
      if (dailyInfo.containsKey(date)) {
        /// Check if the status is pending or completed
        if (allData[i].status == 'pending') {
          /// If the status is pending, then add 1 to the pending count
          dailyInfo[date]!['pending'] = (dailyInfo[date]!['pending'] ?? 0) + 1;
        } else if (allData[i].status == 'completed') {
          /// If the status is completed, then add 1 to the completed count
          dailyInfo[date]!['completed'] =
              (dailyInfo[date]!['completed'] ?? 0) + 1;
        }
      } else {
        /// If dailyInfo does not contain the date
        dailyInfo[date] = {
          'pending': allData[i].status == 'pending' ? 1 : 0,
          'completed': allData[i].status == 'completed' ? 1 : 0,
        };
      }
    }

    debugPrint("dailyInfo $dailyInfo");
  }

  /// This method is used to get the daily burn down data
  late TooltipBehavior _dailyBurndownTooltipBehaviour;
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
                  text: 'Day - Month',
                  textStyle: GoogleFonts.firaMono(
                    fontWeight: FontWeight.bold,
                    color: AppSettings.isDarkMode ? Colors.white : Colors.black,
                    fontSize: 12,
                  ),
                ),
              ),
              primaryYAxis: NumericAxis(
                title: AxisTitle(
                  text: 'Tasks',
                  textStyle: GoogleFonts.firaMono(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    color: AppSettings.isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
              ),
              tooltipBehavior: _dailyBurndownTooltipBehaviour,
              series: <ChartSeries>[
                /// This is the completed tasks
                StackedColumnSeries<ChartData, String>(
                  groupName: 'Group A',
                  enableTooltip: true,
                  color: Appcolors.green,
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

                /// This is the pending tasks
                StackedColumnSeries<ChartData, String>(
                  groupName: 'Group A',
                  color: Appcolors.yellow,
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
