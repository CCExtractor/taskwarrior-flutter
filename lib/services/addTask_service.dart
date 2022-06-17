// ignore_for_file: file_names

import 'package:taskwarrior/model/task.dart';
import 'package:taskwarrior/widgets/boxes.dart';

Future addTask(String name, String description, bool done,
    TaskPriority priority, DateTime dateTime) async {
  final task = Task(
      description: '',
      done: false,
      name: '',
      priority: TaskPriority.medium,
      dateTime: DateTime.now())
    ..name = name
    ..description = description
    ..done = done
    ..priority = priority
    ..dateTime = dateTime;
  final box = Boxes.getTasks();
  box.add(task);
}
