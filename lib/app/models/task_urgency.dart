import 'package:taskwarrior/app/models/task_like.dart';

/// Computes a task's urgency using Taskwarrior's standard algorithm and its
/// built-in default coefficients.
///
/// TaskChampion (the storage/sync layer this app embeds) does not compute or
/// store urgency — it is a Taskwarrior-CLI concept — so we reproduce the
/// formula here. It is written against [TaskLike] so every task model gets the
/// same ranking, rather than only the TaskChampion path.
///
/// Default coefficients, matching upstream Taskwarrior (`Task.cpp urgency_c`):
///
///   priority H/M/L = 6.0 / 3.9 / 1.8   due = 12.0     next(tag) = 15.0
///   active = 4.0    age = 2.0 (over 365d)    annotations = 1.0
///   tags = 1.0      project = 1.0    blocking = 8.0   blocked = -5.0
///   waiting = -3.0
///
/// `scheduled` (+5.0) and user-defined attributes/coefficients are omitted:
/// TaskChampion does not surface a scheduled date, and there are no UDAs here.
///
/// [clock] overrides "now" (for age/due/waiting) so the result is testable.
double computeTaskUrgency(TaskLike task, {DateTime? clock}) {
  final DateTime now = (clock ?? DateTime.now()).toUtc();
  double urgency = 0.0;

  // Priority.
  switch (task.priority) {
    case 'H':
      urgency += 6.0;
      break;
    case 'M':
      urgency += 3.9;
      break;
    case 'L':
      urgency += 1.8;
      break;
  }

  // Belongs to a project.
  final String? project = task.project;
  if (project != null && project.isNotEmpty) urgency += 1.0;

  // Active (has been started).
  final String? start = task.start;
  if (start != null && start.isNotEmpty) urgency += 4.0;

  // Tags: 1 -> 0.8, 2 -> 0.9, 3+ -> 1.0. The special "next" tag adds 15.0.
  final List<String> tagList = task.tags ?? const <String>[];
  if (tagList.length == 1) {
    urgency += 0.8;
  } else if (tagList.length == 2) {
    urgency += 0.9;
  } else if (tagList.length >= 3) {
    urgency += 1.0;
  }
  if (tagList.contains('next')) urgency += 15.0;

  // Annotations: 1 -> 0.8, 2 -> 0.9, 3+ -> 1.0.
  final int annCount = task.annotations?.length ?? 0;
  if (annCount == 1) {
    urgency += 0.8;
  } else if (annCount == 2) {
    urgency += 0.9;
  } else if (annCount >= 3) {
    urgency += 1.0;
  }

  // Age: linear ramp from 0 to 1 over 365 days since entry, coefficient 2.0.
  final DateTime? entryDate = task.entryDate;
  if (entryDate != null) {
    final double ageDays = now.difference(entryDate).inSeconds / 86400.0;
    const double maxAge = 365.0;
    final double ageTerm =
        ageDays >= maxAge ? 1.0 : (ageDays <= 0 ? 0.0 : ageDays / maxAge);
    urgency += 2.0 * ageTerm;
  }

  // Due: ramp mapping ~21 days around the due date to 0.2..1.0, coefficient 12.
  final DateTime? dueDate = parseTaskDate(task.due);
  if (dueDate != null) {
    final double daysOverdue = now.difference(dueDate).inSeconds / 86400.0;
    double term;
    if (daysOverdue >= 7.0) {
      term = 1.0;
    } else if (daysOverdue >= -14.0) {
      term = ((daysOverdue + 14.0) * 0.8 / 21.0) + 0.2;
    } else {
      term = 0.2;
    }
    urgency += 12.0 * term;
  }

  // Waiting (wait date in the future).
  final DateTime? waitDate = parseTaskDate(task.wait);
  if (waitDate != null && waitDate.isAfter(now)) urgency -= 3.0;

  // Dependency relationships.
  if (task.isBlocking == true) urgency += 8.0;
  if (task.isBlocked == true) urgency -= 5.0;

  return urgency;
}
