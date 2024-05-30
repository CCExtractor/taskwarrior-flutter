import 'package:get/get.dart';
import 'package:taskwarrior/app/modules/home/controllers/home_controller.dart';


class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.find<HomeController>(
    );
  }
}
