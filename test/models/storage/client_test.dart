import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:taskwarrior/app/models/storage/client.dart';

class MockPackageInfo extends Mock implements PackageInfo {}

void main() {
  group('client', () {
    test('should return package name and version', () async {
      PackageInfo.setMockInitialValues(
        appName: 'App',
        packageName: 'com.ccextractor.app',
        version: '1.0.0',
        buildNumber: '1',
        buildSignature: '',
      );

      final result = await client();

      expect(result, 'com.ccextractor.app 1.0.0');
    });
  });
}
