// ignore_for_file: file_names

import 'package:taskwarrior/model/task.dart';

void deleteTask(Task task) {
  // final box = Boxes.getTransactions();
  // box.delete(transaction.key);

  task.delete();
  //setState(() => transactions.remove(transaction));
}
