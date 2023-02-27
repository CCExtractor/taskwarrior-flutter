import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:taskwarrior/widgets/taskw.dart';
import 'package:taskwarrior/model/json.dart';

class TaskListItem extends StatelessWidget {
  const TaskListItem(this.task,
      {this.pendingFilter = false, Key? key, required this.darkmode})
      : super(key: key);

  final Task task;
  final bool pendingFilter;
  final bool darkmode;

  @override
  Widget build(BuildContext context) {
    var colour = darkmode ? Colors.white : Colors.black;
    var dimColor = darkmode
        ? const Color.fromARGB(137, 248, 248, 248)
        : const Color.fromARGB(136, 17, 17, 17);
    return ListTile(
      leading: Icon(
        Icons.circle,
        color: task.priority == 'H'
            ? Colors.red
            : task.priority == 'M'
                ? Colors.yellow[600]
                : Colors.green,
        size: 20,
        semanticLabel: 'Priority',
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Text(
                '${(task.id == 0) ? '#' : task.id}. ${task.description}',
                style: TextStyle(
                    color: colour,
                    fontFamily: GoogleFonts.firaMono().fontFamily),
              ),
            ),
          ),
          Text(
            (task.annotations != null) ? ' [${task.annotations!.length}]' : '',
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
                '${pendingFilter ? '' : '${task.status[0].toUpperCase()}\n'}'
                        'Last Modified: ${(task.modified != null) ? age(task.modified!) : ((task.start != null) ? age(task.start!) : '-')} | '
                        'Due: ${(task.due != null) ? when(task.due!) : '-'}'
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
            formatUrgency(urgency(task)),
            style: TextStyle(
                color: colour, fontFamily: GoogleFonts.firaMono().fontFamily),
          ),
        ],
      ),
    );
  }
}
