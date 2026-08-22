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

    List<TargetFocus> build({required bool useTaskchampionProjects}) =>
        filterDrawer(
          statusKey: statusKey,
          projectsKey: projectsKey,
          projectsKeyTaskc: projectsKeyTaskc,
          filterTagKey: filterTagKey,
          sortByKey: sortByKey,
          useTaskchampionProjects: useTaskchampionProjects,
        );

    // Indices after the two projects targets were merged into one.
    const int statusIndex = 0;
    const int projectsIndex = 1;
    const int filterTagIndex = 2;
    const int sortByIndex = 3;

    test('exposes one target per visible control', () {
      final targets = build(useTaskchampionProjects: false);

      // Four, not five: the drawer shows either the legacy projects column or
      // the TaskChampion one, never both.
      expect(targets.length, 4);

      expect(targets[statusIndex].keyTarget, statusKey);
      expect(targets[filterTagIndex].keyTarget, filterTagKey);
      expect(targets[sortByIndex].keyTarget, sortByKey);

      for (final target in targets) {
        expect(target.alignSkip, Alignment.topRight);
        expect(target.shape, ShapeLightFocus.RRect);
      }
    });

    // The regression this guards: both project keys used to be registered as
    // targets unconditionally, but each column sits behind a mutually exclusive
    // Visibility, so one of them was never laid out. tutorial_coach_mark then
    // threw "It was not possible to obtain target position (null)" every time
    // the tour ran — in either mode, by construction rather than by timing.
    test('targets only the projects column that is actually on screen', () {
      final legacy = build(useTaskchampionProjects: false);
      expect(legacy[projectsIndex].keyTarget, projectsKey);
      expect(
        legacy.map((t) => t.keyTarget).contains(projectsKeyTaskc),
        isFalse,
        reason: 'the TaskChampion column is not mounted in legacy mode',
      );

      final taskchampion = build(useTaskchampionProjects: true);
      expect(taskchampion[projectsIndex].keyTarget, projectsKeyTaskc);
      expect(
        taskchampion.map((t) => t.keyTarget).contains(projectsKey),
        isFalse,
        reason: 'the legacy column is not mounted in TaskChampion mode',
      );
    });

    Future<void> expectContent(
      WidgetTester tester,
      TargetFocus target,
      String expected,
    ) async {
      final content = target.contents!.first;
      await tester.pumpWidget(MaterialApp(
        home: Builder(
          builder: (context) => content.builder!(context, controller),
        ),
      ));
      expect(find.text(expected), findsOneWidget);
    }

    testWidgets('renders the status copy', (tester) async {
      await expectContent(
        tester,
        build(useTaskchampionProjects: false)[statusIndex],
        'Filter tasks based on their completion status',
      );
    });

    testWidgets('renders the projects copy in legacy mode', (tester) async {
      await expectContent(
        tester,
        build(useTaskchampionProjects: false)[projectsIndex],
        'Filter tasks based on the projects',
      );
    });

    testWidgets('renders the same projects copy in TaskChampion mode',
        (tester) async {
      await expectContent(
        tester,
        build(useTaskchampionProjects: true)[projectsIndex],
        'Filter tasks based on the projects',
      );
    });

    testWidgets('renders the tag-union copy', (tester) async {
      await expectContent(
        tester,
        build(useTaskchampionProjects: false)[filterTagIndex],
        'Toggle between AND and OR tag union types',
      );
    });

    testWidgets('renders the sort copy', (tester) async {
      await expectContent(
        tester,
        build(useTaskchampionProjects: false)[sortByIndex],
        'Sort tasks based on time of creation, urgency, due date, start date, etc.',
      );
    });
  });
}
