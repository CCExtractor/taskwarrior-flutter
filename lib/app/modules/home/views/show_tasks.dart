import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taskwarrior/api_service.dart';
import 'package:taskwarrior/app/modules/home/views/show_details.dart';
import 'package:taskwarrior/app/utils/constants/palette.dart';
import 'package:taskwarrior/app/utils/constants/taskwarrior_colors.dart';
import 'package:taskwarrior/app/utils/constants/taskwarrior_fonts.dart';
import 'package:taskwarrior/app/utils/taskchampion/taskchampion.dart';
import 'package:taskwarrior/app/utils/theme/app_settings.dart';

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

  Future<void> _loadCredentials(
      Function(TaskDatabase, String, String) callback) async {
    String uuid = (await CredentialsStorage.getClientId()) ?? '';
    String encryptionSecret =
        (await CredentialsStorage.getEncryptionSecret()) ?? '';
    TaskDatabase taskDatabase = TaskDatabase();
    await taskDatabase.open();
    callback(taskDatabase, uuid, encryptionSecret);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _loadCredentials((taskDatabase, uuid, encryptionSecret) {}),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          return FutureBuilder<dynamic>(
            future: _fetchTasks(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('No tasks available'));
              } else {
                // Sorting tasks by ID in ascending order
                List<Tasks> tasks = List<Tasks>.from(snapshot.data!);
                tasks.sort((a, b) => b.id.compareTo(a.id));

                _updateTasksInDatabase(tasks);
                _findTasksWithoutUUIDs();

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

                // Filter tasks based on the pendingFilter
                tasks = tasks.where((task) {
                  if (pendingFilter) {
                    return task.status == 'pending';
                  } else {
                    return task.status == 'completed';
                  }
                }).toList();

                return Scaffold(
                  backgroundColor: AppSettings.isDarkMode
                      ? TaskWarriorColors.kprimaryBackgroundColor
                      : TaskWarriorColors.kLightPrimaryBackgroundColor,
                  body: tasks.isEmpty
                      ? Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Center(
                            child: Text(
                              'Click on the bottom right button to start adding tasks',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.poppins(
                                fontSize: TaskWarriorFonts.fontSizeLarge,
                                color: AppSettings.isDarkMode
                                    ? TaskWarriorColors
                                        .kLightPrimaryBackgroundColor
                                    : TaskWarriorColors.kprimaryBackgroundColor,
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
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            'Task Marked As Completed. Refresh to view changes!',
                                            style: TextStyle(
                                              color: AppSettings.isDarkMode
                                                  ? TaskWarriorColors
                                                      .kprimaryTextColor
                                                  : TaskWarriorColors
                                                      .kLightPrimaryTextColor,
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
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            'Task Marked As Deleted. Refresh to view changes!',
                                            style: TextStyle(
                                              color: AppSettings.isDarkMode
                                                  ? TaskWarriorColors
                                                      .kprimaryTextColor
                                                  : TaskWarriorColors
                                                      .kLightPrimaryTextColor,
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
                                color: AppSettings.isDarkMode
                                    ? Palette.kToDark
                                    : TaskWarriorColors.white,
                                child: InkWell(
                                  splashColor: AppSettings.isDarkMode
                                      ? TaskWarriorColors.black
                                      : TaskWarriorColors.borderColor,
                                  onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          TaskDetails(task: task),
                                    ),
                                  ),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: AppSettings.isDarkMode
                                            ? TaskWarriorColors.borderColor
                                            : TaskWarriorColors.black,
                                      ),
                                      color: AppSettings.isDarkMode
                                          ? Palette.kToDark
                                          : TaskWarriorColors.white,
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
                                          color: AppSettings.isDarkMode
                                              ? TaskWarriorColors
                                                  .kLightDialogBackGroundColor
                                              : TaskWarriorColors
                                                  .kprimaryBackgroundColor,
                                        ),
                                      ),
                                      subtitle: Text(
                                        'Urgency: ${task.urgency!.floorToDouble()} | Status: ${task.status}',
                                        style: GoogleFonts.poppins(
                                          color: AppSettings.isDarkMode
                                              ? TaskWarriorColors
                                                  .ksecondaryTextColor
                                              : TaskWarriorColors
                                                  .kLightSecondaryTextColor,
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
              }
            },
          );
        }
      },
    );
  }

  Future<dynamic> _fetchTasks() async {
    TaskDatabase taskDatabase = TaskDatabase();
    await taskDatabase.open();
    return await taskDatabase.fetchTasksFromDatabase();
  }

  void _updateTasksInDatabase(List<Tasks> tasks) async {
    TaskDatabase taskDatabase = TaskDatabase();
    await taskDatabase.open();
    // Perform update logic
  }

  void _findTasksWithoutUUIDs() async {
    TaskDatabase taskDatabase = TaskDatabase();
    await taskDatabase.open();
    // Perform find logic
  }

  void _markTaskAsCompleted(String uuid) async {
    String clientId = (await CredentialsStorage.getClientId()) ?? '';
    String encryptionSecret =
        (await CredentialsStorage.getEncryptionSecret()) ?? '';
    TaskDatabase taskDatabase = TaskDatabase();
    await taskDatabase.open();
    taskDatabase.markTaskAsCompleted(uuid);
    completeTask('email', encryptionSecret, clientId, uuid);
  }

  void _markTaskAsDeleted(String uuid) async {
    String clientId = (await CredentialsStorage.getClientId()) ?? '';
    String encryptionSecret =
        (await CredentialsStorage.getEncryptionSecret()) ?? '';
    TaskDatabase taskDatabase = TaskDatabase();
    await taskDatabase.open();
    taskDatabase.markTaskAsDeleted(uuid);
    deleteTask('email', encryptionSecret, clientId, uuid);
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
