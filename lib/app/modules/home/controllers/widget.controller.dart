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
  final HomeController storageWidget = Get.find<HomeController>();
  late Storage storage;
  late final Filters filters; // Use RxList for observable list
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
    final HomeController taskController = Get.find<HomeController>();
    int lengthBeforeFilters = allData.length;
    List<Task> tasks = allData;
    debugPrint('Tasks: ${tasks.length}, ${taskController.projectFilter}, ${taskController.pendingFilter.value}, ${taskController.selectedSort.value}');
    if (taskController.projectFilter.value != 'All Projects'&&taskController.projectFilter.toString().isNotEmpty) {
        tasks = tasks.where((task) => task.project == taskController.projectFilter.value).toList();
      } else {
        tasks = List<Task>.from(tasks);
      }

      // Apply other filters and sorting
      tasks.sort((a, b) => a.id!.compareTo(b.id!));

      tasks = tasks.where((task) {
        if (taskController.pendingFilter.value) {
          return task.status == 'pending';
        } else {
          return task.status == 'completed';
        }
      }).toList();

      tasks = tasks.where((task) {
        var tags = task.tags?.toSet() ?? {};
        if (taskController.tagUnion.value) {
          if (taskController.selectedTags.isEmpty) {
            return true;
          }
          return taskController.selectedTags.any((tag) => (tag.startsWith('+'))
              ? tags.contains(tag.substring(1))
              : !tags.contains(tag.substring(1)));
        } else {
          return taskController.selectedTags.every((tag) => (tag.startsWith('+'))
              ? tags.contains(tag.substring(1))
              : !tags.contains(tag.substring(1)));
        }
      }).toList();
      
      // Apply sorting based on selectedSort
      tasks.sort((a, b) {
        switch (taskController.selectedSort.value) {
          case 'Created+':
            return a.entry.compareTo(b.entry);
          case 'Created-':
            return b.entry.compareTo(a.entry);
          case 'Modified+':
            return a.modified!.compareTo(b.modified!);
          case 'Modified-':
            return b.modified!.compareTo(a.modified!);
          case 'Due till+':
            return a.due!.compareTo(b.due!);
          case 'Due till-':
            return b.due!.compareTo(a.due!);
          case 'Priority-':
            return a.priority!.compareTo(b.priority!);
          case 'Priority+':
            return b.priority!.compareTo(a.priority!);
          case 'Project+':
            return a.project!.compareTo(b.project!);
          case 'Project-':
            return b.project!.compareTo(a.project!);
          case 'Urgency-':
            return b.urgency!.compareTo(a.urgency!);
          case 'Urgency+':
            return a.urgency!.compareTo(b.urgency!);
          default:
            return 0;
        }
      });
    List<Map<String, String>> l = [];
    for (var task in tasks) {
        l.add({
          "description": task.description,
          "urgency": 'urgencyLevel : ${urgency(task)}',
          "uuid": task.uuid,
          "priority": task.priority ?? "N"
        });
    }
    if (l.isEmpty&&lengthBeforeFilters>0) {
      l.add({
        "description": "No tasks found because of filter",
        "urgency": "urgencyLevel : 0",
        "priority": "2",
        "uuid": "NO_TASK"
      });
    }else if(l.isEmpty&&lengthBeforeFilters==0){
      l.add({
        "description": "No tasks found",
        "urgency": "urgencyLevel : 0",
        "priority": "1",
        "uuid": "NO_TASK"
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
