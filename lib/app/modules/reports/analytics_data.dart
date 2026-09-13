import 'dart:math' as math;

/// The window an analytics dashboard is showing.
enum ReportRange { d7, d30, m3, y1, all }

/// How the trend line is bucketed, derived from the range length.
enum TrendGranularity { daily, weekly, monthly }

/// One task reduced to what the analytics need: when it was created, when it was
/// completed (if it was), whether it is done, and the dimensions we break down
/// by. Every sync mode maps its own model into this shape — see [ActivityEntry].
class ActivityEntry {
  const ActivityEntry({
    required this.created,
    this.completed,
    this.due,
    required this.isCompleted,
    this.project,
    this.priority,
  });

  /// When the task was created (`entry`), local time.
  final DateTime created;

  /// When it was completed, local time; null while it is still open.
  final DateTime? completed;

  /// Due date, local time; used for the overdue count.
  final DateTime? due;

  final bool isCompleted;
  final String? project;

  /// Taskwarrior priority: `H`, `M`, `L` or null.
  final String? priority;
}

/// A single point on the activity trend: how many tasks were created and
/// completed in one bucket.
class TrendPoint {
  const TrendPoint(this.date, this.created, this.completed);

  final DateTime date;
  final int created;
  final int completed;
}

/// A named value used by the breakdown lists (projects, priorities).
class NamedCount {
  const NamedCount(this.label, this.count);

  final String label;
  final int count;
}

/// Everything the dashboard renders, computed once from the task list.
class AnalyticsSummary {
  const AnalyticsSummary({
    required this.completed,
    required this.created,
    required this.completedDelta,
    required this.createdDelta,
    required this.completionRate,
    required this.pending,
    required this.trend,
    required this.granularity,
    required this.projects,
    required this.priorities,
    required this.heatmapStart,
    required this.heatmapWeeks,
    required this.heatmapMax,
  });

  /// Tasks completed inside the selected range.
  final int completed;

  /// Tasks created inside the selected range.
  final int created;

  /// Change in [completed] vs the previous equal-length window.
  final int completedDelta;

  /// Change in [created] vs the previous equal-length window.
  final int createdDelta;

  /// Share of all known tasks that are done, 0..1.
  final double completionRate;

  /// Tasks not yet completed (a snapshot, not range-bound).
  final int pending;

  final List<TrendPoint> trend;
  final TrendGranularity granularity;

  /// Completed-per-project in the range, highest first.
  final List<NamedCount> projects;

  /// Every task grouped by priority (`H`, `M`, `L`, or [noPriority]).
  final List<NamedCount> priorities;

  /// First cell (a Sunday) of the activity heatmap.
  final DateTime heatmapStart;

  /// Heatmap columns; each is 7 daily activity counts, Sunday first.
  final List<List<int>> heatmapWeeks;

  /// Highest single-day count in the heatmap, for scaling the colour ramp.
  final int heatmapMax;
}

/// Label used when a task has no project. Callers pass the translated string.
const String noProject = '\u0000no-project';

/// Label used when a task has no priority.
const String noPriority = '\u0000no-priority';

/// Buckets [entries] into the dashboard summary for [range].
///
/// Pure: no Flutter or storage dependencies, so it is cheap to test.
AnalyticsSummary summarize({
  required List<ActivityEntry> entries,
  required ReportRange range,
  required DateTime now,
}) {
  final DateTime today = _dateOnly(now);
  final DateTime start = _rangeStart(range, today, entries);
  final DateTime endExclusive = today.add(const Duration(days: 1));
  final int spanDays = math.max(1, endExclusive.difference(start).inDays);
  final DateTime prevStart = start.subtract(Duration(days: spanDays));
  final DateTime prevEnd = start;

  int completedIn(DateTime from, DateTime to) => entries
      .where((e) =>
          e.isCompleted &&
          e.completed != null &&
          !e.completed!.isBefore(from) &&
          e.completed!.isBefore(to))
      .length;

  int createdIn(DateTime from, DateTime to) => entries
      .where((e) => !e.created.isBefore(from) && e.created.isBefore(to))
      .length;

  final int completed = completedIn(start, endExclusive);
  final int created = createdIn(start, endExclusive);
  final int prevCompleted = completedIn(prevStart, prevEnd);
  final int prevCreated = createdIn(prevStart, prevEnd);

  final int totalCompleted = entries.where((e) => e.isCompleted).length;
  final int totalPending = entries.where((e) => !e.isCompleted).length;
  final double completionRate = (totalCompleted + totalPending) == 0
      ? 0
      : totalCompleted / (totalCompleted + totalPending);

  final TrendGranularity granularity = spanDays <= 31
      ? TrendGranularity.daily
      : spanDays <= 120
          ? TrendGranularity.weekly
          : TrendGranularity.monthly;

  final DateTime heatmapStart = _heatmapStart(today);
  final List<List<int>> heatmapWeeks = _buildHeatmap(entries, heatmapStart, today);

  int heatmapMax = 0;
  for (final List<int> week in heatmapWeeks) {
    for (final int count in week) {
      if (count > heatmapMax) heatmapMax = count;
    }
  }

  return AnalyticsSummary(
    completed: completed,
    created: created,
    completedDelta: completed - prevCompleted,
    createdDelta: created - prevCreated,
    completionRate: completionRate,
    pending: totalPending,
    trend: _buildTrend(entries, start, endExclusive, granularity),
    granularity: granularity,
    projects: _projectBreakdown(entries, start, endExclusive),
    priorities: _priorityBreakdown(entries),
    heatmapStart: heatmapStart,
    heatmapWeeks: heatmapWeeks,
    heatmapMax: heatmapMax,
  );
}

