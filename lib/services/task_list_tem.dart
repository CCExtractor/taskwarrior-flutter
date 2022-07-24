import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:taskwarrior/widgets/taskw.dart';
import 'package:taskwarrior/model/json.dart';

class TaskListItem extends StatelessWidget {
  const TaskListItem(this.task, {this.pendingFilter = false, Key? key})
      : super(key: key);

  final Task task;
  final bool pendingFilter;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Text(
                task.description,
                style: GoogleFonts.firaMono(),
              ),
            ),
          ),
          Text(
            (task.annotations != null) ? ' [${task.annotations!.length}]' : '',
            style: GoogleFonts.firaMono(),
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
                '${(task.id == 0) ? '-' : task.id} '
                        '${pendingFilter ? '' : '${task.status[0].toUpperCase()} '}'
                        '${age(task.entry)} '
                        '${(task.modified != null) ? 'm:${age(task.modified!)}' : ''} '
                        '${(task.start != null) ? 'st:${age(task.start!)}' : ''} '
                        '${(task.due != null) ? 'd:${when(task.due!)}' : ''} '
                        '${task.priority ?? ''} '
                        '${task.project ?? ''} '
                        '[${task.tags?.join(',') ?? ''}]'
                    .replaceFirst(RegExp(r' \[\]$'), '')
                    .replaceAll(RegExp(r' +'), ' '),
                style: GoogleFonts.firaMono(),
              ),
            ),
          ),
          Text(
            formatUrgency(urgency(task)),
            style: GoogleFonts.firaMono(),
          ),
        ],
      ),
    );
  }
}
