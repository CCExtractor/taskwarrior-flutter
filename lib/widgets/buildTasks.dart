// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:taskwarrior/config/app_settings.dart';
import 'package:taskwarrior/model/json.dart';
import 'package:taskwarrior/model/storage/storage_widget.dart';
import 'package:taskwarrior/services/task_details.dart';
import 'package:taskwarrior/services/task_list_tem.dart';
import 'package:taskwarrior/widgets/taskfunctions/modify.dart';

import 'pallete.dart';

class TasksBuilder extends StatefulWidget {
  const TasksBuilder({
    Key? key,
    required this.taskData,
    required this.pendingFilter,
  }) : super(key: key);

  final List<Task> taskData;
  final bool pendingFilter;

  @override
  State<TasksBuilder> createState() => _TasksBuilderState();
}

class _TasksBuilderState extends State<TasksBuilder> {
  late Modify modify;

  void setStatus(String newValue, String id) {
    var storageWidget = StorageWidget.of(context);
    modify = Modify(
      getTask: storageWidget.getTask,
      mergeTask: storageWidget.mergeTask,
      uuid: id,
    );
    modify.set('status', newValue);
    saveChanges();
  }

  void saveChanges() async {
    var now = DateTime.now().toUtc();
    modify.save(
      modified: () => now,
    );
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text('Task Updated'),
        backgroundColor: AppSettings.isDarkMode
            ? const Color.fromARGB(255, 61, 61, 61)
            : const Color.fromARGB(255, 39, 39, 39),
        duration: const Duration(seconds: 2)));
  }

  // final bool darkmode;
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 2),
      children: [
        for (var task in widget.taskData)
          widget.pendingFilter
              ? Slidable(
                  key: ValueKey(task.uuid),
                  startActionPane: ActionPane(
                    motion: const BehindMotion(),
                    children: [
                      SlidableAction(
                        onPressed: (context) {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title:
                                    const Text('Do you want to save changes?'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      setStatus('completed', task.uuid);
                                      final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
                                      DateTime? dtb = task.due;
                                      if (dtb == null) {
                                        flutterLocalNotificationsPlugin.cancel(0);
                                        Navigator.of(context).pop();
                                        return;
                                      }

                                      dtb = dtb.add(const Duration(minutes: 1));
                                    
                                      flutterLocalNotificationsPlugin.cancel(
                                          dtb.day * 100 +
                                              dtb.hour * 10 +
                                              dtb.minute);

                                      print("Task due is $dtb");
                                      print(dtb.day * 100 +
                                          dtb.hour * 10 +
                                          dtb.minute);

                                      Navigator.of(context).pop();
                                    },
                                    child: const Text('Yes'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text('No'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text('Cancel'),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        icon: Icons.done,
                        label: "COMPLETE",
                        backgroundColor: Colors.green,
                      ),
                    ],
                  ),
                  endActionPane: ActionPane(
                    motion: const DrawerMotion(),
                    children: [
                      SlidableAction(
                        onPressed: (context) {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title:
                                    const Text('Do you want to save changes?'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      setStatus('deleted', task.uuid);
                                      DateTime? dtb = task.due;
                                      final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

                                      if (dtb == null) {
                                        flutterLocalNotificationsPlugin.cancel(0);
                                        Navigator.of(context).pop();
                                        return;
                                      }

                                      dtb = dtb.add(const Duration(minutes: 1));
                                      flutterLocalNotificationsPlugin.cancel(
                                          dtb.day * 100 +
                                              dtb.hour * 10 +
                                              dtb.minute);

                                      print("Task due is $dtb");
                                      print(dtb.day * 100 +
                                          dtb.hour * 10 +
                                          dtb.minute);
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text('Yes'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text('No'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text('Cancel'),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        icon: Icons.delete,
                        label: "DELETE",
                        backgroundColor: Colors.red,
                      ),
                    ],
                  ),
                  child: Card(
                    color:
                        AppSettings.isDarkMode ? Palette.kToDark : Colors.white,
                    child: InkWell(
                      splashColor: AppSettings.isDarkMode
                          ? Colors.black
                          : Colors.grey.shade200,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailRoute(task.uuid),
                        ),
                      ),
                      child: TaskListItem(
                        task,
                        pendingFilter: widget.pendingFilter,
                        darkmode: AppSettings.isDarkMode,
                      ),
                    ),
                  ),
                )
              : Card(
                  color:
                      AppSettings.isDarkMode ? Palette.kToDark : Colors.white,
                  child: InkWell(
                    splashColor: AppSettings.isDarkMode
                        ? Colors.black
                        : Colors.grey.shade200,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailRoute(task.uuid),
                      ),
                    ),
                    child: TaskListItem(
                      task,
                      pendingFilter: widget.pendingFilter,
                      darkmode: AppSettings.isDarkMode,
                    ),
                  ),
                ),
      ],
    );
  }
}
