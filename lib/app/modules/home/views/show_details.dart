// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:taskwarrior/api_service.dart';
import 'package:taskwarrior/app/utils/constants/taskwarrior_colors.dart';
import 'package:taskwarrior/app/utils/constants/utilites.dart';
import 'package:taskwarrior/app/utils/theme/app_settings.dart';

class TaskDetails extends StatefulWidget {
  final Tasks task;
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
    return Scaffold(
      backgroundColor: AppSettings.isDarkMode
          ? TaskWarriorColors.kprimaryBackgroundColor
          : TaskWarriorColors.kLightPrimaryBackgroundColor,
      appBar: AppBar(
        foregroundColor: TaskWarriorColors.lightGrey,
        backgroundColor: TaskWarriorColors.kprimaryBackgroundColor,
        title: Text(
          'Task: ${widget.task.description}',
          style: GoogleFonts.poppins(color: TaskWarriorColors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildEditableDetail('Description:', description, (value) {
              setState(() {
                description = value;
                hasChanges = true;
              });
            }),
            _buildEditableDetail('Project:', project, (value) {
              setState(() {
                project = value;
                hasChanges = true;
              });
            }),
            _buildSelectableDetail('Status:', status, ['pending', 'completed'],
                (value) {
              setState(() {
                status = value;
                hasChanges = true;
              });
            }),
            _buildSelectableDetail('Priority:', priority, ['H', 'M', 'L'],
                (value) {
              setState(() {
                priority = value;
                hasChanges = true;
              });
            }),
            _buildDatePickerDetail('Due:', due, (value) {
              setState(() {
                due = value;
                hasChanges = true;
              });
            }),
            _buildDetail('UUID:', widget.task.uuid!),
            _buildDetail('Urgency:', widget.task.urgency.toString()),
            _buildDetail('End:', _buildDate(widget.task.end)),
            _buildDetail('Entry:', _buildDate(widget.task.entry)),
            _buildDetail('Modified:', _buildDate(widget.task.modified)),
          ],
        ),
      ),
      floatingActionButton: hasChanges
          ? FloatingActionButton(
              onPressed: () async {
                await taskDatabase.saveEditedTaskInDB(widget.task.uuid!,
                    description, project, status, priority, due);
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
                );
                // used this for testing
              },
              child: const Icon(Icons.save),
            )
          : null,
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
              data: Theme.of(context).copyWith(
                colorScheme: AppSettings.isDarkMode
                    ? ColorScheme(
                        brightness: Brightness.dark,
                        primary: TaskWarriorColors.white,
                        onPrimary: TaskWarriorColors.black,
                        secondary: TaskWarriorColors.black,
                        onSecondary: TaskWarriorColors.white,
                        error: TaskWarriorColors.red,
                        onError: TaskWarriorColors.black,
                        surface: TaskWarriorColors.black,
                        onSurface: TaskWarriorColors.white,
                      )
                    : ColorScheme(
                        brightness: Brightness.light,
                        primary: TaskWarriorColors.black,
                        onPrimary: TaskWarriorColors.white,
                        secondary: TaskWarriorColors.white,
                        onSecondary: TaskWarriorColors.black,
                        error: TaskWarriorColors.red,
                        onError: TaskWarriorColors.white,
                        surface: TaskWarriorColors.white,
                        onSurface: TaskWarriorColors.black,
                      ),
              ),
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
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppSettings.isDarkMode
            ? TaskWarriorColors.ksecondaryBackgroundColor
            : TaskWarriorColors.kLightSecondaryBackgroundColor,
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
              color: AppSettings.isDarkMode
                  ? TaskWarriorColors.kprimaryTextColor
                  : TaskWarriorColors.kLightSecondaryTextColor,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 18,
                color: AppSettings.isDarkMode
                    ? TaskWarriorColors.kprimaryTextColor
                    : TaskWarriorColors.kLightSecondaryTextColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<String?> _showEditDialog(
      BuildContext context, String label, String initialValue) async {
    final TextEditingController controller =
        TextEditingController(text: initialValue);
    return await showDialog<String>(
      context: context,
      builder: (context) {
        return Utils.showAlertDialog(
          title: Text(
            'Edit $label',
            style: TextStyle(
                color: AppSettings.isDarkMode
                    ? TaskWarriorColors.kprimaryTextColor
                    : TaskWarriorColors.kLightPrimaryTextColor),
          ),
          content: TextField(
            style: TextStyle(
                color: AppSettings.isDarkMode
                    ? TaskWarriorColors.kprimaryTextColor
                    : TaskWarriorColors.kLightPrimaryTextColor),
            controller: controller,
            decoration: InputDecoration(
              hintText: 'Enter new $label',
              hintStyle: TextStyle(
                  color: AppSettings.isDarkMode
                      ? TaskWarriorColors.kprimaryTextColor
                      : TaskWarriorColors.kLightPrimaryTextColor),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Cancel',
                style: TextStyle(
                    color: AppSettings.isDarkMode
                        ? TaskWarriorColors.kprimaryTextColor
                        : TaskWarriorColors.kLightPrimaryTextColor),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(controller.text);
              },
              child: Text(
                'Save',
                style: TextStyle(
                    color: AppSettings.isDarkMode
                        ? TaskWarriorColors.kprimaryTextColor
                        : TaskWarriorColors.kLightPrimaryTextColor),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<String?> _showSelectDialog(BuildContext context, String label,
      String initialValue, List<String> options) async {
    return await showDialog<String>(
      context: context,
      builder: (context) {
        return Utils.showAlertDialog(
          title: Text(
            'Select $label',
            style: TextStyle(
                color: AppSettings.isDarkMode
                    ? TaskWarriorColors.kprimaryTextColor
                    : TaskWarriorColors.kLightPrimaryTextColor),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: options.map((option) {
              return RadioListTile<String>(
                title: Text(
                  option,
                  style: TextStyle(
                      color: AppSettings.isDarkMode
                          ? TaskWarriorColors.kprimaryTextColor
                          : TaskWarriorColors.kLightPrimaryTextColor),
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
}
