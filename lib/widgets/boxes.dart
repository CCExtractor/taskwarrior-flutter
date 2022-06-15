import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:taskwarrior/model/task.dart';

class Boxes {
  static Box<Task> getTasks() => Hive.box<Task>('tasks');
}
