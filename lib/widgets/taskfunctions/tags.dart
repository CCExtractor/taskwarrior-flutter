import 'dart:math';

import 'package:taskwarrior/model/json.dart';

Set<String> tagSet(Iterable<Task> tasks) {
  return tasks.where((task) => task.tags != null).fold(
      <String>{}, (aggregate, task) => aggregate..addAll(task.tags!.toList()));
}

Map<String, int> tagFrequencies(Iterable<Task> tasks) {
  var frequency = <String, int>{};
  for (var task in tasks) {
    for (var tag in task.tags?.asList() ?? []) {
      if (frequency.containsKey(tag)) {
        frequency[tag] = (frequency[tag] ?? 0) + 1;
      } else {
        frequency[tag] = 1;
      }
    }
  }
  return frequency;
}

Map<String, DateTime> tagsLastModified(Iterable<Task> tasks) {
  var modifiedMap = <String, DateTime>{};
  for (var task in tasks) {
    var modified = task.modified ?? task.start ?? task.entry;
    for (var tag in task.tags?.asList() ?? []) {
      if (modifiedMap.containsKey(tag)) {
        modifiedMap[tag] = DateTime.fromMicrosecondsSinceEpoch(
          max(
            modified.microsecondsSinceEpoch,
            modifiedMap[tag]!.microsecondsSinceEpoch,
          ),
          isUtc: true,
        );
      } else {
        modifiedMap[tag] = modified;
      }
    }
  }
  return modifiedMap;
}
