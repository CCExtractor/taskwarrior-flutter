import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taskwarrior/app/models/json/task.dart';
import 'package:taskwarrior/app/models/storage.dart';
import 'package:taskwarrior/app/modules/splash/controllers/splash_controller.dart';
import 'package:taskwarrior/app/tour/reports_page_tour.dart';
import 'package:taskwarrior/app/utils/constants/taskwarrior_colors.dart';
import 'package:taskwarrior/app/utils/app_settings/app_settings.dart';
import 'package:taskwarrior/app/v3/db/task_database.dart';
import 'package:taskwarrior/app/v3/models/task.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
import 'package:taskwarrior/app/tour/safe_tour.dart';

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
      () async {
        if (await SaveTourStatus.getReportsTourStatus()) {
          debugPrint('User has seen this page');
          return;
        }
        await safeShowTour(
          tutorialCoachMark: tutorialCoachMark,
          context: context,
          targetKeys: [daily, weekly, monthly],
          markSeen: () => SaveTourStatus.saveReportsTourStatus(true),
        );
      },
    );
  }

  @override
  void onInit() {
    super.onInit();

    tabController = TabController(length: 3, vsync: this);

    Future.delayed(Duration.zero, () {
      var currentProfile = Get.find<SplashController>().currentProfile;
      Directory baseDirectory = Get.find<SplashController>().baseDirectory();
      storage =
          Storage(Directory('${baseDirectory.path}/profiles/$currentProfile'));

      allData.value = storage.data.allData();
    });
  }

  // daily report

  // weekly reports

  Future<List<TaskForC>> fetchTasks() async {
    await taskDatabase.open();
    return await taskDatabase.fetchTasksFromDatabase();
  }

  // monthly report

}
