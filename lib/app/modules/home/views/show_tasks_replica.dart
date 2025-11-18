import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taskwarrior/app/modules/home/controllers/home_controller.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:taskwarrior/app/utils/constants/taskwarrior_colors.dart';
import 'package:taskwarrior/app/routes/app_pages.dart';
import 'package:taskwarrior/app/utils/app_settings/app_settings.dart';
import 'package:taskwarrior/app/utils/constants/taskwarrior_fonts.dart';
import 'package:taskwarrior/app/utils/themes/theme_extension.dart';
import 'package:taskwarrior/app/utils/language/sentence_manager.dart';
import 'package:taskwarrior/app/v3/champion/replica.dart';
import 'package:taskwarrior/app/v3/champion/models/task_for_replica.dart';

class TaskReplicaViewBuilder extends StatelessWidget {
  const TaskReplicaViewBuilder({
    super.key,
    this.project,
    required this.pendingFilter,
    required this.selectedSort,
    required this.replicaTasks,
  });

  final String selectedSort;
  final bool pendingFilter;
  final String? project;
  final List<TaskForReplica> replicaTasks;

  @override
  Widget build(BuildContext context) {
    TaskwarriorColorTheme tColors =
        Theme.of(context).extension<TaskwarriorColorTheme>()!;

    return Obx(() {
      List<TaskForReplica> tasks = List<TaskForReplica>.from(replicaTasks);
      if (project != null && project != 'All Projects') {
        tasks = tasks.where((task) => task.project == project).toList();
      }
      tasks.sort((a, b) {
        final am = a.modified ?? 0;
        final bm = b.modified ?? 0;
        return bm.compareTo(am);
      });
      tasks = tasks.where((task) {
        if (pendingFilter) {
          return task.status == 'pending';
        } else {
          return task.status == 'completed';
        }
      }).toList();

      tasks.sort((a, b) {
        switch (selectedSort) {
          case 'Modified+':
            return (a.modified ?? 0).compareTo(b.modified ?? 0);
          case 'Modified-':
            return (b.modified ?? 0).compareTo(a.modified ?? 0);
          case 'Due till+':
            return (a.due ?? '').compareTo(b.due ?? '');
          case 'Due till-':
            return (b.due ?? '').compareTo(a.due ?? '');
          case 'Priority+':
            return (a.priority ?? '').compareTo(b.priority ?? '');
          case 'Priority-':
            return (b.priority ?? '').compareTo(a.priority ?? '');
          default:
            return 0;
        }
      });

      return Scaffold(
        backgroundColor: tColors.dialogBackgroundColor,
        body: tasks.isEmpty
            ? Padding(
                padding: const EdgeInsets.all(16.0),
                child: Center(
                  child: Text(
                    SentenceManager(
                            currentLanguage: AppSettings.selectedLanguage)
                        .sentences
                        .clickOnBottomRightButtonToStartAddingTasks,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: TaskWarriorFonts.fontSizeLarge,
                      color: tColors.primaryTextColor,
                    ),
                  ),
                ),
              )
            : ListView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.only(
                  top: 4,
                  left: 2,
                  right: 2,
                  bottom: MediaQuery.of(context).size.height * 0.1,
                ),
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  final task = tasks[index];
                  // Determine if due is within 24 hours or already past (only for pending filter)
                  final bool isDueSoon = (() {
                    if (!pendingFilter) return false;
                    // Only apply due-soon highlighting when delay-task setting is enabled
                    try {
                      final HomeController hc = Get.find<HomeController>();
                      if (!hc.useDelayTask.value) return false;
                    } catch (_) {
                      return false;
                    }
                    final dueStr = task.due;
                    if (dueStr == null || dueStr.isEmpty) return false;
                    final parsed = DateTime.tryParse(dueStr);
                    if (parsed == null) return false;
                    final now = DateTime.now().toUtc();
                    final threshold = now.add(const Duration(hours: 24));
                    return parsed.toUtc().isBefore(threshold);
                  })();

                  final card = Card(
                    color: tColors.secondaryBackgroundColor,
                    child: InkWell(
                      splashColor: tColors.primaryBackgroundColor,
                      onTap: () =>
                          Get.toNamed(Routes.TASKC_DETAILS, arguments: task),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: isDueSoon
                                ? Colors.red
                                : tColors.primaryTextColor!,
                          ),
                          color: tColors.primaryBackgroundColor,
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor:
                                _getPriorityColor(task.priority ?? ''),
                            radius: 8,
                          ),
                          title: Text(
                            task.description ?? '',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.poppins(
                              color: tColors.primaryTextColor,
                            ),
                          ),
                          subtitle: Text(
                            '${SentenceManager(currentLanguage: AppSettings.selectedLanguage).sentences.detailPageStatus}: ${task.status ?? ''}',
                            style: GoogleFonts.poppins(
                              color: tColors.secondaryTextColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );

                  // Only enable swipe actions (complete/delete) when pendingFilter is true
                  if (pendingFilter) {
                    return Slidable(
                      startActionPane: ActionPane(
                        motion: const BehindMotion(),
                        children: [
                          SlidableAction(
                            onPressed: (ctx) {
                              completeTask(task);
                            },
                            icon: Icons.done,
                            label: SentenceManager(
                                    currentLanguage:
                                        AppSettings.selectedLanguage)
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
                            onPressed: (ctx) {
                              deleteTask(task);
                            },
                            icon: Icons.delete,
                            label: SentenceManager(
                                    currentLanguage:
                                        AppSettings.selectedLanguage)
                                .sentences
                                .delete,
                            backgroundColor: TaskWarriorColors.red,
                          ),
                        ],
                      ),
                      child: card,
                    );
                  }

                  return card;
                },
              ),
      );
    });
  }

  Color _getPriorityColor(String priority) {
    switch (priority) {
      case 'H':
        return Colors.red;
      case 'M':
        return Colors.yellow;
      case 'L':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  void completeTask(TaskForReplica task) async {
    await Replica.modifyTaskInReplica(task.copyWith(status: 'completed'));
    Get.find<HomeController>().refreshReplicaTaskList();
  }

  void deleteTask(TaskForReplica task) async {
    await Replica.deleteTaskFromReplica(task.uuid);
    Get.find<HomeController>().refreshReplicaTaskList();
  }
}
