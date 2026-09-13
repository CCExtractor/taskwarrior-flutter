import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:taskwarrior/app/models/json/task.dart';
import 'package:taskwarrior/app/modules/reports/analytics_data.dart';
import 'package:taskwarrior/app/modules/reports/views/reports_dashboard.dart';
import 'package:taskwarrior/app/modules/reports/views/reports_page_app_bar.dart';
import 'package:taskwarrior/app/utils/app_settings/app_settings.dart';
import 'package:taskwarrior/app/utils/language/sentence_manager.dart';
import 'package:taskwarrior/app/utils/themes/theme_extension.dart';

import '../controllers/reports_controller.dart';

class ReportsView extends GetView<ReportsController> {
  const ReportsView({super.key});

  ActivityEntry _toEntry(Task task) {
    final bool done = task.status == 'completed';
    return ActivityEntry(
      created: task.entry,
      completed: done ? (task.end ?? task.modified) : null,
      due: task.due,
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
    return Scaffold(
      appBar: ReportsPageAppBar(title: sentences.reportsPageTitle),
      backgroundColor: tColors.primaryBackgroundColor,
      body: Obx(() {
        final List<ActivityEntry> entries =
            controller.allData.map(_toEntry).toList();
        return entries.isEmpty
            ? const ReportsEmptyState()
            : ReportsDashboard(entries: entries);
      }),
    );
  }
}
