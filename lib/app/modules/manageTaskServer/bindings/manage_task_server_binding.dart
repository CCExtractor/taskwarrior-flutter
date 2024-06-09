import 'package:get/get.dart';

import '../controllers/manage_task_server_controller.dart';

class ManageTaskServerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ManageTaskServerController>(
      () => ManageTaskServerController(),
    );
  }
}
