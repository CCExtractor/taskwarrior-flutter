import 'package:get/get.dart';

import '../controllers/report_engine_controller.dart';

class ReportEngineBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ReportEngineController>(
      () => ReportEngineController(),
    );
  }
}
