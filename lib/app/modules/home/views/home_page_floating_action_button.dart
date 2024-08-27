import 'package:flutter/material.dart';

import 'package:taskwarrior/app/modules/home/views/add_task_bottom_sheet.dart';
import 'package:taskwarrior/app/modules/home/views/add_task_to_taskc_bottom_sheet.dart';

import 'package:taskwarrior/app/utils/constants/taskwarrior_colors.dart';
import 'package:taskwarrior/app/utils/theme/app_settings.dart';

import '../controllers/home_controller.dart';

class HomePageFloatingActionButton extends StatelessWidget {
  final HomeController controller;
  const HomePageFloatingActionButton({required this.controller, super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
        key: controller.addKey,
        heroTag: "btn3",
        backgroundColor: AppSettings.isDarkMode
            ? TaskWarriorColors.kLightPrimaryBackgroundColor
            : TaskWarriorColors.kprimaryBackgroundColor,
        child: Tooltip(
          message: 'Add Task',
          child: Icon(
            Icons.add,
            color: AppSettings.isDarkMode
                ? TaskWarriorColors.kprimaryBackgroundColor
                : TaskWarriorColors.white,
          ),
        ),
        onPressed: () => (controller.taskchampion.value)
            ? (showDialog(
                context: context,
                builder: (context) => AddTaskToTaskcBottomSheet(
                  homeController: controller,
                ),
              ).then((value) {
                if (controller.isSyncNeeded.value && value != "cancel") {
                  controller.isNeededtoSyncOnStart(context);
                }
              }))
            : (showDialog(
                context: context,
                builder: (context) => AddTaskBottomSheet(
                  homeController: controller,
                ),
              ).then((value) {
                if (controller.isSyncNeeded.value && value != "cancel") {
                  controller.isNeededtoSyncOnStart(context);
                }
              }))
        // .then((value) {
        //   // print(value);

        //   //if auto sync is turned on
        //   if (isSyncNeeded) {
        //     //if user have not created any event then
        //     //we won't call sync method
        //     if (value == "cancel") {
        //     } else {
        //       //else we can sync new tasks
        //       isNeededtoSyncOnStart();
        //     }
        //   }
        // }),
        );
  }
}
