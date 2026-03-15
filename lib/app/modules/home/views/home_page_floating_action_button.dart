import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:taskwarrior/app/modules/home/views/add_task_bottom_sheet_new.dart';
import 'package:taskwarrior/app/utils/themes/theme_extension.dart';
import 'package:taskwarrior/app/utils/language/sentence_manager.dart';
import '../controllers/home_controller.dart';

class HomePageFloatingActionButton extends StatelessWidget {
  final HomeController controller;
  const HomePageFloatingActionButton({required this.controller, super.key});

  @override
  Widget build(BuildContext context) {
    TaskwarriorColorTheme tColors =
        Theme.of(context).extension<TaskwarriorColorTheme>()!;
    return FloatingActionButton(
        key: controller.addKey,
        heroTag: "btn3",
        backgroundColor: tColors.primaryTextColor,
        child: Tooltip(
          message: SentenceManager(
                  currentLanguage: controller.selectedLanguage.value)
              .sentences
              .homePageAddTaskTooltip,
          child: Icon(
            Icons.add,
            color: tColors.secondaryBackgroundColor,
          ),
        ),
        onPressed: () {
          Get.bottomSheet(
            AddTaskBottomSheet(
              homeController: controller,
              forTaskC: controller.taskchampion.value,
              forReplica: controller.taskReplica.value,
            ),
            backgroundColor: tColors.dialogBackgroundColor,
            isScrollControlled: true,
            ignoreSafeArea: true,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(0),
                topRight: Radius.circular(0),
              ),
            ),
          ).then((value) {
            if (controller.isSyncNeeded.value && value != "cancel") {
              controller.isNeededtoSyncOnStart(context);
            }
          });
        },        // .then((value) {
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

