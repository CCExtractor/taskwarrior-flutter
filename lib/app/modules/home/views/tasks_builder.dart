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

class TasksBuilder extends StatefulWidget {
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

  @override
  State<TasksBuilder> createState() => _TasksBuilderState();
}

class _TasksBuilderState extends State<TasksBuilder> {
  final Set<String> _selectedTasks = <String>{};
  bool _isMultiSelectMode = false;
  final Map<String, String> _lastModifiedTasks = <String, String>{};

  void setStatus(BuildContext context, String newValue, String id,
      {bool showSnackbar = true}) {
    var storageWidget = Get.find<HomeController>();
    Modify modify = Modify(
      getTask: storageWidget.getTask,
      mergeTask: storageWidget.mergeTask,
      uuid: id,
    );
    Task task = storageWidget.getTask(id);
    _lastModifiedTasks[id] = task.status;

    modify.set('status', newValue);
    saveChanges(context, modify, id, newValue, showSnackbar: showSnackbar);
    if (task.due != null) {
      cancelNotification(task);
    }
  }

  void saveChanges(
      BuildContext context, Modify modify, String id, String newValue,
      {bool showSnackbar = true}) async {
    TaskwarriorColorTheme tColors =
        Theme.of(context).extension<TaskwarriorColorTheme>()!;
    var now = DateTime.now().toUtc();
    modify.save(
      modified: () => now,
    );
    if (showSnackbar) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          SentenceManager(currentLanguage: widget.selectedLanguage)
              .sentences
              .taskUpdated,
          style: TextStyle(
            color: tColors.primaryTextColor,
          ),
        ),
        backgroundColor: tColors.secondaryBackgroundColor,
        duration: const Duration(seconds: 2),
        action: SnackBarAction(
          label: SentenceManager(currentLanguage: widget.selectedLanguage)
              .sentences
              .undo,
          onPressed: () {
            undoChanges(context, id, 'pending');
          },
        ),
      ));
    }
  }

  void toggleTaskSelection(String taskId) {
    if (widget.pendingFilter) {
      setState(() {
        if (_selectedTasks.contains(taskId)) {
          _selectedTasks.remove(taskId);
          if (_selectedTasks.isEmpty) {
            _isMultiSelectMode = false;
          }
        } else {
          _selectedTasks.add(taskId);
          _isMultiSelectMode = true;
        }
      });
    }
  }

  void completeSelectedTasks(BuildContext context) {
    TaskwarriorColorTheme tColors =
        Theme.of(context).extension<TaskwarriorColorTheme>()!;
    _lastModifiedTasks.clear();

    for (String taskId in _selectedTasks) {
      setStatus(context, 'completed', taskId, showSnackbar: false);
    }

    if (Platform.isAndroid) {
      WidgetController widgetController = Get.put(WidgetController());
      widgetController.fetchAllData();
      widgetController.update();
    }

    final int taskCount = _selectedTasks.length;
    setState(() {
      _selectedTasks.clear();
      _isMultiSelectMode = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        '$taskCount Tasks Completed',
        style: TextStyle(
          color: tColors.primaryTextColor,
        ),
      ),
      backgroundColor: tColors.secondaryBackgroundColor,
      duration: const Duration(seconds: 3),
      action: SnackBarAction(
        textColor: tColors.primaryTextColor,
        label: 'Undo All',
        onPressed: () {
          undoAllChanges(context);
        },
      ),
    ));
  }

  void deleteSelectedTasks(BuildContext context) {
    TaskwarriorColorTheme tColors =
        Theme.of(context).extension<TaskwarriorColorTheme>()!;
    _lastModifiedTasks.clear();

    for (String taskId in _selectedTasks) {
      setStatus(context, 'deleted', taskId, showSnackbar: false);
    }

    if (Platform.isAndroid) {
      WidgetController widgetController = Get.put(WidgetController());
      widgetController.fetchAllData();
      widgetController.update();
    }

    final int taskCount = _selectedTasks.length;
    setState(() {
      _selectedTasks.clear();
      _isMultiSelectMode = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        '$taskCount Tasks Deleted',
        style: TextStyle(
          color: tColors.primaryTextColor,
        ),
      ),
      backgroundColor: tColors.dialogBackgroundColor,
      duration: const Duration(seconds: 3),
      action: SnackBarAction(
        label: 'Undo All',
        onPressed: () {
          undoAllChanges(context);
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

  void undoAllChanges(BuildContext context) {
    TaskwarriorColorTheme tColors =
        Theme.of(context).extension<TaskwarriorColorTheme>()!;
    var storageWidget = Get.find<HomeController>();

    for (var entry in _lastModifiedTasks.entries) {
      String taskId = entry.key;
      String originalStatus = entry.value;

      Modify modify = Modify(
        getTask: storageWidget.getTask,
        mergeTask: storageWidget.mergeTask,
        uuid: taskId,
      );
      modify.set('status', originalStatus);
      modify.save(
        modified: () => DateTime.now().toUtc(),
      );
    }

    storageWidget.update();
    _lastModifiedTasks.clear();

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        'Tasks Restored',
        style: TextStyle(
          color: tColors.secondaryTextColor,
        ),
      ),
      backgroundColor: tColors.dialogBackgroundColor,
      duration: const Duration(seconds: 2),
    ));
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
    TaskwarriorColorTheme tColors =
        Theme.of(context).extension<TaskwarriorColorTheme>()!;
    var storageWidget = Get.find<HomeController>();
    return Scaffold(
        floatingActionButtonLocation:
            FloatingActionButtonLocation.miniStartFloat,
        floatingActionButton: widget.showbtn
            ? AnimatedOpacity(
                duration:
                    const Duration(milliseconds: 100), //show/hide animation
                opacity: widget.showbtn
                    ? 1.0
                    : 0.0, //set obacity to 1 on visible, or hide
                child: FloatingActionButton(
                  heroTag: "btn2",
                  onPressed: () {
                    widget.scrollController.animateTo(
                        //go to top of scroll
                        0, //scroll offset to go
                        duration: const Duration(
                            milliseconds: 500), //duration of scroll
                        curve: Curves.fastLinearToSlowEaseIn //scroll type
                        );
                  },
                  backgroundColor: tColors.primaryTextColor,
                  child: Icon(
                    Icons.arrow_upward,
                    color: tColors.secondaryBackgroundColor,
                  ),
                ),
              )
            : null,
        backgroundColor: Colors.transparent,
        appBar: _isMultiSelectMode
            ? AppBar(
                backgroundColor: tColors.primaryBackgroundColor,
                title: Text(
                  '${_selectedTasks.length} selected',
                  style: TextStyle(
                    color: tColors.primaryTextColor,
                  ),
                ),
                leading: IconButton(
                  icon: Icon(
                    Icons.close,
                    color: tColors.primaryTextColor,
                  ),
                  onPressed: () {
                    setState(() {
                      _selectedTasks.clear();
                      _isMultiSelectMode = false;
                    });
                  },
                ),
                actions: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.done_all),
                      label: const Text('Complete'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: TaskWarriorColors.green,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () => completeSelectedTasks(context),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.delete),
                      label: const Text('Delete'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: TaskWarriorColors.red,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () => deleteSelectedTasks(context),
                    ),
                  ),
                ],
              )
            : null,
        body: Obx(
          () => widget.taskData.isEmpty
              ? Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Center(
                    child: Text(
                      (widget.searchVisible)
                          ? '${SentenceManager(currentLanguage: widget.selectedLanguage).sentences.homePageSearchNotFound} :('
                          : SentenceManager(
                                  currentLanguage: widget.selectedLanguage)
                              .sentences
                              .homePageClickOnTheBottomRightButtonToStartAddingTasks,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontFamily: FontFamily.poppins,
                          fontSize: TaskWarriorFonts.fontSizeLarge,
                          color: tColors.primaryTextColor),
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
                  itemCount: widget.taskData.length,
                  controller: widget.scrollController,
                  primary: false,
                  itemBuilder: (context, index) {
                    var task = widget.taskData[index];
                    final itemKey = index == 0
                        ? storageWidget.taskItemKey
                        : ValueKey(task.uuid);
                    final bool isSelected = _selectedTasks.contains(task.uuid);

                    Widget taskCard = Card(
                      color: isSelected
                          ? tColors.primaryBackgroundColor
                          : tColors.secondaryBackgroundColor,
                      child: InkWell(
                        splashColor: tColors.dialogBackgroundColor,
                        onTap: _isMultiSelectMode && widget.pendingFilter
                            ? () => toggleTaskSelection(task.uuid)
                            : () {
                                Get.toNamed(Routes.DETAIL_ROUTE,
                                    arguments: ["uuid", task.uuid]);
                              },
                        onLongPress: widget.pendingFilter
                            ? () {
                                toggleTaskSelection(task.uuid);
                              }
                            : null,
                        child: Stack(
                          children: [
                            TaskListItem(
                              task,
                              pendingFilter: widget.pendingFilter,
                              useDelayTask: widget.useDelayTask,
                              modify: Modify(
                                getTask: storageWidget.getTask,
                                mergeTask: storageWidget.mergeTask,
                                uuid: task.uuid,
                              ),
                              selectedLanguage: widget.selectedLanguage,
                            ),
                            if (isSelected && widget.pendingFilter)
                              Positioned(
                                right: 10,
                                top: 10,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color:
                                        TaskWarriorColors.green.withAlpha(140),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.check,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    );

                    return !widget.pendingFilter || _isMultiSelectMode
                        ? taskCard
                        : Slidable(
                            key: itemKey,
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
                                  label: SentenceManager(
                                          currentLanguage:
                                              widget.selectedLanguage)
                                      .sentences
                                      .complete,
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
                                  label: SentenceManager(
                                          currentLanguage:
                                              widget.selectedLanguage)
                                      .sentences
                                      .delete,
                                  backgroundColor: TaskWarriorColors.red,
                                ),
                              ],
                            ),
                            child: taskCard,
                          );
                  },
                ),
        ));
  }
}
