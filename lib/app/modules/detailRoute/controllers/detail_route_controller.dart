// ignore_for_file: depend_on_referenced_packages

import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taskwarrior/app/modules/home/controllers/home_controller.dart';
import 'package:taskwarrior/app/tour/details_page_tour.dart';
import 'package:taskwarrior/app/utils/constants/taskwarrior_colors.dart';
import 'package:taskwarrior/app/utils/taskfunctions/modify.dart';
import 'package:taskwarrior/app/utils/taskfunctions/urgency.dart';
import 'package:taskwarrior/app/utils/app_settings/app_settings.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
import 'package:taskwarrior/app/utils/language/sentence_manager.dart';

class DetailRouteController extends GetxController {
  late String uuid;
  late Modify modify;
  var onEdit = false.obs;
  var isReadOnly = false.obs;

  // Description Edit State
  final descriptionController = TextEditingController();
  var descriptionErrorText = Rxn<String>();
  // Track whether user explicitly selected a start date
  bool startEdited = false;

  @override
  void onInit() {
    super.onInit();
    var arguments = Get.arguments;
    uuid = arguments[1] as String;
    var storageWidget = Get.find<HomeController>();
    modify = Modify(
      getTask: storageWidget.getTask,
      mergeTask: storageWidget.mergeTask,
      uuid: uuid,
    );
    initValues();

    // Check if task is completed or deleted and set read-only state
    isReadOnly.value = (modify.draft.status == 'completed' ||
        modify.draft.status == 'deleted');
  }

  void setAttribute(String name, dynamic newValue) {
    if (isReadOnly.value && name != 'status') {
      return;
    }

    modify.set(name, newValue);
    onEdit.value = true;

    // If status is being changed, update read-only state
    if (name == 'status') {
      isReadOnly.value = (newValue == 'completed' || newValue == 'deleted');
    }

    if (name == 'start') {
      startEdited = true; // MARK AS USER-SELECTED
      startValue.value = newValue;
    }
    initValues();
  }

  // Validation Logic for Description
  bool validateDescription() {
    if (descriptionController.text.trim().isEmpty) {
      descriptionErrorText.value =
          SentenceManager(currentLanguage: AppSettings.selectedLanguage)
              .sentences
              .descriprtionCannotBeEmpty;
      return false;
    }
    descriptionErrorText.value = null;
    return true;
  }

  void prepareDescriptionEdit(String initialValue) {
    descriptionController.text = initialValue;
    descriptionErrorText.value = null;
  }

  Future<void> saveChanges() async {
    // If start was never edited AND backend auto-generated it (start == entry)
    if (!startEdited &&
        modify.original.start != null &&
        modify.original.start!.isAtSameMomentAs(modify.original.entry)) {
      modify.set('start', null); // remove auto start
    }
    var now = DateTime.now().toUtc();
    modify.save(modified: () => now);
    onEdit.value = false;

    // Show snackbar
    Get.snackbar(
      'Task Updated',
      '',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
    );

    // Navigate back immediately after showing snackbar
    Get.back();
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
    final originalStart = modify.original.start;
    final originalEntry = modify.original.entry;

    final backendAutoStart = (originalStart != null &&
        originalStart.isAtSameMomentAs(originalEntry));

    // START DATE LOGIC (THE FIX)
    if (startEdited) {
      startValue.value = modify.draft.start;
    } else if (backendAutoStart) {
      startValue.value = null; // Do not show backend auto start
    } else {
      startValue.value = modify.draft.start; // Existing meaningful start
    }
    endValue.value = modify.draft.end;
    dueValue.value = modify.draft.due;
    waitValue.value = modify.draft.wait;
    untilValue.value = modify.draft.until;
    priorityValue?.value = modify.draft.priority;
    projectValue?.value = modify.draft.project;
    tagsValue?.value = modify.draft.tags;
    urgencyValue.value = urgency(modify.draft);
  }

  late TutorialCoachMark tutorialCoachMark;

  final GlobalKey dueKey = GlobalKey();
  final GlobalKey untilKey = GlobalKey();

  final GlobalKey waitKey = GlobalKey();
  final GlobalKey priorityKey = GlobalKey();

  void initDetailsPageTour() {
    tutorialCoachMark = TutorialCoachMark(
      targets: addDetailsPage(
        dueKey: dueKey,
        waitKey: waitKey,
        untilKey: untilKey,
        priorityKey: priorityKey,
      ),
      colorShadow: TaskWarriorColors.black,
      paddingFocus: 10,
      opacityShadow: 1.00,
      hideSkip: true,
      onFinish: () {
        SaveTourStatus.saveDetailsTourStatus(true);
      },
    );
  }

  void showDetailsPageTour(BuildContext context) {
    Future.delayed(
      const Duration(milliseconds: 500),
      () {
        SaveTourStatus.getDetailsTourStatus().then((value) => {
              if (!value) {tutorialCoachMark.show(context: context)}
            });
      },
    );
  }

  @override
  void onClose() {
    descriptionController.dispose();
    super.onClose();
  }
}
