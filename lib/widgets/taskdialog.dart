// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:taskwarrior/widgets/datetimepicker.dart';

import '../model/task.dart';

class TaskDialog extends StatefulWidget {
  final Task? task;
  final Function(
    String name,
    String description,
    bool done,
    TaskPriority priority,
    DateTime dateTime,
  ) onClickedDone;

  const TaskDialog({
    Key? key,
    this.task,
    required this.onClickedDone,
  }) : super(key: key);

  @override
  _TaskDialogState createState() => _TaskDialogState();
}

class _TaskDialogState extends State<TaskDialog> {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();

  bool done = false;
  TaskPriority priority = TaskPriority.medium;
  DateTime dateTime = DateTime.now();
  @override
  void initState() {
    super.initState();

    if (widget.task != null) {
      final task = widget.task!;

      nameController.text = task.name;
      descriptionController.text = task.description;
      done = task.done;
      priority = task.priority;
      dateTime = task.dateTime;
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.task != null;
    final title = isEditing ? 'Edit Transaction' : 'Add Transaction';

    return AlertDialog(
      title: Text(title),
      content: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const SizedBox(height: 8),
              buildName(),
              const SizedBox(height: 8),
              buildDescription(),
              const SizedBox(height: 8),
              buildPriority(),
              const SizedBox(height: 8),
              DateTimePicker(dateTime: dateTime),
            ],
          ),
        ),
      ),
      actions: <Widget>[
        buildCancelButton(context),
        buildAddButton(context, isEditing: isEditing),
      ],
    );
  }

  Widget buildName() => TextFormField(
        controller: nameController,
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          hintText: 'Enter Name',
        ),
        validator: (name) =>
            name != null && name.isEmpty ? 'Enter a name' : null,
      );

  Widget buildDescription() => TextFormField(
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          hintText: 'Enter Description',
        ),
        validator: (description) => description != null && description.isEmpty
            ? 'Enter a Description'
            : null,
        controller: descriptionController,
      );
  Widget buildPriority() => Column(
        children: [
          const Text("Priority"),
          DropdownButton<TaskPriority>(
            items: prioritystring.keys.map((TaskPriority value) {
              return DropdownMenuItem<TaskPriority>(
                value: value,
                child: Text(prioritystring[value].toString()),
              );
            }).toList(),
            value: priority,
            hint: const Text("Priority"),
            onChanged: (value) {
              setState(() {
                priority = value!;
              });
            },
          ),
        ],
      );
  Widget buildDateTime() => TextFormField(
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          hintText: 'Enter DateTime',
        ),
        validator: (dateTime) =>
            dateTime != null && dateTime.isEmpty ? 'Enter a DateTime' : null,
        controller: descriptionController,
      );
  Widget buildCancelButton(BuildContext context) => TextButton(
        child: const Text('Cancel'),
        onPressed: () => Navigator.of(context).pop(),
      );

  Widget buildAddButton(BuildContext context, {required bool isEditing}) {
    final text = isEditing ? 'Save' : 'Add';

    return TextButton(
      child: Text(text),
      onPressed: () async {
        final isValid = formKey.currentState!.validate();

        if (isValid) {
          final name = nameController.text;
          final description = descriptionController.text;

          widget.onClickedDone(name, description, done, priority, dateTime);

          Navigator.of(context).pop();
        }
      },
    );
  }
}
