// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:taskwarrior/model/json.dart';
import 'package:taskwarrior/services/task_details.dart';
import 'package:taskwarrior/services/task_list_tem.dart';

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
            color: darkmode?Color.fromARGB(255, 10, 21, 58):Colors.white,
            child: InkWell(
              splashColor: Colors.black,
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
