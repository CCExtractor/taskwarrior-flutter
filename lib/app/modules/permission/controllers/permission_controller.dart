import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionController extends GetxController {
  final RxBool isStorageGranted = false.obs;
  final RxBool isNotificationGranted = false.obs;
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
    } catch (e) {
      print('Error checking permissions: $e');
    }
  }

  Future<void> requestPermissions() async {
    try {
      isLoading.value = true;

      PermissionStatus storageStatus;
      if (GetPlatform.isAndroid) {
        storageStatus = await Permission.storage.request();
      } else {
        storageStatus = await Permission.photos.request();
      }
      isStorageGranted.value = storageStatus.isGranted;

      final notificationStatus = await Permission.notification.request();
      isNotificationGranted.value = notificationStatus.isGranted;

      if (isStorageGranted.value && isNotificationGranted.value) {
        Get.offNamed('/home');
      }
    } catch (e) {
      print('Error requesting permissions: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void openSettings() async {
    try {
      await Get.offNamed('/home');
    } catch (e) {
      print('Error opening settings: $e');
    }
  }
}
