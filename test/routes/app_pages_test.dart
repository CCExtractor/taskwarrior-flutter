import 'package:flutter_test/flutter_test.dart';
import 'package:taskwarrior/app/modules/about/bindings/about_binding.dart';
import 'package:taskwarrior/app/modules/about/views/about_view.dart';
import 'package:taskwarrior/app/modules/home/bindings/home_binding.dart';
import 'package:taskwarrior/app/modules/splash/bindings/splash_binding.dart';

import 'package:taskwarrior/app/routes/app_pages.dart';
import 'package:taskwarrior/app/modules/home/views/home_view.dart';
import 'package:taskwarrior/app/modules/splash/views/splash_view.dart';

import 'package:taskwarrior/app/modules/detailRoute/views/detail_route_view.dart';
import 'package:taskwarrior/app/modules/detailRoute/bindings/detail_route_binding.dart';
import 'package:taskwarrior/app/modules/manageTaskServer/views/manage_task_server_view.dart';
import 'package:taskwarrior/app/modules/manageTaskServer/bindings/manage_task_server_binding.dart';
import 'package:taskwarrior/app/modules/onboarding/views/onboarding_view.dart';
import 'package:taskwarrior/app/modules/onboarding/bindings/onboarding_binding.dart';
import 'package:taskwarrior/app/modules/profile/views/profile_view.dart';
import 'package:taskwarrior/app/modules/profile/bindings/profile_binding.dart';
import 'package:taskwarrior/app/modules/reports/views/reports_view.dart';
import 'package:taskwarrior/app/modules/reports/bindings/reports_binding.dart';
import 'package:taskwarrior/app/modules/settings/views/settings_view.dart';
import 'package:taskwarrior/app/modules/settings/bindings/settings_binding.dart';

void main() {
  group('AppPages Test', () {
    test('Initial route is correct', () {
      expect(AppPages.INITIAL, Routes.SPLASH);
    });

    test('All routes should be defined correctly', () {
      final routes = AppPages.routes;

      expect(routes.length, 10);

      expect(
        routes.any((route) =>
            route.name == Routes.HOME &&
            route.page() is HomeView &&
            route.binding is HomeBinding),
        true,
      );
      expect(
        routes.any((route) =>
            route.name == Routes.SPLASH &&
            route.page() is SplashView &&
            route.binding is SplashBinding),
        true,
      );
      expect(
        routes.any((route) =>
            route.name == Routes.ABOUT &&
            route.page() is AboutView &&
            route.binding is AboutBinding),
        true,
      );
      expect(
        routes.any((route) =>
            route.name == Routes.DETAIL_ROUTE &&
            route.page() is DetailRouteView &&
            route.binding is DetailRouteBinding),
        true,
      );
      expect(
        routes.any((route) =>
            route.name == Routes.MANAGE_TASK_SERVER &&
            route.page() is ManageTaskServerView &&
            route.binding is ManageTaskServerBinding),
        true,
      );
      expect(
        routes.any((route) =>
            route.name == Routes.ONBOARDING &&
            route.page() is OnboardingView &&
            route.binding is OnboardingBinding),
        true,
      );
      expect(
        routes.any((route) =>
            route.name == Routes.PROFILE &&
            route.page() is ProfileView &&
            route.binding is ProfileBinding),
        true,
      );
      expect(
        routes.any((route) =>
            route.name == Routes.REPORTS &&
            route.page() is ReportsView &&
            route.binding is ReportsBinding),
        true,
      );
      expect(
        routes.any((route) =>
            route.name == Routes.SETTINGS &&
            route.page() is SettingsView &&
            route.binding is SettingsBinding),
        true,
      );
    });

    test('All routes are accessible without crashing', () {
      final routes = AppPages.routes;

      for (var route in routes) {
        expect(() => route.page(), returnsNormally,
            reason: 'Route ${route.name} should not throw errors');
      }
    });
  });
}
