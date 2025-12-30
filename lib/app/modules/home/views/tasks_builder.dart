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
    final storage = Get.find<HomeController>();

    final modify = Modify(
      getTask: storage.getTask,
      mergeTask: storage.mergeTask,
      uuid: id,
    );

    modify.set('status', newValue);
    _saveChanges(context, modify, id);
  }

  void _saveChanges(BuildContext context, Modify modify, String id) {
    final tColors =
        Theme.of(context).extension<TaskwarriorColorTheme>()!;

    modify.save(modified: () => DateTime.now().toUtc());

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: tColors.secondaryBackgroundColor,
        content: Text(
          SentenceManager(currentLanguage: selectedLanguage)
              .sentences
              .taskUpdated,
          style: TextStyle(color: tColors.primaryTextColor),
        ),
        action: SnackBarAction(
          label: SentenceManager(currentLanguage: selectedLanguage)
              .sentences
              .undo,
          textColor: tColors.purpleShade,
          onPressed: () => _undoChanges(context, id),
        ),
      ),
    );
  }

  void _undoChanges(BuildContext context, String id) {
    final storage = Get.find<HomeController>();

    final modify = Modify(
      getTask: storage.getTask,
      mergeTask: storage.mergeTask,
      uuid: id,
    );

    modify.set('status', 'pending');
    modify.save(modified: () => DateTime.now().toUtc());

    storage.update();
  }

  void _cancelNotification(Task task) {
    final service = NotificationService();

    final id = service.calculateNotificationId(
      task.due!,
      task.description,
      false,
      task.entry,
    );

    service.cancelNotification(id);

    if (task.wait != null) {
      final waitId = service.calculateNotificationId(
        task.wait!,
        task.description,
        true,
        task.entry,
      );
      service.cancelNotification(waitId);
    }
  }

 
  Widget _buildEmptyState(
      BuildContext context, TaskwarriorColorTheme tColors) {
    return Center(
      child: Card(
        elevation: 0,
        margin: const EdgeInsets.symmetric(horizontal: 20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        color: tColors.secondaryBackgroundColor,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 32,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 110,
                width: 110,
                decoration: BoxDecoration(
                  color: tColors.primaryBackgroundColor,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Icon(
                  Icons.checklist_rounded,
                  size: 60,
                  color: tColors.purpleShade,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                "No tasks yet",
                style: TextStyle(
                  fontFamily: FontFamily.poppins,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: tColors.primaryTextColor,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                SentenceManager(
                  currentLanguage: selectedLanguage,
                ).sentences
                    .homePageClickOnTheBottomRightButtonToStartAddingTasks,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: FontFamily.poppins,
                  fontSize: 14,
                  color: tColors.secondaryTextColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

 
  @override
  Widget build(BuildContext context) {
    final tColors =
        Theme.of(context).extension<TaskwarriorColorTheme>()!;
    final storage = Get.find<HomeController>();

    return Scaffold(
      backgroundColor: Colors.transparent,

      /* -------- Scroll To Top FAB -------- */
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniStartFloat,
      floatingActionButton: showbtn
          ? FloatingActionButton(
              heroTag: "scrollTopBtn",
              backgroundColor: tColors.primaryTextColor,
              onPressed: () {
                scrollController.animateTo(
                  0,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeOut,
                );
              },
              child: Icon(
                Icons.arrow_upward,
                color: tColors.secondaryBackgroundColor,
              ),
            )
          : null,

      
      body: Obx(
        () => taskData.isEmpty
            ? _buildEmptyState(context, tColors)
            : ListView.builder(
                controller: scrollController,
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                itemCount: taskData.length,
                itemBuilder: (context, index) {
                  final task = taskData[index];
                  final key = index == 0
                      ? storage.taskItemKey
                      : ValueKey(task.uuid);

                  final card = Card(
                    color: tColors.secondaryBackgroundColor,
                    child: InkWell(
                      onTap: () => Get.toNamed(
                        Routes.DETAIL_ROUTE,
                        arguments: ["uuid", task.uuid],
                      ),
                      child: TaskListItem(
                        task,
                        pendingFilter: pendingFilter,
                        useDelayTask: useDelayTask,
                        modify: Modify(
                          getTask: storage.getTask,
                          mergeTask: storage.mergeTask,
                          uuid: task.uuid,
                        ),
                        selectedLanguage: selectedLanguage,
                      ),
                    ),
                  );

                  if (!pendingFilter) return card;

                  return Slidable(
                    key: key,
                    startActionPane: ActionPane(
                      motion: const BehindMotion(),
                      children: [
                        SlidableAction(
                          backgroundColor: TaskWarriorColors.green,
                          icon: Icons.done,
                          label: SentenceManager(
                            currentLanguage: selectedLanguage,
                          ).sentences.complete,
                          onPressed: (_) {
                            setStatus(
                                context, 'completed', task.uuid);
                            if (task.due != null) {
                              _cancelNotification(task);
                            }
                          },
                        ),
                      ],
                    ),
                    endActionPane: ActionPane(
                      motion: const DrawerMotion(),
                      children: [
                        SlidableAction(
                          backgroundColor: TaskWarriorColors.red,
                          icon: Icons.delete,
                          label: SentenceManager(
                            currentLanguage: selectedLanguage,
                          ).sentences.delete,
                          onPressed: (_) {
                            setStatus(context, 'deleted', task.uuid);
                            if (task.due != null) {
                              _cancelNotification(task);
                            }
                            if (Platform.isAndroid ||
                                Platform.isIOS) {
                              final widgetController =
                                  Get.put(WidgetController());
                              widgetController.fetchAllData();
                              widgetController.update();
                            }
                          },
                        ),
                      ],
                    ),
                    child: card,
                  );
                },
              ),
      ),
    );
  }
}
