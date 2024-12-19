import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:taskwarrior/app/utils/permissions/permissions_manager.dart';
import 'package:taskwarrior/app/utils/constants/permissions.dart';

import 'permissions_manager_test.mocks.dart';

@GenerateMocks([Permission])
void main() {
  group('PermissionsManager', () {
    late MockPermission mockPermission;

    setUp(() {
      WidgetsFlutterBinding.ensureInitialized();
      mockPermission = MockPermission();
      permissions.clear();
      permissions.add(mockPermission);
    });
    test('requestAllPermissions handles permission denied', () async {
      when(mockPermission.request())
          .thenAnswer((_) async => PermissionStatus.denied);

      await PermissionsManager.requestAllPermissions();

      verify(mockPermission.request()).called(1);
    });
  });
}
