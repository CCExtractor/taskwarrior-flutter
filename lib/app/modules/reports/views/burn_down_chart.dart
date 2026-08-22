import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:taskwarrior/app/models/chart.dart';
import 'package:taskwarrior/app/modules/reports/burn_down_data.dart';
import 'package:taskwarrior/app/modules/reports/views/common_chart_indicator.dart';
import 'package:taskwarrior/app/utils/app_settings/app_settings.dart';
import 'package:taskwarrior/app/utils/constants/taskwarrior_colors.dart';
import 'package:taskwarrior/app/utils/constants/taskwarrior_fonts.dart';
import 'package:taskwarrior/app/utils/language/sentence_manager.dart';
import 'package:taskwarrior/app/utils/themes/theme_extension.dart';

/// The stacked pending/completed burndown chart, for any period and any sync
/// mode.
///
/// This replaces the nine near-identical `burn_down_{daily,weekly,monthly}`
/// × `{base,taskc,replica}` widgets. Those differed only in where they fetched
/// tasks from, which date field they bucketed by, and their title text — the
/// chart configuration itself was duplicated verbatim. Callers now do the
/// fetching and hand over [entries]; everything below is shared.
class BurnDownChart extends StatelessWidget {
  const BurnDownChart({
    super.key,
    required this.entries,
    required this.period,
    this.titleSuffix = '',
    this.dateAxisSuffix = '',
  });

  /// Tasks reduced to (date, status). See [BurnDownEntry].
  final List<BurnDownEntry> entries;

  final BurnDownPeriod period;

  /// Appended to the chart caption, e.g. ` (Replica)`, to keep the previous
  /// per-mode captions intact.
  final String titleSuffix;

  /// Appended to the x-axis label, e.g. ` (Modified Date)`, so a mode that
  /// buckets by a non-obvious date still says which one.
  final String dateAxisSuffix;

  String get _xAxisTitle {
    switch (period) {
      case BurnDownPeriod.daily:
        return 'Day - Month$dateAxisSuffix';
      case BurnDownPeriod.weekly:
        return 'Weeks - Year$dateAxisSuffix';
      case BurnDownPeriod.monthly:
        return 'Month - Year$dateAxisSuffix';
    }
  }

  String get _caption {
    switch (period) {
      case BurnDownPeriod.daily:
        return 'Daily Burndown Chart$titleSuffix';
      case BurnDownPeriod.weekly:
        return 'Weekly Burndown Chart$titleSuffix';
      case BurnDownPeriod.monthly:
        return 'Monthly Burndown Chart$titleSuffix';
    }
  }

  TooltipBehavior _buildTooltip() {
    return TooltipBehavior(
      enable: true,
      builder: (dynamic data, dynamic point, dynamic series, int pointIndex,
          int seriesIndex) {
        final sentences =
            SentenceManager(currentLanguage: AppSettings.selectedLanguage)
                .sentences;
        return Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${sentences.reportsDate}: ${data.x}',
                style: GoogleFonts.poppins(fontWeight: TaskWarriorFonts.bold),
              ),
              Text('${sentences.reportsPending}: ${data.y1}'),
              Text('${sentences.reportsCompleted}: ${data.y2}'),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final TaskwarriorColorTheme tColors =
        Theme.of(context).extension<TaskwarriorColorTheme>()!;

    final Map<String, Map<String, int>> buckets =
        bucketBurnDown(entries, period);

    final List<ChartData> data = buckets.entries
        .map((e) => ChartData(
              e.key,
              e.value['pending'] ?? 0,
              e.value['completed'] ?? 0,
            ))
        .toList();

    final TextStyle axisStyle = GoogleFonts.poppins(
      fontWeight: TaskWarriorFonts.bold,
      fontSize: TaskWarriorFonts.fontSizeSmall,
      color: tColors.primaryTextColor,
    );

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: SizedBox(
            height: height * 0.6,
            child: SfCartesianChart(
              primaryXAxis: CategoryAxis(
                title: AxisTitle(text: _xAxisTitle, textStyle: axisStyle),
              ),
              primaryYAxis: NumericAxis(
                title: AxisTitle(text: 'Tasks', textStyle: axisStyle),
              ),
              tooltipBehavior: _buildTooltip(),
              series: <CartesianSeries>[
                StackedColumnSeries<ChartData, String>(
                  groupName: 'Group A',
                  enableTooltip: true,
                  color: TaskWarriorColors.green,
                  dataSource: data,
                  xValueMapper: (ChartData d, _) => d.x,
                  yValueMapper: (ChartData d, _) => d.y2,
                  name: 'Completed',
                ),
                StackedColumnSeries<ChartData, String>(
                  groupName: 'Group A',
                  enableTooltip: true,
                  color: TaskWarriorColors.yellow,
                  dataSource: data,
                  xValueMapper: (ChartData d, _) => d.x,
                  yValueMapper: (ChartData d, _) => d.y1,
                  name: 'Pending',
                ),
              ],
            ),
          ),
        ),
        CommonChartIndicator(title: _caption),
      ],
    );
  }
}
