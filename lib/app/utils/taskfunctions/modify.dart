// ignore_for_file: depend_on_referenced_packages

import 'package:collection/collection.dart';
import 'package:taskwarrior/app/models/models.dart';
import 'package:taskwarrior/app/utils/taskfunctions/recurrence_engine.dart';
import 'package:taskwarrior/app/utils/taskfunctions/draft.dart';
import 'package:uuid/uuid.dart';

class Modify {
  Modify({
    required Task Function(String) getTask,
    required void Function(Task) mergeTask,
    required String uuid,
  })  : _getTask = getTask,
        _mergeTask = mergeTask,
        _uuid = uuid {
    _draft = Draft(_getTask(_uuid));
  }

  final Task Function(String) _getTask;
  final void Function(Task) _mergeTask;
  final String _uuid;
  late Draft _draft;

  Task get draft => _draft.draft;
  int get id => _draft.original.id!;
  Task get original => _draft.original;

  Map<dynamic, Map> get changes {
    var result = <dynamic, Map>{};
    var savedJson = _draft.original.toJson();
    var draftJson = _draft.draft.toJson();

    for (var entry in {
      for (var key in [
        'description',
        'status',
        'start',
        'end',
        'due',
        'wait',
        'until',
        'recur',
        'priority',
        'project',
        'tags',
        'annotations',
      ])
        key: (value) {
          if (value != null &&
              ['start', 'end', 'due', 'wait', 'until'].contains(key)) {
            return DateTime.parse(value).toLocal();
          } else if (key == 'annotations') {
            return (value as List?)?.length ?? 0;
          }
          return value;
        },
    }.entries) {
      var key = entry.key;
      var savedValue = savedJson[key];
      var draftValue = draftJson[key];

      if (draftValue != savedValue &&
          !(key == 'tags' &&
              const ListEquality().equals(draftValue, savedValue)) &&
          !(key == 'annotations' &&
              const DeepCollectionEquality().equals(draftValue, savedValue))) {
        result[key] = {
          'old': entry.value(savedValue),
          'new': entry.value(draftValue),
        };
      }
    }
    return result;
  }

  // ignore: avoid_annotating_with_dynamic
  void set(String key, dynamic value) {
    _draft.set(key, value);
  }

  Task? _nextRecurringTask({
    required Task source,
    required DateTime now,
  }) {
    final recur = source.recur;
    if (recur == null || recur.trim().isEmpty) {
      return null;
    }

    final baseDue = source.due ?? now;
    final nextDue = RecurrenceEngine.calculateNextDate(baseDue, recur);
    if (nextDue == null) {
      return null;
    }

    final nextWait = source.wait != null
        ? RecurrenceEngine.calculateNextDate(source.wait!, recur)
        : null;

    return source.rebuild((b) {
      b
        ..id = null
        ..uuid = const Uuid().v1()
        ..status = 'pending'
        ..entry = now
        ..modified = now
        ..start = null
        ..end = null
        ..due = nextDue.toUtc()
        ..wait = nextWait?.toUtc();
    });
  }

  void save({required DateTime Function() modified}) {
    final now = modified();
    final wasCompleted = _draft.original.status == 'completed';
    final isNowCompleted = _draft.draft.status == 'completed';
    final Task? spawnedRecurring = (!wasCompleted && isNowCompleted)
        ? _nextRecurringTask(source: _draft.draft, now: now)
        : null;

    _draft.set('modified', now);
    _mergeTask(_draft.draft);
    if (spawnedRecurring != null) {
      _mergeTask(spawnedRecurring);
    }
    _draft = Draft(_getTask(_uuid));
  }
}
