import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:taskwarrior/app/v3/champion/replica.dart';
import 'package:uuid/v4.dart';

/// Debug helper: populate the app with ~a year of tasks so the Report Engine
/// and the Statistics (burndown) screens have realistic data.
///
/// The add-task APIs stamp `entry`/`modified` with "now", so every task would
/// land in a single day. Instead this writes the underlying stores directly,
/// giving full control over the dates the charts bucket by:
///
///  * the TaskChampion replica SQLite (`tasks` + `working_set`) — what the
///    Report Engine reads, bucketed by `modified`;
///  * the legacy `.task/all.data` JSON-lines file — what the Statistics screen
///    reads in local mode, bucketed by `entry`.
///
/// Idempotent: tasks whose description starts with [marker] are removed first.
const String marker = '[seed] ';

Future<int> seedDummyTasks({int days = 365}) async {
  final List<_Dummy> tasks = _generate(days);
  await _seedReplica(tasks);
  await _seedLegacy(tasks);
  debugPrint('Seeded ${tasks.length} tasks over $days days');
  return tasks.length;
}

class _Dummy {
  _Dummy({
    required this.description,
    required this.entry,
    required this.modified,
    required this.status,
    this.project,
    this.priority,
    this.due,
    this.start,
    this.wait,
    this.tags = const <String>[],
  });

  final String description;
  final DateTime entry;
  final DateTime modified;
  final String status;
  final String? project;
  final String? priority;
  final DateTime? due;
  final DateTime? start;
  final DateTime? wait;
  final List<String> tags;
}

List<_Dummy> _generate(int days) {
  final Random rng = Random();
  final List<String> verbs = [
    'Review', 'Write', 'Fix', 'Plan', 'Call', 'Email', 'Buy', 'Read',
    'Refactor', 'Test', 'Deploy', 'Design', 'Book', 'Clean', 'Update',
    'Draft', 'Schedule', 'Investigate', 'Ship', 'Archive',
  ];
  final List<String> nouns = [
    'invoice', 'docs', 'landing page', 'bug', 'standup', 'budget', 'report',
    'garden', 'gym', 'flight', 'database', 'API', 'prototype', 'notes',
    'receipt', 'tax form', 'release notes', 'onboarding', 'backlog', 'demo',
  ];
  final List<String?> projects = [
    'Work', 'Personal', 'Finance', 'Home', 'Health', 'Study', null,
  ];
  final List<String?> priorities = ['H', 'M', 'L', null, null, null];
  final List<String> allTags = [
    'urgent', 'home', 'work', 'errands', 'review', 'later',
  ];

  final DateTime now = DateTime.now();
  final List<_Dummy> tasks = <_Dummy>[];

  for (int d = 0; d < days; d++) {
    final int perDay = 1 + rng.nextInt(4); // 1..4 tasks per day
    for (int i = 0; i < perDay; i++) {
      final DateTime modified = DateTime(now.year, now.month, now.day)
          .subtract(Duration(days: d))
          .add(Duration(hours: rng.nextInt(24), minutes: rng.nextInt(60)));
      final bool completed = rng.nextDouble() < 0.3;

      final String? project = projects[rng.nextInt(projects.length)];
      final String? priority =
          completed ? null : priorities[rng.nextInt(priorities.length)];

      DateTime? due;
      DateTime? start;
      DateTime? wait;
      if (!completed) {
        final int roll = rng.nextInt(10);
        if (roll < 3) {
          due = modified.add(Duration(days: 1 + rng.nextInt(14)));
        } else if (roll == 3) {
          due = modified.subtract(Duration(days: 1 + rng.nextInt(7)));
        } else if (roll == 4) {
          start = modified;
        } else if (roll == 5) {
          wait = modified.add(Duration(days: 1 + rng.nextInt(7)));
        }
      }

      final List<String> tags = <String>[
        for (final String tag in allTags)
          if (!completed && rng.nextDouble() < 0.15) tag,
      ];

      tasks.add(_Dummy(
        description:
            '$marker${verbs[rng.nextInt(verbs.length)]} ${nouns[rng.nextInt(nouns.length)]} #${d + 1}',
        entry: modified.subtract(Duration(seconds: rng.nextInt(3600))),
        modified: modified,
        status: completed ? 'completed' : 'pending',
        project: project,
        priority: priority,
        due: due,
        start: start,
        wait: wait,
        tags: tags,
      ));
    }
  }
  return tasks;
}

