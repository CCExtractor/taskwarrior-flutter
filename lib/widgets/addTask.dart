// ignore_for_file: file_names

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:material_segmented_control/material_segmented_control.dart';

import 'package:taskwarrior/config/app_settings.dart';
import 'package:taskwarrior/model/storage/storage_widget.dart';
import 'package:taskwarrior/services/notification_services.dart';
import 'package:taskwarrior/widgets/taskfunctions/taskparser.dart';
import 'package:taskwarrior/widgets/taskw.dart';

class AddTaskDialog extends StatefulWidget {
  const AddTaskDialog({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _AddTaskDialogState createState() => _AddTaskDialogState();
}

class _AddTaskDialogState extends State<AddTaskDialog> {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final dateController = TextEditingController();
  final timeController = TextEditingController();
  //final prioritycontroller;
  DateTime? due;
  DateTime? date;
  TimeOfDay? time;
  String dueString = '';
  String priority = 'M';
  String? dueError;
  final Map<int, Widget> _children = {
    0: const Padding(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Text('High'),
    ),
    1: const Padding(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Text('Medium'),
    ),
    2: const Padding(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Text('Low'),
    ),
  };
  int _currentSelection = 1;
  @override
  void initState() {
    nameController.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    nameController.dispose();
    dateController.dispose();
    timeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const title = 'Add Task';
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Center(
        child: SingleChildScrollView(
          child: AlertDialog(
            backgroundColor: AppSettings.isDarkMode
                ? const Color.fromARGB(255, 220, 216, 216)
                : Colors.white,
            title: const Center(child: Text(title)),
            content: Form(
              key: formKey,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    const SizedBox(height: 6),
                    buildLabel("Task Title"),
                    buildName(),
                    const SizedBox(height: 12),
                    buildLabel("Due date & time"),
                    buildDueDateTime(),
                    buildDueError(context),
                    const SizedBox(height: 8),
                    buildLabel("Task Priority"),
                    buildPriority(context),
                  ],
                ),
              ),
            ),
            actions: <Widget>[
              buildCancelButton(context),
              buildAddButton(context),
            ],
          ),
        ),
      ),
    );
  }

  void showDateDialog() async {
    var initialDate = due?.toLocal() ?? DateTime.now();
    DateTime? tDate;
    tDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1990), // >= 1980-01-01T00:00:00.000Z
      lastDate: DateTime(2037, 12, 31), // < 2038-01-19T03:14:08.000Z
    );
    if (tDate != null) {
      date = tDate;
      FocusManager.instance.primaryFocus?.unfocus();
    }
    if (date != null) {
      setState(() {
        dateController.text = DateFormat("dd-MM-yyyy")
            .format(date!)
            .toString()
            .replaceAll('/', '-');
      });
    }
    if (date != null && time != null) {
      combineDateTime();
      setState(() {
        dueError = null;
      });
    }
  }

  void showTimeDialog() async {
    var initialDate = due?.toLocal() ?? DateTime.now();
    TimeOfDay? tTime;
    tTime = await showTimePicker(
        context: context, initialTime: TimeOfDay.fromDateTime(initialDate));
    if (tTime != null) {
      time = tTime;
    }
    if (time != null) {
      FocusManager.instance.primaryFocus?.unfocus();
      String hrStr;
      int hrInt = int.parse(time.toString().substring(10, 12));
      hrStr = hrInt.toString();
      if (hrStr.length == 1) {
        hrStr = '0$hrStr';
      }
      String min = time.toString().substring(13, 15);
      setState(() {
        timeController.text = "$hrStr:$min";
      });
    }
    if (date != null && time != null) {
      combineDateTime();
      setState(() {
        dueError = null;
      });
    }
  }

  void combineDateTime() {
    var dateTime = date!.add(
      Duration(
        hours: time!.hour,
        minutes: time!.minute,
      ),
    );
    dateTime = dateTime.add(
      Duration(
        hours: time!.hour - dateTime.hour,
      ),
    );
    due = dateTime.toUtc();
    NotificationService notificationService = NotificationService();
    notificationService.initiliazeNotification();

    if ((dateTime.millisecondsSinceEpoch -
            DateTime.now().millisecondsSinceEpoch) >
        0) {
      notificationService.sendNotification(dateTime, nameController.text);
    }

    dueString = DateFormat("dd-MM-yyyy HH:mm").format(dateTime);
    setState(() {});
  }

  Widget buildName() {
    return TextFormField(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        controller: nameController,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.fromLTRB(16, 8, 0, 8),
          border: const OutlineInputBorder(),
          hintText: 'Enter Task',
          suffixIcon: nameController.text.isNotEmpty
              ? IconButton(
                  tooltip: "Clear",
                  icon: const Icon(
                    Icons.clear,
                    size: 20,
                  ),
                  onPressed: () {
                    setState(() {
                      nameController.clear();
                    });
                  },
                )
              : null,
        ),
        validator: (name) {
          if (name == null || name.trim().isEmpty) {
            return 'You cannot leave this field empty!';
          }
          return null;
        });
  }

  Widget buildDueError(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 8, 0, 0),
      child: dueError != null
          ? Text(
              dueError!,
              style: Theme.of(context)
                  .textTheme
                  .bodySmall!
                  .copyWith(color: Theme.of(context).colorScheme.error),
            )
          : null,
    );
  }

  Widget buildDueDateTime() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          constraints: const BoxConstraints(maxWidth: 130),
          child: TextFormField(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            controller: dateController,
            onTap: () {
              showDateDialog();
            },
            onChanged: (value) {
              if (date == null) {
                setState(() {
                  dueError = "Due date & time can't be empty!";
                });
              } else if (date != null && time != null) {
                setState(() {
                  dueError = null;
                });
              }
            },
            validator: (value) {
              if (date == null) {
                return "";
              }
              return null;
            },
            readOnly: true,
            decoration: const InputDecoration(
              errorStyle: TextStyle(height: 0, fontSize: 0),
              hintText: 'Due Date',
              contentPadding: EdgeInsets.fromLTRB(16, 8, 0, 8),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.horizontal(left: Radius.circular(4)),
              ),
            ),
          ),
        ),
        Container(
          constraints: const BoxConstraints(maxWidth: 100),
          child: TextFormField(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            controller: timeController,
            onTap: () {
              showTimeDialog();
            },
            onChanged: (value) {
              if (date == null) {
                setState(() {
                  dueError = "Due date & time can't be empty!";
                });
              } else if (date != null && time != null) {
                setState(() {
                  dueError = null;
                });
              }
            },
            validator: (value) {
              if (time == null) {
                return "";
              }
              return null;
            },
            readOnly: true,
            decoration: const InputDecoration(
              hintText: 'Due Time',
              errorStyle: TextStyle(height: 0, fontSize: 0),
              contentPadding: EdgeInsets.fromLTRB(16, 8, 0, 8),
              border: OutlineInputBorder(
                borderRadius:
                    BorderRadius.horizontal(right: Radius.circular(4)),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildPriority(BuildContext context) {
    return Row(children: [
      MaterialSegmentedControl(
        verticalOffset: 8,
        children: _children,
        selectionIndex: _currentSelection,
        borderColor: Colors.grey[600],
        borderWidth: 1,
        selectedColor: Theme.of(context).colorScheme.primary,
        unselectedColor: Colors.transparent,
        selectedTextStyle: const TextStyle(
          color: Colors.white70,
          fontWeight: FontWeight.bold,
        ),
        unselectedTextStyle: TextStyle(
          color: Colors.grey[700],
          fontWeight: FontWeight.w600,
        ),
        borderRadius: 4,
        horizontalPadding: EdgeInsets.zero,
        onSegmentTapped: (index) {
          String selection;
          switch (_currentSelection) {
            case 0:
              selection = 'H';
              break;
            case 1:
              selection = 'M';
              break;
            case 2:
              selection = 'L';
              break;
            default:
              selection = 'M';
          }
          setState(() {
            _currentSelection = int.parse(index.toString());
            priority = selection;
          });
        },
      ),
    ]);
  }

  Widget buildLabel(String title) {
    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      child: Text(
        title,
        style: Theme.of(context)
            .textTheme
            .bodyMedium!
            .copyWith(fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget buildCancelButton(BuildContext context) {
    return TextButton(
      child: const Text('Cancel'),
      onPressed: () => Navigator.of(context).pop(),
    );
  }

  Widget buildAddButton(BuildContext context) {
    return TextButton(
      child: const Text("Add"),
      onPressed: () {
        try {
          if (date == null || time == null) {
            formKey.currentState!.validate();
            setState(() {
              dueError = "Due date & time can't be empty!";
            });
          } else if (formKey.currentState!.validate()) {
            var task = taskParser(nameController.text)
                .rebuild((b) => b..due = due)
                .rebuild((p) => p..priority = priority);

            StorageWidget.of(context).mergeTask(task);
            //StorageWidget.of(context).mergeTask(prioritytask);
            nameController.text = '';
            due = null;
            priority = 'M';
            setState(() {});
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: const Text(
                    'Task Added Successfully, Double tap to Edit'), // Intimating the user about the double tap to edit feature
                backgroundColor: AppSettings.isDarkMode
                    ? const Color.fromARGB(255, 61, 61, 61)
                    : const Color.fromARGB(255, 39, 39, 39),
                duration: const Duration(seconds: 2)));
          }
        } on FormatException catch (e) {
          Navigator.of(context).pop();

          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: const Text('Task Addition Failed'),
              backgroundColor: AppSettings.isDarkMode
                  ? const Color.fromARGB(255, 61, 61, 61)
                  : const Color.fromARGB(255, 39, 39, 39),
              duration: const Duration(seconds: 2)));
          log(e.toString());
        }
      },
    );
  }
}
