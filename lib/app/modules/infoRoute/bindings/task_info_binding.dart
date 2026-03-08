import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:taskwarrior/app/modules/infoRoute/controllers/tasks_info_route_controller.dart';
// import 'package:taskwarrior/app/modules/infoRoute/views/tasks_info_view.dart';

class TasksInfoRouteBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TasksInfoRouteController>(
      () => TasksInfoRouteController(),
    );
  }
}