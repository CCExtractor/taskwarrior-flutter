import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taskwarrior/app/utils/constants/taskwarrior_colors.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
import 'package:taskwarrior/app/utils/language/sentence_manager.dart';
import 'package:taskwarrior/app/utils/app_settings/app_settings.dart';

List<TargetFocus> filterDrawer({
  required GlobalKey statusKey,
  required GlobalKey projectsKey,
  required GlobalKey projectsKeyTaskc,
  required GlobalKey filterTagKey,
  required GlobalKey sortByKey,
}) {
  List<TargetFocus> targets = [];

  // statusKey
  targets.add(
    TargetFocus(
      keyTarget: statusKey,
      alignSkip: Alignment.topRight,
      radius: 10,
      shape: ShapeLightFocus.RRect,
      contents: [
        TargetContent(
          align: ContentAlign.top,
          builder: (context, controller) {
            return Container(
              alignment: Alignment.center,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    SentenceManager(
                            currentLanguage: AppSettings.selectedLanguage)
                        .sentences
                        .tourFilterStatus,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      color: TaskWarriorColors.white,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    ),
  );

  // projectsKey
  targets.add(
    TargetFocus(
      keyTarget: projectsKey,
      alignSkip: Alignment.topRight,
      radius: 10,
      shape: ShapeLightFocus.RRect,
      contents: [
        TargetContent(
          align: ContentAlign.top,
          builder: (context, controller) {
            return Container(
              alignment: Alignment.center,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    SentenceManager(
                            currentLanguage: AppSettings.selectedLanguage)
                        .sentences
                        .tourFilterProjects,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      color: TaskWarriorColors.white,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    ),
  );

  // projectsKeyTaskc
  targets.add(
    TargetFocus(
      keyTarget: projectsKeyTaskc,
      alignSkip: Alignment.topRight,
      radius: 10,
      shape: ShapeLightFocus.RRect,
      contents: [
        TargetContent(
          align: ContentAlign.top,
          builder: (context, controller) {
            return Container(
              alignment: Alignment.center,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    SentenceManager(
                            currentLanguage: AppSettings.selectedLanguage)
                        .sentences
                        .tourFilterProjects,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      color: TaskWarriorColors.white,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    ),
  );

  // filterTagByKey
  targets.add(
    TargetFocus(
      keyTarget: filterTagKey,
      alignSkip: Alignment.topRight,
      radius: 10,
      shape: ShapeLightFocus.RRect,
      contents: [
        TargetContent(
          align: ContentAlign.top,
          builder: (context, controller) {
            return Container(
              alignment: Alignment.center,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    SentenceManager(
                            currentLanguage: AppSettings.selectedLanguage)
                        .sentences
                        .tourFilterTagUnion,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      color: TaskWarriorColors.white,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    ),
  );

  // sortByKey
  targets.add(
    TargetFocus(
      keyTarget: sortByKey,
      alignSkip: Alignment.topRight,
      radius: 10,
      shape: ShapeLightFocus.RRect,
      contents: [
        TargetContent(
          align: ContentAlign.top,
          builder: (context, controller) {
            return Container(
              alignment: Alignment.center,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    SentenceManager(
                            currentLanguage: AppSettings.selectedLanguage)
                        .sentences
                        .tourFilterSort,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      color: TaskWarriorColors.white,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    ),
  );
  return targets;
}
