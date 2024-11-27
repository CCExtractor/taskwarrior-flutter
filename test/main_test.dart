import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:taskwarrior/app/utils/app_settings/app_settings.dart';
import 'package:taskwarrior/main.dart' as app;

class MockMethodChannel extends Mock implements MethodChannel {}

class AppSettingsService {
  Future<void> init() => AppSettings.init();
}

class MockAppSettingsService extends Mock implements AppSettingsService {}

@GenerateMocks([MockMethodChannel])
void main() {
  late MockAppSettingsService mockAppSettingsService;

  setUp(() {
    mockAppSettingsService = MockAppSettingsService();
  });

  testWidgets('App initializes and renders correctly',
      (WidgetTester tester) async {
    when(mockAppSettingsService.init()).thenAnswer((_) async {});

    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) {
            app.main();
            return Container();
          },
        ),
      ),
    );

    await tester.pumpAndSettle();

    verify(mockAppSettingsService.init()).called(1);

    expect(find.byType(GetMaterialApp), findsOneWidget);
  });
}
