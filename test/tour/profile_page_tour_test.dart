import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:taskwarrior/app/tour/profile_page_tour.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

class MockTutorialCoachMarkController extends Mock
    implements TutorialCoachMarkController {}

void main() {
  group('Profile Page Tour', () {
    late GlobalKey currentProfileKey;
    late GlobalKey addNewProfileKey;
    late GlobalKey manageSelectedProfileKey;
    final controller = MockTutorialCoachMarkController();

    setUp(() {
      currentProfileKey = GlobalKey();
      addNewProfileKey = GlobalKey();
      manageSelectedProfileKey = GlobalKey();
    });

    test('should return a list of TargetFocus with correct properties', () {
      final targets = addProfilePage(
        currentProfileKey: currentProfileKey,
        addNewProfileKey: addNewProfileKey,
        manageSelectedProfileKey: manageSelectedProfileKey,
      );

      expect(targets.length, 3);

      expect(targets[0].keyTarget, currentProfileKey);
      expect(targets[0].alignSkip, Alignment.topRight);
      expect(targets[0].shape, ShapeLightFocus.RRect);

      expect(targets[1].keyTarget, manageSelectedProfileKey);
      expect(targets[1].alignSkip, Alignment.topRight);
      expect(targets[1].shape, ShapeLightFocus.RRect);

      expect(targets[2].keyTarget, addNewProfileKey);
      expect(targets[2].alignSkip, Alignment.topRight);
      expect(targets[2].shape, ShapeLightFocus.RRect);
    });

    testWidgets(
        'should render correct text for currentProfileKey TargetContent',
        (WidgetTester tester) async {
      final targets = addProfilePage(
        currentProfileKey: currentProfileKey,
        addNewProfileKey: addNewProfileKey,
        manageSelectedProfileKey: manageSelectedProfileKey,
      );

      final content = targets[0].contents!.first;

      await tester.pumpWidget(MaterialApp(
        home: Builder(
          builder: (context) => content.builder!(context, controller),
        ),
      ));

      expect(find.text("See your current profile here"), findsOneWidget);
    });

    testWidgets(
        'should render correct text for manageSelectedProfileKey TargetContent',
        (WidgetTester tester) async {
      final targets = addProfilePage(
        currentProfileKey: currentProfileKey,
        addNewProfileKey: addNewProfileKey,
        manageSelectedProfileKey: manageSelectedProfileKey,
      );

      final content = targets[1].contents!.first;

      await tester.pumpWidget(MaterialApp(
        home: Builder(
          builder: (context) => content.builder!(context, controller),
        ),
      ));

      expect(find.text("Manage your current profile here"), findsOneWidget);
    });

    testWidgets('should render correct text for addNewProfileKey TargetContent',
        (WidgetTester tester) async {
      final targets = addProfilePage(
        currentProfileKey: currentProfileKey,
        addNewProfileKey: addNewProfileKey,
        manageSelectedProfileKey: manageSelectedProfileKey,
      );

      final content = targets[2].contents!.first;

      await tester.pumpWidget(MaterialApp(
        home: Builder(
          builder: (context) => content.builder!(context, controller),
        ),
      ));

      expect(find.text("Add a new profile here"), findsOneWidget);
    });
  });
}
