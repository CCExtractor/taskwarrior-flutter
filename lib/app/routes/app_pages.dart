import 'package:get/get.dart';

// Splash
import '../modules/splash/bindings/splash_binding.dart';
import '../modules/splash/views/splash_view.dart';

// Home
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';

// Onboarding
import '../modules/onboarding/bindings/onboarding_binding.dart';
import '../modules/onboarding/views/onboarding_view.dart';

// Profile
import '../modules/profile/bindings/profile_binding.dart';
import '../modules/profile/views/profile_view.dart';

// Settings
import '../modules/settings/bindings/settings_binding.dart';
import '../modules/settings/views/settings_view.dart';

// About
import '../modules/about/bindings/about_binding.dart';
import '../modules/about/views/about_view.dart';

// Reports
import '../modules/reports/bindings/reports_binding.dart';
import '../modules/reports/views/reports_view.dart';

// Logs
import '../modules/logs/bindings/logs_binding.dart';
import '../modules/logs/views/logs_view.dart';

// Task server
import '../modules/manageTaskServer/bindings/manage_task_server_binding.dart';
import '../modules/manageTaskServer/views/manage_task_server_view.dart';

// Permissions
import '../modules/permission/bindings/permission_binding.dart';
import '../modules/permission/views/permission_view.dart';

// Task details
import '../modules/taskc_details/bindings/taskc_details_binding.dart';
import '../modules/taskc_details/views/taskc_details_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  /// ALWAYS start from Splash
  static const INITIAL = Routes.SPLASH;

  static final routes = <GetPage>[
    GetPage(
      name: Routes.SPLASH,
      page: () => const SplashView(),
      binding: SplashBinding(),
    ),

    GetPage(
      name: Routes.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),

    GetPage(
      name: Routes.ONBOARDING,
      page: () => const OnboardingView(),
      binding: OnboardingBinding(),
    ),

    GetPage(
      name: Routes.PROFILE,
      page: () => const ProfileView(),
      binding: ProfileBinding(),
    ),

    GetPage(
      name: Routes.SETTINGS,
      page: () => const SettingsView(),
      binding: SettingsBinding(),
    ),

    GetPage(
      name: Routes.ABOUT,
      page: () => const AboutView(),
      binding: AboutBinding(),
    ),

    GetPage(
      name: Routes.REPORTS,
      page: () => const ReportsView(),
      binding: ReportsBinding(),
    ),

    GetPage(
      name: Routes.LOGS,
      page: () => const LogsView(),
      binding: LogsBinding(),
    ),

    GetPage(
      name: Routes.MANAGE_TASK_SERVER,
      page: () => const ManageTaskServerView(),
      binding: ManageTaskServerBinding(),
    ),

    GetPage(
      name: Routes.PERMISSION,
      page: () => const PermissionView(),
      binding: PermissionBinding(),
    ),

    GetPage(
      name: Routes.TASKC_DETAILS,
      page: () => const TaskcDetailsView(),
      binding: TaskcDetailsBinding(),
    ),
  ];
}
