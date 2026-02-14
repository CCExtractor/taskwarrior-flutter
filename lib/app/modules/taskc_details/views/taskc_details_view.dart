// ignore_for_file: deprecated_member_use, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taskwarrior/app/modules/home/controllers/home_controller.dart';
import 'package:taskwarrior/app/modules/taskc_details/views/tag_editor.dart';
import 'package:taskwarrior/app/utils/app_settings/app_settings.dart';
import 'package:taskwarrior/app/utils/constants/taskwarrior_colors.dart';
import 'package:taskwarrior/app/utils/constants/taskwarrior_fonts.dart';
import 'package:taskwarrior/app/utils/home_path/impl/home.dart';
import 'package:taskwarrior/app/utils/themes/theme_extension.dart';
import 'package:taskwarrior/app/utils/language/sentence_manager.dart';
import '../controllers/taskc_details_controller.dart';

class TaskcDetailsView extends GetView<TaskcDetailsController> {
  const TaskcDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    TaskwarriorColorTheme tColors =
        Theme.of(context).extension<TaskwarriorColorTheme>()!;
    return WillPopScope(
      onWillPop: controller.handleWillPop,
      child: Scaffold(
        backgroundColor: tColors.primaryBackgroundColor,
        appBar: AppBar(
          foregroundColor: TaskWarriorColors.lightGrey,
          backgroundColor: TaskWarriorColors.kprimaryBackgroundColor,
          title: Text(
            '${SentenceManager(currentLanguage: AppSettings.selectedLanguage).sentences.task}: ${controller.initialTask.description}',
            style: GoogleFonts.poppins(color: TaskWarriorColors.white),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Obx(
            () => ListView(
              children: [
                _buildEditableDetail(
                  context,
                  '${SentenceManager(currentLanguage: AppSettings.selectedLanguage).sentences.detailPageDescription}:',
                  controller.description.value,
                  (value) =>
                      controller.updateField(controller.description, value),
                ),
                _buildEditableDetail(
                  context,
                  '${SentenceManager(currentLanguage: AppSettings.selectedLanguage).sentences.project}:',
                  controller.project.value,
                  (value) => controller.updateField(controller.project, value),
                ),
                _buildSelectableDetail(
                  context,
                  '${SentenceManager(currentLanguage: AppSettings.selectedLanguage).sentences.detailPageStatus}:',
                  controller.status.value,
                  ['pending', 'completed'],
                  (value) => controller.updateField(controller.status, value),
                ),
                _buildSelectableDetail(
                  context,
                  '${SentenceManager(currentLanguage: AppSettings.selectedLanguage).sentences.detailPagePriority}:',
                  controller.priority.value,
                  ['H', 'M', 'L', 'None'],
                  (value) => controller.updateField(controller.priority, value),
                ),
                _buildDatePickerDetail(
                  context,
                  '${SentenceManager(currentLanguage: AppSettings.selectedLanguage).sentences.homePageDue}:',
                  controller.due.value,
                  () => controller.pickDateTime(controller.due),
                ),
                // Start / Wait: editable date pickers for replica tasks, read-only otherwise
                if (controller.isReplicaTask) ...[
                  _buildDatePickerDetail(
                    context,
                    '${SentenceManager(currentLanguage: AppSettings.selectedLanguage).sentences.detailPageStart}:',
                    controller.start.value == "stop"
                        ? "None"
                        : controller.start.value,
                    () => controller.start.value == "stop" ||
                            controller.start.value == "None" ||
                            controller.start.value.isEmpty
                        ? controller.updateField(
                            controller.start,
                            controller.formatDate(DateTime.now()),
                          )
                        : controller.updateField(controller.start, "stop"),
                  ),
                  _buildDatePickerDetail(
                    context,
                    '${SentenceManager(currentLanguage: AppSettings.selectedLanguage).sentences.detailPageWait}:',
                    controller.wait.value,
                    () => controller.pickDateTime(controller.wait),
                  ),
                ] else ...[
                  _buildDetail(
                    context,
                    '${SentenceManager(currentLanguage: AppSettings.selectedLanguage).sentences.detailPageStart}:',
                    controller.start.value,
                  ),
                  _buildDetail(
                    context,
                    '${SentenceManager(currentLanguage: AppSettings.selectedLanguage).sentences.detailPageWait}:',
                    controller.wait.value,
                  ),
                ],
                _buildTagEditorDetail(
                  context,
                  '${SentenceManager(currentLanguage: AppSettings.selectedLanguage).sentences.detailPageTags}:',
                  controller.tags.join(', '),
                  (value) => controller.updateListField(controller.tags, value),
                ),
                _buildSelectableDetail(
                  context,
                  'Recurrence:',
                  controller.recur.value.isEmpty
                      ? 'None'
                      : controller.recur.value,
                  ['None', 'daily', 'weekly', 'monthly', 'yearly'],
                  (value) {
                    controller.updateField(
                      controller.recur,
                      value == 'None' ? '' : value,
                    );
                    // Auto-set rtype
                    controller.updateField(
                      controller.rtype,
                      value == 'None' ? '' : 'periodic',
                    );
                  },
                ),
                // Conditionally show fields that are only present on local tasks
                if (controller.isLocalTask) ...[
                  _buildDetail(
                    context,
                    'UUID:',
                    controller.initialTaskUuidDisplay(),
                  ),
                  _buildDetail(
                    context,
                    '${SentenceManager(currentLanguage: AppSettings.selectedLanguage).sentences.detailPageUrgency}:',
                    controller.initialTaskUrgencyDisplay(),
                  ),
                  _buildDetail(
                    context,
                    '${SentenceManager(currentLanguage: AppSettings.selectedLanguage).sentences.detailPageEnd}:',
                    controller
                        .formatDate(controller.initialTaskEndForFormatting()),
                  ),
                  _buildDetail(
                    context,
                    '${SentenceManager(currentLanguage: AppSettings.selectedLanguage).sentences.detailPageEntry}:',
                    controller
                        .formatDate(controller.initialTaskEntryForFormatting()),
                  ),
                ],

                // Modified is available for both; show it for both types
                _buildDetail(
                    context,
                    '${SentenceManager(currentLanguage: AppSettings.selectedLanguage).sentences.detailPageModified}:',
                    controller.formatDate(
                        controller.initialTaskModifiedForFormatting()),
                    disabled: true),
              ],
            ),
          ),
        ),
        floatingActionButton: Obx(
          () => controller.hasChanges.value
              ? FloatingActionButton(
                  onPressed: controller.saveTask,
                  child: const Icon(Icons.save),
                )
              : const SizedBox.shrink(),
        ),
      ),
    );
  }

