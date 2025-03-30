import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
import 'package:taskwarrior/app/utils/language/sentence_manager.dart';
import 'package:taskwarrior/app/utils/app_settings/app_settings.dart';

List<TargetFocus> addProfilePage({
  required GlobalKey currentProfileKey,
  required GlobalKey addNewProfileKey,
  required GlobalKey manageSelectedProfileKey,
}) {
  List<TargetFocus> targets = [];

  // currentProfile
  targets.add(
    TargetFocus(
      keyTarget: currentProfileKey,
      alignSkip: Alignment.topRight,
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
                        .tourProfileCurrent,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      color: Colors.white,
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

  //manage current profile
  targets.add(
    TargetFocus(
      keyTarget: manageSelectedProfileKey,
      alignSkip: Alignment.topRight,
      shape: ShapeLightFocus.RRect,
      contents: [
        TargetContent(
          align: ContentAlign.bottom,
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
                        .tourProfileManage,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      color: Colors.white,
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
  //addNewProfile
  targets.add(
    TargetFocus(
      keyTarget: addNewProfileKey,
      alignSkip: Alignment.topRight,
      shape: ShapeLightFocus.RRect,
      contents: [
        TargetContent(
          align: ContentAlign.bottom,
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
                        .tourProfileAddNew,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      color: Colors.white,
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
