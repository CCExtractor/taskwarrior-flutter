import 'package:flutter/material.dart';
import 'package:taskwarrior/model/task.dart';
import 'package:taskwarrior/services/deleteTask_service.dart';
import 'package:taskwarrior/services/editTask_service.dart';
import 'package:taskwarrior/widgets/taskdialog.dart';

Widget buildButtons(BuildContext context, Task task) => Row(
      children: [
        Expanded(
          child: TextButton.icon(
            label: Text('Edit'),
            icon: Icon(Icons.edit),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => TaskDialog(
                  task: task,
                  onClickedDone: (name, description, done, priority) =>
                      editTask(task, name, description, done,
                          priority as TaskPriority),
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: TextButton.icon(
            label: Text('Delete'),
            icon: Icon(Icons.delete),
            onPressed: () => deleteTask(task),
          ),
        )
      ],
    );
