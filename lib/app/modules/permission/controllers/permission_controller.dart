import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:taskwarrior/app/utils/permissions/permissions_manager.dart';

class PermissionController extends GetxController {
  final RxBool isStorageGranted = false.obs;
  final RxBool isNotificationGranted = false.obs;
  final RxBool isExteternalStorageGranted = false.obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    checkPermissions();
  }

  Future<void> checkPermissions() async {
    try {
      isStorageGranted.value = await Permission.storage.status.isGranted;
      isNotificationGranted.value =
          await Permission.notification.status.isGranted;
      isExteternalStorageGranted.value =
          await Permission.manageExternalStorage.status.isGranted;
    } catch (e) {
      debugPrint('Error checking permissions: $e');
    }
  }

  Future<void> requestPermissions() async {
    try {
      isLoading.value = true;

      if (!isStorageGranted.value &&
          !isNotificationGranted.value &&
          !isExteternalStorageGranted.value) {
        await PermissionsManager.requestAllPermissions();
      }
      Get.offNamed('/home');
    } catch (e) {
      debugPrint('Error requesting permissions: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void gotoHome() async {
    try {
      await Get.offNamed('/home');
    } catch (e) {
      debugPrint('Error opening home screen: $e');
    }
  }
}
