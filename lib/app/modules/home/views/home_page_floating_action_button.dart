import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:taskwarrior/app/modules/detailRoute/views/detail_route_view.dart';
import 'package:taskwarrior/app/modules/home/views/add_task_bottom_sheet.dart';

import 'package:taskwarrior/app/modules/home/views/filter_drawer_home_page.dart';
import 'package:taskwarrior/app/modules/home/views/home_page_app_bar.dart';
import 'package:taskwarrior/app/modules/home/views/home_page_body.dart';
import 'package:taskwarrior/app/modules/home/views/nav_drawer.dart';
import 'package:taskwarrior/app/modules/home/views/tasks_builder.dart';
import 'package:taskwarrior/app/modules/manageTaskServer/views/manage_task_server_view.dart';
import 'package:taskwarrior/app/routes/app_pages.dart';
import 'package:taskwarrior/app/utils/constants/palette.dart';
import 'package:taskwarrior/app/utils/constants/taskwarrior_colors.dart';
import 'package:taskwarrior/app/utils/gen/fonts.gen.dart';
import 'package:taskwarrior/app/utils/taskserver/taskserver.dart';
import 'package:taskwarrior/app/utils/home_path/home_path.dart' as rc;
import 'package:taskwarrior/app/utils/theme/app_settings.dart';

import '../controllers/home_controller.dart';
import 'package:flutter/material.dart';

class HomePageFloatingActionButton extends StatelessWidget {
  final HomeController controller;
  const HomePageFloatingActionButton({required this.controller,super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
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
        onPressed: () => showDialog(
              context: context,
              builder: (context) => AddTaskBottomSheet(
                homeController: controller,
              ),
            ).then((value) {
              if (controller.isSyncNeeded.value && value != "cancel") {
                controller.isNeededtoSyncOnStart(context);
              }
            })
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
