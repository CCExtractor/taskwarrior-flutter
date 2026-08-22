import 'package:flutter/widgets.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

/// Safely shows a coach-mark tour.
///
/// `tutorial_coach_mark` throws
/// `FormatException: It was not possible to obtain target position (null)`
/// when any target's [GlobalKey] is not currently laid out. This happens when
/// the screen changes during the pre-show delay (e.g. the user navigates
/// deeper before the tour fires): the target widgets are unmounted, so their
/// render boxes are null.
///
/// This helper guards against that: it only calls `show()` when the context is
/// still mounted and every target key has a live element. Otherwise — or if
/// `show()` throws anyway — it marks the tour as seen via [markSeen] so a
/// failed attempt never surfaces an exception or loops forever (the tour's own
/// `onFinish` would never run to persist the flag).
Future<void> safeShowTour({
  required TutorialCoachMark tutorialCoachMark,
  required BuildContext context,
  required List<GlobalKey> targetKeys,
  Future<void> Function()? markSeen,
}) async {
  final bool allMounted =
      targetKeys.every((k) => k.currentContext != null);
  if (!context.mounted || !allMounted) {
    await markSeen?.call();
    return;
  }
  try {
    tutorialCoachMark.show(context: context);
  } catch (_) {
    // Defensive: never let a tour failure bubble up or repeat.
    await markSeen?.call();
  }
}
