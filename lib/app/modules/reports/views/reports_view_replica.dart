import 'package:flutter/material.dart';
import 'package:taskwarrior/app/modules/reports/analytics_data.dart';
import 'package:taskwarrior/app/modules/reports/views/reports_dashboard.dart';
import 'package:taskwarrior/app/modules/reports/views/reports_page_app_bar.dart';
import 'package:taskwarrior/app/utils/app_settings/app_settings.dart';
import 'package:taskwarrior/app/utils/language/sentence_manager.dart';
import 'package:taskwarrior/app/utils/themes/theme_extension.dart';
import 'package:taskwarrior/app/v3/champion/models/task_for_replica.dart';
import 'package:taskwarrior/app/v3/champion/replica.dart';

class ReportsHomeReplica extends StatelessWidget {
  const ReportsHomeReplica({super.key});

  Future<List<TaskForReplica>> fetchTasks() async {
    return await Replica.getAllTasksFromReplica();
  }

  /// Replica stores `entry`/`modified` as epoch seconds. Completion time is the
  /// `modified` value, since a completed task's last change is its completion.
  ///
  /// TaskChampion's `create_task` (what Add Task uses) does not stamp `entry`,
  /// so app-created tasks carry only `modified` — fall back to it rather than
  /// dropping the task from the stats entirely.
  ActivityEntry? _toEntry(TaskForReplica task) {
    final int? stamp = task.entry ?? task.modified;
    if (stamp == null) return null;
    final bool done = task.status == 'completed';
    final int? modified = task.modified;
    return ActivityEntry(
      created:
          DateTime.fromMillisecondsSinceEpoch(stamp * 1000, isUtc: true).toLocal(),
      completed: (done && modified != null)
          ? DateTime.fromMillisecondsSinceEpoch(modified * 1000, isUtc: true)
              .toLocal()
          : null,
      due: DateTime.tryParse(task.due ?? '')?.toLocal(),
      isCompleted: done,
      project: task.project,
      priority: task.priority,
    );
  }

  @override
  Widget build(BuildContext context) {
    final TaskwarriorColorTheme tColors =
        Theme.of(context).extension<TaskwarriorColorTheme>()!;
    final sentences =
        SentenceManager(currentLanguage: AppSettings.selectedLanguage).sentences;
    return FutureBuilder<List<TaskForReplica>>(
      future: fetchTasks(),
      builder: (context, snapshot) {
        final List<ActivityEntry> entries = (snapshot.data ?? [])
            .map(_toEntry)
            .whereType<ActivityEntry>()
            .toList();
        return Scaffold(
          appBar: ReportsPageAppBar(title: sentences.reportsPageTitle),
          backgroundColor: tColors.primaryBackgroundColor,
          body: snapshot.connectionState == ConnectionState.waiting
              ? const Center(child: CircularProgressIndicator())
              : entries.isEmpty
                  ? const ReportsEmptyState()
                  : ReportsDashboard(entries: entries),
        );
      },
    );
  }
}
