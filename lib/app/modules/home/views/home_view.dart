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

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});
  @override
  Widget build(BuildContext context) {
    bool isHomeWidgetTaskTapped = false;
    Server? server;
    Credentials? credentials;

    var contents = rc.Taskrc(controller.storage.home.home).readTaskrc();
    if (contents != null) {
      server = Taskrc.fromString(contents).server;
      credentials = Taskrc.fromString(contents).credentials;
    }

    if (contents != null) {
      server = Taskrc.fromString(contents).server;
      credentials = Taskrc.fromString(contents).credentials;
    }

    controller.checkForSync(context);

    var taskData = controller.searchedTasks;

    var pendingFilter = controller.pendingFilter;
    var waitingFilter = controller.waitingFilter;
    var pendingTags = controller.pendingTags;

    return isHomeWidgetTaskTapped == false
        ? Scaffold(
            appBar: AppBar(
              backgroundColor: TaskWarriorColors.kprimaryBackgroundColor,
              surfaceTintColor: TaskWarriorColors.kprimaryBackgroundColor,
              title: Text(
                'Home Page',
                style: TextStyle(
                    fontFamily: FontFamily.poppins,
                    color: TaskWarriorColors.white),
              ),
              actions: [
                Obx(
                  () => IconButton(
                    icon: (controller.searchVisible.value)
                        ? Tooltip(
                            message: 'Cancel',
                            child: Icon(Icons.cancel,
                                color: TaskWarriorColors.white))
                        : Tooltip(
                            message: 'Search',
                            child: Icon(Icons.search,
                                color: TaskWarriorColors.white)),
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
                      child: Icon(Icons.filter_list,
                          color: TaskWarriorColors.white),
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
            ),
            // drawer: Obx(
            //   () => NavDrawer(controller: controller, notifyParent: refresh),
            // ),
            drawer: NavDrawer(homeController: controller),
            body: DoubleBackToCloseApp(
              snackBar: const SnackBar(content: Text('Tap back again to exit')),
              // ignore: avoid_unnecessary_containers
              child: Container(
                color: AppSettings.isDarkMode
                    ? Palette.kToDark.shade200
                    : TaskWarriorColors.white,
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                  child: Obx(
                    () => Column(
                      children: <Widget>[
                        if (controller.searchVisible.value)
                          Container(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10),
                            child: SearchBar(
                              backgroundColor: WidgetStateProperty.all<Color>(
                                  (TaskWarriorColors
                                      .kLightPrimaryBackgroundColor)),
                              surfaceTintColor: WidgetStateProperty.all<Color>(
                                  (TaskWarriorColors
                                      .kLightPrimaryBackgroundColor)),
                              controller: controller.searchController,
                              // shape:,
                              onChanged: (value) {
                                controller.search(value);
                              },

                              shape: WidgetStateProperty.resolveWith<
                                  OutlinedBorder?>(
                                (Set<WidgetState> states) {
                                  if (states.contains(WidgetState.focused)) {
                                    return RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12.0),
                                      side: BorderSide(
                                        color: TaskWarriorColors.black,
                                        width: 2.0,
                                      ),
                                    );
                                  } else {
                                    return RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12.0),
                                      side: BorderSide(
                                        color: TaskWarriorColors.black,
                                        width: 1.5,
                                      ),
                                    );
                                  }
                                },
                              ),
                              leading: const Icon(Icons.search_rounded),
                              trailing: <Widget>[
                                (controller.searchController.text.isNotEmpty)
                                    ? IconButton(
                                        key: GlobalKey(),
                                        icon: Icon(Icons.cancel,
                                            color: TaskWarriorColors.black),
                                        onPressed: () {
                                          controller.searchController.clear();
                                          controller.search(
                                              controller.searchController.text);
                                        },
                                      )
                                    : const SizedBox(
                                        width: 0,
                                        height: 0,
                                      )
                              ],

                              hintText: 'Search',
                            ),
                          ),
                        Expanded(
                          child: Scrollbar(
                            child: Obx(
                              () => TasksBuilder(
                                  // darkmode: AppSettings.isDarkMode,
                                  useDelayTask: controller.useDelayTask.value,
                                  taskData: taskData,
                                  pendingFilter: pendingFilter.value,
                                  waitingFilter: waitingFilter.value,
                                  searchVisible:
                                      controller.searchVisible.value),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            endDrawer: Obx(
              () => FilterDrawer(
                filters: controller.getFilters(),
                homeController: controller,
              ),
            ),
            floatingActionButton: FloatingActionButton(
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
                ),
            resizeToAvoidBottomInset: false,
          )
        : const DetailRouteView();
  }
}
