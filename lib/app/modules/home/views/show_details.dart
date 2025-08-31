// ignore_for_file: deprecated_member_use, use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:taskwarrior/app/utils/app_settings/app_settings.dart';
import 'package:taskwarrior/app/utils/constants/taskwarrior_colors.dart';
import 'package:taskwarrior/app/utils/constants/utilites.dart';
import 'package:taskwarrior/app/utils/themes/theme_extension.dart';
import 'package:taskwarrior/app/utils/language/sentence_manager.dart';
import 'package:taskwarrior/app/v3/db/task_database.dart';
import 'package:taskwarrior/app/v3/models/task.dart';
import 'package:taskwarrior/app/v3/net/modify.dart';

class TaskDetails extends StatefulWidget {
  final TaskForC task;
  const TaskDetails({super.key, required this.task});

  @override
  State<TaskDetails> createState() => _TaskDetailsState();
}

class _TaskDetailsState extends State<TaskDetails> {
  late String description;
  late String project;
  late String status;
  late String priority;
  late String due;
  late TaskDatabase taskDatabase;

  bool hasChanges = false;

  @override
  void initState() {
    super.initState();
    description = widget.task.description;
    project = widget.task.project!;
    status = widget.task.status;
    priority = widget.task.priority!;
    due = widget.task.due ?? '-';
    due = _buildDate(due);
    setState(() {
      taskDatabase = TaskDatabase();
      taskDatabase.open();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    taskDatabase = TaskDatabase();
    taskDatabase.open();
  }

  @override
  Widget build(BuildContext context) {
    TaskwarriorColorTheme tColors =
        Theme.of(context).extension<TaskwarriorColorTheme>()!;
    return WillPopScope(
      onWillPop: () async {
        if (hasChanges) {
          final action = await _showUnsavedChangesDialog(context);
          if (action == UnsavedChangesAction.cancel) {
            return Future.value(false);
          } else if (action == UnsavedChangesAction.save) {
            await _saveTask();
          }
        }
        return Future.value(true);
      },
      child: Scaffold(
        backgroundColor: tColors.primaryBackgroundColor,
        appBar: AppBar(
          foregroundColor: TaskWarriorColors.lightGrey,
          backgroundColor: TaskWarriorColors.kprimaryBackgroundColor,
          title: Text(
            '${SentenceManager(currentLanguage: AppSettings.selectedLanguage).sentences.task}: ${widget.task.description}',
            style: GoogleFonts.poppins(color: TaskWarriorColors.white),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: [
              _buildEditableDetail(
                  '${SentenceManager(currentLanguage: AppSettings.selectedLanguage).sentences.detailPageDescription}:',
                  description, (value) {
                setState(() {
                  description = value;
                  hasChanges = true;
                });
              }),
              _buildEditableDetail(
                  '${SentenceManager(currentLanguage: AppSettings.selectedLanguage).sentences.project}:',
                  project, (value) {
                setState(() {
                  project = value;
                  hasChanges = true;
                });
              }),
              _buildSelectableDetail(
                  '${SentenceManager(currentLanguage: AppSettings.selectedLanguage).sentences.detailPageStatus}:',
                  status,
                  ['pending', 'completed'], (value) {
                setState(() {
                  status = value;
                  hasChanges = true;
                });
              }),
              _buildSelectableDetail(
                  '${SentenceManager(currentLanguage: AppSettings.selectedLanguage).sentences.detailPagePriority}:',
                  priority,
                  ['H', 'M', 'L'], (value) {
                setState(() {
                  priority = value;
                  hasChanges = true;
                });
              }),
              _buildDatePickerDetail(
                  '${SentenceManager(currentLanguage: AppSettings.selectedLanguage).sentences.homePageDue}:',
                  due, (value) {
                setState(() {
                  due = value;
                  hasChanges = true;
                });
              }),
              _buildDetail('UUID:', widget.task.uuid!),
              _buildDetail(
                  '${SentenceManager(currentLanguage: AppSettings.selectedLanguage).sentences.detailPageUrgency}:',
                  widget.task.urgency.toString()),
              _buildDetail(
                  '${SentenceManager(currentLanguage: AppSettings.selectedLanguage).sentences.detailPageEnd}:',
                  _buildDate(widget.task.end)),
              _buildDetail(
                  '${SentenceManager(currentLanguage: AppSettings.selectedLanguage).sentences.detailPageEntry}:',
                  _buildDate(widget.task.entry)),
              _buildDetail(
                  '${SentenceManager(currentLanguage: AppSettings.selectedLanguage).sentences.detailPageModified}:',
                  _buildDate(widget.task.modified)),
            ],
          ),
        ),
        floatingActionButton: hasChanges
            ? FloatingActionButton(
                onPressed: () async {
                  await _saveTask();
                },
                child: const Icon(Icons.save),
              )
            : null,
      ),
    );
  }

  Widget _buildEditableDetail(
      String label, String value, Function(String) onChanged) {
    return InkWell(
      onTap: () async {
        final result = await _showEditDialog(context, label, value);
        if (result != null) {
          onChanged(result);
        }
      },
      child: _buildDetail(label, value),
    );
  }

  Widget _buildSelectableDetail(String label, String value,
      List<String> options, Function(String) onChanged) {
    return InkWell(
      onTap: () async {
        final result = await _showSelectDialog(context, label, value, options);
        if (result != null) {
          onChanged(result);
        }
      },
      child: _buildDetail(label, value),
    );
  }

  Widget _buildDatePickerDetail(
      String label, String value, Function(String) onChanged) {
    return InkWell(
      onTap: () async {
        final DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: value != '-' ? DateTime.parse(value) : DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime(2101),
          builder: (BuildContext context, Widget? child) {
            return Theme(
              data: Theme.of(context),
              child: child!,
            );
          },
        );
        if (pickedDate != null) {
          final TimeOfDay? pickedTime = await showTimePicker(
            context: context,
            initialTime: TimeOfDay.fromDateTime(
                value != '-' ? DateTime.parse(value) : DateTime.now()),
          );
          if (pickedTime != null) {
            final DateTime fullDateTime = DateTime(
                pickedDate.year,
                pickedDate.month,
                pickedDate.day,
                pickedTime.hour,
                pickedTime.minute);
            onChanged(DateFormat('yyyy-MM-dd HH:mm:ss').format(fullDateTime));
          }
        }
      },
      child: _buildDetail(label, value),
    );
  }

  Widget _buildDetail(String label, String value) {
    TaskwarriorColorTheme tColors =
        Theme.of(context).extension<TaskwarriorColorTheme>()!;
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
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: tColors.primaryTextColor,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 18,
                color: tColors.primaryTextColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<String?> _showEditDialog(
      BuildContext context, String label, String initialValue) async {
    TaskwarriorColorTheme tColors =
        Theme.of(context).extension<TaskwarriorColorTheme>()!;
    final TextEditingController controller =
        TextEditingController(text: initialValue);
    return await showDialog<String>(
      context: context,
      builder: (context) {
        return Utils.showAlertDialog(
          title: Text(
            '${SentenceManager(currentLanguage: AppSettings.selectedLanguage).sentences.edit} $label',
            style: TextStyle(color: tColors.primaryTextColor),
          ),
          content: TextField(
            style: TextStyle(color: tColors.primaryTextColor),
            controller: controller,
            decoration: InputDecoration(
              hintText:
                  '${SentenceManager(currentLanguage: AppSettings.selectedLanguage).sentences.enterNew} $label',
              hintStyle: TextStyle(color: tColors.primaryTextColor),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                SentenceManager(currentLanguage: AppSettings.selectedLanguage)
                    .sentences
                    .cancel,
                style: TextStyle(color: tColors.primaryTextColor),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(controller.text);
              },
              child: Text(
                SentenceManager(currentLanguage: AppSettings.selectedLanguage)
                    .sentences
                    .save,
                style: TextStyle(color: tColors.primaryTextColor),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<String?> _showSelectDialog(BuildContext context, String label,
      String initialValue, List<String> options) async {
    TaskwarriorColorTheme tColors =
        Theme.of(context).extension<TaskwarriorColorTheme>()!;
    return await showDialog<String>(
      context: context,
      builder: (context) {
        return Utils.showAlertDialog(
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
                onChanged: (value) {
                  Navigator.of(context).pop(value);
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }

  String _buildDate(String? dateString) {
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

  Future<UnsavedChangesAction?> _showUnsavedChangesDialog(
      BuildContext context) async {
    TaskwarriorColorTheme tColors =
        Theme.of(context).extension<TaskwarriorColorTheme>()!;
    return showDialog<UnsavedChangesAction>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Utils.showAlertDialog(
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
              onPressed: () {
                Navigator.of(context).pop(UnsavedChangesAction.cancel);
              },
              child: Text(
                  SentenceManager(currentLanguage: AppSettings.selectedLanguage)
                      .sentences
                      .cancel),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(UnsavedChangesAction.discard);
              },
              child: Text(
                  SentenceManager(currentLanguage: AppSettings.selectedLanguage)
                      .sentences
                      .dontSave),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(UnsavedChangesAction.save);
              },
              child: Text(
                  SentenceManager(currentLanguage: AppSettings.selectedLanguage)
                      .sentences
                      .save),
            ),
          ],
        );
      },
    );
  }

  Future<void> _saveTask() async {
    await taskDatabase.saveEditedTaskInDB(
      widget.task.uuid!,
      description,
      project,
      status,
      priority,
      due,
    );
    setState(() {
      hasChanges = false;
    });
    modifyTaskOnTaskwarrior(
      description,
      project,
      due,
      priority,
      status,
      widget.task.uuid!,
      widget.task.id.toString(),
    );
  }
}

enum UnsavedChangesAction { save, discard, cancel }
