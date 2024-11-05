// ignore_for_file: avoid_print

import 'package:permission_handler/permission_handler.dart';
import 'package:taskwarrior/app/utils/constants/permissions.dart';

class PermissionsManager {
  static Future<void> requestAllPermissions() async {
    try {
      for (var permission in permissions) {
        final status = await _requestPermission(permission);
        
        if (status) {
          print("Permission '${permission.toString().split('.').last}' granted.");
        } else {
          print("Permission '${permission.toString().split('.').last}' denied.");
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