import 'package:taskwarrior/app/utils/constants/utilites.dart';

/// The time buckets a burndown chart can group tasks into.
enum BurnDownPeriod { daily, weekly, monthly }

/// A single task reduced to the only two things a burndown chart needs: when it
/// happened, and whether it was pending or completed.
///
/// Keeping the chart layer this narrow is what lets one implementation serve
/// every sync mode. The app has three task models — the built-value `Task`
/// (local/Taskserver), `TaskForC` (taskc) and `TaskForReplica` (TaskChampion) —
/// and each caller maps its own model into this shape. That also preserves each
/// mode's existing choice of *which* date to bucket by, since the caller picks
/// the date it passes in.
class BurnDownEntry {
  const BurnDownEntry({required this.date, required this.status});

  /// The date this task is counted under, already in local time.
  final DateTime date;

  /// `pending` / `completed` / anything else (which is simply not counted,
  /// matching the previous per-mode behaviour).
  final String status;
}

/// Groups [entries] into `{bucketKey: {'pending': n, 'completed': n}}`, the
/// shape the chart series expect.
///
/// Bucket keys match what the previous per-mode charts produced, so the x-axis
/// labels are unchanged:
///  * daily   — `MM-dd`
///  * weekly  — ISO week number
///  * monthly — `MonthName YYYY`
Map<String, Map<String, int>> bucketBurnDown(
  Iterable<BurnDownEntry> entries,
  BurnDownPeriod period,
) {
  final Map<String, Map<String, int>> buckets = {};

  // Oldest first, so the chart reads left-to-right in chronological order.
  final List<BurnDownEntry> sorted = entries.toList()
    ..sort((a, b) => a.date.compareTo(b.date));

  for (final BurnDownEntry entry in sorted) {
    final String key = burnDownBucketKey(entry.date, period);
    final Map<String, int> bucket =
        buckets.putIfAbsent(key, () => {'pending': 0, 'completed': 0});

    // Only pending/completed are plotted; other statuses (deleted, recurring)
    // are ignored, as they were before.
    if (entry.status == 'pending' || entry.status == 'completed') {
      bucket[entry.status] = (bucket[entry.status] ?? 0) + 1;
    }
  }

  return buckets;
}

/// The bucket a [date] falls into for a given [period].
String burnDownBucketKey(DateTime date, BurnDownPeriod period) {
  switch (period) {
    case BurnDownPeriod.daily:
      return Utils.formatDate(date, 'MM-dd');
    case BurnDownPeriod.weekly:
      return Utils.getWeekNumbertoInt(date).toString();
    case BurnDownPeriod.monthly:
      return '${Utils.getMonthName(date.month)} ${date.year}';
  }
}
