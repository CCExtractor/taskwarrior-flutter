import 'package:get/get.dart';

import '../controllers/detail_route_controller.dart';

class DetailRouteBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DetailRouteController>(
      () => DetailRouteController(),
    );
  }
}
