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
  ScrollController scrollController = ScrollController();
  bool showbtn = false;
  @override
  void initState() {
    // TODO: implement initState
    scrollController.addListener(() {
      //scroll listener
      double showoffset =
          10.0; //Back to top botton will show on scroll offset 10.0

      if (scrollController.offset > showoffset) {
        showbtn = true;
        setState(() {
          //update state
        });
      } else {
        showbtn = false;
        setState(() {
          //update state
        });
      }
    });
    super.initState();
  }

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
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.miniStartFloat,
      floatingActionButton: AnimatedOpacity(
        duration: const Duration(milliseconds: 100), //show/hide animation
        opacity: showbtn ? 1.0 : 0.0, //set obacity to 1 on visible, or hide
        child: FloatingActionButton(
          heroTag: "btn2",
          onPressed: () {
            scrollController.animateTo(
                //go to top of scroll
                0, //scroll offset to go
                duration:
                    const Duration(milliseconds: 500), //duration of scroll
                curve: Curves.fastLinearToSlowEaseIn //scroll type
                );
          },
          backgroundColor:
              AppSettings.isDarkMode ? Colors.white : Palette.kToDark.shade200,
          child: Icon(
            Icons.arrow_upward,
            color: AppSettings.isDarkMode
                ? Palette.kToDark.shade200
                : Colors.white,
          ),
        ),
      ),
      backgroundColor: Colors.transparent,
      body: widget.taskData.isEmpty ? const Padding(
        padding: EdgeInsets.all(16.0),
        child: Center(
          child: Text('Click on the bottom right button to start adding tasks', textAlign: TextAlign.center,),
        ),
      ) : ListView(
        controller: scrollController,
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
                                  title: const Text(
                                      'Do you want to save changes?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        setStatus('completed', task.uuid);
                                        DateTime? dtb = task.due;
                                        dtb = dtb!
                                            .add(const Duration(minutes: 1));
                                        final FlutterLocalNotificationsPlugin
                                            flutterLocalNotificationsPlugin =
                                            FlutterLocalNotificationsPlugin();
                                        flutterLocalNotificationsPlugin.cancel(
                                            dtb.day * 100 +
                                                dtb.hour * 10 +
                                                dtb.minute);

                                          print("Task due is $dtb");
                                          print(widget
                                              .taskData); // status is in first index
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
                                    title: const Text(
                                        'Do you want to save changes?'),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          setStatus('deleted', task.uuid);
                                          DateTime? dtb = task.due;
                                          dtb = dtb!
                                              .add(const Duration(minutes: 1));
                                          final FlutterLocalNotificationsPlugin
                                              flutterLocalNotificationsPlugin =
                                              FlutterLocalNotificationsPlugin();
                                          flutterLocalNotificationsPlugin
                                              .cancel(dtb.day * 100 +
                                                  dtb.hour * 10 +
                                                  dtb.minute);

                                          print("Task due is$dtb");
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
                        color: AppSettings.isDarkMode
                            ? Palette.kToDark
                            : Colors.white,
                        child: InkWell(
                          splashColor: AppSettings.isDarkMode
                              ? Colors.black
                              : Colors.grey.shade200,
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetailRoute(task
                                  .uuid), // added functionality for double tap to open task-details
                            ),
                          ),
                          child: IgnorePointer(
                            child: TaskListItem(
                              task,
                              pendingFilter: widget.pendingFilter,
                              darkmode: AppSettings.isDarkMode,
                            ),
                          ),
                        ),
                      ),
                    )
                  : Card(
                      color: AppSettings.isDarkMode
                          ? Palette.kToDark
                          : Colors.white,
                      child: InkWell(
                        splashColor: AppSettings.isDarkMode
                            ? Colors.black
                            : Colors.grey.shade200,
                        onDoubleTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetailRoute(task
                                .uuid), // added functionality for double tap to open task-details
                          ),
                        ),
                        child: IgnorePointer(
                          child: TaskListItem(
                            task,
                            pendingFilter: widget.pendingFilter,
                            darkmode: AppSettings.isDarkMode,
                          ),
                        ),
                      ),
                    ),
          ],
        ));
  }
}
