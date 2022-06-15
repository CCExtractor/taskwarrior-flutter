import 'package:flutter/material.dart';

import '../model/task.dart';

class TaskDialog extends StatefulWidget {
  final Task? task;
  final Function(
    String name,
    String description,
    bool done,
    TaskPriority priority,
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

  @override
  void initState() {
    super.initState();

    if (widget.task != null) {
      final task = widget.task!;

      nameController.text = task.name;
      descriptionController.text = task.description;
      done = task.done;
      priority = task.priority;
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
              SizedBox(height: 8),
              buildName(),
              SizedBox(height: 8),
              buildDescription(),
              SizedBox(height: 8),
              buildRadioButtons(),
              SizedBox(height: 8),
              buildPriority(),
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
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          hintText: 'Enter Name',
        ),
        validator: (name) =>
            name != null && name.isEmpty ? 'Enter a name' : null,
      );

  Widget buildDescription() => TextFormField(
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          hintText: 'Enter Description',
        ),
        validator: (description) => description != null && description.isEmpty
            ? 'Enter a Description'
            : null,
        controller: descriptionController,
      );

  Widget buildRadioButtons() => Column(
        children: [
          RadioListTile<bool>(
            title: Text('True'),
            value: true,
            groupValue: done,
            onChanged: (value) => setState(() => done = value!),
          ),
          RadioListTile<bool>(
            title: Text('False'),
            value: false,
            groupValue: done,
            onChanged: (value) => setState(() => done = value!),
          ),
        ],
      );
  Widget buildPriority() => Column(
        children: [
          Text("Priority"),
          DropdownButton<TaskPriority>(
            items: prioritystring.keys.map((TaskPriority value) {
              return DropdownMenuItem<TaskPriority>(
                value: value,
                child: Text(prioritystring[value].toString()),
              );
            }).toList(),
            value: priority,
            hint: Text("Priority"),
            onChanged: (value) {
              setState(() {
                priority = value!;
              });
            },
          ),
        ],
      );

  Widget buildCancelButton(BuildContext context) => TextButton(
        child: Text('Cancel'),
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

          widget.onClickedDone(name, description, done, priority);

          Navigator.of(context).pop();
        }
      },
    );
  }
}
