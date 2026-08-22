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
import 'package:taskwarrior/app/v3/champion/models/task_for_replica.dart';
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
                // Offered statuses come from the controller so `deleted` is
                // reachable and `recurring` is not: a task becomes a template by
                // being given a repeat, and saveTask derives the status from it.
                // While a repeat is set the row is read-only, because any choice
                // made here would be silently overridden on save.
                if (controller.canEditStatus)
                  _buildSelectableDetail(
                    context,
                    '${SentenceManager(currentLanguage: AppSettings.selectedLanguage).sentences.detailPageStatus}:',
                    controller.status.value,
                    TaskcDetailsController.selectableStatuses,
                    (value) => controller.updateField(controller.status, value),
                  )
                else
                  _buildDetail(
                    context,
                    '${SentenceManager(currentLanguage: AppSettings.selectedLanguage).sentences.detailPageStatus}:',
                    controller.status.value,
                    disabled: true,
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
                  // No clear while a repeat is set: a recurring task without a
                  // due date is exactly what the FFI refuses (the desktop CLI
                  // deletes such a task), so don't offer the dead end.
                  onClear: controller.isReplicaTask &&
                          controller.due.value != 'None' &&
                          controller.due.value.isNotEmpty &&
                          controller.recur.value.trim().isEmpty
                      ? () => controller.updateField(controller.due, 'None')
                      : null,
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
                    onClear: controller.wait.value != 'None' &&
                            controller.wait.value.isNotEmpty
                        ? () => controller.updateField(controller.wait, 'None')
                        : null,
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
                // Attributes surfaced by the enriched Rust serializer (D2),
                // replica tasks only. Dependencies, annotations and recurrence
                // are editable; Blocked/Blocking are computed from the
                // dependency graph, so they stay read-only.
                if (controller.isReplicaTask) ...[
                  _buildDetail(
                    context,
                    'Blocked:',
                    controller.isBlocked.value ? 'Yes' : 'No',
                  ),
                  _buildDetail(
                    context,
                    'Blocking:',
                    controller.isBlocking.value ? 'Yes' : 'No',
                  ),
                  _buildDependencyEditor(context, controller),
                  _buildRecurrenceDetail(context, controller),
                  _buildAnnotationEditor(context, controller),
                ],
                if (controller.isLocalTask) ...[
                  _buildDetail(
                    context,
                    'Rtype:',
                    controller.rtype.value,
                  ),
                  _buildDetail(
                    context,
                    'Recur:',
                    controller.recur.value,
                  ),
                ],
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
      BuildContext context, String label, String value, VoidCallback onTap,
      {VoidCallback? onClear}) {
    final TaskwarriorColorTheme tColors =
        Theme.of(context).extension<TaskwarriorColorTheme>()!;
    final Widget row = InkWell(
      onTap: onTap,
      child: _buildDetail(context, label, value),
    );
    // The picker has no "no date" option, so without this a date, once set,
    // could never be removed.
    if (onClear == null) return row;
    return Stack(
      alignment: Alignment.centerRight,
      children: [
        row,
        IconButton(
          icon: Icon(Icons.clear, size: 18, color: tColors.secondaryTextColor),
          tooltip: 'Clear',
          onPressed: onClear,
        ),
      ],
    );
  }

  /// Tasks this one is waiting on, with add and remove.
  ///
  /// Dependencies are stored as bare UUIDs, so each is resolved to its task
  /// description — a raw UUID tells the reader nothing. Whether an edge is
  /// legal (no self-reference, no missing task, no loop) is decided by the Rust
  /// layer, which can see the whole graph; this only reports what it says.
  Widget _buildDependencyEditor(
      BuildContext context, TaskcDetailsController controller) {
    final TaskwarriorColorTheme tColors =
        Theme.of(context).extension<TaskwarriorColorTheme>()!;

    Future<void> pick() async {
      final candidates = controller.availableDependencyCandidates();
      if (candidates.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No other tasks available to depend on.')),
        );
        return;
      }
      final String? chosen = await showModalBottomSheet<String>(
        context: context,
        isScrollControlled: true,
        backgroundColor: tColors.primaryBackgroundColor,
        builder: (sheetContext) => _DependencyPicker(
          candidates: candidates,
          colors: tColors,
        ),
      );
      if (chosen == null) return;
      final String? error = await controller.addDependencyToTask(chosen);
      if (error != null && context.mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(error)));
      }
    }

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: tColors.secondaryBackgroundColor,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 4.0, offset: Offset(0, 2)),
        ],
      ),
      padding: const EdgeInsets.all(16.0),
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Obx(
        () => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Depends:',
              style: GoogleFonts.poppins(
                fontWeight: TaskWarriorFonts.bold,
                fontSize: TaskWarriorFonts.fontSizeMedium,
                color: tColors.primaryTextColor,
              ),
            ),
            const SizedBox(height: 8),
            if (controller.depends.isEmpty)
              Text(
                'None',
                style: GoogleFonts.poppins(
                  fontSize: TaskWarriorFonts.fontSizeMedium,
                  color: tColors.primaryTextColor,
                ),
              )
            else
              ...controller.depends.map(
                (uuid) => Padding(
                  padding: const EdgeInsets.only(bottom: 4.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          controller.describeDependency(uuid),
                          style: GoogleFonts.poppins(
                            fontSize: TaskWarriorFonts.fontSizeMedium,
                            color: tColors.primaryTextColor,
                          ),
                        ),
                      ),
                      if (controller.canEditDependencies)
                        IconButton(
                          tooltip: 'Remove dependency',
                          icon: const Icon(Icons.close, size: 18),
                          color: tColors.primaryTextColor,
                          onPressed: controller.dependencyBusy.value
                              ? null
                              : () async {
                                  final String? error = await controller
                                      .removeDependencyFromTask(uuid);
                                  if (error != null && context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text(error)));
                                  }
                                },
                        ),
                    ],
                  ),
                ),
              ),
            if (controller.canEditDependencies) ...[
              const SizedBox(height: 4),
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton.icon(
                  onPressed: controller.dependencyBusy.value ? null : pick,
                  icon: const Icon(Icons.add, size: 18),
                  label: Text(
                    'Add dependency',
                    style: GoogleFonts.poppins(
                      fontSize: TaskWarriorFonts.fontSizeMedium,
                    ),
                  ),
                  style: TextButton.styleFrom(
                    foregroundColor: tColors.primaryTextColor,
                    padding: EdgeInsets.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }


  /// Recurrence.
  ///
  /// This app cannot generate the repeats itself — TaskChampion has no
  /// recurrence engine, so the value written here is acted on by the desktop
  /// Taskwarrior CLI the next time it opens the same database. The caption says
  /// so, because a control that looks self-contained but is not would be worse
  /// than none.
  ///
  /// It also requires a due date. Taskwarrior *deletes* a recurring task that
  /// has none, so offering the option without one would let the app destroy a
  /// task on the user's next desktop sync.
  Widget _buildRecurrenceDetail(
      BuildContext context, TaskcDetailsController controller) {
    final TaskwarriorColorTheme c =
        Theme.of(context).extension<TaskwarriorColorTheme>()!;
    final bool enabled = controller.canEditRecurrence;
    final String current = controller.recur.value.trim();

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: c.secondaryBackgroundColor,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 4.0, offset: Offset(0, 2)),
        ],
      ),
      padding: const EdgeInsets.all(16.0),
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Repeats:',
                style: GoogleFonts.poppins(
                  fontWeight: TaskWarriorFonts.bold,
                  fontSize: TaskWarriorFonts.fontSizeMedium,
                  color: enabled
                      ? c.primaryTextColor
                      : c.primaryDisabledTextColor,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: GestureDetector(
                  onTap: enabled
                      ? () => _pickRecurrence(context, controller)
                      : null,
                  child: Text(
                    current.isEmpty ? 'None' : current,
                    textAlign: TextAlign.end,
                    style: GoogleFonts.poppins(
                      fontSize: TaskWarriorFonts.fontSizeMedium,
                      color: enabled
                          ? c.primaryTextColor
                          : c.primaryDisabledTextColor,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            enabled
                ? 'Repeats are created by Taskwarrior on desktop, not on the phone.'
                : 'Set a due date first — a repeating task needs one.',
            style: GoogleFonts.poppins(
              fontSize: TaskWarriorFonts.fontSizeSmall,
              color: c.primaryDisabledTextColor,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _pickRecurrence(
      BuildContext context, TaskcDetailsController controller) async {
    final TaskwarriorColorTheme c =
        Theme.of(context).extension<TaskwarriorColorTheme>()!;
    final String? chosen = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: c.primaryBackgroundColor,
      builder: (sheetContext) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final String option
                in TaskcDetailsController.recurrenceOptions)
              ListTile(
                title: Text(option,
                    style: GoogleFonts.poppins(color: c.primaryTextColor)),
                onTap: () => Navigator.of(sheetContext).pop(option),
              ),
          ],
        ),
      ),
    );
    if (chosen == null) return;
    controller.updateField(
        controller.recur, chosen == 'None' ? '' : chosen);
  }

  /// Notes on a task, with add and remove.
  ///
  /// Notes are written straight through to the replica rather than joining the
  /// draft the Save button commits, because each one is its own record in
  /// TaskChampion. The list therefore reflects what is stored, not what is
  /// pending, and leaving the page never discards a note.
  Widget _buildAnnotationEditor(
      BuildContext context, TaskcDetailsController controller) {
    final TaskwarriorColorTheme tColors =
        Theme.of(context).extension<TaskwarriorColorTheme>()!;
    final TextEditingController input = controller.annotationInput;

    Future<void> submit() async {
      final String text = input.text.trim();
      if (text.isEmpty) return;
      final String? error = await controller.addAnnotationToTask(text);
      if (error == null) {
        input.clear();
      } else if (context.mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(error)));
      }
    }

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: tColors.secondaryBackgroundColor,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 4.0, offset: Offset(0, 2)),
        ],
      ),
      padding: const EdgeInsets.all(16.0),
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Obx(
        () => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Annotations:',
              style: GoogleFonts.poppins(
                fontWeight: TaskWarriorFonts.bold,
                fontSize: TaskWarriorFonts.fontSizeMedium,
                color: tColors.primaryTextColor,
              ),
            ),
            const SizedBox(height: 8),
            if (controller.annotations.isEmpty)
              Text(
                'None',
                style: GoogleFonts.poppins(
                  fontSize: TaskWarriorFonts.fontSizeMedium,
                  color: tColors.primaryTextColor,
                ),
              )
            else
              ...controller.annotations.map(
                (annotation) => Padding(
                  padding: const EdgeInsets.only(bottom: 4.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              annotation.description ?? '',
                              style: GoogleFonts.poppins(
                                fontSize: TaskWarriorFonts.fontSizeMedium,
                                color: tColors.primaryTextColor,
                              ),
                            ),
                            if (annotation.entry != null &&
                                annotation.entry!.isNotEmpty)
                              Text(
                                annotation.entry!,
                                style: GoogleFonts.poppins(
                                  fontSize: TaskWarriorFonts.fontSizeSmall,
                                  color: tColors.primaryDisabledTextColor,
                                ),
                              ),
                          ],
                        ),
                      ),
                      if (controller.canEditAnnotations)
                        IconButton(
                          tooltip: 'Remove note',
                          icon: const Icon(Icons.close, size: 18),
                          color: tColors.primaryTextColor,
                          onPressed: controller.annotationBusy.value
                              ? null
                              : () async {
                                  final String? error = await controller
                                      .removeAnnotationFromTask(annotation);
                                  if (error != null && context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text(error)));
                                  }
                                },
                        ),
                    ],
                  ),
                ),
              ),
            if (controller.canEditAnnotations) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: input,
                      enabled: !controller.annotationBusy.value,
                      textInputAction: TextInputAction.done,
                      onSubmitted: (_) => submit(),
                      style: GoogleFonts.poppins(
                        fontSize: TaskWarriorFonts.fontSizeMedium,
                        color: tColors.primaryTextColor,
                      ),
                      decoration: InputDecoration(
                        isDense: true,
                        hintText: 'Add a note',
                        hintStyle: GoogleFonts.poppins(
                          fontSize: TaskWarriorFonts.fontSizeMedium,
                          color: tColors.primaryDisabledTextColor,
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    tooltip: 'Add note',
                    icon: const Icon(Icons.add),
                    color: tColors.primaryTextColor,
                    onPressed: controller.annotationBusy.value ? null : submit,
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
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

/// Bottom sheet for choosing a task to depend on.
///
/// Stateful purely for the filter field: a replica can hold hundreds of tasks,
/// so an unfiltered list is not usable. Selecting pops the chosen UUID; the
/// caller decides whether the edge is legal.
class _DependencyPicker extends StatefulWidget {
  const _DependencyPicker({
    required this.candidates,
    required this.colors,
  });

  final List<TaskForReplica> candidates;
  final TaskwarriorColorTheme colors;

  @override
  State<_DependencyPicker> createState() => _DependencyPickerState();
}

class _DependencyPickerState extends State<_DependencyPicker> {
  final TextEditingController _query = TextEditingController();

  @override
  void dispose() {
    _query.dispose();
    super.dispose();
  }

  List<TaskForReplica> get _visible {
    final String q = _query.text.trim().toLowerCase();
    if (q.isEmpty) return widget.candidates;
    return widget.candidates
        .where((t) => (t.description ?? '').toLowerCase().contains(q))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final TaskwarriorColorTheme colors = widget.colors;
    final List<TaskForReplica> visible = _visible;

    return SafeArea(
      child: Padding(
        // Keep the field above the keyboard.
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: 16,
          bottom: MediaQuery.of(context).viewInsets.bottom + 16,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Depends on',
              style: GoogleFonts.poppins(
                fontWeight: TaskWarriorFonts.bold,
                fontSize: TaskWarriorFonts.fontSizeLarge,
                color: colors.primaryTextColor,
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _query,
              autofocus: false,
              onChanged: (_) => setState(() {}),
              style: GoogleFonts.poppins(color: colors.primaryTextColor),
              decoration: InputDecoration(
                isDense: true,
                prefixIcon: const Icon(Icons.search, size: 20),
                hintText: 'Search tasks',
                hintStyle:
                    GoogleFonts.poppins(color: colors.primaryDisabledTextColor),
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.45,
              ),
              child: visible.isEmpty
                  ? Padding(
                      padding: const EdgeInsets.symmetric(vertical: 24),
                      child: Text(
                        'No tasks match that search.',
                        style: GoogleFonts.poppins(
                          color: colors.primaryDisabledTextColor,
                        ),
                      ),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      itemCount: visible.length,
                      itemBuilder: (context, index) {
                        final TaskForReplica task = visible[index];
                        final String description =
                            (task.description ?? '').trim();
                        return ListTile(
                          dense: true,
                          contentPadding: EdgeInsets.zero,
                          title: Text(
                            description.isEmpty ? task.uuid : description,
                            style: GoogleFonts.poppins(
                              color: colors.primaryTextColor,
                            ),
                          ),
                          subtitle: task.status == null
                              ? null
                              : Text(
                                  task.status!,
                                  style: GoogleFonts.poppins(
                                    fontSize: TaskWarriorFonts.fontSizeSmall,
                                    color: colors.primaryDisabledTextColor,
                                  ),
                                ),
                          onTap: () => Navigator.of(context).pop(task.uuid),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
