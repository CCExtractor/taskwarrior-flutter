import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

List<TargetFocus> reportsDrawer({
  required GlobalKey daily,
  required GlobalKey weekly,
  required GlobalKey monthly,
}) {
  List<TargetFocus> targets = [];

  // daily
  targets.add(
    TargetFocus(
      keyTarget: daily,
      alignSkip: Alignment.topRight,
      radius: 10,
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
                    "Access your daily task report here",
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

  // weekly
  targets.add(
    TargetFocus(
      keyTarget: weekly,
      alignSkip: Alignment.topRight,
      radius: 10,
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
                    "Access your weekly task reports here",
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

  // monthly
  targets.add(
    TargetFocus(
      keyTarget: monthly,
      alignSkip: Alignment.bottomCenter,
      radius: 10,
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
                    "Access your monthly task reports here",
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
