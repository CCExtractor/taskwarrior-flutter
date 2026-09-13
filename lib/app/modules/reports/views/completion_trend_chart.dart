import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:taskwarrior/app/modules/reports/analytics_data.dart';
import 'package:taskwarrior/app/utils/app_settings/app_settings.dart';
import 'package:taskwarrior/app/utils/constants/taskwarrior_colors.dart';
import 'package:taskwarrior/app/utils/constants/taskwarrior_fonts.dart';
import 'package:taskwarrior/app/utils/language/sentence_manager.dart';
import 'package:taskwarrior/app/utils/themes/theme_extension.dart';

/// The activity trend: created vs completed over the selected range, drawn as
/// two smooth lines on a real time axis so a full year stays readable (unlike
/// one column per day).
class CompletionTrendChart extends StatelessWidget {
  const CompletionTrendChart({super.key, required this.points, required this.granularity});

  final List<TrendPoint> points;
  final TrendGranularity granularity;

  String get _labelFormat {
    switch (granularity) {
      case TrendGranularity.daily:
      case TrendGranularity.weekly:
        return 'MMM d';
      case TrendGranularity.monthly:
        return 'MMM yyyy';
    }
  }

  DateTimeIntervalType get _intervalType {
    switch (granularity) {
      case TrendGranularity.daily:
        return DateTimeIntervalType.days;
      case TrendGranularity.weekly:
        return DateTimeIntervalType.days;
      case TrendGranularity.monthly:
        return DateTimeIntervalType.months;
    }
  }

  /// A spline needs two points to draw a segment, so a short range (e.g. a
  /// single task under "All") would otherwise render an empty plot. Show point
  /// markers when the series is short enough that they aid reading rather than
  /// clutter it.
  bool get _showMarkers => points.length <= 60;

  @override
  Widget build(BuildContext context) {
    final TaskwarriorColorTheme tColors =
        Theme.of(context).extension<TaskwarriorColorTheme>()!;
    final sentences =
        SentenceManager(currentLanguage: AppSettings.selectedLanguage).sentences;

    final Color createdColor =
        tColors.purpleShade ?? TaskWarriorColors.deepPurpleAccent;
    final Color completedColor = TaskWarriorColors.green;
    final Color textColor = tColors.primaryTextColor ?? Colors.white;
    final Color gridColor = (tColors.dividerColor ?? Colors.grey).withValues(alpha: 0.15);

    if (points.isEmpty) {
      return const SizedBox(height: 220);
    }

    return SizedBox(
      height: 240,
      child: SfCartesianChart(
        margin: const EdgeInsets.only(top: 8),
        primaryXAxis: DateTimeAxis(
          intervalType: _intervalType,
          interval: granularity == TrendGranularity.weekly ? 7 : null,
          dateFormat: DateFormat(_labelFormat),
          edgeLabelPlacement: EdgeLabelPlacement.shift,
          majorGridLines: MajorGridLines(width: 0),
          axisLine: AxisLine(width: 0),
          labelStyle: GoogleFonts.poppins(
            fontSize: TaskWarriorFonts.fontSizeSmall,
            color: tColors.secondaryTextColor,
          ),
        ),
        primaryYAxis: NumericAxis(
          minimum: 0,
          majorGridLines: MajorGridLines(width: 0.5, color: gridColor),
          axisLine: AxisLine(width: 0),
          labelStyle: GoogleFonts.poppins(
            fontSize: TaskWarriorFonts.fontSizeSmall,
            color: tColors.secondaryTextColor,
          ),
        ),
        legend: Legend(
          isVisible: true,
          position: LegendPosition.bottom,
          textStyle: GoogleFonts.poppins(
            fontSize: TaskWarriorFonts.fontSizeSmall,
            color: textColor,
          ),
        ),
        tooltipBehavior: TooltipBehavior(
          enable: true,
          format: 'point.x : point.y',
          textStyle: GoogleFonts.poppins(color: Colors.black),
        ),
        zoomPanBehavior: ZoomPanBehavior(
          enablePanning: true,
          enablePinching: true,
          enableDoubleTapZooming: true,
        ),
        series: <CartesianSeries<TrendPoint, DateTime>>[
          SplineSeries<TrendPoint, DateTime>(
            name: sentences.reportsCreated,
            color: createdColor,
            width: 2,
            markerSettings: MarkerSettings(
              isVisible: _showMarkers,
              width: 6,
              height: 6,
              color: createdColor,
            ),
            dataSource: points,
            xValueMapper: (TrendPoint p, _) => p.date,
            yValueMapper: (TrendPoint p, _) => p.created,
          ),
          SplineSeries<TrendPoint, DateTime>(
            name: sentences.reportsCompleted,
            color: completedColor,
            width: 2,
            markerSettings: MarkerSettings(
              isVisible: _showMarkers,
              width: 6,
              height: 6,
              color: completedColor,
            ),
            dataSource: points,
            xValueMapper: (TrendPoint p, _) => p.date,
            yValueMapper: (TrendPoint p, _) => p.completed,
          ),
        ],
      ),
    );
  }
}
