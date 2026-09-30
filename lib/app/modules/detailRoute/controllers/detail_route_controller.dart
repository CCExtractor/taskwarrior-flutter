// ignore_for_file: depend_on_referenced_packages

import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taskwarrior/app/models/tag_meta_data.dart';
import 'package:taskwarrior/app/models/task_attribute.dart';
import 'package:taskwarrior/app/modules/home/controllers/home_controller.dart';
import 'package:taskwarrior/app/tour/details_page_tour.dart';
import 'package:taskwarrior/app/tour/safe_tour.dart';
import 'package:taskwarrior/app/utils/app_settings/app_settings.dart';
import 'package:taskwarrior/app/utils/constants/taskwarrior_colors.dart';
import 'package:taskwarrior/app/utils/debug_logger/app_logger.dart';
import 'package:taskwarrior/app/utils/language/sentence_manager.dart';
import 'package:taskwarrior/app/utils/language/sentences.dart';
import 'package:taskwarrior/app/utils/taskfunctions/modify.dart';
import 'package:taskwarrior/app/utils/taskfunctions/urgency.dart';
import 'package:taskwarrior/app/utils/themes/theme_extension.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

class DetailRouteController extends GetxController {
  /// [arguments], [createModify] and [knownTags] default to the route
  /// arguments and the [HomeController] task storage; tests pass their own.
  DetailRouteController({
    Object? arguments,
    Modify Function(String uuid)? createModify,
    Map<String, TagMetadata> Function()? knownTags,
  })  : _arguments = arguments,
        _createModify = createModify,
        _knownTags = knownTags;

  static const AppLogger _log = AppLogger('DetailRoute');

  final Object? _arguments;
  final Modify Function(String uuid)? _createModify;
  final Map<String, TagMetadata> Function()? _knownTags;

  late String uuid;
  late Modify modify;

  /// False when the page was opened without a loadable task; the view then
  /// renders an empty page and [onReady] closes it.
  bool hasTask = false;

  final RxBool onEdit = false.obs;
  final RxBool isReadOnly = false.obs;

  /// Whether the draft differs from the saved task. Refreshed after every
  /// edit and save so the save button can react to it.
  final RxBool hasPendingChanges = false.obs;

  // Description and project edit state
  final descriptionController = TextEditingController();
  final Rxn<String> descriptionErrorText = Rxn<String>();
  final projectController = TextEditingController();
  final tagController = TextEditingController();

  // Track whether user explicitly selected a start date
  bool startEdited = false;

