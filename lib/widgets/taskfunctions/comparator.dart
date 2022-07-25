import 'dart:math';

import 'package:taskwarrior/model/json.dart';

import 'package:taskwarrior/widgets/taskw.dart';

// ignore: prefer_expression_function_bodies
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
        var compare = {'H': 2, 'M': 1, 'L': 0};
        result =
            (compare[a.priority] ?? -1).compareTo(compare[b.priority] ?? -1);
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
    }
    return result!;
  };
}
