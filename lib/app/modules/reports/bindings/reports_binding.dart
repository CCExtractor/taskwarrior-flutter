import 'package:get/get.dart';

import '../controllers/reports_controller.dart';

class ReportsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ReportsController>(
      () => ReportsController(),
    );
  }
}
