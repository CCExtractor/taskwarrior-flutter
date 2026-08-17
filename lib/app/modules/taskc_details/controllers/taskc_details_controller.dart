// ignore_for_file: deprecated_member_use, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:taskwarrior/app/modules/home/controllers/home_controller.dart';
import 'package:taskwarrior/app/utils/app_settings/app_settings.dart';
import 'package:taskwarrior/app/utils/constants/utilites.dart';
import 'package:taskwarrior/app/utils/themes/theme_extension.dart';
import 'package:taskwarrior/app/utils/language/sentence_manager.dart';
import 'package:taskwarrior/app/v3/db/task_database.dart';
import 'package:taskwarrior/app/v3/models/annotation.dart';
import 'package:taskwarrior/app/v3/models/task.dart';
import 'package:taskwarrior/app/v3/champion/replica.dart';
import 'package:taskwarrior/app/v3/champion/models/task_for_replica.dart';

enum UnsavedChangesAction { save, discard, cancel }

class TaskcDetailsController extends GetxController {
  late final dynamic initialTask;
  late TaskDatabase taskDatabase;

  final hasChanges = false.obs;

  late RxString description;
  late RxString project;
  late RxString status;
  late RxString priority;
  late RxString due;
  late RxString start;
  late RxString wait;
  late RxList<String> tags;
  late RxList<String> depends;
  late RxString rtype;
  late RxString recur;
  late RxList<Annotation> annotations;
  // Blocking state surfaced by the Rust serializer (replica tasks only).
  late RxBool isBlocked;
  late RxBool isBlocking;
  late RxList<String> previousTags = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    initialTask = Get.arguments;
    _initializeState(initialTask);
    taskDatabase = TaskDatabase();
    taskDatabase.open();
  }

  void _initializeState(dynamic task) {
    // Support both TaskForC (local tasks) and TaskForReplica (replica tasks)
    if (task is TaskForC) {
      description = task.description.obs;
      project = (task.project ?? 'None').obs;
      status = task.status.obs;
      priority = (task.priority ?? 'None').obs;
      due = formatDate(task.due).obs;
      start = "".obs;
      wait = "".obs;
      tags = task.tags != null
          ? task.tags!.map((e) => e.toString()).toList().obs
          : <String>[].obs;
      previousTags = tags.toList().obs;
      depends = "".split(",").obs;
      rtype = "".obs;
      recur = "".obs;
      annotations = <Annotation>[].obs;
      isBlocked = false.obs;
      isBlocking = false.obs;
    } else if (task is TaskForReplica) {
      description = (task.description ?? '').obs;
      project = (task.project ?? 'None').obs;
      status = (task.status ?? '').obs;
      priority = (task.priority ?? 'None').obs;
      // TaskForReplica stores epoch seconds; convert to ISO string for formatting
      debugPrint('Replica task due: ${task.due}');
      due = formatDate(task.due).obs;
      // Initialize start/wait from replica model (may be ISO or epoch)
      start = formatDate(task.start).obs;
      wait = formatDate(task.wait).obs;
      debugPrint(
          'Replica task tags while init: ${task.tags ?? task.tags?.join(", ")}');
      tags = task.tags != null
          ? task.tags!.map((e) => e.toString()).toList().obs
          : <String>[].obs;
      previousTags = tags.toList().obs;
      // Attributes now surfaced by the Rust serializer.
      depends = (task.depends ?? <String>[]).obs;
      rtype = "".obs;
      recur = (task.recur ?? "").obs;
      annotations = (task.annotations ?? <Annotation>[]).obs;
      isBlocked = (task.isBlocked ?? false).obs;
      isBlocking = (task.isBlocking ?? false).obs;
    } else {
      // Fallback
      description = ''.obs;
      project = 'None'.obs;
      status = ''.obs;
      priority = 'None'.obs;
      due = 'None'.obs;
      start = "".obs;
      wait = "".obs;
      tags = <String>[].obs;
      previousTags = <String>[].obs;
      depends = "".split(",").obs;
      rtype = "".obs;
      recur = "".obs;
      annotations = <Annotation>[].obs;
      isBlocked = false.obs;
      isBlocking = false.obs;
    }
  }

  String formatDate(dynamic date) {
    if (date == null) return 'None';
    // If date is epoch seconds as int
    bool is24hrFormat = AppSettings.use24HourFormatRx.value;
    final pattern = is24hrFormat
        ? 'EEE, yyyy-MM-dd HH:mm:ss'
        : 'EEE, yyyy-MM-dd hh:mm:ss a';

    if (date == null) return 'None';

    if (date is int) {
      try {
        final dt = DateTime.fromMillisecondsSinceEpoch(date * 1000);
        return DateFormat(pattern).format(dt.toLocal());
      } catch (e) {
        debugPrint('Error formatting epoch date: $e');
        return 'None';
      }
    }

    if (date is DateTime) {
      try {
        return DateFormat(pattern).format(date.toLocal());
      } catch (e) {
        debugPrint('Error formatting DateTime: $e');
        return 'None';
      }
    }

    final dateString = date?.toString() ?? '';
    if (dateString.isEmpty || dateString == 'None') return 'None';

    try {
      final parsedDate = DateTime.parse(dateString).toLocal();
      return DateFormat(pattern).format(parsedDate);
    } catch (e) {
      debugPrint('Error parsing date: $dateString $e');
      return 'None';
    }
  }

  void updateField<T>(Rx<T> field, T value) {
    if (field.value != value) {
      field.value = value;
      hasChanges.value = true;
    }
  }

  void updateListField(RxList<String> field, String value) {
    final newList = value.split(',').map((e) => e.trim()).toList();
    if (field.toList().toString() != newList.toString()) {
      field.assignAll(newList);
      hasChanges.value = true;
    }
  }

  /// Whether this task's notes can be edited.
  ///
  /// Only replica tasks: the annotation write path is the TaskChampion FFI, and
  /// the legacy SQLite model has no equivalent. The view hides the editor
  /// entirely rather than offering a control that would silently do nothing.
  bool get canEditAnnotations => isReplicaTask;

  /// True while an annotation write is in flight, so the view can disable its
  /// controls instead of allowing a second write to race the first.
  final annotationBusy = false.obs;

  /// Backing field for the "add a note" input. Owned by the controller rather
  /// than the view so its text survives rebuilds, and so it is disposed exactly
  /// once when the page is torn down.
  final TextEditingController annotationInput = TextEditingController();

  @override
  void onClose() {
    annotationInput.dispose();
    super.onClose();
  }

  /// Add a note to this task.
  ///
  /// Unlike the field editors, this writes through immediately rather than
  /// joining the draft that [saveTask] commits. An annotation is its own
  /// record in TaskChampion, added and removed by dedicated operations — there
  /// is no "whole task" write that would carry it along, so deferring it would
  /// mean inventing a pending-notes buffer for no benefit. It therefore does
  /// not set [hasChanges]; leaving the page after adding a note loses nothing.
  ///
  /// Returns null on success, or a message describing why the write failed.
  Future<String?> addAnnotationToTask(String description) async {
    if (!canEditAnnotations) return 'Notes can only be edited on synced tasks.';
    if (annotationBusy.value) return null;

    final String uuid = initialTaskUuidDisplay();
    if (uuid == 'None') return 'This task has no identifier yet.';

    annotationBusy.value = true;
    try {
      final String entry =
          await Replica.addAnnotationToReplica(uuid, description);
      // Append locally rather than re-reading every task from the replica: the
      // entry the FFI returns is authoritative, so the list stays in step.
      annotations.add(Annotation(entry: entry, description: description.trim()));
      await _refreshHomeTasks();
      return null;
    } catch (e) {
      return _annotationErrorMessage(e);
    } finally {
      annotationBusy.value = false;
    }
  }

  /// Remove a note. Returns null on success, or a message on failure.
  Future<String?> removeAnnotationFromTask(Annotation annotation) async {
    if (!canEditAnnotations) return 'Notes can only be edited on synced tasks.';
    if (annotationBusy.value) return null;

    final String uuid = initialTaskUuidDisplay();
    final String? entry = annotation.entry;
    if (uuid == 'None' || entry == null || entry.isEmpty) {
      return 'This note cannot be identified, so it cannot be removed.';
    }

    annotationBusy.value = true;
    try {
      await Replica.removeAnnotationFromReplica(uuid, entry);
      annotations.removeWhere((a) => a.entry == entry);
      await _refreshHomeTasks();
      return null;
    } catch (e) {
      return _annotationErrorMessage(e);
    } finally {
      annotationBusy.value = false;
    }
  }

  /// Recurrence options the picker offers. Taskwarrior accepts far more, but
  /// these cover the ordinary cases and cannot be mistyped.
  static const List<String> recurrenceOptions = <String>[
    'None',
    'daily',
    'weekly',
    'monthly',
    'quarterly',
    'yearly',
  ];

  /// Whether a due date is currently set. Recurrence depends on it: Taskwarrior
  /// deletes a recurring task that has no due date, so the control stays
  /// unavailable until there is one.
  bool get hasDueDate {
    final String d = due.value.trim();
    return d.isNotEmpty && d != 'None';
  }

  /// Whether recurrence can be edited: replica tasks with a due date.
  bool get canEditRecurrence => isReplicaTask && hasDueDate;

  /// Why the due date cannot be cleared right now, or null if it can.
  String? get dueRemovalBlockedReason =>
      (isReplicaTask && recur.value.trim().isNotEmpty)
          ? 'Clear the repeat first — a repeating task needs a due date.'
          : null;

  /// Whether this task's dependencies can be edited. Replica tasks only, for
  /// the same reason as annotations: the write path is the TaskChampion FFI.
  bool get canEditDependencies => isReplicaTask;

  /// True while a dependency write is in flight.
  final dependencyBusy = false.obs;

  /// Tasks that can be picked as a dependency: everything in the replica except
  /// this task and the ones it already depends on.
  ///
  /// Cycles are rejected by the Rust layer rather than filtered out here — the
  /// check needs the whole graph, and doing it in one place keeps the answer
  /// consistent no matter which client asks.
  List<TaskForReplica> availableDependencyCandidates() {
    if (!canEditDependencies) return <TaskForReplica>[];
    final String self = initialTaskUuidDisplay();
    final Set<String> already = depends.toSet();
    try {
      return Get.find<HomeController>()
          .tasksFromReplica
          .where((t) => t.uuid != self && !already.contains(t.uuid))
          .toList();
    } catch (e) {
      debugPrint('Could not list dependency candidates: $e');
      return <TaskForReplica>[];
    }
  }

  /// A dependency is stored as a bare UUID, which means nothing to a reader.
  /// Resolve it to the task's description, falling back to a short UUID prefix
  /// when the task is not in the local replica.
  String describeDependency(String uuid) {
    try {
      final matches = Get.find<HomeController>()
          .tasksFromReplica
          .where((t) => t.uuid == uuid);
      if (matches.isNotEmpty) {
        final String? description = matches.first.description;
        if (description != null && description.trim().isNotEmpty) {
          return description.trim();
        }
      }
    } catch (_) {
      // fall through to the UUID form
    }
    return uuid.length > 8 ? '${uuid.substring(0, 8)}…' : uuid;
  }

  /// Add a dependency. Returns null on success, or a message on failure.
  Future<String?> addDependencyToTask(String dependsOnUuid) async {
    if (!canEditDependencies) {
      return 'Dependencies can only be edited on synced tasks.';
    }
    if (dependencyBusy.value) return null;

    final String uuid = initialTaskUuidDisplay();
    if (uuid == 'None') return 'This task has no identifier yet.';

    dependencyBusy.value = true;
    try {
      await Replica.addDependencyToReplica(uuid, dependsOnUuid);
      depends.add(dependsOnUuid);
      // Adding a dependency makes this task blocked; the depended-on task
      // becomes blocking. Reflect the half we are showing.
      isBlocked.value = true;
      await _refreshHomeTasks();
      return null;
    } catch (e) {
      return _annotationErrorMessage(e);
    } finally {
      dependencyBusy.value = false;
    }
  }

  /// Remove a dependency. Returns null on success, or a message on failure.
  Future<String?> removeDependencyFromTask(String dependsOnUuid) async {
    if (!canEditDependencies) {
      return 'Dependencies can only be edited on synced tasks.';
    }
    if (dependencyBusy.value) return null;

    final String uuid = initialTaskUuidDisplay();
    if (uuid == 'None') return 'This task has no identifier yet.';

    dependencyBusy.value = true;
    try {
      await Replica.removeDependencyFromReplica(uuid, dependsOnUuid);
      depends.remove(dependsOnUuid);
      // Only the last remaining dependency clears the blocked flag.
      if (depends.isEmpty) isBlocked.value = false;
      await _refreshHomeTasks();
      return null;
    } catch (e) {
      return _annotationErrorMessage(e);
    } finally {
      dependencyBusy.value = false;
    }
  }

  /// Reload the home list after a write.
  ///
  /// The detail page renders the `TaskForReplica` it was handed from that list,
  /// so without this the cached copy goes stale the moment anything is written.
  /// It matters most for dependencies: adding one changes the *other* task's
  /// computed `is_blocking`, and opening that task would otherwise still show
  /// the value from before the edge existed.
  Future<void> _refreshHomeTasks() async {
    try {
      await Get.find<HomeController>().refreshReplicaTasks();
    } catch (e) {
      debugPrint('Could not refresh tasks after write: $e');
    }
  }

  /// The Rust layer returns typed, already-readable messages ("annotation text
  /// cannot be empty", "no task with UUID ..."). Surface those rather than a
  /// generic failure, but strip the exception wrapper Dart adds around them.
  String _annotationErrorMessage(Object error) {
    final String raw = error.toString();
    final int marker = raw.indexOf(': ');
    final String message =
        marker >= 0 && marker + 2 < raw.length ? raw.substring(marker + 2) : raw;
    return message.trim().isEmpty ? 'Could not save the note.' : message.trim();
  }

  // Safe accessors for fields on the initial task so views don't attempt to
  // read properties that don't exist on TaskForReplica (which is a different
  // model shape than TaskForC).
  String initialTaskUuidDisplay() {
    try {
      if (initialTask == null) return 'None';
      if (initialTask is TaskForC)
        return (initialTask.uuid ?? 'None')?.toString() ?? 'None';
      if (initialTask is TaskForReplica) return initialTask.uuid ?? 'None';
      return 'None';
    } catch (_) {
      return 'None';
    }
  }

  String initialTaskUrgencyDisplay() {
    try {
      if (initialTask is TaskForC) {
        final u = initialTask.urgency as double?;
        return (u != null) ? u.toStringAsFixed(2) : 'None';
      }
      // TaskForReplica doesn't have urgency
      return 'None';
    } catch (_) {
      return 'None';
    }
  }

  // Provide values suitable for controller.formatDate(...) without accessing
  // missing properties directly from the view.
  dynamic initialTaskEntryForFormatting() {
    try {
      if (initialTask is TaskForC) return initialTask.entry;
      return null;
    } catch (_) {
      return null;
    }
  }

  dynamic initialTaskEndForFormatting() {
    try {
      if (initialTask is TaskForC) return initialTask.end;
      return null;
    } catch (_) {
      return null;
    }
  }

  dynamic initialTaskModifiedForFormatting() {
    try {
      if (initialTask is TaskForC) return initialTask.modified;
      if (initialTask is TaskForReplica) return initialTask.modified;
      return null;
    } catch (_) {
      return null;
    }
  }

  // Shorthand helpers for view logic
  bool get isReplicaTask => initialTask is TaskForReplica;
  bool get isLocalTask => initialTask is TaskForC;

  void processTagsLists() {
    final itemsToMove = previousTags.toSet().difference(tags.toSet());
    tags.addAll(itemsToMove.map((item) => '-$item'));
    previousTags.removeWhere((item) => itemsToMove.contains(item));
  }

  Future<void> saveTask() async {
    bool is24hrFormat = AppSettings.use24HourFormatRx.value;
    final datePattern = is24hrFormat
        ? 'EEE, yyyy-MM-dd HH:mm:ss'
        : 'EEE, yyyy-MM-dd hh:mm:ss a';

    if (tags.length == 1 && tags[0] == "") {
      tags.clear();
    }
    if (initialTask is TaskForC) {
      await taskDatabase.saveEditedTaskInDB(
        initialTask.uuid!,
        description.string,
        project.string,
        status.string,
        priority.string,
        DateTime.parse(due.string).toIso8601String(),
        tags.toList(),
      );
      hasChanges.value = false;
      debugPrint('Task saved in local DB ${description.string}');
      processTagsLists();
    } else if (initialTask is TaskForReplica) {
      debugPrint(
          'Saving replica task changes... status ${status.string} ${tags.join(", ")}');
      final int nowEpoch = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      final modifiedTask = TaskForReplica(
        modified: nowEpoch,
        due: () {
          if (due.string == 'None' || due.string.isEmpty) return null;
          try {
            final parsed = DateFormat(datePattern).parse(due.string);
            return parsed.toUtc().toIso8601String();
          } catch (e) {
            try {
              final parsed2 = DateTime.parse(due.string);
              return parsed2.toUtc().toIso8601String();
            } catch (_) {
              debugPrint(
                  'Could not parse due string for replica: ${due.string}');
              return null;
            }
          }
        }(),
        start: () {
          if (start.string == 'None' || start.string.isEmpty) return null;
          if (start.string == "stop") return "stop";
          try {
            final parsed = DateFormat(datePattern).parse(start.string);
            return parsed.toUtc().toIso8601String();
          } catch (e) {
            try {
              final parsed2 = DateTime.parse(start.string);
              return parsed2.toUtc().toIso8601String();
            } catch (_) {
              debugPrint(
                  'Could not parse start string for replica: ${start.string}');
              return null;
            }
          }
        }(),
        wait: () {
          if (wait.string == 'None' || wait.string.isEmpty) return null;
          try {
            final parsed = DateFormat(datePattern).parse(wait.string);
            return parsed.toUtc().toIso8601String();
          } catch (e) {
            try {
              final parsed2 = DateTime.parse(wait.string);
              return parsed2.toUtc().toIso8601String();
            } catch (_) {
              debugPrint(
                  'Could not parse wait string for replica: ${wait.string}');
              return null;
            }
          }
        }(),
        // Setting a repeat turns the task into a recurrence *template*, which
        // Taskwarrior marks with status `recurring`. Verified against the CLI:
        // with `recur` alone it reads the value but generates nothing; only a
        // task whose status is `recurring` gets instances created. Clearing the
        // repeat turns it back into an ordinary pending task.
        status: recur.string.trim().isNotEmpty
            ? 'recurring'
            : (status.string.isNotEmpty
                ? (status.string == 'recurring' ? 'pending' : status.string)
                : null),
        description: description.string.isNotEmpty ? description.string : null,
        tags: tags.isNotEmpty ? tags.toList() : null,
        uuid: initialTask.uuid ?? '',
        priority: priority.string.isNotEmpty ? priority.string : null,
        project: project.string != 'None' ? project.string : null,
        // Sent as part of the same edit rather than as its own write, because
        // the FFI validates recurrence against the due date — and the user may
        // legitimately set both in one go.
        recur: recur.string.trim().isEmpty ? null : recur.string.trim(),
      );
      debugPrint('Modified replica task: $modifiedTask');
      hasChanges.value = false;
      processTagsLists();
      final String? error = await Replica.modifyTaskInReplica(modifiedTask);
      if (error != null) {
        // The edit was rejected outright (e.g. recurrence without a due date),
        // so the draft is still unsaved — say why rather than silently losing it.
        hasChanges.value = true;
        Get.snackbar('Not saved', error,
            snackPosition: SnackPosition.BOTTOM, duration: const Duration(seconds: 4));
        return;
      }
      try {
        final HomeController homeController = Get.find<HomeController>();
        await homeController.refreshReplicaTasks();
      } catch (e) {
        debugPrint('Could not find HomeController to refresh tasks: $e');
      }
    }
  }

  Future<bool> handleWillPop() async {
    if (hasChanges.value) {
      final action = await _showUnsavedChangesDialog();
      if (action == UnsavedChangesAction.save) {
        await saveTask();
        return true;
      } else if (action == UnsavedChangesAction.discard) {
        return true;
      } else {
        return false;
      }
    }
    return true;
  }

  Future<void> pickDateTime(RxString field) async {
    final BuildContext context = Get.context!;
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: field.value != 'None'
          ? DateTime.tryParse(field.value) ?? DateTime.now()
          : DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(field.value != 'None'
            ? DateTime.tryParse(field.value) ?? DateTime.now()
            : DateTime.now()),
      );

      DateTime fullDateTime;
      if (pickedTime != null) {
        fullDateTime = DateTime(pickedDate.year, pickedDate.month,
            pickedDate.day, pickedTime.hour, pickedTime.minute);
      } else {
        fullDateTime = pickedDate;
      }
      updateField(
          field, DateFormat('yyyy-MM-dd HH:mm:ss').format(fullDateTime));
    }
  }

  Future<String?> showEditDialog(String label, String initialValue) async {
    final BuildContext context = Get.context!;
    TaskwarriorColorTheme tColors =
        Theme.of(context).extension<TaskwarriorColorTheme>()!;
    final TextEditingController textController =
        TextEditingController(text: initialValue);

    return await Get.dialog<String>(
      Utils.showAlertDialog(
        title: Text(
          '${SentenceManager(currentLanguage: AppSettings.selectedLanguage).sentences.edit} $label',
          style: TextStyle(color: tColors.primaryTextColor),
        ),
        content: TextField(
          style: TextStyle(color: tColors.primaryTextColor),
          controller: textController,
          decoration: InputDecoration(
            hintText:
                '${SentenceManager(currentLanguage: AppSettings.selectedLanguage).sentences.enterNew} $label',
            hintStyle: TextStyle(color: tColors.primaryTextColor),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              SentenceManager(currentLanguage: AppSettings.selectedLanguage)
                  .sentences
                  .cancel,
              style: TextStyle(color: tColors.primaryTextColor),
            ),
          ),
          TextButton(
            onPressed: () => Get.back(result: textController.text),
            child: Text(
              SentenceManager(currentLanguage: AppSettings.selectedLanguage)
                  .sentences
                  .save,
              style: TextStyle(color: tColors.primaryTextColor),
            ),
          ),
        ],
      ),
    );
  }

  Future<String?> showSelectDialog(
      String label, String initialValue, List<String> options) async {
    final BuildContext context = Get.context!;
    TaskwarriorColorTheme tColors =
        Theme.of(context).extension<TaskwarriorColorTheme>()!;

    return await Get.dialog<String>(
      Utils.showAlertDialog(
        title: Text(
          '${SentenceManager(currentLanguage: AppSettings.selectedLanguage).sentences.select} $label',
          style: TextStyle(color: tColors.primaryTextColor),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: options.map((option) {
            return RadioListTile<String>(
              title: Text(
                option,
                style: TextStyle(color: tColors.primaryTextColor),
              ),
              value: option,
              groupValue: initialValue,
              onChanged: (value) => Get.back(result: value),
            );
          }).toList(),
        ),
      ),
    );
  }

  Future<UnsavedChangesAction?> _showUnsavedChangesDialog() async {
    final BuildContext context = Get.context!;
    TaskwarriorColorTheme tColors =
        Theme.of(context).extension<TaskwarriorColorTheme>()!;
    return Get.dialog<UnsavedChangesAction>(
      barrierDismissible: false,
      Utils.showAlertDialog(
        title: Text(
          SentenceManager(currentLanguage: AppSettings.selectedLanguage)
              .sentences
              .unsavedChanges,
          style: TextStyle(color: tColors.primaryTextColor),
        ),
        content: Text(
          SentenceManager(currentLanguage: AppSettings.selectedLanguage)
              .sentences
              .unsavedChangesWarning,
          style: TextStyle(color: tColors.primaryTextColor),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Get.back(result: UnsavedChangesAction.cancel),
            child: Text(
                SentenceManager(currentLanguage: AppSettings.selectedLanguage)
                    .sentences
                    .cancel),
          ),
          TextButton(
            onPressed: () => Get.back(result: UnsavedChangesAction.discard),
            child: Text(
                SentenceManager(currentLanguage: AppSettings.selectedLanguage)
                    .sentences
                    .dontSave),
          ),
          TextButton(
            onPressed: () => Get.back(result: UnsavedChangesAction.save),
            child: Text(
                SentenceManager(currentLanguage: AppSettings.selectedLanguage)
                    .sentences
                    .save),
          ),
        ],
      ),
    );
  }
}
