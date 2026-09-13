import 'package:flutter/material.dart';
import 'package:taskwarrior/app/modules/reports/analytics_data.dart';
import 'package:taskwarrior/app/modules/reports/views/reports_dashboard.dart';
import 'package:taskwarrior/app/modules/reports/views/reports_page_app_bar.dart';
import 'package:taskwarrior/app/utils/app_settings/app_settings.dart';
import 'package:taskwarrior/app/utils/language/sentence_manager.dart';
import 'package:taskwarrior/app/utils/themes/theme_extension.dart';
import 'package:taskwarrior/app/v3/db/task_database.dart';
import 'package:taskwarrior/app/v3/models/task.dart';

class ReportsHomeTaskc extends StatelessWidget {
  final TaskDatabase taskDatabase = TaskDatabase();

  ReportsHomeTaskc({super.key});

  Future<List<TaskForC>> fetchTasks() async {
    await taskDatabase.open();
    return await taskDatabase.fetchTasksFromDatabase();
  }

  /// Taskc stores dates as strings; unparseable ones are skipped.
  ActivityEntry? _toEntry(TaskForC task) {
    final DateTime? created =
        DateTime.tryParse(task.entry) ?? DateTime.tryParse(task.modified ?? '');
    if (created == null) return null;
    final bool done = task.status == 'completed';
    final DateTime? completed =
        done ? DateTime.tryParse(task.end ?? task.modified ?? '') : null;
    return ActivityEntry(
      created: created.toLocal(),
      completed: completed?.toLocal(),
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
    return FutureBuilder<List<TaskForC>>(
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
