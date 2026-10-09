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
import 'package:taskwarrior/app/models/task_like.dart' show parseTaskDate;
import 'package:taskwarrior/app/modules/home/controllers/home_controller.dart';
import 'package:taskwarrior/app/modules/splash/controllers/splash_controller.dart';
import 'package:taskwarrior/app/utils/taskfunctions/urgency.dart';
// import 'package:taskwarrior/widgets/taskfunctions/datetime_differences.dart';

/// Fully qualified home-screen widget provider class.
///
/// home_widget otherwise prefixes the provider name with the application id,
/// which is `com.ccextractor.taskwarriorflutter.nightly` for the nightly
/// flavor, while the Kotlin class always lives in the base package; the
/// lookup then fails with ClassNotFoundException.
const String kAndroidWidgetProvider =
    'com.ccextractor.taskwarriorflutter.TaskWarriorWidgetProvider';

class WidgetController extends GetxController {
  final HomeController storageWidget = Get.find<HomeController>();
  late Storage storage;
  late final Filters filters; // Use RxList for observable list
  List<CartesianSeries> dailyBurnDown = [];
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

  /// Orders priorities the way they should appear in the widget: High, then
  /// Medium, Low, and finally tasks with no priority.
  int _priorityRank(String? priority) {
    switch (priority) {
      case 'H':
        return 0;
      case 'M':
        return 1;
      case 'L':
        return 2;
      default:
        return 3;
    }
  }

  /// One widget row. `status` is the field the in-widget
  /// pending/completed/deleted/recurring toggle filters on. `due` is stored as
  /// an ISO-8601 UTC string (or null) so the widget payload is self-describing
  /// and stays in the same due-first order everywhere it is rendered.
  Map<String, dynamic> _widgetTask({
    required String description,
    required String? uuid,
    required String? priority,
    required String? status,
    required num urgency,
    DateTime? due,
  }) {
    return {
      "description": description,
      "urgency": 'urgencyLevel : ${urgency.toStringAsFixed(1)}',
      "uuid": uuid,
      "priority": priority ?? "N",
      "status": status ?? "pending",
      "due": due?.toUtc().toIso8601String(),
    };
  }

  /// Every task across every status, due soonest first, then by priority.
  ///
  /// The widget filters by status itself, so the app's current
  /// pending/completed/deleted/recurring selection is deliberately NOT applied
  /// here — otherwise the toggle would have nothing to switch to. Project, tag
  /// and sort filters are likewise skipped: the widget is meant to show all
  /// tasks. Ships deleted tasks too, which the old payload dropped entirely.
  List<Map<String, dynamic>> getWidgetTasks(HomeController taskController) {
    final List<Map<String, dynamic>> l = [];

    if (taskController.taskchampion.value) {
      for (final task in taskController.tasks) {
        l.add(_widgetTask(
          description: task.description,
          uuid: task.uuid,
          priority: task.priority,
          status: task.status,
          urgency: task.urgency ?? 0,
          due: parseTaskDate(task.due),
        ));
      }
    } else if (taskController.taskReplica.value) {
      for (final task in taskController.tasksFromReplica) {
        l.add(_widgetTask(
          description: task.description ?? '',
          uuid: task.uuid,
          priority: task.priority,
          status: task.status,
          urgency: 0,
          due: parseTaskDate(task.due),
        ));
      }
    } else {
      for (final task in allData) {
        l.add(_widgetTask(
          description: task.description,
          uuid: task.uuid,
          priority: task.priority,
          status: task.status,
          urgency: urgency(task),
          due: task.due,
        ));
      }
    }

    l.sort((a, b) {
      final DateTime? da = DateTime.tryParse((a['due'] as String?) ?? '')?.toUtc();
      final DateTime? db = DateTime.tryParse((b['due'] as String?) ?? '')?.toUtc();

      // Tasks with a due date come first, soonest first (overdue included at the
      // very top); tasks without one sink below all dated tasks.
      if (da != null && db != null) {
        final int byDue = da.compareTo(db);
        if (byDue != 0) return byDue;
      } else if (da != null) {
        return -1;
      } else if (db != null) {
        return 1;
      }

      final int byPriority = _priorityRank(a['priority'] as String?)
          .compareTo(_priorityRank(b['priority'] as String?));
      if (byPriority != 0) return byPriority;
      return (a['description'] as String)
          .toLowerCase()
          .compareTo((b['description'] as String).toLowerCase());
    });
    return l;
  }

  Future<void> sendData() async {
    final HomeController taskController = Get.find<HomeController>();
    final List<Map<String, dynamic>> l = getWidgetTasks(taskController);
    debugPrint('Widget payload: ${l.length} tasks across all statuses');
    await HomeWidget.saveWidgetData("tasks", jsonEncode(l));
  }

  Future updateWidget() async {
    try {
      // Awaited so a failure is caught here instead of surfacing as an
      // unhandled exception.
      return await HomeWidget.updateWidget(
          qualifiedAndroidName: kAndroidWidgetProvider,
          iOSName: 'TaskWarriorWidgets');
    } on PlatformException catch (exception) {
      debugPrint('Error Updating Widget. $exception');
    }
  }
}
