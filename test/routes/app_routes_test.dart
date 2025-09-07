import 'package:flutter_test/flutter_test.dart';
import 'package:taskwarrior/app/routes/app_pages.dart';

void main() {
  test('Routes should be defined correctly', () {
    expect(Routes.HOME, '/home');
    expect(Routes.ONBOARDING, '/onboarding');
    expect(Routes.SPLASH, '/');
    expect(Routes.MANAGE_TASK_SERVER, '/manage-task-server');
    expect(Routes.DETAIL_ROUTE, '/detail-route');
    expect(Routes.PROFILE, '/profile');
    expect(Routes.ABOUT, '/about');
    expect(Routes.REPORTS, '/reports');
    expect(Routes.SETTINGS, '/settings');
  });
}
