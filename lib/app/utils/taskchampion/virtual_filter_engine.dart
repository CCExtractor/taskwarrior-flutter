import 'package:taskwarrior/app/models/task_like.dart';

/// Evaluates Taskwarrior-style filter expressions against tasks.
///
/// Supports the virtual tags that drive the default reports (Issue #418) —
/// `+ACTIVE`, `+READY`, `+BLOCKED`, `+BLOCKING`, `+OVERDUE`, `+WAITING`,
/// `+PENDING`, `+COMPLETED`, `+DELETED` — plus attribute filters
/// (`status:`, `project:`, `priority:`) and negation (`-TAG`). Tokens are
/// combined with AND, so `"status:pending +ACTIVE project:work"` keeps tasks
/// that satisfy every token.
///
/// Written against [TaskLike] so it works for every task model / sync mode.
class VirtualFilterEngine {
  /// Returns whether [task] satisfies a single virtual/real tag like `+READY`
  /// or `+home`. [now] anchors time-relative tags (`+OVERDUE`).
  static bool evaluateTag(TaskLike task, String tag, {DateTime? now}) {
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
        // Taskwarrior defines +OVERDUE as pending tasks whose due date has
        // passed; a completed/deleted task is never "overdue" even if its due
        // date lapsed before it was closed.
        final DateTime? due = parseTaskDate(task.due);
        return task.status == 'pending' && due != null && due.isBefore(clock);
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
  /// expression matches everything. The element type is preserved, so callers
  /// keep their concrete model type.
  static List<T> applyFilter<T extends TaskLike>(
    List<T> tasks,
    String? expression, {
    DateTime? now,
  }) {
    final String expr = (expression ?? '').trim();
    if (expr.isEmpty) return List<T>.from(tasks);

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

  static bool _matchAttribute(TaskLike task, String attr, String value) {
    switch (attr) {
      case 'status':
        return (task.status ?? '') == value;
      case 'project':
        // Taskwarrior treats project as a hierarchy match: "work" matches
        // "work" and its children ("work.sub"), but a raw prefix match would
        // also wrongly match an unrelated sibling like "workshop" — require a
        // dot boundary after the prefix.
        final String proj = task.project ?? '';
        return proj == value || proj.startsWith('$value.');
      case 'priority':
        return (task.priority ?? '') == value;
      default:
        // Unknown attribute → don't exclude the task.
        return true;
    }
  }

  static bool _isSet(String? v) => v != null && v.isNotEmpty;

  static bool _isFutureWait(TaskLike task, DateTime clock) {
    final DateTime? wait = parseTaskDate(task.wait);
    return wait != null && wait.isAfter(clock);
  }
}
