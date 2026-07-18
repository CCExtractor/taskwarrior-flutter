import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taskwarrior/app/models/report.dart';
import 'package:taskwarrior/app/modules/report_engine/controllers/report_engine_controller.dart';
import 'package:taskwarrior/app/routes/app_pages.dart';
import 'package:taskwarrior/app/utils/constants/taskwarrior_colors.dart';
import 'package:taskwarrior/app/utils/themes/theme_extension.dart';
import 'package:taskwarrior/app/v3/champion/models/task_for_replica.dart';

class ReportEngineView extends GetView<ReportEngineController> {
  const ReportEngineView({super.key});

  @override
  Widget build(BuildContext context) {
    final TaskwarriorColorTheme tColors =
        Theme.of(context).extension<TaskwarriorColorTheme>()!;

    return Scaffold(
      backgroundColor: tColors.primaryBackgroundColor,
      appBar: AppBar(
        backgroundColor: tColors.primaryBackgroundColor,
        foregroundColor: tColors.primaryTextColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (controller.selectedReport.value != null) {
              controller.clearSelection();
            } else {
              Get.back();
            }
          },
        ),
        title: Obx(() {
          final ReportDefinition? sel = controller.selectedReport.value;
          return Text(
            sel == null ? 'Reports' : sel.name,
            style: GoogleFonts.poppins(
                color: tColors.primaryTextColor, fontWeight: FontWeight.w600),
          );
        }),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        return controller.selectedReport.value == null
            ? _buildPicker(context, tColors)
            : _buildResults(context, tColors);
      }),
    );
  }

  // --- Report picker -------------------------------------------------------

  Widget _buildPicker(BuildContext context, TaskwarriorColorTheme tColors) {
    final List<ReportDefinition> custom =
        controller.reports.where((r) => r.isCustom).toList();
    final List<ReportDefinition> defaults =
        controller.reports.where((r) => !r.isCustom).toList();

    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 8),
      children: [
        if (custom.isNotEmpty) ...[
          _sectionHeader('Your reports', tColors),
          ...custom.map((r) => _reportTile(context, r, tColors)),
        ],
        _sectionHeader('Default reports', tColors),
        ...defaults.map((r) => _reportTile(context, r, tColors)),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
          child: Text(
            'Tip: add or tweak reports by placing a .taskrc with '
            'report.<name>.sort/.filter/.description entries at:\n'
            '${controller.taskrcPath.value}',
            style: GoogleFonts.poppins(
                fontSize: 11, color: tColors.secondaryTextColor),
          ),
        ),
      ],
    );
  }

  Widget _sectionHeader(String text, TaskwarriorColorTheme tColors) => Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 6),
        child: Text(
          text.toUpperCase(),
          style: GoogleFonts.poppins(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
            color: tColors.secondaryTextColor,
          ),
        ),
      );

  Widget _reportTile(
      BuildContext context, ReportDefinition r, TaskwarriorColorTheme tColors) {
    return Card(
      color: tColors.secondaryBackgroundColor,
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      child: ListTile(
        onTap: () => controller.runReport(r),
        title: Row(
          children: [
            Text(
              r.name,
              style: GoogleFonts.poppins(
                  color: tColors.primaryTextColor,
                  fontWeight: FontWeight.w600),
            ),
            if (r.isCustom) ...[
              const SizedBox(width: 8),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                decoration: BoxDecoration(
                  color: TaskWarriorColors.purple.withValues(alpha: 0.25),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text('CUSTOM',
                    style: GoogleFonts.poppins(
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                        color: tColors.primaryTextColor)),
              ),
            ],
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(r.description,
                style: GoogleFonts.poppins(
                    color: tColors.secondaryTextColor, fontSize: 12)),
            if ((r.filterExpression ?? '').trim().isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Text(
                  r.filterExpression!,
                  style: GoogleFonts.robotoMono(
                      fontSize: 11, color: TaskWarriorColors.purple),
                ),
              ),
          ],
        ),
        trailing:
            Icon(Icons.chevron_right, color: tColors.secondaryTextColor),
      ),
    );
  }

  // --- Report results ------------------------------------------------------

  Widget _buildResults(BuildContext context, TaskwarriorColorTheme tColors) {
    final ReportDefinition report = controller.selectedReport.value!;
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
          color: tColors.secondaryBackgroundColor,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(report.description,
                  style: GoogleFonts.poppins(
                      color: tColors.primaryTextColor, fontSize: 13)),
              const SizedBox(height: 2),
              Text('${controller.results.length} task(s)',
                  style: GoogleFonts.poppins(
                      color: tColors.secondaryTextColor, fontSize: 11)),
            ],
          ),
        ),
        Expanded(
          child: controller.results.isEmpty
              ? Center(
                  child: Text('No tasks match this report.',
                      style: GoogleFonts.poppins(
                          color: tColors.secondaryTextColor)),
                )
              : RefreshIndicator(
                  onRefresh: controller.rerunSelected,
                  child: ListView.builder(
                    padding: const EdgeInsets.only(top: 4, bottom: 24),
                    itemCount: controller.results.length,
                    itemBuilder: (context, index) =>
                        _taskCard(controller.results[index], tColors),
                  ),
                ),
        ),
      ],
    );
  }

  Widget _taskCard(TaskForReplica task, TaskwarriorColorTheme tColors) {
    return Card(
      color: tColors.secondaryBackgroundColor,
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: InkWell(
        onTap: () => Get.toNamed(Routes.TASKC_DETAILS, arguments: task),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: tColors.primaryTextColor!),
            color: tColors.primaryBackgroundColor,
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: _priorityColor(task.priority ?? ''),
              radius: 8,
            ),
            title: Text(
              task.description ?? '',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.poppins(color: tColors.primaryTextColor),
            ),
            subtitle: Text(
              'Status: ${task.status ?? ''}'
              '${(task.project ?? '').isNotEmpty ? '  ·  ${task.project}' : ''}',
              style: GoogleFonts.poppins(color: tColors.secondaryTextColor),
            ),
          ),
        ),
      ),
    );
  }

  Color _priorityColor(String priority) {
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
