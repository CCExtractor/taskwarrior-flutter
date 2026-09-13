import 'package:flutter_test/flutter_test.dart';
import 'package:taskwarrior/app/modules/reports/analytics_data.dart';

ActivityEntry e(
  DateTime created, {
  DateTime? completed,
  DateTime? due,
  String? project,
  String? priority,
}) =>
    ActivityEntry(
      created: created,
      completed: completed,
      due: due,
      isCompleted: completed != null,
      project: project,
      priority: priority,
    );

void main() {
  // A Sunday, so heatmap week alignment is deterministic.
  final DateTime now = DateTime(2024, 6, 30, 12);
  final DateTime today = DateTime(2024, 6, 30);

  group('KPIs', () {
    test('counts completed and created inside the range only', () {
      final summary = summarize(
        entries: [
          e(DateTime(2024, 6, 25), completed: DateTime(2024, 6, 29)), // in
          e(DateTime(2024, 1, 1), completed: DateTime(2024, 1, 2)), // out
          e(DateTime(2024, 6, 30)), // created in
        ],
        range: ReportRange.d7,
        now: now,
      );

      expect(summary.completed, 1);
      expect(summary.created, 2);
    });

    test('deltas compare against the previous equal-length window', () {
      final summary = summarize(
        entries: [
          // Previous 7 days: two completions.
          e(DateTime(2024, 6, 18), completed: DateTime(2024, 6, 20)),
          e(DateTime(2024, 6, 19), completed: DateTime(2024, 6, 21)),
          // Current 7 days: one completion.
          e(DateTime(2024, 6, 26), completed: DateTime(2024, 6, 28)),
        ],
        range: ReportRange.d7,
        now: now,
      );

      expect(summary.completed, 1);
      expect(summary.completedDelta, -1);
    });

    test('completion rate is the global done share', () {
      final summary = summarize(
        entries: [
          e(DateTime(2024, 6, 1), completed: DateTime(2024, 6, 2)),
          e(DateTime(2024, 6, 1), completed: DateTime(2024, 6, 3)),
          e(DateTime(2024, 6, 1)),
          e(DateTime(2024, 6, 1)),
        ],
        range: ReportRange.d7,
        now: now,
      );

      expect(summary.completionRate, 0.5);
    });

    test('pending counts tasks that are not completed', () {
      final summary = summarize(
        entries: [
          e(DateTime(2024, 6, 1), completed: DateTime(2024, 6, 25)),
          e(DateTime(2024, 6, 1)),
          e(DateTime(2024, 6, 1)),
        ],
        range: ReportRange.d7,
        now: now,
      );

      expect(summary.pending, 2);
    });
  });

  group('trend', () {
    test('daily range yields one continuous point per day', () {
      final summary = summarize(
        entries: [e(DateTime(2024, 6, 30))],
        range: ReportRange.d7,
        now: now,
      );

      expect(summary.granularity, TrendGranularity.daily);
      expect(summary.trend.length, 7);
      expect(summary.trend.last.date, today);
      expect(summary.trend.last.created, 1);
    });

    test('a quarter is bucketed weekly', () {
      final summary =
          summarize(entries: const [], range: ReportRange.m3, now: now);
      expect(summary.granularity, TrendGranularity.weekly);
      expect(summary.trend.length, 13); // 90 days => 13 buckets
    });

    test('a year is bucketed monthly with no gaps', () {
      final summary = summarize(
        entries: [
          e(DateTime(2024, 6, 10), completed: DateTime(2024, 6, 11)),
        ],
        range: ReportRange.y1,
        now: now,
      );
      expect(summary.granularity, TrendGranularity.monthly);
      expect(summary.trend.length, 12);
      expect(summary.trend.last.completed, 1);
    });
  });

  group('breakdowns', () {
    test('projects group completions, null becomes the sentinel', () {
      final summary = summarize(
        entries: [
          e(DateTime(2024, 6, 1), completed: DateTime(2024, 6, 25), project: 'Work'),
          e(DateTime(2024, 6, 1), completed: DateTime(2024, 6, 26), project: 'Work'),
          e(DateTime(2024, 6, 1), completed: DateTime(2024, 6, 27)),
        ],
        range: ReportRange.d30,
        now: now,
      );

      expect(summary.projects.first.label, 'Work');
      expect(summary.projects.first.count, 2);
      expect(summary.projects.last.label, noProject);
      expect(summary.projects.last.count, 1);
    });

    test('priorities cover every task, in H, M, L, none order', () {
      final summary = summarize(
        entries: [
          e(DateTime(2024, 6, 1), completed: DateTime(2024, 6, 25)),
          e(DateTime(2024, 6, 1), priority: 'L'), // pending still counts
          e(DateTime(2024, 6, 1), priority: 'H'),
          e(DateTime(2024, 1, 1), priority: 'M'), // outside the range still counts
        ],
        range: ReportRange.d30,
        now: now,
      );

      expect(summary.priorities.map((p) => p.label).toList(),
          ['H', 'M', 'L', noPriority]);
      expect(summary.priorities.map((p) => p.count).toList(), [1, 1, 1, 1]);
    });
  });

  group('heatmap', () {
    test('spans 53 weeks of 7 days and places a completion on today', () {
      final summary = summarize(
        entries: [
          e(DateTime(2024, 6, 1), completed: DateTime(2024, 6, 30)),
        ],
        range: ReportRange.d30,
        now: now,
      );

      expect(summary.heatmapWeeks.length, 53);
      expect(summary.heatmapWeeks.every((w) => w.length == 7), isTrue);
      expect(summary.heatmapWeeks.last.first, 1);
      expect(summary.heatmapMax, 1);
    });

    test('a pending task still registers on the heatmap', () {
      // The heatmap counts activity, not just completions, so a task that was
      // only created shows up — otherwise a user with open tasks sees an empty
      // chart.
      final summary = summarize(
        entries: [e(today)],
        range: ReportRange.d30,
        now: now,
      );

      expect(summary.heatmapWeeks.last.first, 1);
      expect(summary.heatmapMax, 1);
    });
  });
}
