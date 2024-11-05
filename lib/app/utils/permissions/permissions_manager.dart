// ignore_for_file: avoid_print

import 'package:permission_handler/permission_handler.dart';
import 'package:taskwarrior/app/utils/constants/permissions.dart';

class PermissionsManager {
  static Future<void> requestAllPermissions() async {
    try {
      final results = await Future.wait(
          permissions.map((permission) => _requestPermission(permission)));

      for (var i = 0; i < results.length; i++) {
        final permission = permissions[i];
        final status = results[i];

        if (status) {
          print(
              "Permission '${permission.toString().split('.').last}' granted.");
        } else {
          print(
              "Permission '${permission.toString().split('.').last}' denied.");
        }
      }
    } catch (e) {
      print("Error requesting permissions: $e");
    }
  }

  static Future<bool> _requestPermission(Permission permission) async {
    final status = await permission.request();
    return status.isGranted;
  }
}