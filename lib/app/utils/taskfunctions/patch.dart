// ignore_for_file: depend_on_referenced_packages

import 'package:built_collection/built_collection.dart';
import 'package:taskwarrior/app/models/models.dart';

Task patch(Task task, Map<String, dynamic> updates) {
  return updates.entries.fold(
    task,
    (result, entry) => _patch(
      result,
      entry.key,
      entry.value,
    ),
  );
}

// ignore: avoid_annotating_with_dynamic
Task _patch(Task task, String key, dynamic value) {
  return task.rebuild(
    (b) {
      switch (key) {
        case 'description':
          b.description = value;
          break;
        case 'status':
          b.status = value;
          break;
        case 'start':
          b.start = value;
          break;
        case 'end':
          b.end = value;
          break;
        case 'due':
          b.due = value;
          break;
        case 'wait':
          b.wait = value;
          break;
        case 'until':
          b.until = value;
          break;
        case 'modified':
          b.modified = value;
          break;
        case 'priority':
          b.priority = value;
          break;
        case 'project':
          b.project = value;
          break;
        case 'tags':
          b.tags = BuiltList<String>(
                  (value as ListBuilder).build().toList().cast<String>())
              .toBuilder();
          break;
      }
    },
  );
}
