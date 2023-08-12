// ignore_for_file: file_names

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
import 'package:taskwarrior/widgets/taskfunctions/datetime_differences.dart';
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
    storageWidget = StorageWidget.of(context!); // Use Get.context from GetX
    var currentProfile = ProfilesWidget.of(context!).currentProfile;

    baseDirectory = await getApplicationDocumentsDirectory();
    storage =
        Storage(Directory('${baseDirectory!.path}/profiles/$currentProfile'));

    allData.assignAll(storage.data.allData());

    if (allData.isNotEmpty) {
      List<Task> temp = [];
      for (int i = 0; i < allData.length; i++) {
        if (allData[i].status == "pending") {
          if (temp.length < 3) {
            temp.add(allData[i]);
          } else {
            break;
          }
        }
      }

      allData.assignAll(temp);
      //   allData = allData.reversed.toList().obs;
      _sendAndUpdate();
    }
  }

  Future<void> _sendAndUpdate() async {
    await _sendData();
    await _updateWidget();
  }

  Future<void> _sendData() async {
    try {
      for (int i = 0; i < allData.length && i < 3; i++) {
        String subtitle = 'No Task';

        if (allData[i].modified != null) {
          subtitle = 'Last Modified: ${age(allData[i].modified!)}';
        } else if (allData[i].start != null) {
          subtitle = 'Last Modified: ${age(allData[i].start!)}';
        }

        if (allData[i].due != null) {
          subtitle += ' | Due: ${when(allData[i].due!)}';
        } else {
          subtitle += ' | Due: -';
        }

        subtitle = subtitle.replaceAll(RegExp(r' +'), ' ') +
            formatUrgency(urgency(allData[i]));

        await HomeWidget.saveWidgetData<String>('title${i + 1}',
            '${allData[i].id == 0 ? "#" : allData[i].id}. ${allData[i].description}');
        await HomeWidget.saveWidgetData<String>('subtitle${i + 1}', subtitle);
      }

      // If there is no data in allData, set "No Data" for all three slots.
      for (int i = allData.length; i < 3; i++) {
        await HomeWidget.saveWidgetData<String>('title${i + 1}', 'No Task');
        await HomeWidget.saveWidgetData<String>('subtitle${i + 1}', '');
      }
    } catch (exception) {
      debugPrint('Error Sending Data. $exception');
    }
  }

  Future _updateWidget() async {
    try {
      return HomeWidget.updateWidget(
          name: 'HomeWidgetExampleProvider', iOSName: 'HomeWidgetExample');
    } on PlatformException catch (exception) {
      debugPrint('Error Updating Widget. $exception');
    }
  }
}
