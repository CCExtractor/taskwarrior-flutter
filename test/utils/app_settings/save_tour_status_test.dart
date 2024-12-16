import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taskwarrior/app/utils/app_settings/app_settings.dart';

void main() {
  group('SaveTourStatus', () {
    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      await SaveTourStatus.init();
    });

    test('should save and retrieve reports tour status correctly', () async {
      await SaveTourStatus.saveReportsTourStatus(true);
      expect(await SaveTourStatus.getReportsTourStatus(), true);

      await SaveTourStatus.saveReportsTourStatus(false);
      expect(await SaveTourStatus.getReportsTourStatus(), false);
    });

    test('should save and retrieve in-app tour status correctly', () async {
      await SaveTourStatus.saveInAppTourStatus(true);
      expect(await SaveTourStatus.getInAppTourStatus(), true);

      await SaveTourStatus.saveInAppTourStatus(false);
      expect(await SaveTourStatus.getInAppTourStatus(), false);
    });

    test('should save and retrieve filter tour status correctly', () async {
      await SaveTourStatus.saveFilterTourStatus(true);
      expect(await SaveTourStatus.getFilterTourStatus(), true);

      await SaveTourStatus.saveFilterTourStatus(false);
      expect(await SaveTourStatus.getFilterTourStatus(), false);
    });

    test('should save and retrieve profile tour status correctly', () async {
      await SaveTourStatus.saveProfileTourStatus(true);
      expect(await SaveTourStatus.getProfileTourStatus(), true);

      await SaveTourStatus.saveProfileTourStatus(false);
      expect(await SaveTourStatus.getProfileTourStatus(), false);
    });

    test('should save and retrieve details tour status correctly', () async {
      await SaveTourStatus.saveDetailsTourStatus(true);
      expect(await SaveTourStatus.getDetailsTourStatus(), true);

      await SaveTourStatus.saveDetailsTourStatus(false);
      expect(await SaveTourStatus.getDetailsTourStatus(), false);
    });

    test('should save and retrieve manage task server tour status correctly',
        () async {
      await SaveTourStatus.saveManageTaskServerTourStatus(true);
      expect(await SaveTourStatus.getManageTaskServerTourStatus(), true);

      await SaveTourStatus.saveManageTaskServerTourStatus(false);
      expect(await SaveTourStatus.getManageTaskServerTourStatus(), false);
    });
  });
}
