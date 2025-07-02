import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:taskwarrior/app/tour/task_swipe_tour.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

class MockTutorialCoachMarkController extends Mock
    implements TutorialCoachMarkController {}

void main() {
  group('Task Swipe Tour', () {
    late GlobalKey taskItemKey;
    final controller = MockTutorialCoachMarkController();

    setUp(() {
      taskItemKey = GlobalKey();
    });

    test('should return a list of TargetFocus with correct properties', () {
      final targets = addTaskSwipeTutorialTargets(
        taskItemKey: taskItemKey,
      );

      expect(targets.length, 1);

      expect(targets[0].keyTarget, taskItemKey);
      expect(targets[0].identify, "taskSwipeTutorial");
      expect(targets[0].alignSkip, Alignment.bottomRight);
      expect(targets[0].shape, ShapeLightFocus.RRect);
      expect(targets[0].radius, 10);
    });

    testWidgets('should render correct text for task swipe TargetContent',
        (WidgetTester tester) async {
      final targets = addTaskSwipeTutorialTargets(
        taskItemKey: taskItemKey,
      );

      final content = targets[0].contents!.first;

      await tester.pumpWidget(MaterialApp(
        home: Builder(
          builder: (context) => content.builder!(context, controller),
        ),
      ));

      expect(find.text("Task Swipe Actions"), findsOneWidget);
      expect(find.text("This is how you manage your tasks quickly : "),
          findsOneWidget);
      expect(find.text("Swipe RIGHT to COMPLETE"), findsOneWidget);
      expect(find.text("Swipe LEFT to DELETE"), findsOneWidget);
    });
  });
}
