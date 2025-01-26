// ignore_for_file: file_names

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:taskwarrior/app/models/models.dart';
import 'package:taskwarrior/app/modules/home/controllers/home_controller.dart';
import 'package:taskwarrior/app/modules/home/controllers/widget.controller.dart';
import 'package:taskwarrior/app/modules/home/views/tas_list_item.dart';
import 'package:taskwarrior/app/routes/app_pages.dart';
import 'package:taskwarrior/app/services/notification_services.dart';
import 'package:taskwarrior/app/utils/constants/taskwarrior_colors.dart';
import 'package:taskwarrior/app/utils/constants/taskwarrior_fonts.dart';
import 'package:taskwarrior/app/utils/gen/fonts.gen.dart';
import 'package:taskwarrior/app/utils/language/sentence_manager.dart';
import 'package:taskwarrior/app/utils/language/supported_language.dart';
import 'package:taskwarrior/app/utils/taskfunctions/modify.dart';
import 'package:taskwarrior/app/utils/themes/theme_extension.dart';

class TasksBuilder extends StatelessWidget {
  const TasksBuilder({
    super.key,
    required this.taskData,
    required this.pendingFilter,
    required this.waitingFilter,
    required this.useDelayTask,
    required this.searchVisible,
    required this.selectedLanguage,
    required this.scrollController,
    required this.showbtn,
  });

  final List<Task> taskData;
  final bool pendingFilter;
  final bool waitingFilter;
  final bool searchVisible;
  final bool useDelayTask;
  final SupportedLanguage selectedLanguage;
  final ScrollController scrollController;
  final bool showbtn;
  void setStatus(BuildContext context, String newValue, String id) {
    var storageWidget = Get.find<HomeController>();
    Modify modify = Modify(
      getTask: storageWidget.getTask,
      mergeTask: storageWidget.mergeTask,
      uuid: id,
    );
    modify.set('status', newValue);
    saveChanges(context, modify, id, newValue);
  }

