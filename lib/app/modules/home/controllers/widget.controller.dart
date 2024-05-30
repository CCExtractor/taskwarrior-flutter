// ignore_for_file: file_names

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:home_widget/home_widget.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:taskwarrior/app/models/filters.dart';
import 'package:taskwarrior/app/models/json/task.dart';
import 'package:taskwarrior/app/models/storage.dart';
import 'package:taskwarrior/app/modules/home/controllers/home_controller.dart';
import 'package:taskwarrior/app/modules/splash/controllers/splash_controller.dart';
import 'package:taskwarrior/app/utils/taskfunctions/urgency.dart';
// import 'package:taskwarrior/widgets/taskfunctions/datetime_differences.dart';

class WidgetController extends GetxController {
  final BuildContext? context;
  WidgetController(this.context);
  final HomeController storageWidget = Get.find<HomeController>();
  late Storage storage;
  late final Filters filters;
  RxList<Task> taskData = <Task>[].obs; // Use RxList for observable list
  List<ChartSeries> dailyBurnDown = [];
  Directory? baseDirectory;
  RxList<Task> allData = <Task>[].obs; // Use RxList for observable list
  bool stopTraver = false;

  void fetchAllData() async {
    if (Platform.isAndroid || Platform.isIOS) {
      // storageWidget = StorageWidget.of(context!); // Use Get.context from GetX
      // var currentProfile = ProfilesWidget.of(context!).currentProfile;
      var currentProfile = Get.find<SplashController>().currentProfile.value;

      baseDirectory = Get.find<SplashController>().baseDirectory();
       storage =
          Storage(Directory('${baseDirectory!.path}/profiles/$currentProfile'));
      allData.assignAll(storage.data.allData());
      sendAndUpdate();
    }
  }

  Future<void> sendAndUpdate() async {
    await sendData();
    await updateWidget();
  }

  Future<void> sendData() async {
    int i = 1;
    List<Map<String, String>> l = [];
    for (var task in allData) {
      if (task.status == "pending") {
        l.add({
          "description": "$i.${task.description}",
          "urgency": 'urgencyLevel : ${urgency(task)}',
          "uuid": task.uuid
        });
        i++;
      }
    }
    if (l.isEmpty) {
      l.add({
        "description": "No tasks added yet.",
        "urgency": "urgencyLevel : 0",
        "uuid": ""
      });
    }
    await HomeWidget.saveWidgetData("tasks", jsonEncode(l));
  }

  Future updateWidget() async {
    try {
      return HomeWidget.updateWidget(
          name: 'TaskWarriorWidgetProvider', iOSName: 'HomeWidgetExample');
    } on PlatformException catch (exception) {
      debugPrint('Error Updating Widget. $exception');
    }
  }
}
