import 'package:taskwarrior/model/task.dart';
import 'package:taskwarrior/widgets/boxes.dart';

Future addTask(
    String name, String description, bool done, TaskPriority priority) async {
  final task = Task(
      description: '', done: false, name: '', priority: TaskPriority.medium)
    ..name = name
    ..description = description
    ..done = done
    ..priority = priority;

  final box = Boxes.getTasks();
  box.add(task);
  //box.put('mykey', transaction);

  // final mybox = Boxes.getTransactions();
  // final myTransaction = mybox.get('key');
  // mybox.values;
  // mybox.keys;
}
