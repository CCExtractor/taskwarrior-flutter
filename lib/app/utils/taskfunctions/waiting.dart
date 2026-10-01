import 'package:taskwarrior/app/models/models.dart';

/// Whether [task] is waiting: hidden until its wait date, as in Taskwarrior.
bool isWaiting(Task task, DateTime now) =>
    task.wait != null && task.wait!.isAfter(now);