  final RxString descriptionValue = ''.obs;
  final RxString statusValue = ''.obs;
  final Rx<DateTime?> entryValue = Rx<DateTime?>(null);
  final Rx<DateTime?> modifiedValue = Rx<DateTime?>(null);
  final Rx<DateTime?> startValue = Rx<DateTime?>(null);
  final Rx<DateTime?> endValue = Rx<DateTime?>(null);
  final Rx<DateTime?> dueValue = Rx<DateTime?>(null);
  final Rx<DateTime?> waitValue = Rx<DateTime?>(null);
  final Rx<DateTime?> untilValue = Rx<DateTime?>(null);
  final Rxn<String> priorityValue = Rxn<String>(null);
  final Rxn<String> projectValue = Rxn<String>(null);
  final Rxn<BuiltList<String>> tagsValue = Rxn<BuiltList<String>>(null);
  final RxDouble urgencyValue = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    _loadTask();
  }

  @override
  void onReady() {
    super.onReady();
    if (!hasTask) {
      Get.back();
      _notify(sentences.taskNotFound);
    }
  }

  /// Extracts the uuid from the `["uuid", <uuid>]` route arguments.
  static String? uuidFromArguments(Object? arguments) {
    if (arguments is List && arguments.length > 1) {
      final Object? uuid = arguments[1];
      if (uuid is String && uuid.isNotEmpty) return uuid;
    }
    return null;
  }

  void _loadTask() {
    final Object? arguments = _arguments ?? Get.arguments;
    final String? taskUuid = uuidFromArguments(arguments);
    if (taskUuid == null) {
      _log.error('Opened with invalid route arguments: $arguments');
      return;
    }
    try {
      modify = (_createModify ?? _modifyFromHome)(taskUuid);
    } catch (e, trace) {
      _log.error('Could not load task $taskUuid', e, trace);
      return;
    }
    uuid = taskUuid;
    hasTask = true;
    initValues();

    // Check if task is completed or deleted and set read-only state
    isReadOnly.value = _isClosedStatus(modify.draft.status);
    _log.info('Opened task $uuid (status: ${modify.draft.status}, '
        'read-only: ${isReadOnly.value})');
  }

  Modify _modifyFromHome(String uuid) {
    final storageWidget = Get.find<HomeController>();
    return Modify(
      getTask: storageWidget.getTask,
      mergeTask: storageWidget.mergeTask,
      uuid: uuid,
    );
  }

  static bool _isClosedStatus(dynamic status) =>
      status == 'completed' || status == 'deleted';

  Sentences get sentences =>
      SentenceManager(currentLanguage: AppSettings.selectedLanguage).sentences;

  String get appBarTitle {
    final int? id = modify.original.id;
    return '${sentences.detailPageID}: ${(id == null || id == 0) ? '-' : id}';
  }

  /// Human-readable old/new summary of every pending change.
  String get changesSummary => modify.changes.entries
      .map((entry) => '${entry.key}:\n'
          '  ${sentences.oldChanges}: ${entry.value['old']}\n'
          '  ${sentences.newChanges}: ${entry.value['new']}')
      .join('\n');

  /// Current value of every attribute, in display order. Reads the reactive
  /// values, so calling this inside an [Obx] rebuilds on every edit.
  Map<TaskAttribute, dynamic> get attributes => {
        TaskAttribute.description: descriptionValue.value,
        TaskAttribute.status: statusValue.value,
        TaskAttribute.entry: entryValue.value,
        TaskAttribute.modified: modifiedValue.value,
        TaskAttribute.start: startValue.value,
        TaskAttribute.end: endValue.value,
        TaskAttribute.due: dueValue.value,
        TaskAttribute.wait: waitValue.value,
        TaskAttribute.until: untilValue.value,
        TaskAttribute.priority: priorityValue.value,
        TaskAttribute.project: projectValue.value,
        TaskAttribute.tags: tagsValue.value,
        TaskAttribute.urgency: urgencyValue.value,
      };

  /// Status is always editable; everything else respects [isReadOnly].
  bool isAttributeEditable(TaskAttribute attribute) =>
      !isReadOnly.value || attribute == TaskAttribute.status;

  void setAttribute(TaskAttribute attribute, dynamic newValue) {
    if (!isAttributeEditable(attribute)) {
      _log.warning('Ignored edit of ${attribute.name} on read-only task $uuid');
      return;
    }
    _log.debug('Edit ${attribute.name}: '
        '${attributes[attribute]} -> $newValue (task $uuid)');

    modify.set(attribute.name, newValue);
    onEdit.value = true;

    // If status is being changed, update read-only state
    if (attribute == TaskAttribute.status) {
      isReadOnly.value = _isClosedStatus(newValue);
      _log.info('Task $uuid status -> $newValue '
          '(read-only: ${isReadOnly.value})');
    }

    if (attribute == TaskAttribute.start) {
      startEdited = true; // MARK AS USER-SELECTED
      startValue.value = newValue;
    }
    initValues();
  }

  // Validation Logic for Description
  bool validateDescription() {
    if (descriptionController.text.trim().isEmpty) {
      descriptionErrorText.value = sentences.descriprtionCannotBeEmpty;
      return false;
    }
    descriptionErrorText.value = null;
    return true;
  }

  void prepareDescriptionEdit(String initialValue) {
    descriptionController.text = initialValue;
    descriptionErrorText.value = null;
  }

  void prepareProjectEdit(String? initialValue) {
    projectController.text = initialValue ?? '';
  }

  /// Saves the draft, reports the outcome with a snackbar and returns whether
  /// it succeeded. Navigation is left to the caller.
  bool saveChanges() {
    final String changedKeys = modify.changes.keys.join(', ');
    try {
      // If start was never edited AND backend auto-generated it (start == entry)
      if (!startEdited &&
          modify.original.start != null &&
          modify.original.start!.isAtSameMomentAs(modify.original.entry)) {
        modify.set('start', null); // remove auto start
      }
      final now = DateTime.now().toUtc();
      modify.save(modified: () => now);
    } catch (e, trace) {
      _log.error('Failed to save task $uuid', e, trace);
      _notify(sentences.taskUpdateFailed);
      return false;
    }
    onEdit.value = false;
    hasPendingChanges.value = modify.changes.isNotEmpty;
    _log.info('Saved task $uuid (changed: $changedKeys)');
    _notify(sentences.taskUpdated);
    return true;
  }

  /// Shows [message] on the app-wide [ScaffoldMessenger], so it stays visible
  /// after the page closes. Used instead of `Get.snackbar`, which cannot find
  /// its overlay on current Flutter versions.
  void _notify(String message) {
    final BuildContext? context = Get.context;
    if (context == null) return;
    final ScaffoldMessengerState? messenger =
        ScaffoldMessenger.maybeOf(context);
    if (messenger == null) return;
    final TaskwarriorColorTheme? tColors =
        Theme.of(context).extension<TaskwarriorColorTheme>();
    messenger.showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(color: tColors?.primaryTextColor),
        ),
        backgroundColor: tColors?.primaryBackgroundColor,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  // Tag editing

  BuiltList<String> get currentTags => tagsValue.value ?? BuiltList<String>();

  /// Tags used across all tasks, with their frequency. Reactive when backed
  /// by the [HomeController].
  Map<String, TagMetadata> get knownTags =>
      (_knownTags ?? () => Get.find<HomeController>().pendingTags)();

  static List<String> parseTags(String input) {
    return input
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();
  }

  /// Form validator for the add-tag field.
  String? validateTags(String? value) {
    final tags = parseTags(value ?? '');
    if (tags.isEmpty) {
      return sentences.pleaseEnterATag;
    }
    for (final tag in tags) {
      if (tag.contains(' ')) {
        return sentences.tagShouldNotContainSpaces;
      }
      if (currentTags.contains(tag)) {
        return sentences.tagAlreadyExists;
      }
    }
    return null;
  }

  void prepareTagEdit() => tagController.clear();

  void addTags(List<String> tags) {
    if (tags.isEmpty) return;
    final builder = currentTags.toBuilder();
    for (final tag in tags) {
      if (!builder.build().contains(tag)) {
        builder.add(tag);
      }
    }
    setAttribute(TaskAttribute.tags, builder);
  }

  void removeTag(String tag) {
    setAttribute(TaskAttribute.tags, currentTags.toBuilder()..remove(tag));
  }

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
    priorityValue.value = modify.draft.priority;
    projectValue.value = modify.draft.project;
    tagsValue.value = modify.draft.tags;
    urgencyValue.value = urgency(modify.draft);
    hasPendingChanges.value = modify.changes.isNotEmpty;
  }

  late TutorialCoachMark tutorialCoachMark;
  bool _tourStarted = false;

  final GlobalKey dueKey = GlobalKey();
  final GlobalKey untilKey = GlobalKey();
  final GlobalKey waitKey = GlobalKey();
  final GlobalKey priorityKey = GlobalKey();

  /// Tour anchor for the attribute card, if that attribute is part of the tour.
  GlobalKey? tourKeyFor(TaskAttribute attribute) => switch (attribute) {
        TaskAttribute.due => dueKey,
        TaskAttribute.wait => waitKey,
        TaskAttribute.until => untilKey,
        TaskAttribute.priority => priorityKey,
        _ => null,
      };

  /// Builds and schedules the tour the first time the page is built; later
  /// rebuilds are no-ops.
  void startTourOnce(BuildContext context) {
    if (_tourStarted) return;
    _tourStarted = true;
    initDetailsPageTour();
    showDetailsPageTour(context);
  }

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
      () async {
        if (await SaveTourStatus.getDetailsTourStatus()) return;
        if (!context.mounted) {
          // Same as safeShowTour's unmounted path: never retry a lost tour.
          await SaveTourStatus.saveDetailsTourStatus(true);
          return;
        }
        await safeShowTour(
          tutorialCoachMark: tutorialCoachMark,
          context: context,
          targetKeys: [dueKey, waitKey, untilKey, priorityKey],
          markSeen: () => SaveTourStatus.saveDetailsTourStatus(true),
        );
      },
    );
  }

  @override
  void onClose() {
    descriptionController.dispose();
    projectController.dispose();
    tagController.dispose();
    super.onClose();
  }
}