  Widget _buildEditableDetail(BuildContext context, String label, String value,
      Function(String) onChanged) {
    return InkWell(
      onTap: () async {
        final result = await controller.showEditDialog(label, value);
        if (result != null) {
          onChanged(result);
        }
      },
      child: _buildDetail(context, label, value),
    );
  }

  Widget _buildTagEditorDetail(BuildContext context, String label, String value,
      Function(String) onChanged) {
    TaskwarriorColorTheme tColors =
        Theme.of(context).extension<TaskwarriorColorTheme>()!;
    Iterable<String> suggestions =
        Get.find<HomeController>().allTagsInCurrentTasks;
    return InkWell(
      onTap: () async {
        showModalBottomSheet(
          backgroundColor: tColors.dialogBackgroundColor,
          context: context,
          isScrollControlled: true,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(0),
              topRight: Radius.circular(0),
            ),
          ),
          builder: (context) => TagEditor(
            suggestions:
                suggestions.toList(), // You can pass tag suggestions here
            initialTags: value.isNotEmpty
                ? value.split(',').map((e) => e.trim()).toList()
                : [],
            onSave: (List<String> newTags) {
              onChanged(newTags.join(', '));
            },
          ),
        );
      },
      child: _buildDetail(context, label, value),
    );
  }

  Widget _buildSelectableDetail(BuildContext context, String label,
      String value, List<String> options, Function(String) onChanged) {
    return InkWell(
      onTap: () async {
        final result = await controller.showSelectDialog(label, value, options);
        if (result != null) {
          onChanged(result);
        }
      },
      child: _buildDetail(context, label, value),
    );
  }

  Widget _buildDatePickerDetail(
      BuildContext context, String label, String value, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: _buildDetail(context, label, value),
    );
  }

  Widget _buildDetail(BuildContext context, String label, String value,
      {bool disabled = false}) {
    TaskwarriorColorTheme tColors =
        Theme.of(context).extension<TaskwarriorColorTheme>()!;
    final Color? textColor =
        disabled ? tColors.primaryDisabledTextColor : tColors.primaryTextColor;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: tColors.secondaryBackgroundColor,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4.0,
            offset: Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16.0),
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.poppins(
              fontWeight: TaskWarriorFonts.bold,
              fontSize: TaskWarriorFonts.fontSizeMedium,
              color: textColor,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.normal,
                fontSize: TaskWarriorFonts.fontSizeMedium,
                color: textColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
