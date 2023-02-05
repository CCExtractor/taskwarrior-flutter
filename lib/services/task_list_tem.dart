import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taskwarrior/widgets/taskw.dart';
import 'package:taskwarrior/model/json.dart';

import '../model/storage/storage_widget.dart';
import '/widgets/taskdetails/status_widget.dart';

class TaskListItem extends StatefulWidget {
  const TaskListItem(this.task,
      {this.pendingFilter = false, Key? key, required this.darkmode})
      : super(key: key);

  final Task task;
  final bool pendingFilter;
  final bool darkmode;

  @override
  State<TaskListItem> createState() => _TaskListItemState();
}

class _TaskListItemState extends State<TaskListItem> {
  late Modify modify;
  bool isChecked = false;

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
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Task Updated'),
      duration: Duration(seconds: 2),
    ));
  }
  //dynamic status_value = StatusWidgetData.value;

  @override
  Widget build(BuildContext context) {
    MaterialColor colours = Colors.grey;
    var colour = widget.darkmode ? Colors.white : Colors.black;
    var dimColor = widget.darkmode
        ? const Color.fromARGB(137, 248, 248, 248)
        : const Color.fromARGB(136, 17, 17, 17);

    if (widget.task.priority == 'H') {
      colours = Colors.red;
    } else if (widget.task.priority == 'M') {
      colours = Colors.yellow;
    } else if (widget.task.priority == 'L') {
      colours = Colors.green;
    }

    if ((widget.task.status[0].toUpperCase()) == 'P') {
      // to differentiate between pending and completed tasks
      // pending tasks will be having the check boxes, on the other hand completed one's doesn't
      return CheckboxListTile(
        // homepage for pending tasks (when the home page is set to pending)
        side: const BorderSide(
          color: Colors.grey,
          width: 1.5,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
          side: const BorderSide(color: Colors.black, width: 1.0),
        ),
        onChanged: (value) {
          setState(() {
            isChecked = value!;
          });
          print(isChecked);
          StatusWidgetData.value = isChecked ? 'completed' : 'pending';
          setStatus(StatusWidgetData.value, widget.task.uuid);
          DateTime? dtb = widget.task.due;
          dtb = dtb!.add(const Duration(minutes: 1));
          final FlutterLocalNotificationsPlugin
              flutterLocalNotificationsPlugin =
              FlutterLocalNotificationsPlugin();
          flutterLocalNotificationsPlugin
              .cancel(dtb.day * 100 + dtb.hour * 10 + dtb.minute);

          print("Task due is $dtb");
          print(dtb.day * 100 + dtb.hour * 10 + dtb.minute);
          print(widget.task.status[0].toUpperCase());
          print(StatusWidgetData.value);
        },
        value: isChecked,
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
                Text(
                  '${(widget.task.id == 0) ? '#' : widget.task.id}. ${widget.task.description}',
                  style: TextStyle(
                      color: colour,
                      fontFamily: GoogleFonts.firaMono().fontFamily),
                ),
              ],
            ),
            Text(
              (widget.task.annotations != null)
                  ? ' [${widget.task.annotations!.length}]'
                  : '',
              style: TextStyle(
                  color: colour, fontFamily: GoogleFonts.firaMono().fontFamily),
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
                  '${widget.pendingFilter ? '' : '${widget.task.status[0].toUpperCase()}\n'}'
                          'Last Modified: ${(widget.task.modified != null) ? age(widget.task.modified!) : ((widget.task.start != null) ? age(widget.task.start!) : '-')} | '
                          'Due: ${(widget.task.due != null) ? when(widget.task.due!) : '-'}'
                      .replaceFirst(RegExp(r' \[\]$'), '')
                      .replaceAll(RegExp(r' +'), ' '),
                  style: TextStyle(
                      color: dimColor,
                      fontFamily: GoogleFonts.firaMono().fontFamily,
                      fontSize: 12,
                      overflow: TextOverflow.ellipsis),
                ),
              ),
            ),
            Text(
              formatUrgency(urgency(widget.task)),
              style: TextStyle(
                  color: colour, fontFamily: GoogleFonts.firaMono().fontFamily),
            ),
          ],
        ),
        // isThreeLine: true,
      );
    } else {
      // homepage for completed tasks (when the filter is set to completed)
      return ListTile(
        /*leading: Icon(
          Icons.circle,
          color: widget.task.priority == 'H'
              ? Colors.red
              : widget.task.priority == 'M'
                  ? Colors.yellow[600]
                  : Colors.green,
          size: 20,
          semanticLabel: 'Priority',
        ),*/
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
                Text(
                  '${(widget.task.id == 0) ? '#' : widget.task.id}. ${widget.task.description}',
                  style: TextStyle(
                      color: colour,
                      fontFamily: GoogleFonts.firaMono().fontFamily),
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
                  //'${widget.pendingFilter ? '' : '${widget.task.status[0].toUpperCase()}\n'}'
                  'Last Modified: ${(widget.task.modified != null) ? age(widget.task.modified!) : ((widget.task.start != null) ? age(widget.task.start!) : '-')} | '
                          'Due: ${(widget.task.due != null) ? when(widget.task.due!) : '-'}'
                      .replaceFirst(RegExp(r' \[\]$'), '')
                      .replaceAll(RegExp(r' +'), ' '),
                  style: TextStyle(
                      color: dimColor,
                      fontFamily: GoogleFonts.firaMono().fontFamily,
                      fontSize: 12,
                      overflow: TextOverflow.ellipsis),
                ),
              ),
            ),
            Text(
              formatUrgency(urgency(widget.task)),
              style: TextStyle(
                  color: colour, fontFamily: GoogleFonts.firaMono().fontFamily),
            ),
          ],
        ),
        // isThreeLine: true,
      );
    }
  }
}
