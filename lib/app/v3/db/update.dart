import 'package:flutter/material.dart';
import 'package:taskwarrior/app/v3/db/task_database.dart';
import 'package:taskwarrior/app/v3/models/task.dart';
import 'package:taskwarrior/app/v3/net/add_task.dart';
import 'package:taskwarrior/app/v3/net/complete.dart';
import 'package:taskwarrior/app/v3/net/delete.dart';
import 'package:taskwarrior/app/v3/net/modify.dart';
import 'package:timezone/timezone.dart';

Future<void> updateTasksInDatabase(List<TaskForC> tasks) async {
  var taskDatabase = TaskDatabase();
  await taskDatabase.open();
  // find tasks without UUID
  List<TaskForC> tasksWithoutUUID = await taskDatabase.findTasksWithoutUUIDs();

  //add tasks without UUID to the server and delete them from database
  for (var task in tasksWithoutUUID) {
    try {
      await addTaskAndDeleteFromDatabase(
          task.description,
          task.project != null ? task.project! : '',
          task.due!,
          task.priority!,
          task.tags != null ? task.tags! : []);
    } catch (e) {
      debugPrint(
          'Failed to add task without UUID to server: $e ${task.tags} ${task.project}');
    }
  }

  // update existing tasks in db
  for (var task in tasks) {
    var existingTask = await taskDatabase.getTaskByUuid(task.uuid!);
    if (existingTask != null) {
      if (task.modified!.compareTo(existingTask.modified!) > 0) {
        await taskDatabase.updateTask(task);
      }
    } else {
      // add new tasks to db
      await taskDatabase.insertTask(task);
    }
  }

  var localTasks = await taskDatabase.fetchTasksFromDatabase();
  var localTasksMap = {for (var task in localTasks) task.uuid: task};

  for (var serverTask in tasks) {
    var localTask = localTasksMap[serverTask.uuid];

    if (localTask == null) {
      // Task doesn't exist in the local database, insert it
      await taskDatabase.insertTask(serverTask);
    } else {
      var serverTaskModifiedDate = DateTime.parse(serverTask.modified!);
      var localTaskModifiedDate = DateTime.parse(localTask.modified!);

      if (serverTaskModifiedDate.isAfter(localTaskModifiedDate)) {
        // Server task is newer, update local database
        await taskDatabase.updateTask(serverTask);
      } else if (serverTaskModifiedDate.isBefore(localTaskModifiedDate)) {
        // local task is newer, update server
        debugPrint(
            'Updating task on server: ${localTask.description}, modified: ${localTask.modified}');
        await modifyTaskOnTaskwarrior(
            localTask.description,
            localTask.project!,
            localTask.due!,
            localTask.priority!,
            localTask.status,
            localTask.uuid!,
            localTask.id.toString(),
            localTask.tags != null
                ? localTask.tags!.map((e) => e.toString()).toList()
                : []);
        if (localTask.status == 'completed') {
          completeTask('email', localTask.uuid!);
        } else if (localTask.status == 'deleted') {
          deleteTask('email', localTask.uuid!);
        }
      }
    }
  }
}
