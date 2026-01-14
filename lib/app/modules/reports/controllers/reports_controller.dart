import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:taskwarrior/app/models/json/task.dart';
import 'package:taskwarrior/app/models/storage.dart';
import 'package:taskwarrior/app/modules/home/controllers/home_controller.dart';
import 'package:taskwarrior/app/modules/splash/controllers/splash_controller.dart';
import 'package:taskwarrior/app/tour/reports_page_tour.dart';
import 'package:taskwarrior/app/utils/constants/taskwarrior_colors.dart';
import 'package:taskwarrior/app/utils/constants/taskwarrior_fonts.dart';
import 'package:taskwarrior/app/utils/constants/utilites.dart';
import 'package:taskwarrior/app/utils/gen/fonts.gen.dart';
import 'package:taskwarrior/app/utils/app_settings/app_settings.dart';
import 'package:taskwarrior/app/v3/db/task_database.dart';
import 'package:taskwarrior/app/v3/models/task.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

class ReportsController extends GetxController
    with GetTickerProviderStateMixin {
  late TabController tabController;
  final GlobalKey daily = GlobalKey();
  final GlobalKey weekly = GlobalKey();
  final GlobalKey monthly = GlobalKey();
  late TaskDatabase taskDatabase;
  var isSaved = false.obs;
  late TutorialCoachMark tutorialCoachMark;

  var selectedIndex = 0.obs;
  var allData = <Task>[].obs;
  late Storage storage;
  var storageWidget;

  // void _initReportsTour() {
  //   tutorialCoachMark = TutorialCoachMark(
  //     targets: reportsDrawer(
  //       daily: daily,
  //       weekly: weekly,
  //       monthly: monthly,
  //     ),
  //     colorShadow: TaskWarriorColors.black,
  //     paddingFocus: 10,
  //     opacityShadow: 0.8,
  //     hideSkip: true,
  //     onFinish: () {
  //       SaveReportsTour().saveReportsTourStatus();
  //     },
  //   );
  // }

  // void showReportsTour() {
  //   Future.delayed(
  //     const Duration(seconds: 2),
  //     () {
  //       SaveReportsTour().getReportsTourStatus().then((value) => {
  //             if (value == false)
  //               {
  //                 tutorialCoachMark.show(context: Get.context!),
  //               }
  //             else
  //               {
  //                 // ignore: avoid_print
  //                 print('User has seen this page'),
  //               }
  //           });
  //     },
  //   );
  // }

  void initReportsTour() {
    tutorialCoachMark = TutorialCoachMark(
      targets: reportsDrawer(
        daily: daily,
        weekly: weekly,
        monthly: monthly,
      ),
      colorShadow: TaskWarriorColors.black,
      paddingFocus: 10,
      opacityShadow: 0.8,
      hideSkip: true,
      onFinish: () {
        SaveTourStatus.saveReportsTourStatus(true);
      },
    );
  }

  void showReportsTour(BuildContext context) {
    Future.delayed(
      const Duration(milliseconds: 500),
      () {
        SaveTourStatus.getReportsTourStatus().then((value) => {
              if (value == false)
                {
                  tutorialCoachMark.show(context: context),
                }
              else
                {
                  // ignore: avoid_print
                  print('User has seen this page'),
                }
            });
      },
    );
  }

  @override
  void onInit() {
    super.onInit();
    initDailyReports();
    initWeeklyReports();
    initMonthlyReports();

    tabController = TabController(length: 3, vsync: this);

    Future.delayed(Duration.zero, () {
      var currentProfile = Get.find<SplashController>().currentProfile;
      Directory baseDirectory = Get.find<SplashController>().baseDirectory();
      storage =
          Storage(Directory('${baseDirectory.path}/profiles/$currentProfile'));

      allData.value = storage.data.allData();
    });
  }

  /// This method is used to get the daily burn down data
  late TooltipBehavior dailyBurndownTooltipBehaviour;

  ///this method is used to get the weekly burn down data
  late TooltipBehavior weeklyBurndownTooltipBehaviour;

  // daily report

  void initDailyReports() {
    ///initialize the _dailyBurndownTooltipBehaviour tooltip behavior
    dailyBurndownTooltipBehaviour = TooltipBehavior(
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
                // style: GoogleFonts.poppins(
                //   fontWeight: TaskWarriorFonts.bold,
                // ),

                style: const TextStyle(
                    fontFamily: FontFamily.poppins,
                    fontWeight: TaskWarriorFonts.bold,
                    color: Colors.black),
              ),
              Text(
                'Pending: $pendingCount',
                style: const TextStyle(
                    fontWeight: TaskWarriorFonts.bold, color: Colors.black),
              ),
              Text(
                'Completed: $completedCount',
                style: const TextStyle(
                    fontWeight: TaskWarriorFonts.bold, color: Colors.black),
              ),
            ],
          ),
        );
      },
    );

    ///initialize the storage widget
    Future.delayed(Duration.zero, () {
      storageWidget = Get.find<HomeController>();
      var currentProfile = Get.find<SplashController>().currentProfile;

      Directory baseDirectory = Get.find<SplashController>().baseDirectory();
      storage = Storage(
        Directory('${baseDirectory.path}/profiles/$currentProfile'),
      );

      ///fetch all data contains all the tasks
      allData.value = storage.data.allData();

      ///check if allData is not empty
      if (allData.isNotEmpty) {
        ///sort the data by daily burn down
        sortBurnDownDaily();
      }
    });
  }

  /// dailyInfo is a map that contains the daily burn down data
  /// The key is the date (formatted as "MM-dd") and the value is a map
  /// containing the pending and completed tasks count for that day.
  RxMap<String, Map<String, int>> dailyInfo = <String, Map<String, int>>{}.obs;

  void sortBurnDownDaily() {
    // Initialize dailyInfo map
    dailyInfo.value = {};

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

  // weekly reports

  ///weeklyInfo is a map that contains the weekly burn down data
  ///first int holds the week value
  ///the second map holds the pending and completed tasks
  ///the key is the status and the value is the count
  RxMap<int, Map<String, int>> weeklyInfo = <int, Map<String, int>>{}.obs;

  void sortBurnDownWeekLy() {
    // Initialize weeklyInfo map
    weeklyInfo.value = {};

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

  void initWeeklyReports() {
    ///initialize the _weeklyBurndownTooltipBehaviour tooltip behavior
    weeklyBurndownTooltipBehaviour = TooltipBehavior(
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
                    fontWeight: TaskWarriorFonts.bold, color: Colors.black),
              ),
              Text(
                'Pending: $pendingCount',
                style: const TextStyle(
                    fontWeight: TaskWarriorFonts.bold, color: Colors.black),
              ),
              Text(
                'Completed: $completedCount',
                style: const TextStyle(
                    fontWeight: TaskWarriorFonts.bold, color: Colors.black),
              ),
            ],
          ),
        );
      },
    );

    ///initialize the storage widget
    Future.delayed(Duration.zero, () {
      storageWidget = Get.find<HomeController>();
      var currentProfile = Get.find<SplashController>().currentProfile;

      Directory baseDirectory = Get.find<SplashController>().baseDirectory();
      storage = Storage(
        Directory('${baseDirectory.path}/profiles/$currentProfile'),
      );

      ///fetch all data contains all the tasks
      allData.value = storage.data.allData();

      ///check if allData is not empty
      if (allData.isNotEmpty) {
        ///sort the data by weekly burn down
        sortBurnDownWeekLy();
      }
    });
  }

  Future<List<TaskForC>> fetchTasks() async {
    await taskDatabase.open();
    return await taskDatabase.fetchTasksFromDatabase();
  }

  // monthly report
  late TooltipBehavior monthlyBurndownTooltipBehaviour;
  RxMap<String, Map<String, int>> monthlyInfo =
      <String, Map<String, int>>{}.obs;

  void sortBurnDownMonthly() {
    monthlyInfo.value = {};

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

  void initMonthlyReports() {
    monthlyBurndownTooltipBehaviour = TooltipBehavior(
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
                    fontFamily: FontFamily.poppins,
                    fontWeight: TaskWarriorFonts.bold,
                    color: Colors.black),
              ),
              Text(
                'Pending: $pendingCount',
                style: const TextStyle(
                    fontFamily: FontFamily.poppins,
                    fontWeight: TaskWarriorFonts.bold,
                    color: Colors.black),
              ),
              Text(
                'Completed: $completedCount',
                style: const TextStyle(
                    fontFamily: FontFamily.poppins,
                    fontWeight: TaskWarriorFonts.bold,
                    color: Colors.black),
              ),
            ],
          ),
        );
      },
    );

    ///initialize the storage widget
    Future.delayed(Duration.zero, () {
      storageWidget = Get.find<HomeController>();
      var currentProfile = Get.find<SplashController>().currentProfile;

      Directory baseDirectory = Get.find<SplashController>().baseDirectory();
      storage = Storage(
        Directory('${baseDirectory.path}/profiles/$currentProfile'),
      );

      ///fetch all data contains all the tasks
      allData.value = storage.data.allData();

      ///check if allData is not empty
      if (allData.isNotEmpty) {
        ///sort the data by weekly burn down
        sortBurnDownMonthly();
      }
    });
  }
}
