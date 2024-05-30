import 'package:get/get.dart';
import 'package:taskwarrior/app/modules/home/controllers/home_controller.dart';
import 'package:taskwarrior/app/utils/taskfunctions/modify.dart';

class DetailRouteController extends GetxController {
  late String uuid;
  late Modify modify;
  var onEdit = false.obs;

  @override
  void onInit() {
    super.onInit();
    var arguments = Get.arguments;
    uuid = arguments[1] as String;
    // uuid = Get.arguments['uuid'];
    var storageWidget = Get.find<HomeController>();
    modify = Modify(
      getTask: storageWidget.getTask,
      mergeTask: storageWidget.mergeTask,
      uuid: uuid,
    );
  }

  void setAttribute(String name, dynamic newValue) {
    modify.set(name, newValue);
    onEdit.value = true;
  }

  Future<void> saveChanges() async {
    var now = DateTime.now().toUtc();
    modify.save(modified: () => now);
    onEdit.value = false;
    Get.back();
    Get.snackbar(
      'Task Updated',
      '',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}
