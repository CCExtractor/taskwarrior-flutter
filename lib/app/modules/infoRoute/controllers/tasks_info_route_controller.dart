import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taskwarrior/app/modules/home/controllers/home_controller.dart';
import 'package:taskwarrior/app/models/json/task.dart';
import 'package:collection/collection.dart';
class TasksInfoRouteController extends GetxController {
  late String uuid;
  var task = Rxn<Task>();
  @override
  void onInit() {
     super.onInit();
    var arguments = Get.arguments;
    // uuid = arguments[1] as String;
    if(arguments is List){
      uuid = arguments[1] as String;
    } else{
      uuid = arguments.uuid;
    } 
    loadTask();
  }
 Future<void> loadTask() async {
  final homeController = Get.find<HomeController>();
  Task? foundTask;
  if (homeController.taskchampion.value) {
      final dbTask = await homeController.taskdb.getTaskByUuid(uuid);

  if (dbTask != null) {
    foundTask =
        homeController.convertTaskForCToTask(dbTask);
  }
  }
  else if (homeController.taskReplica.value) {
    await homeController.refreshReplicaTaskList();
    final replicaTask = homeController.tasksFromReplica
        .firstWhereOrNull((t) => t.uuid == uuid);
    if (replicaTask != null) {
      foundTask =
          homeController.convertReplicaToTask(replicaTask);
    }
  }
  else {
    foundTask = homeController.getTask(uuid);
  }
  task.value = foundTask;
  }
}