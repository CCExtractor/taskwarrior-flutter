import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:taskwarrior/app/tour/manage_task_server_page_tour.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

class MockTutorialCoachMarkController extends Mock
    implements TutorialCoachMarkController {}

void main() {
  group('Manage Task Server Page Tour', () {
    late GlobalKey configureTaskRC;
    late GlobalKey configureYourCertificate;
    late GlobalKey configureTaskServerKey;
    late GlobalKey configureServerCertificate;
    final controller = MockTutorialCoachMarkController();

    setUp(() {
      configureTaskRC = GlobalKey();
      configureYourCertificate = GlobalKey();
      configureTaskServerKey = GlobalKey();
      configureServerCertificate = GlobalKey();
    });

    test('should return a list of TargetFocus with correct properties', () {
      final targets = addManageTaskServerPage(
        configureTaskRC: configureTaskRC,
        configureYourCertificate: configureYourCertificate,
        configureTaskServerKey: configureTaskServerKey,
        configureServerCertificate: configureServerCertificate,
      );

      expect(targets.length, 4);

      expect(targets[0].keyTarget, configureTaskRC);
      expect(targets[0].alignSkip, Alignment.topRight);
      expect(targets[0].shape, ShapeLightFocus.RRect);

      expect(targets[1].keyTarget, configureYourCertificate);
      expect(targets[1].alignSkip, Alignment.topRight);
      expect(targets[1].shape, ShapeLightFocus.RRect);

      expect(targets[2].keyTarget, configureTaskServerKey);
      expect(targets[2].alignSkip, Alignment.bottomCenter);
      expect(targets[2].shape, ShapeLightFocus.RRect);

      expect(targets[3].keyTarget, configureServerCertificate);
      expect(targets[3].alignSkip, Alignment.bottomCenter);
      expect(targets[3].shape, ShapeLightFocus.RRect);
    });

    testWidgets('should render correct text for configureTaskRC TargetContent',
        (WidgetTester tester) async {
      final targets = addManageTaskServerPage(
        configureTaskRC: configureTaskRC,
        configureYourCertificate: configureYourCertificate,
        configureTaskServerKey: configureTaskServerKey,
        configureServerCertificate: configureServerCertificate,
      );

      final content = targets[0].contents!.first;

      await tester.pumpWidget(MaterialApp(
        home: Builder(
          builder: (context) => content.builder!(context, controller),
        ),
      ));

      expect(
          find.text("Select the file named taskrc here or paste it's content"),
          findsOneWidget);
    });

    testWidgets(
        'should render correct text for configureYourCertificate TargetContent',
        (WidgetTester tester) async {
      final targets = addManageTaskServerPage(
        configureTaskRC: configureTaskRC,
        configureYourCertificate: configureYourCertificate,
        configureTaskServerKey: configureTaskServerKey,
        configureServerCertificate: configureServerCertificate,
      );

      final content = targets[1].contents!.first;

      await tester.pumpWidget(MaterialApp(
        home: Builder(
          builder: (context) => content.builder!(context, controller),
        ),
      ));

      expect(
          find.text(
              "Select file similarly named like <Your Email>.com.cert.pem here"),
          findsOneWidget);
    });

    testWidgets(
        'should render correct text for configureTaskServerKey TargetContent',
        (WidgetTester tester) async {
      final targets = addManageTaskServerPage(
        configureTaskRC: configureTaskRC,
        configureYourCertificate: configureYourCertificate,
        configureTaskServerKey: configureTaskServerKey,
        configureServerCertificate: configureServerCertificate,
      );

      final content = targets[2].contents!.first;

      await tester.pumpWidget(MaterialApp(
        home: Builder(
          builder: (context) => content.builder!(context, controller),
        ),
      ));

      expect(
          find.text(
              "Select file similarly named like <Your Email>.key.pem here"),
          findsOneWidget);
    });

    testWidgets(
        'should render correct text for configureServerCertificate TargetContent',
        (WidgetTester tester) async {
      final targets = addManageTaskServerPage(
        configureTaskRC: configureTaskRC,
        configureYourCertificate: configureYourCertificate,
        configureTaskServerKey: configureTaskServerKey,
        configureServerCertificate: configureServerCertificate,
      );

      final content = targets[3].contents!.first;

      await tester.pumpWidget(MaterialApp(
        home: Builder(
          builder: (context) => content.builder!(context, controller),
        ),
      ));

      expect(
          find.text(
              "Select file similarly named like letsencrypt_root_cert.pem here"),
          findsOneWidget);
    });
  });
}
