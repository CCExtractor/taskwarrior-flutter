import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:taskwarrior/app/tour/filter_drawer_tour.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

class MockTutorialCoachMarkController extends Mock
    implements TutorialCoachMarkController {}

void main() {
  group('Filter Drawer Page Tour', () {
    late GlobalKey statusKey;
    late GlobalKey projectsKey;
    late GlobalKey projectsKeyTaskc;
    late GlobalKey filterTagKey;
    late GlobalKey sortByKey;
    final controller = MockTutorialCoachMarkController();

    setUp(() {
      statusKey = GlobalKey();
      projectsKey = GlobalKey();
      projectsKeyTaskc = GlobalKey();
      filterTagKey = GlobalKey();
      sortByKey = GlobalKey();
    });

    test('should return a list of TargetFocus with correct properties', () {
      final targets = filterDrawer(
        statusKey: statusKey,
        projectsKey: projectsKey,
        projectsKeyTaskc: projectsKeyTaskc,
        filterTagKey: filterTagKey,
        sortByKey: sortByKey,
      );

      expect(targets.length, 5);

      expect(targets[0].keyTarget, statusKey);
      expect(targets[0].alignSkip, Alignment.topRight);
      expect(targets[0].shape, ShapeLightFocus.RRect);

      expect(targets[1].keyTarget, projectsKey);
      expect(targets[1].alignSkip, Alignment.topRight);
      expect(targets[1].shape, ShapeLightFocus.RRect);

      expect(targets[2].keyTarget, projectsKeyTaskc);
      expect(targets[2].alignSkip, Alignment.topRight);
      expect(targets[2].shape, ShapeLightFocus.RRect);

      expect(targets[3].keyTarget, filterTagKey);
      expect(targets[3].alignSkip, Alignment.topRight);
      expect(targets[3].shape, ShapeLightFocus.RRect);

      expect(targets[4].keyTarget, sortByKey);
      expect(targets[4].alignSkip, Alignment.topRight);
      expect(targets[4].shape, ShapeLightFocus.RRect);
    });

    testWidgets('should render correct text for statusKey TargetContent',
        (WidgetTester tester) async {
      final targets = filterDrawer(
        statusKey: statusKey,
        projectsKey: projectsKey,
        projectsKeyTaskc: projectsKeyTaskc,
        filterTagKey: filterTagKey,
        sortByKey: sortByKey,
      );

      final content = targets[0].contents!.first;

      await tester.pumpWidget(MaterialApp(
        home: Builder(
          builder: (context) => content.builder!(context, controller),
        ),
      ));

      expect(find.text("Filter tasks based on their completion status"),
          findsOneWidget);
    });

    testWidgets('should render correct text for projectsKey TargetContent',
        (WidgetTester tester) async {
      final targets = filterDrawer(
        statusKey: statusKey,
        projectsKey: projectsKey,
        projectsKeyTaskc: projectsKeyTaskc,
        filterTagKey: filterTagKey,
        sortByKey: sortByKey,
      );

      final content = targets[1].contents!.first;

      await tester.pumpWidget(MaterialApp(
        home: Builder(
          builder: (context) => content.builder!(context, controller),
        ),
      ));

      expect(find.text("Filter tasks based on the projects"), findsOneWidget);
    });

    testWidgets('should render correct text for projectsKeyTaskc TargetContent',
        (WidgetTester tester) async {
      final targets = filterDrawer(
        statusKey: statusKey,
        projectsKey: projectsKey,
        projectsKeyTaskc: projectsKeyTaskc,
        filterTagKey: filterTagKey,
        sortByKey: sortByKey,
      );

      final content = targets[2].contents!.first;

      await tester.pumpWidget(MaterialApp(
        home: Builder(
          builder: (context) => content.builder!(context, controller),
        ),
      ));

      expect(find.text("Filter tasks based on the projects"), findsOneWidget);
    });

    testWidgets('should render correct text for filterTagKey TargetContent',
        (WidgetTester tester) async {
      final targets = filterDrawer(
        statusKey: statusKey,
        projectsKey: projectsKey,
        projectsKeyTaskc: projectsKeyTaskc,
        filterTagKey: filterTagKey,
        sortByKey: sortByKey,
      );

      final content = targets[3].contents!.first;

      await tester.pumpWidget(MaterialApp(
        home: Builder(
          builder: (context) => content.builder!(context, controller),
        ),
      ));

      expect(find.text("Toggle between AND and OR tag union types"),
          findsOneWidget);
    });

    testWidgets('should render correct text for sortByKey TargetContent',
        (WidgetTester tester) async {
      final targets = filterDrawer(
        statusKey: statusKey,
        projectsKey: projectsKey,
        projectsKeyTaskc: projectsKeyTaskc,
        filterTagKey: filterTagKey,
        sortByKey: sortByKey,
      );

      final content = targets[4].contents!.first;

      await tester.pumpWidget(MaterialApp(
        home: Builder(
          builder: (context) => content.builder!(context, controller),
        ),
      ));

      expect(
        find.text(
            "Sort tasks based on time of creation, urgency, due date, start date, etc."),
        findsOneWidget,
      );
    });
  });
}