/// TaskChampion replica: `tasks(uuid, data)` + `working_set(uuid)` + `operations`.
///
/// Each task is written together with the Create/Update operations TaskChampion
/// syncs. Writing only the `tasks`/`working_set` tables (as an earlier version
/// did) leaves the replica with no operations — and TaskChampion's sync then
/// does nothing at all, because there is nothing to push and it never records a
/// base version.
Future<void> _seedReplica(List<_Dummy> tasks) async {
  await Replica.getAllTasksFromReplica(); // create the replica/schema if absent
  final String replicaPath = await Replica.getReplicaPath();
  final Database db = await openDatabase('$replicaPath/taskchampion.sqlite3');
  try {
    await _deletePreviousSeed(db);

    final Batch batch = db.batch();
    for (final _Dummy t in tasks) {
      final String uuid = UuidV4().generate();
      final Map<String, String> data = <String, String>{
        'description': t.description,
        'entry': '${t.entry.toUtc().millisecondsSinceEpoch ~/ 1000}',
        'modified': '${t.modified.toUtc().millisecondsSinceEpoch ~/ 1000}',
        'status': t.status,
        if (t.project != null) 'project': t.project!,
        if (t.priority != null) 'priority': t.priority!,
        if (t.due != null)
          'due': '${t.due!.toUtc().millisecondsSinceEpoch ~/ 1000}',
        if (t.start != null)
          'start': '${t.start!.toUtc().millisecondsSinceEpoch ~/ 1000}',
        if (t.wait != null)
          'wait': '${t.wait!.toUtc().millisecondsSinceEpoch ~/ 1000}',
        for (final String tag in t.tags) 'tag_$tag': '',
      };
      batch.insert('tasks', {'uuid': uuid, 'data': jsonEncode(data)},
          conflictAlgorithm: ConflictAlgorithm.replace);
      // Only pending/recurring tasks belong in the working set; completed and
      // deleted ones are rebuilt out of it after every sync.
      if (t.status == 'pending' || t.status == 'recurring') {
        batch.insert('working_set', {'uuid': uuid});
      }
      for (final Map<String, Object?> op in _operationsFor(uuid, data, t.modified)) {
        batch.insert('operations', op);
      }
    }
    await batch.commit(noResult: true);
  } finally {
    await db.close();
  }
}

/// The TaskChampion operations that produce [data] on a fresh replica: a
/// Create followed by one Update per property. The timestamp is the task's
/// `modified` instant, so last-write-wins resolves sensibly against edits made
/// on other replicas.
List<Map<String, Object?>> _operationsFor(
  String uuid,
  Map<String, String> data,
  DateTime modified,
) {
  final String ts = modified.toUtc().toIso8601String();
  final List<Map<String, Object?>> ops = <Map<String, Object?>>[
    <String, Object?>{
      'data': jsonEncode(<String, dynamic>{
        'Create': {'uuid': uuid}
      }),
      'synced': 0,
    },
  ];
  for (final MapEntry<String, String> e in data.entries) {
    ops.add(<String, Object?>{
      'data': jsonEncode(<String, dynamic>{
        'Update': {
          'uuid': uuid,
          'property': e.key,
          'old_value': null,
          'value': e.value,
          'timestamp': ts,
        }
      }),
      'synced': 0,
    });
  }
  return ops;
}

/// Remove tasks left by a previous run (and their operation-log rows) so
/// re-running stays idempotent.
Future<void> _deletePreviousSeed(Database db) async {
  await db.delete('tasks', where: 'data LIKE ?', whereArgs: ['%$marker%']);
  await db.rawDelete(
      'DELETE FROM operations WHERE uuid NOT IN (SELECT uuid FROM tasks)');
  await db.rawDelete(
      'DELETE FROM working_set WHERE uuid NOT IN (SELECT uuid FROM tasks)');
}

/// Legacy store: one JSON `Task` per line in `profiles/<profile>/.task/all.data`.
Future<void> _seedLegacy(List<_Dummy> tasks) async {
  final Directory base = await Replica.getBaseDire();
  final String? profile = await Replica.getCurrentProfile();
  if (profile == null) return;

  final File file = File('${base.path}/profiles/$profile/.task/all.data');
  final List<String> kept = file.existsSync()
      ? file
          .readAsLinesSync()
          .where((line) => line.isNotEmpty && !line.contains(marker))
          .toList()
      : <String>[];

  for (final _Dummy t in tasks) {
    kept.add(jsonEncode(<String, dynamic>{
      'status': t.status,
      'uuid': UuidV4().generate(),
      'entry': _basicIso(t.entry),
      'description': t.description,
      'modified': _basicIso(t.modified),
      if (t.project != null) 'project': t.project,
      if (t.priority != null) 'priority': t.priority,
      if (t.due != null) 'due': _basicIso(t.due!),
      if (t.start != null) 'start': _basicIso(t.start!),
      if (t.wait != null) 'wait': _basicIso(t.wait!),
      if (t.tags.isNotEmpty) 'tags': t.tags,
    }));
  }

  file.parent.createSync(recursive: true);
  file.writeAsStringSync('${kept.join('\n')}\n');
}

/// Taskwarrior's compact UTC date format: `YYYYMMDDTHHMMSSZ`.
String _basicIso(DateTime dateTime) {
  final DateTime u = dateTime.toUtc();
  String p(int n, [int width = 2]) => n.toString().padLeft(width, '0');
  return '${p(u.year, 4)}${p(u.month)}${p(u.day)}'
      'T${p(u.hour)}${p(u.minute)}${p(u.second)}Z';
}
