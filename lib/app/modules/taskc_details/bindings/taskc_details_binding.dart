import 'package:get/get.dart';

import '../controllers/taskc_details_controller.dart';

class TaskcDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TaskcDetailsController>(
      () => TaskcDetailsController(),
    );
  }
}
