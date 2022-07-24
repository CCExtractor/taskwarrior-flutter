// ignore_for_file: file_names

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:taskwarrior/model/storage/storage_widget.dart';

import 'package:taskwarrior/widgets/taskw.dart';

class AddTaskBottomSheet extends StatefulWidget {
  const AddTaskBottomSheet({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _AddTaskBottomSheetState createState() => _AddTaskBottomSheetState();
}

class _AddTaskBottomSheetState extends State<AddTaskBottomSheet> {
  final formKey = GlobalKey<FormState>();
  final namecontroller = TextEditingController();
  DateTime? due;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    namecontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const title = 'Add Task';

    return AlertDialog(
      title: const Text(title),
      content: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const SizedBox(height: 8),
              buildName(),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: Wrap(
                      children: [
                        GestureDetector(
                          onLongPress: () {
                            due = null;
                            setState(() {});
                          },
                          child: ActionChip(
                            label: Text(
                              'due:${(due != null) ? due!.toLocal().toIso8601String() : ''}',
                            ),
                            onPressed: () async {
                              var initialDate =
                                  due?.toLocal() ?? DateTime.now();
                              var date = await showDatePicker(
                                context: context,
                                initialDate: initialDate,
                                firstDate: DateTime(
                                    1990), // >= 1980-01-01T00:00:00.000Z
                                lastDate: DateTime(
                                    2037, 12, 31), // < 2038-01-19T03:14:08.000Z
                              );
                              if (date != null) {
                                var time = await showTimePicker(
                                  context: context,
                                  initialTime:
                                      TimeOfDay.fromDateTime(initialDate),
                                );
                                if (time != null) {
                                  var dateTime = date.add(
                                    Duration(
                                      hours: time.hour,
                                      minutes: time.minute,
                                    ),
                                  );
                                  dateTime = dateTime.add(
                                    Duration(
                                      hours: time.hour - dateTime.hour,
                                    ),
                                  );
                                  due = dateTime.toUtc();
                                }
                              }
                              setState(() {});
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      actions: <Widget>[
        buildCancelButton(context),
        buildAddButton(context),
      ],
    );
  }

  Widget buildName() => TextFormField(
        controller: namecontroller,
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          hintText: 'Enter Name',
        ),
        validator: (name) =>
            name != null && name.isEmpty ? 'Enter a name' : null,
      );
  Widget buildCancelButton(BuildContext context) => TextButton(
        child: const Text('Cancel'),
        onPressed: () => Navigator.of(context).pop(),
      );

  Widget buildAddButton(BuildContext context) {
    return TextButton(
      child: const Text("Add"),
      onPressed: () async {
        try {
          var task =
              taskParser(namecontroller.text).rebuild((b) => b..due = due);
          StorageWidget.of(context).mergeTask(task);
          namecontroller.text = '';
          due = null;
          setState(() {});
          Navigator.of(context).pop();
        } on FormatException catch (e) {
          //   showExceptionDialog(
          //     context: context,
          //     e: e,
          //     trace: trace,
          //   );
          log(e.toString());
        }
      },
    );
  }
}
