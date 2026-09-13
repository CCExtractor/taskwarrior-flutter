import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taskwarrior/app/modules/reports/analytics_data.dart';
import 'package:taskwarrior/app/modules/reports/views/activity_heatmap.dart';
import 'package:taskwarrior/app/modules/reports/views/completion_trend_chart.dart';
import 'package:taskwarrior/app/modules/reports/views/reports_breakdown.dart';
import 'package:taskwarrior/app/utils/app_settings/app_settings.dart';
import 'package:taskwarrior/app/utils/constants/taskwarrior_colors.dart';
import 'package:taskwarrior/app/utils/constants/taskwarrior_fonts.dart';
import 'package:taskwarrior/app/utils/language/sentence_manager.dart';
import 'package:taskwarrior/app/utils/language/sentences.dart';
import 'package:taskwarrior/app/utils/themes/theme_extension.dart';

/// The Statistics dashboard: a range selector, KPI tiles, an activity trend, a
/// year heatmap, and project/priority breakdowns. It replaces the old
/// Daily/Weekly/Monthly column charts, which became unreadable once there was
/// more than a few weeks of data.
class ReportsDashboard extends StatefulWidget {
  const ReportsDashboard({super.key, required this.entries});

  final List<ActivityEntry> entries;

  @override
  State<ReportsDashboard> createState() => _ReportsDashboardState();
}

class _ReportsDashboardState extends State<ReportsDashboard> {
  ReportRange _range = ReportRange.d30;

