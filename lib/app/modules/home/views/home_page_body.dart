import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taskwarrior/app/modules/home/views/show_tasks.dart';
import 'package:taskwarrior/app/modules/home/views/show_tasks_replica.dart';
import 'package:taskwarrior/app/modules/home/views/tasks_builder.dart';
import 'package:taskwarrior/app/utils/constants/taskwarrior_colors.dart';
import 'package:taskwarrior/app/utils/themes/theme_extension.dart';
import 'package:taskwarrior/app/utils/language/sentence_manager.dart';
import '../controllers/home_controller.dart';

class HomePageBody extends StatelessWidget {
  final HomeController controller;
  const HomePageBody({required this.controller, super.key});

  @override
  Widget build(BuildContext context) {
    controller.initInAppTour();
    controller.showInAppTour(context);
    TaskwarriorColorTheme tColors =
        Theme.of(context).extension<TaskwarriorColorTheme>()!;
    return DoubleBackToCloseApp(
      snackBar: SnackBar(
          content: Text(SentenceManager(
                  currentLanguage: controller.selectedLanguage.value)
              .sentences
              .homePageTapBackToExit)),
      child: Container(
        color: tColors.dialogBackgroundColor,
        child: Padding(
          padding: const EdgeInsets.only(left: 8.0, right: 8.0),
          child: Obx(
            () {
              // Read the replica list reactively here so the whole view rebuilds
              // when tasks arrive. On launch, taskReplica flips true (triggering a
              // rebuild) *before* the async FFI fetch populates tasksFromReplica;
              // without a reactive read of the list itself, the populated tasks
              // would never appear (the view stays on its initial empty build).
              var replicaTasks = controller.tasksFromReplica.toList();
              // Apply the search text to the replica list. Unlike the local-taskc
              // path (which reads the pre-filtered `searchedTasks`), this builder
              // gets the raw list, so filter here. Reading `searchQuery`/
              // `searchVisible` inside the Obx makes it rebuild on each keystroke.
              final query = controller.searchQuery.value.trim().toLowerCase();
              if (controller.searchVisible.value && query.isNotEmpty) {
                replicaTasks = replicaTasks
                    .where((task) =>
                        (task.description ?? '').toLowerCase().contains(query))
                    .toList();
              }
              return Column(
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
                      focusNode: controller.searchFocusNode,
                      onChanged: (value) {
                        controller.search(value);
                      },
                      onTapOutside: (event) {
                        controller.searchFocusNode.unfocus();
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

                      hintText: SentenceManager(
                              currentLanguage:
                                  controller.selectedLanguage.value)
                          .sentences
                          .homePageSearchHint,
                    ),
                  ),
                Visibility(
                  visible: !controller.taskchampion.value &&
                      !controller.taskReplica.value,
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
                    ))),
                Visibility(
                    visible: controller.taskReplica.value,
                    child: Expanded(
                        child: Scrollbar(
                      child: TaskReplicaViewBuilder(
                        replicaTasks: replicaTasks,
                        pendingFilter: controller.pendingFilter.value,
                        selectedSort: controller.selectedSort.value,
                        project: controller.projectFilter.value,
                      ),
                    )))
              ],
              );
            },
          ),
        ),
      ),
    );
  }
}
