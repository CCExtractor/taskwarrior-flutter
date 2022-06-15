import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:taskwarrior/model/task.dart';
import 'package:taskwarrior/widgets/buildTasks.dart';

Widget buildContent(List<Task> tasks) {
  if (tasks.isEmpty) {
    return const Center(
      child: Text(
        'No Task yet!',
        style: TextStyle(fontSize: 24),
      ),
    );
  } else {
    return Column(
      children: [
        SizedBox(height: 24),
        const Text(
          'Tasks',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        SizedBox(height: 24),
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.all(8),
            itemCount: tasks.length,
            itemBuilder: (BuildContext context, int index) {
              final task = tasks[index];

              return TasksBuilder(context: context, task: task);
            },
          ),
        ),
      ],
    );
  }
}
