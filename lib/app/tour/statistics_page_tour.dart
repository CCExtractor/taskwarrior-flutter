import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
import 'package:taskwarrior/app/utils/app_settings/app_settings.dart';
import 'package:taskwarrior/app/utils/language/sentence_manager.dart';

/// First-run coach marks for the Statistics dashboard: the range selector, the
/// KPI tiles, and the activity trend. Only targets that are on screen at first
/// paint are included — `safeShowTour` skips the whole tour if any key is not
/// laid out, so off-screen sections would suppress it entirely.
List<TargetFocus> statisticsTargets({
  required GlobalKey rangeKey,
  required GlobalKey kpiKey,
  required GlobalKey trendKey,
}) {
  TargetFocus target(GlobalKey key, String text, ContentAlign align) {
    return TargetFocus(
      keyTarget: key,
      alignSkip: Alignment.topRight,
      radius: 10,
      shape: ShapeLightFocus.RRect,
      contents: [
        TargetContent(
          align: align,
          builder: (context, controller) {
            return Text(
              text,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(color: Colors.white),
            );
          },
        ),
      ],
    );
  }

  final sentences =
      SentenceManager(currentLanguage: AppSettings.selectedLanguage).sentences;
  return [
    target(rangeKey, sentences.tourStatisticsRange, ContentAlign.bottom),
    target(kpiKey, sentences.tourStatisticsKpi, ContentAlign.bottom),
    target(trendKey, sentences.tourStatisticsTrend, ContentAlign.bottom),
  ];
}
