// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:taskwarrior/model/json.dart';
import 'package:taskwarrior/services/task_details.dart';
import 'package:taskwarrior/services/task_list_tem.dart';

import 'pallete.dart';

class TasksBuilder extends StatelessWidget {
  const TasksBuilder({
    Key? key,
    required this.taskData,
    required this.pendingFilter, required this.darkmode,

  }) : super(key: key);

  final List<Task> taskData;
  final bool pendingFilter;
  final bool darkmode;
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 2),
      children: [
        for (var task in taskData)
          Card(
            color: darkmode?Palette.kToDark:Colors.white,
            child: InkWell(
              splashColor: darkmode?Colors.black:Colors.grey.shade200,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailRoute(task.uuid),
                ),
              ),
              child: TaskListItem(task, pendingFilter: pendingFilter,darkmode:darkmode ,),
            ),
          ),
      ],
    );
  }
}
