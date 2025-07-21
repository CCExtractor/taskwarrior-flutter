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
import 'package:taskwarrior/app/v3/models/annotation.dart';
import 'package:taskwarrior/app/v3/models/task.dart'; // Ensure this path is correct for your new model
// import 'package:taskwarrior/app/v3/net/modify.dart';

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
  late String start;
  late String wait;
  late List<String> tags;
  late List<String> depends;
  late String rtype;
  late String recur;
  late List<Annotation> annotations;

  late TaskDatabase taskDatabase;

  bool hasChanges = false;

  @override
  void initState() {
    super.initState();
    description = widget.task.description;
    project = widget.task.project ?? '-';
    status = widget.task.status;
    priority = widget.task.priority ?? '-';
    due = widget.task.due ?? '-';
    start = widget.task.start ?? '-';
    wait = widget.task.wait ?? '-';
    tags = widget.task.tags ?? [];
    depends = widget.task.depends ?? [];
    rtype = widget.task.rtype ?? '-';
    recur = widget.task.recur ?? '-';
    annotations = widget.task.annotations ?? [];

    due = _buildDate(due); // Format the date for display
    start = _buildDate(start);
    wait = _buildDate(wait);

    setState(() {
      taskDatabase = TaskDatabase();
      taskDatabase.open();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // This part seems redundant if taskDatabase.open() is already in initState
    // and ideally, the database connection should be managed more robustly
    // (e.g., singleton, provider, or passed down).
    // However, keeping it as per original logic, but be aware of potential multiple openings.
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
                  ['H', 'M', 'L', '-'], (value) {
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
              _buildDatePickerDetail(
                  '${SentenceManager(currentLanguage: AppSettings.selectedLanguage).sentences.detailPageStart}:',
                  start, (value) {
                setState(() {
                  start = value;
                  hasChanges = true;
                });
              }),
              _buildDatePickerDetail(
                  '${SentenceManager(currentLanguage: AppSettings.selectedLanguage).sentences.detailPageWait}:',
                  wait, (value) {
                setState(() {
                  wait = value;
                  hasChanges = true;
                });
              }),
              _buildEditableDetail(
                  '${SentenceManager(currentLanguage: AppSettings.selectedLanguage).sentences.detailPageTags}:',
                  tags.join(', '), (value) {
                setState(() {
                  tags = value.split(',').map((e) => e.trim()).toList();
                  hasChanges = true;
                });
              }),
              _buildEditableDetail('Depends:', depends.join(', '), (value) {
                setState(() {
                  depends = value.split(',').map((e) => e.trim()).toList();
                  hasChanges = true;
                });
              }),
              _buildEditableDetail('Rtype:', rtype, (value) {
                setState(() {
                  rtype = value;
                  hasChanges = true;
                });
              }),
              _buildEditableDetail('Recur:', recur, (value) {
                setState(() {
                  recur = value;
                  hasChanges = true;
                });
              }),
              _buildDetail('UUID:', widget.task.uuid ?? '-'),
              _buildDetail(
                  '${SentenceManager(currentLanguage: AppSettings.selectedLanguage).sentences.detailPageUrgency}:',
                  widget.task.urgency?.toStringAsFixed(2) ?? '-'),
              _buildDetail(
                  '${SentenceManager(currentLanguage: AppSettings.selectedLanguage).sentences.detailPageEnd}:',
                  _buildDate(widget.task.end)),
              _buildDetail(
                  '${SentenceManager(currentLanguage: AppSettings.selectedLanguage).sentences.detailPageEntry}:',
                  _buildDate(widget.task.entry)),
              _buildDetail(
                  '${SentenceManager(currentLanguage: AppSettings.selectedLanguage).sentences.detailPageModified}:',
                  _buildDate(widget.task.modified)),
              _buildDetail(
                  '${SentenceManager(currentLanguage: AppSettings.selectedLanguage).sentences}:',
                  annotations.isNotEmpty
                      ? annotations.map((e) => e.description).join('\n')
                      : '-'),
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
          initialDate: value != '-'
              ? DateTime.tryParse(value) ?? DateTime.now()
              : DateTime.now(),
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
            initialTime: TimeOfDay.fromDateTime(value != '-'
                ? DateTime.tryParse(value) ?? DateTime.now()
                : DateTime.now()),
          );
          if (pickedTime != null) {
            final DateTime fullDateTime = DateTime(
                pickedDate.year,
                pickedDate.month,
                pickedDate.day,
                pickedTime.hour,
                pickedTime.minute);
            onChanged(DateFormat('yyyy-MM-dd HH:mm:ss').format(fullDateTime));
          } else {
            // If only date is picked, use current time
            onChanged(DateFormat('yyyy-MM-dd HH:mm:ss').format(pickedDate));
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
    // Update the TaskForC object with the new values
    // final updatedTask = TaskForC(
    //   id: widget.task.id,
    //   description: description,
    //   project: project == '-' ? null : project,
    //   status: status,
    //   uuid: widget.task.uuid,
    //   urgency: widget
    //       .task.urgency, // Urgency is typically calculated, not edited directly
    //   priority: priority == '-' ? null : priority,
    //   due: due == '-' ? null : due,
    //   start: start == '-' ? null : start,
    //   end: widget
    //       .task.end, // 'end' is usually set when completed, not edited directly
    //   entry: widget.task.entry, // 'entry' is static
    //   wait: wait == '-' ? null : wait,
    //   modified: DateFormat('yyyy-MM-dd HH:mm:ss')
    //       .format(DateTime.now()), // Update modified time
    //   tags: tags.isEmpty ? null : tags,
    //   depends: depends.isEmpty ? null : depends,
    //   rtype: rtype == '-' ? null : rtype,
    //   recur: recur == '-' ? null : recur,
    //   annotations: annotations.isEmpty ? null : annotations,
    // );

    setState(() {
      hasChanges = false;
    });
    // Assuming modifyTaskOnTaskwarrior takes the updated TaskForC object
    // await modifyTaskOnTaskwarrior(updatedTask);
  }
}

enum UnsavedChangesAction { save, discard, cancel }
