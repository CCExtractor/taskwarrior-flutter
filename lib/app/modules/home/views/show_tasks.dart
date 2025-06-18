import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taskwarrior/api_service.dart';
import 'package:taskwarrior/app/modules/home/controllers/home_controller.dart';
import 'package:taskwarrior/app/modules/home/views/show_details.dart';
import 'package:taskwarrior/app/utils/constants/taskwarrior_colors.dart';
import 'package:taskwarrior/app/utils/constants/taskwarrior_fonts.dart';
import 'package:taskwarrior/app/utils/themes/theme_extension.dart';

class TaskViewBuilder extends StatelessWidget {
  const TaskViewBuilder({
    super.key,
    this.project,
    required this.pendingFilter,
    required this.selectedSort,
  });

  final String selectedSort;
  final bool pendingFilter;
  final String? project;

  @override
  Widget build(BuildContext context) {
    final HomeController taskController = Get.find<HomeController>();
    TaskwarriorColorTheme tColors = Theme.of(context).extension<TaskwarriorColorTheme>()!;
    
    return Obx(() {
      List<Tasks> tasks = List<Tasks>.from(taskController.tasks);
      // Filter tasks based on the selected project
      if (project != 'All Projects') {
        tasks = tasks.where((task) => task.project == project).toList();
      } else {
        tasks = List<Tasks>.from(tasks);
      }

      // Apply other filters and sorting
      tasks.sort((a, b) => b.id.compareTo(a.id));

      tasks = tasks.where((task) {
        if (pendingFilter) {
          return task.status == 'pending';
        } else {
          return task.status == 'completed';
        }
      }).toList();
      // Apply sorting based on selectedSort
      tasks.sort((a, b) {
        switch (selectedSort) {
          case 'Created+':
            return a.entry.compareTo(b.entry);
          case 'Created-':
            return b.entry.compareTo(a.entry);
          case 'Modified+':
            return a.modified!.compareTo(b.modified!);
          case 'Modified-':
            return b.modified!.compareTo(a.modified!);
          case 'Due till+':
            return a.due!.compareTo(b.due!);
          case 'Due till-':
            return b.due!.compareTo(a.due!);
          case 'Priority-':
            return b.priority!.compareTo(a.priority!);
          case 'Priority+':
            return a.priority!.compareTo(b.priority!);
          case 'Project+':
            return a.project!.compareTo(b.project!);
          case 'Project-':
            return b.project!.compareTo(a.project!);
          case 'Urgency-':
            return b.urgency!.compareTo(a.urgency!);
          case 'Urgency+':
            return a.urgency!.compareTo(b.urgency!);
          default:
            return 0;
        }
      });

      return Scaffold(
        backgroundColor: tColors.dialogBackgroundColor,
        body: tasks.isEmpty
            ? Padding(
                padding: const EdgeInsets.all(16.0),
                child: Center(
                  child: Text(
                    'Click on the bottom right button to start adding tasks',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: TaskWarriorFonts.fontSizeLarge,
                      color: tColors.primaryTextColor,
                    ),
                  ),
                ),
              )
            : ListView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.only(
                  top: 4,
                  left: 2,
                  right: 2,
                  bottom: MediaQuery.of(context).size.height * 0.1,
                ),
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  Tasks task = tasks[index];
                  return Slidable(
                    startActionPane: ActionPane(
                      motion: const BehindMotion(),
                      children: [
                        SlidableAction(
                          onPressed: (context) {
                            _markTaskAsCompleted(task.uuid!);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Task Marked As Completed. Refresh to view changes!',
                                  style: TextStyle(
                                    color: tColors.primaryTextColor,
                                  ),
                                ),
                              ),
                            );
                          },
                          icon: Icons.done,
                          label: "COMPLETE",
                          backgroundColor: TaskWarriorColors.green,
                        ),
                      ],
                    ),
                    endActionPane: ActionPane(
                      motion: const DrawerMotion(),
                      children: [
                        SlidableAction(
                          onPressed: (context) {
                            _markTaskAsDeleted(task.uuid!);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Task Marked As Deleted. Refresh to view changes!',
                                  style: TextStyle(
                                    color: tColors.primaryTextColor,
                                  ),
                                ),
                              ),
                            );
                          },
                          icon: Icons.delete,
                          label: "DELETE",
                          backgroundColor: TaskWarriorColors.red,
                        ),
                      ],
                    ),
                    child: Card(
                      color: tColors.secondaryBackgroundColor,
                      child: InkWell(
                        splashColor: tColors.primaryBackgroundColor,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TaskDetails(task: task),
                          ),
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: tColors.primaryTextColor!,
                            ),
                            color: tColors.primaryBackgroundColor,
                            borderRadius: BorderRadius.circular(8.0),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 4.0,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor:
                                  _getPriorityColor(task.priority!),
                              radius: 8,
                            ),
                            title: Text(
                              task.description,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.poppins(
                                color: tColors.dialogBackgroundColor,
                              ),
                            ),
                            subtitle: Text(
                              'Urgency: ${task.urgency!.floorToDouble()} | Status: ${task.status}',
                              style: GoogleFonts.poppins(
                                color: tColors.secondaryTextColor,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
      );
    });
  }

  void _markTaskAsCompleted(String uuid) async {
    TaskDatabase taskDatabase = TaskDatabase();
    await taskDatabase.open();
    taskDatabase.markTaskAsCompleted(uuid);
    completeTask('email', uuid);
  }

  void _markTaskAsDeleted(String uuid) async {
    TaskDatabase taskDatabase = TaskDatabase();
    await taskDatabase.open();
    taskDatabase.markTaskAsDeleted(uuid);
    deleteTask('email', uuid);
  }

  Color _getPriorityColor(String priority) {
    switch (priority) {
      case 'H':
        return Colors.red;
      case 'M':
        return Colors.yellow;
      case 'L':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
}
