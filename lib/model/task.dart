import 'package:hive/hive.dart';

part 'task.g.dart';

@HiveType(typeId: 1)
enum TaskPriority {
  @HiveField(0)
  low,
  @HiveField(1, defaultValue: true)
  medium,
  @HiveField(2)
  high,
}

const prioritystring = <TaskPriority, String>{
  TaskPriority.low: 'Low',
  TaskPriority.medium: 'Medium',
  TaskPriority.high: 'High',
};

@HiveType(typeId: 0)
class Task extends HiveObject {
  @HiveField(0)
  String name;
  @HiveField(1)
  String description;
  @HiveField(2)
  bool done;
  @HiveField(3)
  TaskPriority priority;
  @HiveField(4)
  DateTime dateTime;
  Task(
      {required this.name,
      required this.done,
      required this.description,
      required this.priority,
      required this.dateTime});
}
