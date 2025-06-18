import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taskwarrior/app/modules/home/views/show_tasks.dart';
import 'package:taskwarrior/app/modules/home/views/tasks_builder.dart';
import 'package:taskwarrior/app/utils/constants/taskwarrior_colors.dart';
import 'package:taskwarrior/app/utils/themes/theme_extension.dart';
import '../controllers/home_controller.dart';

class HomePageBody extends StatelessWidget {
  final HomeController controller;
  const HomePageBody({required this.controller, super.key});

  @override
  Widget build(BuildContext context) {
    controller.initInAppTour();
    controller.showInAppTour(context);
    TaskwarriorColorTheme tColors = Theme.of(context).extension<TaskwarriorColorTheme>()!;
    return DoubleBackToCloseApp(
      snackBar: const SnackBar(content: Text('Tap back again to exit')),
      child: Container(
        color: tColors.dialogBackgroundColor,
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
                          (tColors.primaryBackgroundColor!)),
                      surfaceTintColor: WidgetStateProperty.all<Color>(
                          (tColors.primaryBackgroundColor!)),
                      controller: controller.searchController,
                      // shape:,
                      onChanged: (value) {
                        controller.search(value);
                      },

                      shape: WidgetStateProperty.resolveWith<OutlinedBorder?>(
                        (Set<WidgetState> states) {
                          if (states.contains(WidgetState.focused)) {
                            return RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                              side: BorderSide(
                                color: tColors.primaryTextColor!,
                                width: 2.0,
                              ),
                            );
                          } else {
                            return RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                              side: BorderSide(
                                color: tColors.primaryTextColor!,
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
                                  controller
                                      .search(controller.searchController.text);
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
                Visibility(
                  visible: !controller.taskchampion.value,
                  child: Expanded(
                    child: Scrollbar(
                      child: Obx(
                        () => TasksBuilder(
                          // darkmode: AppSettings.isDarkMode,
                          useDelayTask: controller.useDelayTask.value,
                          taskData: controller.searchedTasks,
                          pendingFilter: controller.pendingFilter.value,
                          waitingFilter: controller.waitingFilter.value,
                          searchVisible: controller.searchVisible.value,
                          selectedLanguage: controller.selectedLanguage.value,
                          scrollController: controller.scrollController,
                          showbtn: controller.showbtn.value,
                        ),
                      ),
                    ),
                  ),
                ),
                Visibility(
                    visible: controller.taskchampion.value,
                    child: Expanded(
                        child: Scrollbar(
                      child: TaskViewBuilder(
                        pendingFilter: controller.pendingFilter.value,
                        selectedSort: controller.selectedSort.value,
                        project: controller.projectFilter.value,
                      ),
                    )))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
