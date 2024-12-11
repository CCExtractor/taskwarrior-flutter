import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:taskwarrior/app/tour/details_page_tour.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

class MockTutorialCoachMarkController extends Mock
    implements TutorialCoachMarkController {}

void main() {
  group('Details Page Tour', () {
    late GlobalKey dueKey;
    late GlobalKey waitKey;
    late GlobalKey untilKey;
    late GlobalKey priorityKey;
    final controller = MockTutorialCoachMarkController();

    setUp(() {
      dueKey = GlobalKey();
      waitKey = GlobalKey();
      untilKey = GlobalKey();
      priorityKey = GlobalKey();
    });

    test('should return a list of TargetFocus with correct properties', () {
      final targets = addDetailsPage(
        dueKey: dueKey,
        waitKey: waitKey,
        untilKey: untilKey,
        priorityKey: priorityKey,
      );

      expect(targets.length, 4);

      expect(targets[0].keyTarget, dueKey);
      expect(targets[0].alignSkip, Alignment.topRight);
      expect(targets[0].shape, ShapeLightFocus.RRect);

      expect(targets[1].keyTarget, waitKey);
      expect(targets[1].alignSkip, Alignment.topRight);
      expect(targets[1].shape, ShapeLightFocus.RRect);

      expect(targets[2].keyTarget, untilKey);
      expect(targets[2].alignSkip, Alignment.topRight);
      expect(targets[2].shape, ShapeLightFocus.RRect);

      expect(targets[3].keyTarget, priorityKey);
      expect(targets[3].alignSkip, Alignment.topRight);
      expect(targets[3].shape, ShapeLightFocus.RRect);
    });

    testWidgets('should render correct text for dueKey TargetContent',
        (WidgetTester tester) async {
      final targets = addDetailsPage(
        dueKey: dueKey,
        waitKey: waitKey,
        untilKey: untilKey,
        priorityKey: priorityKey,
      );

      final content = targets[0].contents!.first;

      await tester.pumpWidget(MaterialApp(
        home: Builder(
          builder: (context) => content.builder!(context, controller),
        ),
      ));

      expect(
          find.text("This signifies the due date of the task"), findsOneWidget);
    });

    testWidgets('should render correct text for waitKey TargetContent',
        (WidgetTester tester) async {
      final targets = addDetailsPage(
        dueKey: dueKey,
        waitKey: waitKey,
        untilKey: untilKey,
        priorityKey: priorityKey,
      );

      final content = targets[1].contents!.first;

      await tester.pumpWidget(MaterialApp(
        home: Builder(
          builder: (context) => content.builder!(context, controller),
        ),
      ));

      expect(
        find.text(
            "This signifies the waiting date of the task \n Task will be visible after this date"),
        findsOneWidget,
      );
    });

    testWidgets('should render correct text for untilKey TargetContent',
        (WidgetTester tester) async {
      final targets = addDetailsPage(
        dueKey: dueKey,
        waitKey: waitKey,
        untilKey: untilKey,
        priorityKey: priorityKey,
      );

      final content = targets[2].contents!.first;

      await tester.pumpWidget(MaterialApp(
        home: Builder(
          builder: (context) => content.builder!(context, controller),
        ),
      ));

      expect(find.text("This shows the last date of the task"), findsOneWidget);
    });

    testWidgets('should render correct text for priorityKey TargetContent',
        (WidgetTester tester) async {
      final targets = addDetailsPage(
        dueKey: dueKey,
        waitKey: waitKey,
        untilKey: untilKey,
        priorityKey: priorityKey,
      );

      final content = targets[3].contents!.first;

      await tester.pumpWidget(MaterialApp(
        home: Builder(
          builder: (context) => content.builder!(context, controller),
        ),
      ));

      expect(
        find.text(
            "This is the priority of the Tasks \n L -> Low \n M -> Medium \n H -> Hard"),
        findsOneWidget,
      );
    });
  });
}
