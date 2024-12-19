import 'package:flutter_test/flutter_test.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:taskwarrior/app/utils/constants/permissions.dart';

void main() {
  group('Permissions', () {
    test('should contain the correct permissions', () {
      expect(permissions, [
        Permission.notification,
        Permission.storage,
        Permission.manageExternalStorage,
      ]);
    });
  });
}
