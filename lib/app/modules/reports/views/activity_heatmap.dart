import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:taskwarrior/app/utils/app_settings/app_settings.dart';
import 'package:taskwarrior/app/utils/constants/taskwarrior_colors.dart';
import 'package:taskwarrior/app/utils/constants/taskwarrior_fonts.dart';
import 'package:taskwarrior/app/utils/language/sentence_manager.dart';
import 'package:taskwarrior/app/utils/themes/theme_extension.dart';

/// A GitHub-style contribution grid: one cell per day for the last year, shaded
/// by how many tasks were created or completed that day. This is the clearest
/// way to show a whole year at once — a bar per day cannot fit, a heatmap can.
///
/// The grid is wider than a phone, so it opens scrolled to the most recent
/// week; otherwise a user with a single recent completion would only ever see
/// the empty left-hand side and assume the chart was broken.
///
/// A day's count is shown by tapping its cell. An earlier version wrapped every
/// cell in a `Tooltip`, but 371 tooltips each create an animation ticker, which
/// flooded the framework ("RawTooltipState ... multiple tickers") and janked
/// the scroll.
class ActivityHeatmap extends StatefulWidget {
  const ActivityHeatmap({
    super.key,
    required this.start,
    required this.weeks,
    required this.maxCount,
  });

  /// The Sunday the grid starts on.
  final DateTime start;

  /// One entry per week; each holds 7 daily activity counts, Sunday first.
  final List<List<int>> weeks;

  /// Highest single-day count, used to scale the colour ramp.
  final int maxCount;

  @override
  State<ActivityHeatmap> createState() => _ActivityHeatmapState();
}

class _ActivityHeatmapState extends State<ActivityHeatmap> {
  static const double _cell = 13;
  static const double _gap = 3;

  final ScrollController _controller = ScrollController();
  DateTime? _selectedDay;
  int _selectedCount = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_controller.hasClients) {
        _controller.jumpTo(_controller.position.maxScrollExtent);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final TaskwarriorColorTheme tColors =
        Theme.of(context).extension<TaskwarriorColorTheme>()!;
    final sentences =
        SentenceManager(currentLanguage: AppSettings.selectedLanguage).sentences;
    final Color empty =
        (tColors.secondaryBackgroundColor ?? TaskWarriorColors.grey)
            .withValues(alpha: 0.6);
    final Color labelColor =
        tColors.secondaryTextColor ?? TaskWarriorColors.grey;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SingleChildScrollView(
          controller: _controller,
          scrollDirection: Axis.horizontal,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _monthLabels(labelColor),
              const SizedBox(height: 4),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (int w = 0; w < widget.weeks.length; w++)
                    Padding(
                      padding: const EdgeInsets.only(right: _gap),
                      child: Column(
                        children: [
                          for (int d = 0; d < 7; d++)
                            Padding(
                              padding: const EdgeInsets.only(bottom: _gap),
                              child: _cellFor(
                                widget.start.add(Duration(days: w * 7 + d)),
                                widget.weeks[w][d],
                                empty,
                                tColors,
                              ),
                            ),
                        ],
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            if (_selectedDay != null)
              Expanded(
                child: Text(
                  '${DateFormat.yMMMd().format(_selectedDay!)} · $_selectedCount',
                  style: GoogleFonts.poppins(
                    fontSize: TaskWarriorFonts.fontSizeSmall,
                    color: tColors.primaryTextColor,
                  ),
                ),
              )
            else
              const Spacer(),
            Text(
              sentences.reportsHeatmapLess,
              style: GoogleFonts.poppins(
                  fontSize: TaskWarriorFonts.fontSizeSmall, color: labelColor),
            ),
            const SizedBox(width: 6),
            for (int level = 0; level <= 4; level++)
              Padding(
                padding: const EdgeInsets.only(right: _gap),
                child: Container(
                  width: _cell,
                  height: _cell,
                  decoration: BoxDecoration(
                    color: _color(level, empty),
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),
            const SizedBox(width: 3),
            Text(
              sentences.reportsHeatmapMore,
              style: GoogleFonts.poppins(
                  fontSize: TaskWarriorFonts.fontSizeSmall, color: labelColor),
            ),
          ],
        ),
      ],
    );
  }

  Widget _monthLabels(Color labelColor) {
    final TextStyle style = GoogleFonts.poppins(
      fontSize: TaskWarriorFonts.fontSizeSmall,
      color: labelColor,
    );
    final List<Widget> labels = <Widget>[];
    int? lastMonth;
    for (int w = 0; w < widget.weeks.length; w++) {
      final DateTime weekStart = widget.start.add(Duration(days: w * 7));
      final bool isNewMonth = lastMonth != weekStart.month;
      labels.add(SizedBox(
        width: _cell + _gap,
        child: isNewMonth
            ? Text(
                DateFormat('MMM').format(weekStart),
                softWrap: false,
                overflow: TextOverflow.visible,
                style: style,
              )
            : null,
      ));
      lastMonth = weekStart.month;
    }
    return Row(children: labels);
  }

  Widget _cellFor(
      DateTime day, int count, Color empty, TaskwarriorColorTheme tColors) {
    final bool selected = _selectedDay != null &&
        _selectedDay!.year == day.year &&
        _selectedDay!.month == day.month &&
        _selectedDay!.day == day.day;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => setState(() {
        _selectedDay = day;
        _selectedCount = count;
      }),
      child: Container(
        width: _cell,
        height: _cell,
        decoration: BoxDecoration(
          color: _color(_level(count), empty),
          borderRadius: BorderRadius.circular(3),
          border: selected
              ? Border.all(
                  color: tColors.primaryTextColor ?? TaskWarriorColors.white,
                  width: 1)
              : null,
        ),
      ),
    );
  }

  int _level(int count) {
    if (count <= 0 || widget.maxCount <= 0) return 0;
    final double ratio = count / widget.maxCount;
    if (ratio <= 0.25) return 1;
    if (ratio <= 0.5) return 2;
    if (ratio <= 0.75) return 3;
    return 4;
  }

  Color _color(int level, Color empty) {
    if (level <= 0) return empty;
    const List<double> alpha = <double>[0, 0.3, 0.5, 0.75, 1];
    return TaskWarriorColors.green.withValues(alpha: alpha[level]);
  }
}
