// ignore_for_file: depend_on_referenced_packages

import 'package:built_collection/built_collection.dart';
import 'package:get/get.dart';
import 'package:taskwarrior/app/modules/home/controllers/home_controller.dart';
import 'package:taskwarrior/app/utils/taskfunctions/modify.dart';
import 'package:taskwarrior/app/utils/taskfunctions/urgency.dart';

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
    initValues();
  }

  void setAttribute(String name, dynamic newValue) {
    modify.set(name, newValue);
    onEdit.value = true;
    initValues();
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

  //  'description': controller.modify.draft.description,
  //                 'status': controller.modify.draft.status,
  //                 'entry': controller.modify.draft.entry,
  //                 'modified': controller.modify.draft.modified,
  // 'start': controller.modify.draft.start,
  //                 'end': controller.modify.draft.end,
  //                 'due': controller.dueValue.value,
  //                 'wait': controller.modify.draft.wait,
  //                 'until': controller.modify.draft.until,
  //                 'priority': controller.modify.draft.priority,
  //                 'project': controller.modify.draft.project,
  //                 'tags': controller.modify.draft.tags,
  //                 'urgency': urgency(controller.modify.draft

  late RxString descriptionValue = ''.obs;
  late RxString statusValue = ''.obs;
  late Rx<DateTime?> entryValue = Rx<DateTime?>(null);
  late Rx<DateTime?> modifiedValue = Rx<DateTime?>(null);
  late Rx<DateTime?> startValue = Rx<DateTime?>(null);
  late Rx<DateTime?> endValue = Rx<DateTime?>(null);
  late Rx<DateTime?> dueValue = Rx<DateTime?>(null);
  late Rx<DateTime?> waitValue = Rx<DateTime?>(null);
  late Rx<DateTime?> untilValue = Rx<DateTime?>(null);
  late Rxn<String>? priorityValue = Rxn<String>(null);
  late Rxn<String>? projectValue = Rxn<String>(null);
  late Rxn<BuiltList<String>>? tagsValue = Rxn<BuiltList<String>>(null);
  late RxDouble urgencyValue = 0.0.obs;

  void initValues() {
    descriptionValue.value = modify.draft.description;
    statusValue.value = modify.draft.status;
    entryValue.value = modify.draft.entry;
    modifiedValue.value = modify.draft.modified;
    startValue.value = modify.draft.start;
    endValue.value = modify.draft.end;
    dueValue.value = modify.draft.due;
    waitValue.value = modify.draft.wait;
    untilValue.value = modify.draft.until;
    priorityValue?.value = modify.draft.priority;
    projectValue?.value = modify.draft.project;
    tagsValue?.value = modify.draft.tags;
    urgencyValue.value = urgency(modify.draft);
  }
}
