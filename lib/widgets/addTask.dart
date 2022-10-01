// ignore_for_file: file_names

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:taskwarrior/model/storage/storage_widget.dart';
import 'package:taskwarrior/widgets/taskfunctions/taskparser.dart';
import 'package:jiffy/jiffy.dart';
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
  //final prioritycontroller;
  DateTime? due;
  String dueString = '';
  String priority = 'M';
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
      title: const Center(child: Text(title)),
      content: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const SizedBox(height: 8),
              buildName(),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: Wrap(
                      children: [
                        const Text(
                          "Due : ",
                          style:
                          TextStyle(fontWeight: FontWeight.bold, height: 3.3),
                        ),
                        GestureDetector(
                          onLongPress: () {
                            due = null;
                            setState(() {});
                          },
                          child: ActionChip(
                            backgroundColor: Colors.grey.shade300,
                            label: Container(
                              child: Text(
                                (due != null)
                                    ? dueString
                                    : "null",
                              ),
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
                                  dueString = Jiffy(dateTime).format('MMM do yyyy, h:mm:ss a');
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
              // const SizedBox(height: 8),
              const SizedBox(height: 0),
              buildPriority(),
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
        validator: (name) => name != null && name.isEmpty
            ? 'You cannot leave this field empty!'
            : null,
      );
  Widget buildPriority() => Column(children: [
    Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text(
          'Priority :  ',
          style: TextStyle(fontWeight: FontWeight.bold),
          textAlign: TextAlign.left,
        ),
        DropdownButton<String>(
          value: priority,
          elevation: 16,
          style: const TextStyle(color: Colors.black),
          underline: Container(
            height: 1.5,
            color: Colors.black,
          ),
          onChanged: (String? newValue) {
            setState(() {
              priority = newValue!;
            });
          },
          items: <String>['H', 'M', 'L']
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text('  $value'),
            );
          }).toList(),
        )
      ],
    ),
  ]);
  Widget buildCancelButton(BuildContext context) => TextButton(
    child: const Text('Cancel'),
    onPressed: () => Navigator.of(context).pop(),
  );

  Widget buildAddButton(BuildContext context) {
    return TextButton(
      child: const Text("Add"),
      onPressed: () async {
        try {
          formKey.currentState!.validate();
          var task = taskParser(namecontroller.text)
              .rebuild((b) => b..due = due)
              .rebuild((p) => p..priority = priority);

          StorageWidget.of(context).mergeTask(task);
          //StorageWidget.of(context).mergeTask(prioritytask);
          namecontroller.text = '';
          due = null;
          priority = 'M';
          setState(() {});
          Navigator.of(context).pop();
        } on FormatException catch (e) {
          log(e.toString());
        }
      },
    );
  }
}
