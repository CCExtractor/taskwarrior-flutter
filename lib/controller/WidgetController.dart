// ignore_for_file: file_names

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart'; // Import the GetX package
import 'package:home_widget/home_widget.dart';
// ignore: depend_on_referenced_packages
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:taskwarrior/views/home/home.dart';
import 'package:taskwarrior/widgets/taskdetails/profiles_widget.dart';
import 'package:taskwarrior/model/storage/storage_widget.dart';
import 'package:taskwarrior/model/json/task.dart';
import 'package:taskwarrior/model/storage.dart';
// import 'package:taskwarrior/widgets/taskfunctions/datetime_differences.dart';
import 'package:taskwarrior/widgets/taskfunctions/urgency.dart';

class WidgetController extends GetxController {
  final BuildContext? context;
  WidgetController(this.context);
  late InheritedStorage storageWidget;

  late Storage storage;
  late final Filters filters;
  RxList<Task> taskData = <Task>[].obs; // Use RxList for observable list
  List<ChartSeries> dailyBurnDown = [];
  Directory? baseDirectory;
  RxList<Task> allData = <Task>[].obs; // Use RxList for observable list
  bool stopTraver = false;

  void fetchAllData() async {
    if (Platform.isAndroid || Platform.isIOS) {
      storageWidget = StorageWidget.of(context!); // Use Get.context from GetX
      var currentProfile = ProfilesWidget.of(context!).currentProfile;

      baseDirectory = await getApplicationDocumentsDirectory();
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
    int i=1;
    List<Map<String, String>> l = [];
    for (var task in allData) {
      l.add({
        "description": "$i.${task.description}",
        "urgency": 'urgencyLevel : ${urgency(task)}',
      });
      i++;
    }
    await HomeWidget.saveWidgetData(
        'tasks', jsonEncode(l));
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
