// ignore_for_file: deprecated_member_use, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:taskwarrior/app/modules/home/controllers/home_controller.dart';
import 'package:taskwarrior/app/utils/app_settings/app_settings.dart';
import 'package:taskwarrior/app/utils/constants/utilites.dart';
import 'package:taskwarrior/app/utils/themes/theme_extension.dart';
import 'package:taskwarrior/app/utils/language/sentence_manager.dart';
import 'package:taskwarrior/app/v3/db/task_database.dart';
import 'package:taskwarrior/app/v3/models/annotation.dart';
import 'package:taskwarrior/app/v3/models/task.dart';
import 'package:taskwarrior/app/v3/champion/replica.dart';
import 'package:taskwarrior/app/v3/champion/models/task_for_replica.dart';
import 'package:taskwarrior/app/v3/net/modify.dart';

enum UnsavedChangesAction { save, discard, cancel }

class TaskcDetailsController extends GetxController {
  late final dynamic initialTask;
  late TaskDatabase taskDatabase;

  final hasChanges = false.obs;

  late RxString description;
  late RxString project;
  late RxString status;
  late RxString priority;
  late RxString due;
  late RxString start;
  late RxString wait;
  late RxList<String> tags;
  late RxList<String> depends;
  late RxString rtype;
  late RxString recur;
  late RxList<Annotation> annotations;
  late RxList<String> previousTags = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    initialTask = Get.arguments;
    _initializeState(initialTask);
    taskDatabase = TaskDatabase();
    taskDatabase.open();
  }

  void _initializeState(dynamic task) {
    // Support both TaskForC (local tasks) and TaskForReplica (replica tasks)
    if (task is TaskForC) {
      description = task.description.obs;
      project = (task.project ?? 'None').obs;
      status = task.status.obs;
      priority = (task.priority ?? 'None').obs;
      due = formatDate(task.due).obs;
      start = "".obs;
      wait = "".obs;
      tags = task.tags != null
          ? task.tags!.map((e) => e.toString()).toList().obs
          : <String>[].obs;
      previousTags = tags.toList().obs;
      depends = "".split(",").obs;
      rtype = (task.rtype ?? '').obs;
      recur = (task.recur ?? '').obs;
      annotations = <Annotation>[].obs;
    } else if (task is TaskForReplica) {
      description = (task.description ?? '').obs;
      project = (task.project ?? 'None').obs;
      status = (task.status ?? '').obs;
      priority = (task.priority ?? 'None').obs;
      // TaskForReplica stores epoch seconds; convert to ISO string for formatting
      debugPrint('Replica task due: ${task.due}');
      due = formatDate(task.due).obs;
      // Initialize start/wait from replica model (may be ISO or epoch)
      start = formatDate(task.start).obs;
      wait = formatDate(task.wait).obs;
      debugPrint(
          'Replica task tags while init: ${task.tags ?? task.tags?.join(", ")}');
      tags = task.tags != null
          ? task.tags!.map((e) => e.toString()).toList().obs
          : <String>[].obs;
      previousTags = tags.toList().obs;
      depends = "".split(",").obs;
      rtype = (task.rtype ?? '').obs;
      recur = (task.recur ?? '').obs;
      annotations = <Annotation>[].obs;
    } else {
      // Fallback
      description = ''.obs;
      project = 'None'.obs;
      status = ''.obs;
      priority = 'None'.obs;
      due = 'None'.obs;
      start = "".obs;
      wait = "".obs;
      tags = <String>[].obs;
      previousTags = <String>[].obs;
      depends = "".split(",").obs;
      rtype = "".obs;
      recur = "".obs;
      annotations = <Annotation>[].obs;
    }
  }

  String formatDate(dynamic date) {
    if (date == null) return 'None';
    // If date is epoch seconds as int
    bool is24hrFormat = AppSettings.use24HourFormatRx.value;
    final pattern = is24hrFormat
        ? 'EEE, yyyy-MM-dd HH:mm:ss'
        : 'EEE, yyyy-MM-dd hh:mm:ss a';

    if (date == null) return 'None';

    if (date is int) {
      try {
        final dt = DateTime.fromMillisecondsSinceEpoch(date * 1000);
        return DateFormat(pattern).format(dt.toLocal());
      } catch (e) {
        debugPrint('Error formatting epoch date: $e');
        return 'None';
      }
    }

    if (date is DateTime) {
      try {
        return DateFormat(pattern).format(date.toLocal());
      } catch (e) {
        debugPrint('Error formatting DateTime: $e');
        return 'None';
      }
    }

    final dateString = date?.toString() ?? '';
    if (dateString.isEmpty || dateString == 'None') return 'None';

    try {
      final parsedDate = DateTime.parse(dateString).toLocal();
      return DateFormat(pattern).format(parsedDate);
    } catch (e) {
      debugPrint('Error parsing date: $dateString $e');
      return 'None';
    }
  }

  DateTime? _parseUiDate(String value, String pattern) {
    if (value == 'None' || value.isEmpty) return null;
    try {
      return DateFormat(pattern).parse(value).toUtc();
    } catch (_) {
      try {
        return DateTime.parse(value).toUtc();
      } catch (_) {
        return null;
      }
    }
  }

  void updateField<T>(Rx<T> field, T value) {
    if (field.value != value) {
      field.value = value;
      hasChanges.value = true;
    }
  }

  void updateListField(RxList<String> field, String value) {
    final newList = value.split(',').map((e) => e.trim()).toList();
    if (field.toList().toString() != newList.toString()) {
      field.assignAll(newList);
      hasChanges.value = true;
    }
  }

  // Safe accessors for fields on the initial task so views don't attempt to
  // read properties that don't exist on TaskForReplica (which is a different
  // model shape than TaskForC).
  String initialTaskUuidDisplay() {
    try {
      if (initialTask == null) return 'None';
      if (initialTask is TaskForC)
        return (initialTask.uuid ?? 'None')?.toString() ?? 'None';
      if (initialTask is TaskForReplica) return initialTask.uuid ?? 'None';
      return 'None';
    } catch (_) {
      return 'None';
    }
  }

  String initialTaskUrgencyDisplay() {
    try {
      if (initialTask is TaskForC) {
        final u = initialTask.urgency as double?;
        return (u != null) ? u.toStringAsFixed(2) : 'None';
      }
      // TaskForReplica doesn't have urgency
      return 'None';
    } catch (_) {
      return 'None';
    }
  }

  // Provide values suitable for controller.formatDate(...) without accessing
  // missing properties directly from the view.
  dynamic initialTaskEntryForFormatting() {
    try {
      if (initialTask is TaskForC) return initialTask.entry;
      return null;
    } catch (_) {
      return null;
    }
  }

  dynamic initialTaskEndForFormatting() {
    try {
      if (initialTask is TaskForC) return initialTask.end;
      return null;
    } catch (_) {
      return null;
    }
  }

  dynamic initialTaskModifiedForFormatting() {
    try {
      if (initialTask is TaskForC) return initialTask.modified;
      if (initialTask is TaskForReplica) return initialTask.modified;
      return null;
    } catch (_) {
      return null;
    }
  }

  // Shorthand helpers for view logic
  bool get isReplicaTask => initialTask is TaskForReplica;
  bool get isLocalTask => initialTask is TaskForC;

  void processTagsLists() {
    final itemsToMove = previousTags.toSet().difference(tags.toSet());
    tags.addAll(itemsToMove.map((item) => '-$item'));
    previousTags.removeWhere((item) => itemsToMove.contains(item));
  }

  Future<void> saveTask() async {
    bool is24hrFormat = AppSettings.use24HourFormatRx.value;
    final datePattern = is24hrFormat
        ? 'EEE, yyyy-MM-dd HH:mm:ss'
        : 'EEE, yyyy-MM-dd hh:mm:ss a';
    final dueDate = _parseUiDate(due.string, datePattern);
    final waitDate = _parseUiDate(wait.string, datePattern);

    if (tags.length == 1 && tags[0] == "") {
      tags.clear();
    }
    if (initialTask is TaskForC) {
      final bool shouldSpawnRecurrence = status.string == 'completed' &&
          initialTask.status != 'completed' &&
          recur.string.isNotEmpty;
      await taskDatabase.saveEditedTaskInDB(
        initialTask.uuid!,
        description.string,
        project.string,
        status.string,
        priority.string,
        dueDate?.toIso8601String() ?? '',
        tags.toList(),
        recur: recur.string.isNotEmpty ? recur.string : null,
        rtype: recur.string.isNotEmpty ? 'periodic' : null,
      );
      if (shouldSpawnRecurrence) {
        await taskDatabase.markTaskAsCompleted(
          initialTask.uuid!,
          forceRecurrence: true,
        );
      }
      hasChanges.value = false;
      debugPrint('Task saved in local DB ${description.string}');
      processTagsLists();
      await modifyTaskOnTaskwarrior(
        description.string,
        project.string,
        dueDate?.toIso8601String() ?? '',
        priority.string,
        status.string,
        initialTask.uuid!,
        initialTask.id.toString(),
        tags.toList(),
        recur: recur.string.isNotEmpty ? recur.string : null,
        rtype: recur.string.isNotEmpty ? 'periodic' : null,
      );
      try {
        await Get.find<HomeController>().fetchTasksFromDB();
      } catch (_) {}
    } else if (initialTask is TaskForReplica) {
      debugPrint(
          'Saving replica task changes... status ${status.string} ${tags.join(", ")}');
      final int nowEpoch = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      final modifiedTask = TaskForReplica(
        modified: nowEpoch,
        due: dueDate?.toIso8601String(),
        start: () {
          if (start.string == 'None' || start.string.isEmpty) return null;
          if (start.string == "stop") return "stop";
          return _parseUiDate(start.string, datePattern)?.toIso8601String();
        }(),
        wait: waitDate?.toIso8601String(),
        status: status.string.isNotEmpty ? status.string : null,
        description: description.string.isNotEmpty ? description.string : null,
        tags: tags.isNotEmpty ? tags.toList() : null,
        uuid: initialTask.uuid ?? '',
        priority: priority.string.isNotEmpty ? priority.string : null,
        project: project.string != 'None' ? project.string : null,
        recur: recur.string.isNotEmpty ? recur.string : null,
        rtype: recur.string.isNotEmpty ? 'periodic' : null,
        mask: (initialTask.mask ?? '').toString(),
        imask: (initialTask.imask ?? '').toString(),
        parent: (initialTask.parent ?? '').toString(),
      );
      debugPrint('Modified replica task: $modifiedTask');
      hasChanges.value = false;
      processTagsLists();
      await Replica.modifyTaskInReplica(modifiedTask);
      try {
        final HomeController homeController = Get.find<HomeController>();
        await homeController.refreshReplicaTasks();
      } catch (e) {
        debugPrint('Could not find HomeController to refresh tasks: $e');
      }
    }
  }

  Future<bool> handleWillPop() async {
    if (hasChanges.value) {
      final action = await _showUnsavedChangesDialog();
      if (action == UnsavedChangesAction.save) {
        await saveTask();
        return true;
      } else if (action == UnsavedChangesAction.discard) {
        return true;
      } else {
        return false;
      }
    }
    return true;
  }

  Future<void> pickDateTime(RxString field) async {
    final BuildContext context = Get.context!;
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: field.value != 'None'
          ? DateTime.tryParse(field.value) ?? DateTime.now()
          : DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(field.value != 'None'
            ? DateTime.tryParse(field.value) ?? DateTime.now()
            : DateTime.now()),
      );

      DateTime fullDateTime;
      if (pickedTime != null) {
        fullDateTime = DateTime(pickedDate.year, pickedDate.month,
            pickedDate.day, pickedTime.hour, pickedTime.minute);
      } else {
        fullDateTime = pickedDate;
      }
      updateField(
          field, DateFormat('yyyy-MM-dd HH:mm:ss').format(fullDateTime));
    }
  }

  Future<String?> showEditDialog(String label, String initialValue) async {
    final BuildContext context = Get.context!;
    TaskwarriorColorTheme tColors =
        Theme.of(context).extension<TaskwarriorColorTheme>()!;
    final TextEditingController textController =
        TextEditingController(text: initialValue);

    return await Get.dialog<String>(
      Utils.showAlertDialog(
        title: Text(
          '${SentenceManager(currentLanguage: AppSettings.selectedLanguage).sentences.edit} $label',
          style: TextStyle(color: tColors.primaryTextColor),
        ),
        content: TextField(
          style: TextStyle(color: tColors.primaryTextColor),
          controller: textController,
          decoration: InputDecoration(
            hintText:
                '${SentenceManager(currentLanguage: AppSettings.selectedLanguage).sentences.enterNew} $label',
            hintStyle: TextStyle(color: tColors.primaryTextColor),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              SentenceManager(currentLanguage: AppSettings.selectedLanguage)
                  .sentences
                  .cancel,
              style: TextStyle(color: tColors.primaryTextColor),
            ),
          ),
          TextButton(
            onPressed: () => Get.back(result: textController.text),
            child: Text(
              SentenceManager(currentLanguage: AppSettings.selectedLanguage)
                  .sentences
                  .save,
              style: TextStyle(color: tColors.primaryTextColor),
            ),
          ),
        ],
      ),
    );
  }

  Future<String?> showSelectDialog(
      String label, String initialValue, List<String> options) async {
    final BuildContext context = Get.context!;
    TaskwarriorColorTheme tColors =
        Theme.of(context).extension<TaskwarriorColorTheme>()!;

    return await Get.dialog<String>(
      Utils.showAlertDialog(
        title: Text(
          '${SentenceManager(currentLanguage: AppSettings.selectedLanguage).sentences.select} $label',
          style: TextStyle(color: tColors.primaryTextColor),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: options.map((option) {
            return RadioListTile<String>(
              title: Text(
                option,
                style: TextStyle(color: tColors.primaryTextColor),
              ),
              value: option,
              groupValue: initialValue,
              onChanged: (value) => Get.back(result: value),
            );
          }).toList(),
        ),
      ),
    );
  }

  Future<UnsavedChangesAction?> _showUnsavedChangesDialog() async {
    final BuildContext context = Get.context!;
    TaskwarriorColorTheme tColors =
        Theme.of(context).extension<TaskwarriorColorTheme>()!;
    return Get.dialog<UnsavedChangesAction>(
      barrierDismissible: false,
      Utils.showAlertDialog(
        title: Text(
          SentenceManager(currentLanguage: AppSettings.selectedLanguage)
              .sentences
              .unsavedChanges,
          style: TextStyle(color: tColors.primaryTextColor),
        ),
        content: Text(
          SentenceManager(currentLanguage: AppSettings.selectedLanguage)
              .sentences
              .unsavedChangesWarning,
          style: TextStyle(color: tColors.primaryTextColor),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Get.back(result: UnsavedChangesAction.cancel),
            child: Text(
                SentenceManager(currentLanguage: AppSettings.selectedLanguage)
                    .sentences
                    .cancel),
          ),
          TextButton(
            onPressed: () => Get.back(result: UnsavedChangesAction.discard),
            child: Text(
                SentenceManager(currentLanguage: AppSettings.selectedLanguage)
                    .sentences
                    .dontSave),
          ),
          TextButton(
            onPressed: () => Get.back(result: UnsavedChangesAction.save),
            child: Text(
                SentenceManager(currentLanguage: AppSettings.selectedLanguage)
                    .sentences
                    .save),
          ),
        ],
      ),
    );
  }
}
