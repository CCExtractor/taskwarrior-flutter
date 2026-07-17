import 'package:taskwarrior/app/v3/champion/models/task_for_replica.dart';

/// Evaluates Taskwarrior-style filter expressions against replica tasks.
///
/// Supports the virtual tags that drive the default reports (Issue #418) —
/// `+ACTIVE`, `+READY`, `+BLOCKED`, `+BLOCKING`, `+OVERDUE`, `+WAITING`,
/// `+PENDING`, `+COMPLETED`, `+DELETED` — plus attribute filters
/// (`status:`, `project:`, `priority:`) and negation (`-TAG`). Tokens are
/// combined with AND, so `"status:pending +ACTIVE project:work"` keeps tasks
/// that satisfy every token.
class VirtualFilterEngine {
  /// Returns whether [task] satisfies a single virtual/real tag like `+READY`
  /// or `+home`. [now] anchors time-relative tags (`+OVERDUE`).
  static bool evaluateTag(TaskForReplica task, String tag, {DateTime? now}) {
    final DateTime clock = (now ?? DateTime.now()).toUtc();
    final String bare = tag.replaceFirst('+', '');
    switch (bare.toUpperCase()) {
      case 'ACTIVE':
        return task.status == 'pending' && _isSet(task.start);
      case 'READY':
        return task.status == 'pending' &&
            !(task.isBlocked ?? false) &&
            !_isFutureWait(task, clock);
      case 'BLOCKED':
        return task.isBlocked ?? false;
      case 'BLOCKING':
        return task.isBlocking ?? false;
      case 'OVERDUE':
        final DateTime? due = _parseDate(task.due);
        return due != null && due.isBefore(clock);
      case 'WAITING':
        return task.status == 'waiting' || _isFutureWait(task, clock);
      case 'PENDING':
        return task.status == 'pending';
      case 'COMPLETED':
        return task.status == 'completed';
      case 'DELETED':
        return task.status == 'deleted';
      default:
        // A real user tag.
        return task.tags?.contains(bare) ?? false;
    }
  }

  /// Applies a compound filter [expression] to [tasks]. An empty/blank
  /// expression matches everything.
  static List<TaskForReplica> applyFilter(
    List<TaskForReplica> tasks,
    String? expression, {
    DateTime? now,
  }) {
    final String expr = (expression ?? '').trim();
    if (expr.isEmpty) return List<TaskForReplica>.from(tasks);

    final List<String> tokens =
        expr.split(RegExp(r'\s+')).where((t) => t.isNotEmpty).toList();
    final DateTime clock = (now ?? DateTime.now()).toUtc();

    return tasks.where((task) {
      return tokens.every((tok) {
        if (tok.startsWith('+')) return evaluateTag(task, tok, now: clock);
        if (tok.startsWith('-')) {
          return !evaluateTag(task, '+${tok.substring(1)}', now: clock);
        }
        final int colon = tok.indexOf(':');
        if (colon > 0) {
          return _matchAttribute(
              task, tok.substring(0, colon), tok.substring(colon + 1));
        }
        // Bare word → substring match on the description.
        return (task.description ?? '')
            .toLowerCase()
            .contains(tok.toLowerCase());
      });
    }).toList();
  }

  static bool _matchAttribute(TaskForReplica task, String attr, String value) {
    switch (attr) {
      case 'status':
        return (task.status ?? '') == value;
      case 'project':
        // Taskwarrior treats project as a hierarchy prefix match.
        return (task.project ?? '').startsWith(value);
      case 'priority':
        return (task.priority ?? '') == value;
      default:
        // Unknown attribute → don't exclude the task.
        return true;
    }
  }

  static bool _isSet(String? v) => v != null && v.isNotEmpty;

  static bool _isFutureWait(TaskForReplica task, DateTime clock) {
    final DateTime? wait = _parseDate(task.wait);
    return wait != null && wait.isAfter(clock);
  }

  static DateTime? _parseDate(String? value) {
    if (value == null || value.isEmpty) return null;
    final DateTime? parsed = DateTime.tryParse(value);
    if (parsed != null) return parsed.toUtc();
    final int? epoch = int.tryParse(value);
    if (epoch != null) {
      return DateTime.fromMillisecondsSinceEpoch(epoch * 1000, isUtc: true);
    }
    return null;
  }
}
