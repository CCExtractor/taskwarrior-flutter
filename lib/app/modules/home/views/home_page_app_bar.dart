import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:taskwarrior/app/modules/detailRoute/views/detail_route_view.dart';
import 'package:taskwarrior/app/modules/home/views/add_task_bottom_sheet.dart';

import 'package:taskwarrior/app/modules/home/views/filter_drawer_home_page.dart';
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

class HomePageAppBar extends StatelessWidget implements PreferredSizeWidget {
  final HomeController controller;
  final Server? server;
  final Credentials? credentials;
  const HomePageAppBar({required this.server,required this.credentials,required this.controller, super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: TaskWarriorColors.kprimaryBackgroundColor,
      surfaceTintColor: TaskWarriorColors.kprimaryBackgroundColor,
      title: Text(
        'Home Page',
        style: TextStyle(
            fontFamily: FontFamily.poppins, color: TaskWarriorColors.white),
      ),
      actions: [
        Obx(
          () => IconButton(
            icon: (controller.searchVisible.value)
                ? Tooltip(
                    message: 'Cancel',
                    child: Icon(Icons.cancel, color: TaskWarriorColors.white))
                : Tooltip(
                    message: 'Search',
                    child: Icon(Icons.search, color: TaskWarriorColors.white)),
            onPressed: controller.toggleSearch,
          ),
        ),
        Builder(
          builder: (context) => IconButton(
            icon: Icon(Icons.refresh, color: TaskWarriorColors.white),
            onPressed: () {
              if (server != null || credentials != null) {
                controller.synchronize(context, true);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'TaskServer is not configured',
                      style: TextStyle(
                        color: AppSettings.isDarkMode
                            ? TaskWarriorColors.white
                            : TaskWarriorColors.black,
                      ),
                    ),
                    action: SnackBarAction(
                      label: 'Set Up',
                      onPressed: () {
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (_) =>
                        //         const ManageTaskServerView(),
                        //   ),
                        // ).then((value) {
                        //   // setState(() {});
                        // });
                        Get.toNamed(Routes.MANAGE_TASK_SERVER);
                      },
                      textColor: TaskWarriorColors.purple,
                    ),
                  ),
                );
              }
            },
          ),
        ),
        Builder(
          builder: (context) => IconButton(
            icon: Tooltip(
              message: 'Filters',
              child: Icon(Icons.filter_list, color: TaskWarriorColors.white),
            ),
            onPressed: () => Scaffold.of(context).openEndDrawer(),
          ),
        ),
      ],
      leading: Builder(
        builder: (context) => IconButton(
          icon: Tooltip(
              message: 'Menu',
              child: Icon(Icons.menu, color: TaskWarriorColors.white)),
          onPressed: () => Scaffold.of(context).openDrawer(),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => AppBar().preferredSize;
}
