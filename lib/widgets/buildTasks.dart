// ignore_for_file: file_names

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:taskwarrior/config/app_settings.dart';
import 'package:taskwarrior/config/taskwarriorcolors.dart';
import 'package:taskwarrior/config/taskwarriorfonts.dart';
import 'package:taskwarrior/model/json.dart';
import 'package:taskwarrior/model/storage/storage_widget.dart';
import 'package:taskwarrior/services/notification_services.dart';
import 'package:taskwarrior/services/task_details.dart';
import 'package:taskwarrior/services/task_list_tem.dart';
import 'package:taskwarrior/widgets/taskfunctions/modify.dart';

import 'pallete.dart';

class TasksBuilder extends StatefulWidget {
  const TasksBuilder(
      {super.key,
      required this.taskData,
      required this.pendingFilter,
      required this.waitingFilter,
      required this.searchVisible});

  final List<Task> taskData;
  final bool pendingFilter;
  final bool waitingFilter;
  final bool searchVisible;

  @override
  State<TasksBuilder> createState() => _TasksBuilderState();
}

class _TasksBuilderState extends State<TasksBuilder> {
  late Modify modify;
  ScrollController scrollController = ScrollController();
  bool showbtn = false;
  Task? lastDeletedTask;
  Task? lastCompletedTask;
  bool isUndoInProgress = false; // track undo action

  @override
  void initState() {
    scrollController.addListener(() {
      //scroll listener
      double showoffset =
          10.0; //Back to top botton will show on scroll offset 10.0

      if (scrollController.offset > showoffset) {
        showbtn = true;
        setState(() {
          //update state
        });
      } else {
        showbtn = false;
        setState(() {
          //update state
        });
      }
    });
    super.initState();
  }

  void setStatus(String newValue, String id) {
    var storageWidget = StorageWidget.of(context);
    modify = Modify(
      getTask: storageWidget.getTask,
      mergeTask: storageWidget.mergeTask,
      uuid: id,
    );
    modify.set('status', newValue);
    saveChanges();
  }

  void saveChanges() async {
    var now = DateTime.now().toUtc();
    modify.save(
      modified: () => now,
    );

    // Show a snackbar with an undo action
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        'Task Updated',
        style: TextStyle(
          color: AppSettings.isDarkMode
              ? TaskWarriorColors.kprimaryTextColor
              : TaskWarriorColors.kLightPrimaryTextColor,
        ),
      ),
      backgroundColor: AppSettings.isDarkMode
          ? TaskWarriorColors.ksecondaryBackgroundColor
          : TaskWarriorColors.kLightSecondaryBackgroundColor,
      duration: const Duration(seconds: 2),
      action: SnackBarAction(
        label: 'Undo',
        onPressed: () {
          // Undo the task status change
          undoChanges();
        },
      ),
    ));
  }

  void undoChanges() {
    if (isUndoInProgress) {
      return; // If undo is already in progress, do nothing
    }
    isUndoInProgress = true;
    ScaffoldMessenger.of(context).removeCurrentSnackBar();

    if (lastDeletedTask != null) {
      setStatus('pending', lastDeletedTask!.uuid);
      lastDeletedTask = null;
    }

    if (lastCompletedTask != null) {
      setStatus('pending', lastCompletedTask!.uuid);
      lastCompletedTask = null;
    }
    isUndoInProgress = false;
  }

  // final bool darkmode;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButtonLocation:
            FloatingActionButtonLocation.miniStartFloat,
        floatingActionButton: AnimatedOpacity(
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
            backgroundColor: AppSettings.isDarkMode
                ? TaskWarriorColors.kLightPrimaryBackgroundColor
                : TaskWarriorColors.kprimaryBackgroundColor,
            child: Icon(
              Icons.arrow_upward,
              color: AppSettings.isDarkMode
                  ? TaskWarriorColors.kprimaryBackgroundColor
                  : TaskWarriorColors.kLightPrimaryBackgroundColor,
            ),
          ),
        ),
        backgroundColor: Colors.transparent,
        body: widget.taskData.isEmpty
            ? Padding(
                padding: const EdgeInsets.all(16.0),
                child: Center(
                  child: Text(
                    (widget.searchVisible)
                        ? 'Search Not Found :('
                        : 'Click on the bottom right button to start adding tasks',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: TaskWarriorFonts.fontSizeLarge,
                      color: AppSettings.isDarkMode
                          ? TaskWarriorColors.kLightPrimaryBackgroundColor
                          : TaskWarriorColors.kprimaryBackgroundColor,
                    ),
                  ),
                ),
              )
            : ListView(
                controller: scrollController,
                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 2),
                children: [
                  for (var task in widget.taskData)
                    widget.pendingFilter
                        ? Slidable(
                            key: ValueKey(task.uuid),
                            startActionPane: ActionPane(
                              motion: const BehindMotion(),
                              children: [
                                SlidableAction(
                                  onPressed: (context) {
                                    // Complete task without confirmation
                                    setStatus('completed', task.uuid);
                                    if (task.due != null) {
                                      DateTime? dtb = task.due;
                                      dtb =
                                          dtb!.add(const Duration(minutes: 1));

                                      cancelNotification(task);

                                      if (kDebugMode) {
                                        print("Task due is $dtb");
                                        print(dtb.day * 100 +
                                            dtb.hour * 10 +
                                            dtb.minute);
                                      }
                                    }
                                    lastCompletedTask = task;
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
                                    setStatus('deleted', task.uuid);
                                    if (task.due != null) {
                                      DateTime? dtb = task.due;
                                      dtb =
                                          dtb!.add(const Duration(minutes: 1));

                                      //Task ID is set to null when creating the notification id.
                                      cancelNotification(task);

                                      if (kDebugMode) {
                                        print("Task due is $dtb");
                                        print(dtb.day * 100 +
                                            dtb.hour * 10 +
                                            dtb.minute);
                                      }
                                    }
                                    lastDeletedTask = task;
                                  },
                                  icon: Icons.delete,
                                  label: "DELETE",
                                  backgroundColor: TaskWarriorColors.red,
                                ),
                              ],
                            ),
                            child: Card(
                              color: AppSettings.isDarkMode
                                  ? Palette.kToDark
                                  : TaskWarriorColors.white,
                              child: InkWell(
                                splashColor: AppSettings.isDarkMode
                                    ? TaskWarriorColors.black
                                    : TaskWarriorColors.borderColor,
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DetailRoute(task
                                        .uuid), // added functionality for double tap to open task-details
                                  ),
                                ),
                                child: TaskListItem(
                                  task,
                                  pendingFilter: widget.pendingFilter,
                                  darkmode: AppSettings.isDarkMode,
                                ),
                              ),
                            ),
                          )
                        : Card(
                            color: AppSettings.isDarkMode
                                ? Palette.kToDark
                                : TaskWarriorColors.white,
                            child: InkWell(
                              splashColor: AppSettings.isDarkMode
                                  ? TaskWarriorColors.black
                                  : TaskWarriorColors.borderColor,
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DetailRoute(task
                                      .uuid), // added functionality for double tap to open task-details
                                ),
                              ),
                              child: TaskListItem(
                                task,
                                pendingFilter: widget.pendingFilter,
                                darkmode: AppSettings.isDarkMode,
                              ),
                            ),
                          ),
                ],
              ));
  }

  void cancelNotification(Task task) {
    //Task ID is set to null when creating the notification id.
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
}
