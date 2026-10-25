import 'dart:math';

import 'package:taskwarrior/app/models/json/task.dart';
import 'package:taskwarrior/app/utils/taskfunctions/urgency.dart';


int _priorityRank(String? priority) {
  switch (priority) {
    case 'H':
      return 3;
    case 'M':
      return 2;
    case 'L':
      return 1;
    default:
      return 0;
  }
}

int _compareDue(DateTime? a, DateTime? b) {
  if (a != null && b != null) {
    return a.compareTo(b);
  } else if (a != null) {
    return -1;
  } else if (b != null) {
    return 1;
  }
  return 0;
}

int Function(Task, Task) compareTasks(String column) {
  return (a, b) {
    int? result;
    switch (column) {
      case 'Created':
        result = a.entry.compareTo(b.entry);
        break;
      case 'Modified':
        if (a.modified == null && b.modified == null) {
          result = 0;
        } else if (a.modified == null) {
          return 1;
        } else if (b.modified == null) {
          return -1;
        } else {
          result = a.modified!.compareTo(b.modified!);
        }
        break;
      case 'Start Time':
        if (a.start == null && b.start == null) {
          result = 0;
        } else if (a.start == null) {
          return 1;
        } else if (b.start == null) {
          return -1;
        } else {
          result = a.start!.compareTo(b.start!);
        }
        break;
      case 'Due till':
        if (a.due == null && b.due == null) {
          result = 0;
        } else if (a.due == null) {
          return 1;
        } else if (b.due == null) {
          return -1;
        } else {
          result = a.due!.compareTo(b.due!);
        }
        break;
      case 'Priority':
      case 'Priority+':
        result =
            _priorityRank(a.priority).compareTo(_priorityRank(b.priority));
        if (result == 0) {
          result = _compareDue(a.due, b.due);
        }
        break;
      case 'Priority-':
        result =
            _priorityRank(b.priority).compareTo(_priorityRank(a.priority));
        if (result == 0) {
          result = _compareDue(a.due, b.due);
        }
        break;
      case 'Project':
        result = (a.project ?? '').compareTo(b.project ?? '');
        break;
      case 'Tags':
        for (var i = 0;
            i < min(a.tags?.length ?? 0, b.tags?.length ?? 0);
            i++) {
          if (result == null || result == 0) {
            result = a.tags![i].compareTo(b.tags![i]);
          }
        }
        if (result == null || result == 0) {
          result = (a.tags?.length ?? 0).compareTo(b.tags?.length ?? 0);
        }
        break;
      case 'Urgency':
        result = -urgency(a).compareTo(urgency(b));
        break;
      default:
        result = 1;
    }
    return result;
  };
}
