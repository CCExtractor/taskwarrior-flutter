import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:taskwarrior/app/tour/home_page_tour.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

class MockTutorialCoachMarkController extends Mock
    implements TutorialCoachMarkController {}

void main() {
  group('Home Page Tour', () {
    late GlobalKey addKey;
    late GlobalKey searchKey;
    late GlobalKey filterKey;
    late GlobalKey menuKey;
    late GlobalKey refreshKey;
    final controller = MockTutorialCoachMarkController();

    setUp(() {
      addKey = GlobalKey();
      searchKey = GlobalKey();
      filterKey = GlobalKey();
      menuKey = GlobalKey();
      refreshKey = GlobalKey();
    });

    test('should return a list of TargetFocus with correct properties', () {
      final targets = addTargetsPage(
        addKey: addKey,
        searchKey: searchKey,
        filterKey: filterKey,
        menuKey: menuKey,
        refreshKey: refreshKey,
      );

      expect(targets.length, 5);

      expect(targets[0].keyTarget, addKey);
      expect(targets[0].alignSkip, Alignment.topRight);
      expect(targets[0].shape, ShapeLightFocus.Circle);

      expect(targets[1].keyTarget, searchKey);
      expect(targets[1].alignSkip, Alignment.topRight);
      expect(targets[1].shape, ShapeLightFocus.Circle);

      expect(targets[2].keyTarget, refreshKey);
      expect(targets[2].alignSkip, Alignment.topCenter);
      expect(targets[2].shape, ShapeLightFocus.Circle);

      expect(targets[3].keyTarget, filterKey);
      expect(targets[3].alignSkip, Alignment.topCenter);
      expect(targets[3].shape, ShapeLightFocus.Circle);

      expect(targets[4].keyTarget, menuKey);
      expect(targets[4].alignSkip, Alignment.bottomRight);
      expect(targets[4].shape, ShapeLightFocus.Circle);
    });

    testWidgets('should render correct text for addKey TargetContent',
        (WidgetTester tester) async {
      final targets = addTargetsPage(
        addKey: addKey,
        searchKey: searchKey,
        filterKey: filterKey,
        menuKey: menuKey,
        refreshKey: refreshKey,
      );

      final content = targets[0].contents!.first;

      await tester.pumpWidget(MaterialApp(
        home: Builder(
          builder: (context) => content.builder!(context, controller),
        ),
      ));

      expect(find.text("Add a new task"), findsOneWidget);
    });

    testWidgets('should render correct text for searchKey TargetContent',
        (WidgetTester tester) async {
      final targets = addTargetsPage(
        addKey: addKey,
        searchKey: searchKey,
        filterKey: filterKey,
        menuKey: menuKey,
        refreshKey: refreshKey,
      );

      final content = targets[1].contents!.first;

      await tester.pumpWidget(MaterialApp(
        home: Builder(
          builder: (context) => content.builder!(context, controller),
        ),
      ));

      expect(find.text("Search for tasks"), findsOneWidget);
    });

    testWidgets('should render correct text for refreshKey TargetContent',
        (WidgetTester tester) async {
      final targets = addTargetsPage(
        addKey: addKey,
        searchKey: searchKey,
        filterKey: filterKey,
        menuKey: menuKey,
        refreshKey: refreshKey,
      );

      final content = targets[2].contents!.first;

      await tester.pumpWidget(MaterialApp(
        home: Builder(
          builder: (context) => content.builder!(context, controller),
        ),
      ));

      expect(find.text("Refresh or sync your tasks"), findsOneWidget);
    });

    testWidgets('should render correct text for filterKey TargetContent',
        (WidgetTester tester) async {
      final targets = addTargetsPage(
        addKey: addKey,
        searchKey: searchKey,
        filterKey: filterKey,
        menuKey: menuKey,
        refreshKey: refreshKey,
      );

      final content = targets[3].contents!.first;

      await tester.pumpWidget(MaterialApp(
        home: Builder(
          builder: (context) => content.builder!(context, controller),
        ),
      ));

      expect(find.text("Add filters to sort your tasks and projects"),
          findsOneWidget);
    });

    testWidgets('should render correct text for menuKey TargetContent',
        (WidgetTester tester) async {
      final targets = addTargetsPage(
        addKey: addKey,
        searchKey: searchKey,
        filterKey: filterKey,
        menuKey: menuKey,
        refreshKey: refreshKey,
      );

      final content = targets[4].contents!.first;

      await tester.pumpWidget(MaterialApp(
        home: Builder(
          builder: (context) => content.builder!(context, controller),
        ),
      ));

      expect(find.text("Access additional settings here"), findsOneWidget);
    });
  });
}
