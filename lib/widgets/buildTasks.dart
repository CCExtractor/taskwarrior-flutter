// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:taskwarrior/model/task.dart';
import 'package:taskwarrior/widgets/buildButtons.dart';

class TasksBuilder extends StatefulWidget {
  final Task task;
  final context;
  const TasksBuilder({Key? key, required this.task, this.context})
      : super(key: key);
  @override
  // ignore: library_private_types_in_public_api
  _TasksBuilderState createState() => _TasksBuilderState();
}

class _TasksBuilderState extends State<TasksBuilder> {
  late bool value;
  late Task task = widget.task;
  @override
  late BuildContext context = widget.context;
  @override
  Widget build(context) {
    final color = task.done ? Colors.green : Colors.red;
    final priority = task.priority;
    final priorityColor = priority == TaskPriority.high
        ? Colors.red
        : priority == TaskPriority.medium
            ? Colors.orange
            : Colors.green;

    return Card(
      color: Colors.white,
      child: ExpansionTile(
        tilePadding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        title: Text(
          task.name,
          maxLines: 2,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        trailing: Text(
          prioritystring[priority].toString(),
          style: TextStyle(
            color: priorityColor,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        leading: IconButton(
          onPressed: () {
            setState(() {
              task.done = !task.done;
              task.save();
            });
          },
          icon: task.done
              ? const Icon(Icons.radio_button_checked)
              : const Icon(Icons.radio_button_off_outlined),
          color: task.done
              ? const Color.fromRGBO(175, 126, 235, 1)
              : const Color.fromRGBO(151, 153, 167, 1),
          iconSize: 26,
        ),
        subtitle: Text(
          task.description,
          style: TextStyle(
              color: color, fontWeight: FontWeight.bold, fontSize: 16),
        ),
        children: [
          buildButtons(context, task),
        ],
      ),
    );
  }
}
