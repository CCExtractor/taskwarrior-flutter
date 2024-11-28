import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:taskwarrior/app/routes/app_pages.dart';

void main() {
  group('Main App Initialization', () {
    testWidgets('App initializes with the correct route',
        (WidgetTester tester) async {
      await tester.pumpWidget(GetMaterialApp(
        title: "Application",
        initialRoute: AppPages.INITIAL,
        getPages: AppPages.routes,
      ));

      // Check if the app starts at the correct initial route
      expect(Get.currentRoute, equals(AppPages.INITIAL));
    });

    testWidgets('Splash screen displays the correct content',
        (WidgetTester tester) async {
      await tester.pumpWidget(GetMaterialApp(
        title: "Application",
        initialRoute: AppPages.INITIAL,
        getPages: AppPages.routes,
      ));

      // Check if the splash screen contains the expected text
      expect(find.text("Setting up the app..."), findsOneWidget);
    });
  });
}
