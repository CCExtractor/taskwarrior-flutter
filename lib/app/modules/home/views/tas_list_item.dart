import 'package:flutter/material.dart';
import 'package:taskwarrior/app/models/json/task.dart';
import 'package:taskwarrior/app/utils/constants/taskwarrior_fonts.dart';
import 'package:taskwarrior/app/utils/gen/fonts.gen.dart';
import 'package:taskwarrior/app/utils/language/sentence_manager.dart';
import 'package:taskwarrior/app/utils/language/supported_language.dart';
import 'package:taskwarrior/app/utils/taskfunctions/datetime_differences.dart';
import 'package:taskwarrior/app/utils/taskfunctions/modify.dart';
import 'package:taskwarrior/app/utils/taskfunctions/urgency.dart';
import 'package:taskwarrior/app/utils/themes/theme_extension.dart';

class TaskListItem extends StatelessWidget {
  const TaskListItem(
    this.task, {
    this.pendingFilter = false,
    this.waitingFilter = false,
    super.key,
    required this.useDelayTask,
    required this.modify,
    required this.selectedLanguage,
  });

  final Task task;
  final bool pendingFilter;
  final bool waitingFilter;
  final Modify modify;
  final bool useDelayTask;
  final SupportedLanguage selectedLanguage;

  @override
  Widget build(BuildContext context) {
    TaskwarriorColorTheme tColors = Theme.of(context).extension<TaskwarriorColorTheme>()!;
    // ignore: unused_element
    void saveChanges() async {
      var now = DateTime.now().toUtc();
      modify.save(
        modified: () => now,
      );
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            'Task Updated',
            style: TextStyle(
              color: tColors.primaryTextColor,
            ),
          ),
          backgroundColor: tColors.secondaryBackgroundColor,
          duration: const Duration(seconds: 2)));
    }

    bool isDueWithinOneDay(DateTime dueDate) {
      DateTime now = DateTime.now();
      Duration difference = dueDate.difference(now);
      return difference.inDays <= 1 && difference.inDays >= 0;
    }

    MaterialColor colours = Colors.grey;
    Color colour =tColors.primaryTextColor!;
    Color dimColor = tColors.dimCol!;
    if (task.priority == 'H') {
      colours = Colors.red;
    } else if (task.priority == 'M') {
      colours = Colors.yellow;
    } else if (task.priority == 'L') {
      colours = Colors.green;
    }

    if ((task.status[0].toUpperCase()) == 'P') {
      // Pending tasks
      return Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: (task.due != null &&
                    isDueWithinOneDay(task.due!) &&
                    useDelayTask)
                ? Colors
                    .red // Set border color to red if due within 1 day and useDelayTask is true
                : dimColor, // Set default border color
          ),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: ListTile(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: colours,
                    radius: 8,
                  ),
                  const SizedBox(width: 8),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.70,
                    child: Text(
                      '${(task.id == 0) ? '#' : task.id}. ${task.description}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      // style: GoogleFonts.poppins(
                      //   color: colour,
                      // ),
                      style: TextStyle(
                          fontFamily: FontFamily.poppins, color: colour),
                    ),
                  ),
                ],
              ),
              Text(
                (task.annotations != null)
                    ? ' [${task.annotations!.length}]'
                    : '',
                // style: GoogleFonts.poppins(
                //   color: colour,
                // ),
                style: TextStyle(fontFamily: FontFamily.poppins, color: colour),
              ),
            ],
          ),
          subtitle: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Text(
                    '${pendingFilter ? '' : '${task.status[0].toUpperCase()}\n'}'
                            '${SentenceManager(currentLanguage: selectedLanguage).sentences.homePageLastModified} : ${(task.modified != null) ? age(task.modified!) : ((task.start != null) ? age(task.start!) : '-')} | '
                            '${SentenceManager(currentLanguage: selectedLanguage).sentences.homePageDue} : ${(task.due != null) ? when(task.due!) : '-'}'
                        .replaceFirst(RegExp(r' \[\]$'), '')
                        .replaceAll(RegExp(r' +'), ' '),
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontFamily: FontFamily.poppins,
                        color: dimColor,
                        fontSize: TaskWarriorFonts.fontSizeSmall),
                  ),
                ),
              ),
              Text(
                formatUrgency(urgency(task)),
                // style: GoogleFonts.poppins(
                //   color: colour,
                // ),
                style: TextStyle(fontFamily: FontFamily.poppins, color: colour),
              ),
            ],
          ),
        ),
      );
    } else {
      // Completed tasks
      return ListTile(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: colours,
                  radius: 8,
                ),
                const SizedBox(width: 8),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.65,
                  child: Text(
                    '${(task.id == 0) ? '#' : task.id}. ${task.description}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    // style: GoogleFonts.poppins(
                    //   color: colour,
                    // ),
                    style: TextStyle(
                        fontFamily: FontFamily.poppins, color: colour),
                  ),
                ),
              ],
            ),
          ],
        ),
        subtitle: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Text(
                  '${SentenceManager(currentLanguage: selectedLanguage).sentences.homePageLastModified} :${(task.modified != null) ? age(task.modified!) : ((task.start != null) ? age(task.start!) : '-')} | '
                          '${SentenceManager(currentLanguage: selectedLanguage).sentences.homePageDue} : ${(task.due != null) ? when(task.due!) : '-'}'
                      .replaceFirst(RegExp(r' \[\]$'), '')
                      .replaceAll(RegExp(r' +'), ' '),
                  overflow: TextOverflow.ellipsis,
                  // style: GoogleFonts.poppins(
                  //   color: dimColor,
                  //   fontSize: TaskWarriorFonts.fontSizeSmall,
                  // ),
                  style: TextStyle(
                      fontFamily: FontFamily.poppins,
                      color: dimColor,
                      fontSize: TaskWarriorFonts.fontSizeSmall),
                ),
              ),
            ),
            Text(
              formatUrgency(urgency(task)),
              // style: GoogleFonts.poppins(
              //   color: colour,
              // ),
              style: TextStyle(fontFamily: FontFamily.poppins, color: colour),
            ),
          ],
        ),
      );
    }
  }
}
