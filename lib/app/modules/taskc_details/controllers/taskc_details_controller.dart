// ignore_for_file: deprecated_member_use, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:taskwarrior/app/utils/app_settings/app_settings.dart';
import 'package:taskwarrior/app/utils/constants/utilites.dart';
import 'package:taskwarrior/app/utils/themes/theme_extension.dart';
import 'package:taskwarrior/app/utils/language/sentence_manager.dart';
import 'package:taskwarrior/app/v3/db/task_database.dart';
import 'package:taskwarrior/app/v3/models/annotation.dart';
import 'package:taskwarrior/app/v3/models/task.dart';
import 'package:taskwarrior/app/v3/net/modify.dart';

enum UnsavedChangesAction { save, discard, cancel }

class TaskcDetailsController extends GetxController {
  late final TaskForC initialTask;
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

  @override
  void onInit() {
    super.onInit();
    initialTask = Get.arguments as TaskForC;
    _initializeState(initialTask);
    taskDatabase = TaskDatabase();
    taskDatabase.open();
  }

  void _initializeState(TaskForC task) {
    description = task.description.obs;
    project = (task.project ?? '-').obs;
    status = task.status.obs;
    priority = (task.priority ?? '-').obs;
    due = formatDate(task.due).obs;
    start = "".obs;
    wait = "".obs;
    tags = "".split(",").obs;
    depends = "".split(",").obs;
    rtype = "".obs;
    recur = "".obs;
    annotations = <Annotation>[].obs;
  }

  String formatDate(String? dateString) {
    if (dateString == null || dateString.isEmpty || dateString == '-') {
      return '-';
    }
    try {
      DateTime parsedDate = DateTime.parse(dateString);
      return DateFormat('yyyy-MM-dd HH:mm:ss').format(parsedDate);
    } catch (e) {
      debugPrint('Error parsing date: $dateString');
      return '-';
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

  Future<void> saveTask() async {
    if (tags.length == 1 && tags[0] == "") {
      tags.clear();
    }
    await taskDatabase.saveEditedTaskInDB(
      initialTask.uuid!,
      description.string,
      project.string,
      status.string,
      priority.string,
      due.string,
      tags.toList(),
    );
    hasChanges.value = false;
    debugPrint('Task saved in local DB ${description.string}');
    await modifyTaskOnTaskwarrior(
      description.string,
      project.string,
      due.string,
      priority.string,
      status.string,
      initialTask.uuid!,
      initialTask.id.toString(),
      tags.toList(),
    );
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
      initialDate: field.value != '-'
          ? DateTime.tryParse(field.value) ?? DateTime.now()
          : DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(field.value != '-'
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
