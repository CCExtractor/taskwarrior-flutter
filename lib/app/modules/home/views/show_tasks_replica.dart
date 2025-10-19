import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taskwarrior/app/routes/app_pages.dart';
import 'package:taskwarrior/app/utils/app_settings/app_settings.dart';
import 'package:taskwarrior/app/utils/constants/taskwarrior_colors.dart';
import 'package:taskwarrior/app/utils/constants/taskwarrior_fonts.dart';
import 'package:taskwarrior/app/utils/themes/theme_extension.dart';
import 'package:taskwarrior/app/utils/language/sentence_manager.dart';
import 'package:taskwarrior/app/v3/champion/models/task_for_replica.dart';

/// A lightweight view builder for TaskForReplica objects.
/// This mirrors `TaskViewBuilder` but only uses fields available on the
/// `TaskForReplica` model (modified, due, status, description, tags, uuid, priority).
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
      // We receive the tasks list from the caller so we copy it here.
      List<TaskForReplica> tasks = List<TaskForReplica>.from(replicaTasks);

      // Project filtering is not meaningful for TaskForReplica if project is not set
      if (project != null && project != 'All Projects') {
        // TaskForReplica doesn't have a `project` field by default, so skip filtering.
      }

      // Default sort: by modified desc if available
      tasks.sort((a, b) {
        final am = a.modified ?? 0;
        final bm = b.modified ?? 0;
        return bm.compareTo(am);
      });

      // Apply pending/completed filter
      tasks = tasks.where((task) {
        if (pendingFilter) {
          return task.status == 'pending';
        } else {
          return task.status == 'completed';
        }
      }).toList();

      // Only allow sorting by fields that exist on TaskForReplica
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
                  return Card(
                    color: tColors.secondaryBackgroundColor,
                    child: InkWell(
                      splashColor: tColors.primaryBackgroundColor,
                      onTap: () =>
                          Get.toNamed(Routes.TASKC_DETAILS, arguments: task),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: tColors.primaryTextColor!,
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
}
