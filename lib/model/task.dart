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
  Task(
      {required this.name,
      required this.done,
      required this.description,
      required this.priority});

  // factory Task.fromMap(Map<String, dynamic> mp) {
  //   return Task(
  //       name: mp['name'],
  //       done: mp['done'],
  //       description: mp['description'],
  //       priority: TaskPriority.values[mp['priority']]);
  // }
  // Map<String, dynamic> toMap() =>
  //     {'name': name, 'done': done, 'description': description, 'priority': priority.index};
}

// const List<Map<String, dynamic>> defaultTasks = [
//   {
//     "name": "Get up at 6 PM",
//     "done": true,
//     "description": "Get up at 6 PM",
//     "priority": "high"
//   },
//   {
//     "name": "Take Breakfast",
//     "done": false,
//     "description": "Take Breakfast",
//     "priority": "medium"
//   },
//   {
//     "name": "Do exercise",
//     "done": true,
//     "description": "Do exercise",
//     "priority": "low"
//   },
//   {"name": "Bath", "done": false, "description": "Bath", "priority": "medium"},
//   {
//     "name": "Morning Jogg",
//     "done": true,
//     "description": "Morning Jogg",
//     "priority": "high"
//   },
// ];

// class TaskList {
//   static List<Task> Tasklist =
//       List.from(defaultTasks).map<Task>((mp) => Task.fromMap(mp)).toList();
// }