  void saveChanges(
      BuildContext context, Modify modify, String id, String newValue) async {
    TaskwarriorColorTheme tColors = Theme.of(context).extension<TaskwarriorColorTheme>()!;
    var now = DateTime.now().toUtc();
    modify.save(
      modified: () => now,
    );
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        'Task Updated',
        style: TextStyle(
          color: tColors.primaryTextColor,
        ),
      ),
      backgroundColor: tColors.secondaryBackgroundColor,
      duration: const Duration(seconds: 2),
      action: SnackBarAction(
        label: 'Undo',
        onPressed: () {
          undoChanges(
              context, id, 'pending');

        },
      ),
    ));
  }

  void undoChanges(BuildContext context, String id, String originalValue) {
    var storageWidget = Get.find<HomeController>();
    Modify modify = Modify(
      getTask: storageWidget.getTask,
      mergeTask: storageWidget.mergeTask,
      uuid: id,
    );
    modify.set('status', originalValue);
    modify.save(
      modified: () => DateTime.now().toUtc(),
    );
    storageWidget.update();
  }

  void cancelNotification(Task task) {
    NotificationService notificationService = NotificationService();

    int notificationId = notificationService.calculateNotificationId(
        task.due!, task.description, false, task.entry);
    notificationService.cancelNotification(notificationId);

    if (task.wait != null) {
      notificationId = notificationService.calculateNotificationId(
          task.wait!, task.description, true, task.entry);
      notificationService.cancelNotification(notificationId);
    }
  }

  @override
  Widget build(BuildContext context) {
    // print(taskData);
    TaskwarriorColorTheme tColors = Theme.of(context).extension<TaskwarriorColorTheme>()!;
    var storageWidget = Get.find<HomeController>();
    return Scaffold(
        floatingActionButtonLocation:
            FloatingActionButtonLocation.miniStartFloat,
        floatingActionButton: showbtn ? AnimatedOpacity(
          duration: const Duration(milliseconds: 100), //show/hide animation
          opacity: showbtn ? 1.0 : 0.0, //set obacity to 1 on visible, or hide
          child: FloatingActionButton(
            heroTag: "btn2",
            onPressed: () {
              scrollController.animateTo(
                  //go to top of scroll
                  0, //scroll offset to go
                  duration:
                      const Duration(milliseconds: 500), //duration of scroll
                  curve: Curves.fastLinearToSlowEaseIn //scroll type
                  );
            },
            backgroundColor: tColors.primaryTextColor,
            child: Icon(
              Icons.arrow_upward,
              color: tColors.secondaryBackgroundColor,
            ),
          ),
        ) : null,
        backgroundColor: Colors.transparent,
        body: Obx(
          () => taskData.isEmpty
              ? Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Center(
                    child: Text(
                      (searchVisible)
                          ? '${SentenceManager(currentLanguage: selectedLanguage).sentences.homePageSearchNotFound} :('
                          : SentenceManager(currentLanguage: selectedLanguage)
                              .sentences
                              .homePageClickOnTheBottomRightButtonToStartAddingTasks,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontFamily: FontFamily.poppins,
                          fontSize: TaskWarriorFonts.fontSizeLarge,
                          color: tColors.primaryTextColor
                      ),
                      // style: GoogleFonts.poppins(
                      //   fontSize: TaskWarriorFonts.fontSizeLarge,
                      //   color: AppSettings.isDarkMode
                      //       ? TaskWarriorColors.kLightPrimaryBackgroundColor
                      //       : TaskWarriorColors.kprimaryBackgroundColor,
                      // ),
                    ),
                  ),
                )
              : ListView.builder(
                  padding:
                      const EdgeInsets.symmetric(vertical: 4, horizontal: 2),
                  itemCount: taskData.length,
                  controller: scrollController,
                  primary: false,
                  itemBuilder: (context, index) {
                    var task = taskData[index];
                    return pendingFilter
                        ? Slidable(
                            key: ValueKey(task.uuid),
                            startActionPane: ActionPane(
                              motion: const BehindMotion(),
                              children: [
                                SlidableAction(
                                  onPressed: (context) {
                                    // Complete task without confirmation
                                    setStatus(context, 'completed', task.uuid);
                                    if (task.due != null) {
                                      DateTime? dtb = task.due;
                                      dtb =
                                          dtb!.add(const Duration(minutes: 1));
                                      cancelNotification(task);
                                    }
                                  },
                                  icon: Icons.done,
                                  label: "COMPLETE",
                                  backgroundColor: TaskWarriorColors.green,
                                ),
                              ],
                            ),
                            endActionPane: ActionPane(
                              motion: const DrawerMotion(),
                              children: [
                                SlidableAction(
                                  onPressed: (context) {
                                    // Delete task without confirmation
                                    setStatus(context, 'deleted', task.uuid);
                                    if (task.due != null) {
                                      DateTime? dtb = task.due;
                                      dtb =
                                          dtb!.add(const Duration(minutes: 1));
                                      cancelNotification(task);
                                    }
                                    if (Platform.isAndroid) {
                                      WidgetController widgetController =
                                          Get.put(WidgetController());
                                      widgetController.fetchAllData();

                                      widgetController.update();
                                    }
                                  },
                                  icon: Icons.delete,
                                  label: "DELETE",
                                  backgroundColor: TaskWarriorColors.red,
                                ),
                              ],
                            ),
                            child: Card(
                              color: tColors.secondaryBackgroundColor,
                              child: InkWell(
                                splashColor: tColors.secondaryBackgroundColor,
                                onTap: () {
                                  Get.toNamed(Routes.DETAIL_ROUTE,
                                      arguments: ["uuid", task.uuid]);
                                },
                                // child: Text(task.entry.toString()),
                                // onTap: () => Navigator.push(
                                //   context,
                                //   MaterialPageRoute(
                                //     builder: (context) => DetailRouteView(task.uuid),
                                //   ),
                                // ),
                                child: TaskListItem(
                                  task,
                                  pendingFilter: pendingFilter,
                                  useDelayTask: useDelayTask,
                                  modify: Modify(
                                    getTask: storageWidget.getTask,
                                    mergeTask: storageWidget.mergeTask,
                                    uuid: task.uuid,
                                  ),
                                  selectedLanguage: selectedLanguage,
                                ),
                              ),
                            ),
                          )
                        : Card(
                            color: tColors.secondaryBackgroundColor,
                            child: InkWell(
                              splashColor: tColors.secondaryBackgroundColor,
                              onTap: () {
                                Get.toNamed(Routes.DETAIL_ROUTE,
                                    arguments: ["uuid", task.uuid]);
                              },
                              // child: Text(task.entry.toString()),
                              child: TaskListItem(
                                task,
                                pendingFilter: pendingFilter,
                                useDelayTask: useDelayTask,
                                modify: Modify(
                                  getTask: storageWidget.getTask,
                                  mergeTask: storageWidget.mergeTask,
                                  uuid: task.uuid,
                                ),
                                selectedLanguage: selectedLanguage,
                              ),
                            ),
                          );
                  },
                ),
        ));
  }
}
