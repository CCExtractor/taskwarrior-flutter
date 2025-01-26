import 'package:get/get.dart';

import '../controllers/permission_controller.dart';

class PermissionBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PermissionController>(
      () => PermissionController(),
    );
  }
}