/// The first day the selected range covers.
DateTime _rangeStart(ReportRange range, DateTime today, List<ActivityEntry> entries) {
  switch (range) {
    case ReportRange.d7:
      return today.subtract(const Duration(days: 6));
    case ReportRange.d30:
      return today.subtract(const Duration(days: 29));
    case ReportRange.m3:
      return today.subtract(const Duration(days: 89));
    case ReportRange.y1:
      return today.subtract(const Duration(days: 364));
    case ReportRange.all:
      if (entries.isEmpty) return today.subtract(const Duration(days: 29));
      DateTime earliest = entries.first.created;
      for (final ActivityEntry e in entries) {
        if (e.created.isBefore(earliest)) earliest = e.created;
      }
      return _dateOnly(earliest);
  }
}

/// Continuous buckets from [start] (inclusive) to [end] (exclusive), so the
/// line has no gaps on days/weeks/months with no activity.
List<TrendPoint> _buildTrend(
  List<ActivityEntry> entries,
  DateTime start,
  DateTime end,
  TrendGranularity granularity,
) {
  final List<DateTime> buckets = <DateTime>[];
  switch (granularity) {
    case TrendGranularity.daily:
      for (DateTime d = start; d.isBefore(end); d = d.add(const Duration(days: 1))) {
        buckets.add(d);
      }
    case TrendGranularity.weekly:
      for (DateTime d = start; d.isBefore(end); d = d.add(const Duration(days: 7))) {
        buckets.add(d);
      }
    case TrendGranularity.monthly:
      DateTime d = DateTime(start.year, start.month);
      while (d.isBefore(end)) {
        buckets.add(d);
        d = DateTime(d.year, d.month + 1);
      }
  }

  final List<int> created = List<int>.filled(buckets.length, 0);
  final List<int> completed = List<int>.filled(buckets.length, 0);

  int indexOf(DateTime date) {
    switch (granularity) {
      case TrendGranularity.daily:
        return date.difference(start).inDays;
      case TrendGranularity.weekly:
        return date.difference(start).inDays ~/ 7;
      case TrendGranularity.monthly:
        return (date.year - start.year) * 12 + (date.month - start.month);
    }
  }

  for (final ActivityEntry e in entries) {
    if (!e.created.isBefore(start) && e.created.isBefore(end)) {
      final int i = indexOf(e.created);
      if (i >= 0 && i < buckets.length) created[i]++;
    }
    final DateTime? c = e.completed;
    if (e.isCompleted && c != null && !c.isBefore(start) && c.isBefore(end)) {
      final int i = indexOf(c);
      if (i >= 0 && i < buckets.length) completed[i]++;
    }
  }

  return List<TrendPoint>.generate(
    buckets.length,
    (i) => TrendPoint(buckets[i], created[i], completed[i]),
  );
}

/// Completed tasks in the range, grouped by project, biggest first.
List<NamedCount> _projectBreakdown(
  List<ActivityEntry> entries,
  DateTime start,
  DateTime end,
) {
  final Map<String, int> counts = <String, int>{};
  for (final ActivityEntry e in entries) {
    final DateTime? c = e.completed;
    if (!e.isCompleted || c == null || c.isBefore(start) || !c.isBefore(end)) {
      continue;
    }
    final String key = (e.project == null || e.project!.trim().isEmpty)
        ? noProject
        : e.project!.trim();
    counts[key] = (counts[key] ?? 0) + 1;
  }
  final List<NamedCount> result = counts.entries
      .map((e) => NamedCount(e.key, e.value))
      .toList()
    ..sort((a, b) => b.count.compareTo(a.count));
  return result.take(8).toList();
}

/// Every task grouped by priority in H/M/L/none order, regardless of status or
/// the selected range — this is an overall picture of the backlog.
List<NamedCount> _priorityBreakdown(List<ActivityEntry> entries) {
  final Map<String, int> counts = <String, int>{'H': 0, 'M': 0, 'L': 0, noPriority: 0};
  for (final ActivityEntry e in entries) {
    final String key = (e.priority == 'H' || e.priority == 'M' || e.priority == 'L')
        ? e.priority!
        : noPriority;
    counts[key] = (counts[key] ?? 0) + 1;
  }
  return counts.entries
      .where((e) => e.value > 0)
      .map((e) => NamedCount(e.key, e.value))
      .toList();
}

/// The Sunday on or before a year ago, so the heatmap starts on a week boundary.
DateTime _heatmapStart(DateTime today) {
  final DateTime first = today.subtract(const Duration(days: 364));
  return first.subtract(Duration(days: first.weekday % 7));
}

/// Last 12 months of daily activity: tasks created plus tasks completed on
/// each day. Counting creations too means a pending task shows up — a
/// completions-only heatmap is empty until something is finished.
List<List<int>> _buildHeatmap(
  List<ActivityEntry> entries,
  DateTime start,
  DateTime today,
) {
  final Map<DateTime, int> perDay = <DateTime, int>{};
  void bump(DateTime day) {
    if (day.isBefore(start) || day.isAfter(today)) return;
    perDay[day] = (perDay[day] ?? 0) + 1;
  }

  for (final ActivityEntry e in entries) {
    bump(_dateOnly(e.created));
    final DateTime? c = e.completed;
    if (e.isCompleted && c != null) bump(_dateOnly(c));
  }

  final int totalDays = today.difference(start).inDays;
  final int weeks = totalDays ~/ 7 + 1;
  return List<List<int>>.generate(weeks, (w) {
    return List<int>.generate(7, (d) {
      final DateTime day = start.add(Duration(days: w * 7 + d));
      return perDay[day] ?? 0;
    });
  });
}

DateTime _dateOnly(DateTime d) => DateTime(d.year, d.month, d.day);
