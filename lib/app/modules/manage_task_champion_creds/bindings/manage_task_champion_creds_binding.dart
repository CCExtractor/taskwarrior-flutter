import 'package:get/get.dart';

import '../controllers/manage_task_champion_creds_controller.dart';

class ManageTaskChampionCredsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ManageTaskChampionCredsController>(
      () => ManageTaskChampionCredsController(),
    );
  }
}
