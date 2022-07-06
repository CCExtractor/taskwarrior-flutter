import 'package:flutter/material.dart';
import 'package:taskwarrior/model/task.dart';
import 'package:taskwarrior/services/deleteTask_service.dart';
import 'package:taskwarrior/services/editTask_service.dart';
import 'package:taskwarrior/widgets/taskdialog.dart';

Widget buildButtons(BuildContext context, Task task) => Row(
      children: [
        Expanded(
          child: TextButton.icon(
            label: const Text('Edit'),
            icon: const Icon(Icons.edit),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => TaskDialog(
                  task: task,
                  onClickedDone:
                      (name, description, done, priority, dateTime) =>
                          editTask(task, name, description, done, priority),
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: TextButton.icon(
            label: const Text('Delete'),
            icon: const Icon(Icons.delete),
            onPressed: () => deleteTask(task),
          ),
        )
      ],
    );
