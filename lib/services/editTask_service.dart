// ignore_for_file: file_names

import 'package:taskwarrior/model/task.dart';

void editTask(
  Task task,
  String name,
  String description,
  bool done,
  TaskPriority priority,
) {
  task.name = name;
  task.description = description;
  task.done = done;
  task.priority = priority;

  // final box = Boxes.getTransactions();
  // box.put(transaction.key, transaction);

  task.save();
}
