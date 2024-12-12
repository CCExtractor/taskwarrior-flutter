import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:taskwarrior/app/tour/reports_page_tour.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

class MockTutorialCoachMarkController extends Mock
    implements TutorialCoachMarkController {}

void main() {
  group('Reports Page Tour', () {
    late GlobalKey dailyKey;
    late GlobalKey weeklyKey;
    late GlobalKey monthlyKey;
    final controller = MockTutorialCoachMarkController();

    setUp(() {
      dailyKey = GlobalKey();
      weeklyKey = GlobalKey();
      monthlyKey = GlobalKey();
    });

    test('should return a list of TargetFocus with correct properties', () {
      final targets = reportsDrawer(
        daily: dailyKey,
        weekly: weeklyKey,
        monthly: monthlyKey,
      );

      expect(targets.length, 3);

      expect(targets[0].keyTarget, dailyKey);
      expect(targets[0].alignSkip, Alignment.topRight);
      expect(targets[0].shape, ShapeLightFocus.RRect);
      expect(targets[0].radius, 10);

      expect(targets[1].keyTarget, weeklyKey);
      expect(targets[1].alignSkip, Alignment.topRight);
      expect(targets[1].shape, ShapeLightFocus.RRect);
      expect(targets[1].radius, 10);

      expect(targets[2].keyTarget, monthlyKey);
      expect(targets[2].alignSkip, Alignment.bottomCenter);
      expect(targets[2].shape, ShapeLightFocus.RRect);
      expect(targets[2].radius, 10);
    });

    testWidgets('should render correct text for dailyKey TargetContent',
        (WidgetTester tester) async {
      final targets = reportsDrawer(
        daily: dailyKey,
        weekly: weeklyKey,
        monthly: monthlyKey,
      );

      final content = targets[0].contents!.first;

      await tester.pumpWidget(MaterialApp(
        home: Builder(
          builder: (context) => content.builder!(context, controller),
        ),
      ));

      expect(find.text("Access your daily task report here"), findsOneWidget);
    });

    testWidgets('should render correct text for weeklyKey TargetContent',
        (WidgetTester tester) async {
      final targets = reportsDrawer(
        daily: dailyKey,
        weekly: weeklyKey,
        monthly: monthlyKey,
      );

      final content = targets[1].contents!.first;

      await tester.pumpWidget(MaterialApp(
        home: Builder(
          builder: (context) => content.builder!(context, controller),
        ),
      ));

      expect(find.text("Access your weekly task reports here"), findsOneWidget);
    });

    testWidgets('should render correct text for monthlyKey TargetContent',
        (WidgetTester tester) async {
      final targets = reportsDrawer(
        daily: dailyKey,
        weekly: weeklyKey,
        monthly: monthlyKey,
      );

      final content = targets[2].contents!.first;

      await tester.pumpWidget(MaterialApp(
        home: Builder(
          builder: (context) => content.builder!(context, controller),
        ),
      ));

      expect(
          find.text("Access your monthly task reports here"), findsOneWidget);
    });
  });
}
