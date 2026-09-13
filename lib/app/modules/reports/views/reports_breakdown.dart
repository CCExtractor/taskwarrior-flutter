import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:taskwarrior/app/modules/reports/analytics_data.dart';
import 'package:taskwarrior/app/utils/app_settings/app_settings.dart';
import 'package:taskwarrior/app/utils/constants/taskwarrior_colors.dart';
import 'package:taskwarrior/app/utils/constants/taskwarrior_fonts.dart';
import 'package:taskwarrior/app/utils/language/sentence_manager.dart';
import 'package:taskwarrior/app/utils/language/sentences.dart';
import 'package:taskwarrior/app/utils/themes/theme_extension.dart';

/// Completed tasks per project, as a ranked list of proportional bars. A ranked
/// list reads far better than a pie once there are more than a couple of
/// projects, and it needs no chart engine.
class ProjectBreakdown extends StatelessWidget {
  const ProjectBreakdown({super.key, required this.projects});

  final List<NamedCount> projects;

  @override
  Widget build(BuildContext context) {
    final TaskwarriorColorTheme tColors =
        Theme.of(context).extension<TaskwarriorColorTheme>()!;
    final sentences =
        SentenceManager(currentLanguage: AppSettings.selectedLanguage).sentences;
    final Color barColor =
        tColors.primaryTextColor ?? TaskWarriorColors.white;
    final int max = projects.isEmpty
        ? 1
        : projects.map((e) => e.count).reduce((a, b) => a > b ? a : b);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final NamedCount project in projects)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        project.label == noProject
                            ? sentences.reportsNoProject
                            : project.label,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.poppins(
                          fontSize: TaskWarriorFonts.fontSizeSmall,
                          color: tColors.primaryTextColor,
                        ),
                      ),
                    ),
                    Text(
                      '${project.count}',
                      style: GoogleFonts.poppins(
                        fontSize: TaskWarriorFonts.fontSizeSmall,
                        fontWeight: TaskWarriorFonts.bold,
                        color: tColors.secondaryTextColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: project.count / max,
                    minHeight: 6,
                    backgroundColor:
                        (tColors.secondaryBackgroundColor ??
                                TaskWarriorColors.grey)
                            .withValues(alpha: 0.6),
                    valueColor: AlwaysStoppedAnimation<Color>(barColor),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

/// Completed tasks per priority as a doughnut, with a colour-coded legend.
class PriorityBreakdown extends StatelessWidget {
  const PriorityBreakdown({super.key, required this.priorities});

  final List<NamedCount> priorities;

  @override
  Widget build(BuildContext context) {
    final TaskwarriorColorTheme tColors =
        Theme.of(context).extension<TaskwarriorColorTheme>()!;
    final sentences =
        SentenceManager(currentLanguage: AppSettings.selectedLanguage).sentences;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: 140,
          height: 140,
          child: SfCircularChart(
            series: <CircularSeries<NamedCount, String>>[
              DoughnutSeries<NamedCount, String>(
                dataSource: priorities,
                xValueMapper: (NamedCount p, _) => p.label,
                yValueMapper: (NamedCount p, _) => p.count,
                pointColorMapper: (NamedCount p, _) => _colorFor(p.label),
                innerRadius: '62%',
                dataLabelSettings: DataLabelSettings(
                  isVisible: true,
                  labelPosition: ChartDataLabelPosition.outside,
                  textStyle: GoogleFonts.poppins(
                    fontSize: TaskWarriorFonts.fontSizeSmall,
                    color: tColors.primaryTextColor,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              for (final NamedCount p in priorities)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 3),
                  child: Row(
                    children: [
                      Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: _colorFor(p.label),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _labelFor(p.label, sentences),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.poppins(
                            fontSize: TaskWarriorFonts.fontSizeSmall,
                            color: tColors.primaryTextColor,
                          ),
                        ),
                      ),
                      Text(
                        '${p.count}',
                        style: GoogleFonts.poppins(
                          fontSize: TaskWarriorFonts.fontSizeSmall,
                          fontWeight: TaskWarriorFonts.bold,
                          color: tColors.secondaryTextColor,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Color _colorFor(String label) {
    switch (label) {
      case 'H':
        return TaskWarriorColors.red;
      case 'M':
        return TaskWarriorColors.yellow;
      case 'L':
        return TaskWarriorColors.green;
      default:
        return TaskWarriorColors.grey;
    }
  }

  String _labelFor(String label, Sentences sentences) {
    switch (label) {
      case 'H':
        return sentences.high;
      case 'M':
        return sentences.medium;
      case 'L':
        return sentences.low;
      default:
        return sentences.reportsNoPriority;
    }
  }
}