  @override
  Widget build(BuildContext context) {
    final TaskwarriorColorTheme tColors =
        Theme.of(context).extension<TaskwarriorColorTheme>()!;
    final Sentences sentences =
        SentenceManager(currentLanguage: AppSettings.selectedLanguage).sentences;
    final AnalyticsSummary summary = summarize(
      entries: widget.entries,
      range: _range,
      now: DateTime.now(),
    );
    final bool hasActivity = summary.created > 0 || summary.completed > 0;

    return ListView(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 24),
      children: [
        _rangeSelector(sentences, tColors),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _KpiTile(
                label: sentences.reportsCompleted,
                value: '${summary.completed}',
                delta: summary.completedDelta,
                deltaNote: sentences.reportsVsPrevious,
                accent: TaskWarriorColors.green,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _KpiTile(
                label: sentences.reportsCreated,
                value: '${summary.created}',
                delta: summary.createdDelta,
                deltaNote: sentences.reportsVsPrevious,
                accent: tColors.purpleShade ?? TaskWarriorColors.deepPurpleAccent,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: _KpiTile(
                label: sentences.reportsCompletionRate,
                value: '${(summary.completionRate * 100).round()}%',
                accent: TaskWarriorColors.green,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _KpiTile(
                label: sentences.reportsPending,
                value: '${summary.pending}',
                accent: TaskWarriorColors.yellow,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _Section(
          title: sentences.reportsTrendTitle,
          child: hasActivity
              ? CompletionTrendChart(
                  points: summary.trend,
                  granularity: summary.granularity,
                )
              : _EmptyRange(sentences: sentences, tColors: tColors),
        ),
        _Section(
          title: sentences.reportsHeatmapTitle,
          child: ActivityHeatmap(
            start: summary.heatmapStart,
            weeks: summary.heatmapWeeks,
            maxCount: summary.heatmapMax,
          ),
        ),
        if (summary.projects.isNotEmpty)
          _Section(
            title: sentences.reportsByProjectTitle,
            child: ProjectBreakdown(projects: summary.projects),
          ),
        if (summary.priorities.isNotEmpty)
          _Section(
            title: sentences.reportsByPriorityTitle,
            child: PriorityBreakdown(priorities: summary.priorities),
          ),
      ],
    );
  }

  Widget _rangeSelector(Sentences sentences, TaskwarriorColorTheme tColors) {
    return Wrap(
      spacing: 8,
      children: [
        for (final ReportRange range in ReportRange.values)
          ChoiceChip(
            label: Text(_rangeLabel(range, sentences)),
            selected: _range == range,
            onSelected: (_) => setState(() => _range = range),
            labelStyle: GoogleFonts.poppins(
              fontSize: TaskWarriorFonts.fontSizeSmall,
              fontWeight: TaskWarriorFonts.medium,
              color: _range == range
                  ? TaskWarriorColors.white
                  : tColors.primaryTextColor,
            ),
            selectedColor:
                tColors.purpleShade ?? TaskWarriorColors.deepPurpleAccent,
            backgroundColor: tColors.secondaryBackgroundColor,
            showCheckmark: false,
          ),
      ],
    );
  }

  String _rangeLabel(ReportRange range, Sentences sentences) {
    switch (range) {
      case ReportRange.d7:
        return sentences.reportsRange7d;
      case ReportRange.d30:
        return sentences.reportsRange30d;
      case ReportRange.m3:
        return sentences.reportsRange3m;
      case ReportRange.y1:
        return sentences.reportsRange1y;
      case ReportRange.all:
        return sentences.reportsRangeAll;
    }
  }
}

/// Shown by the host screens when there is nothing to chart yet.
class ReportsEmptyState extends StatelessWidget {
  const ReportsEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    final TaskwarriorColorTheme tColors =
        Theme.of(context).extension<TaskwarriorColorTheme>()!;
    final Sentences sentences =
        SentenceManager(currentLanguage: AppSettings.selectedLanguage).sentences;
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                color: tColors.secondaryBackgroundColor,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.insights_outlined,
                size: 44,
                color: tColors.purpleShade ?? TaskWarriorColors.deepPurpleAccent,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              sentences.reportsPageNoTasksFound,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: TaskWarriorFonts.bold,
                color: tColors.primaryTextColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              sentences.reportsPageAddTasksToSeeReports,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: TaskWarriorFonts.fontSizeSmall,
                color: tColors.secondaryTextColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Shown inside a dashboard section when the selected range has no activity,
/// so a flat line is not mistaken for a chart that failed to load.
class _EmptyRange extends StatelessWidget {
  const _EmptyRange({required this.sentences, required this.tColors});

  final Sentences sentences;
  final TaskwarriorColorTheme tColors;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 160,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.show_chart,
              size: 32,
              color: tColors.secondaryTextColor,
            ),
            const SizedBox(height: 8),
            Text(
              sentences.reportsNoActivityInRange,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: TaskWarriorFonts.fontSizeSmall,
                color: tColors.secondaryTextColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final TaskwarriorColorTheme tColors =
        Theme.of(context).extension<TaskwarriorColorTheme>()!;
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: tColors.secondaryBackgroundColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: TaskWarriorFonts.fontSizeMedium,
              fontWeight: TaskWarriorFonts.bold,
              color: tColors.primaryTextColor,
            ),
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}

class _KpiTile extends StatelessWidget {
  const _KpiTile({
    required this.label,
    required this.value,
    required this.accent,
    this.delta,
    this.deltaNote,
  });

  final String label;
  final String value;
  final Color accent;
  final int? delta;
  final String? deltaNote;

  @override
  Widget build(BuildContext context) {
    final TaskwarriorColorTheme tColors =
        Theme.of(context).extension<TaskwarriorColorTheme>()!;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: tColors.secondaryBackgroundColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.poppins(
              fontSize: TaskWarriorFonts.fontSizeSmall,
              color: tColors.secondaryTextColor,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 26,
              fontWeight: TaskWarriorFonts.bold,
              color: accent,
            ),
          ),
          if (delta != null) ...[
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(
                  delta! >= 0 ? Icons.arrow_upward : Icons.arrow_downward,
                  size: 13,
                  color: delta! >= 0
                      ? TaskWarriorColors.green
                      : TaskWarriorColors.red,
                ),
                const SizedBox(width: 3),
                Text(
                  '${delta!.abs()}',
                  style: GoogleFonts.poppins(
                    fontSize: TaskWarriorFonts.fontSizeSmall,
                    color: delta! >= 0
                        ? TaskWarriorColors.green
                        : TaskWarriorColors.red,
                  ),
                ),
                if (deltaNote != null) ...[
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      deltaNote!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.poppins(
                        fontSize: 10,
                        color: tColors.secondaryTextColor,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ],
      ),
    );
  }
}
