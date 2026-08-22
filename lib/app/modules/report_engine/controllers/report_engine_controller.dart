import 'package:get/get.dart';
import 'package:taskwarrior/app/models/report.dart';
import 'package:taskwarrior/app/services/report_service.dart';
import 'package:taskwarrior/app/services/taskrc_service.dart';
import 'package:taskwarrior/app/utils/taskchampion/virtual_filter_engine.dart';
import 'package:taskwarrior/app/v3/champion/models/task_for_replica.dart';
import 'package:taskwarrior/app/v3/champion/replica.dart';

/// Drives the reporting-engine screen (Issue #418): loads the available report
/// definitions (custom `.taskrc` reports first, then defaults) and runs the
/// selected one over the current replica task list.
class ReportEngineController extends GetxController {
  final RxList<ReportDefinition> reports = <ReportDefinition>[].obs;
  final Rxn<ReportDefinition> selectedReport = Rxn<ReportDefinition>();
  final RxList<TaskForReplica> results = <TaskForReplica>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool hasError = false.obs;
  final RxString taskrcPath = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadReports();
  }

  /// (Re)loads the report catalogue: default reports plus any user-defined ones
  /// found in `.taskrc`. Never throws — falls back to defaults on any error.
  Future<void> loadReports() async {
    isLoading.value = true;
    try {
      final List<ReportDefinition> custom =
          await TaskrcService.loadCustomReports();
      reports.assignAll(ReportService.availableReports(custom));
      taskrcPath.value = await TaskrcService.taskrcPath();
    } catch (_) {
      reports.assignAll(ReportService.availableReports());
    } finally {
      isLoading.value = false;
    }
  }

  /// Runs [report] against a fresh snapshot of the local replica and shows the
  /// filtered, sorted result.
  Future<void> runReport(ReportDefinition report) async {
    isLoading.value = true;
    hasError.value = false;
    selectedReport.value = report;
    try {
      final List<TaskForReplica> tasks =
          await Replica.getAllTasksFromReplica();
      results.assignAll(ReportService.execute(report, tasks));
    } catch (_) {
      // Surface the failure distinctly from a legitimately empty report —
      // otherwise a broken replica read silently looks like "no tasks match".
      results.clear();
      hasError.value = true;
    } finally {
      isLoading.value = false;
    }
  }

  /// Re-runs the currently selected report (e.g. after a pull-to-refresh).
  Future<void> rerunSelected() async {
    final ReportDefinition? current = selectedReport.value;
    if (current != null) await runReport(current);
  }

  /// Returns to the report picker.
  void clearSelection() {
    selectedReport.value = null;
    results.clear();
  }

  /// Save a user-built report and refresh the catalogue.
  ///
  /// Returns null on success, or a message explaining why it was refused —
  /// the caller shows that rather than a generic failure.
  Future<String?> saveReport(ReportDefinition report) async {
    final String? nameError = TaskrcService.validateName(report.name);
    if (nameError != null) return nameError;

    // A custom report may deliberately override a default of the same name
    // (that is how Taskwarrior behaves), so a clash is allowed — but silently
    // shadowing a built-in would be surprising, so say so.
    try {
      await TaskrcService.saveReport(report);
      await loadReports();
      return null;
    } catch (e) {
      return 'Could not save the report: $e';
    }
  }

  /// Delete a user-built report. Returns null on success, or a message.
  Future<String?> deleteReport(String name) async {
    try {
      await TaskrcService.deleteReport(name);
      if (selectedReport.value?.name == name) clearSelection();
      await loadReports();
      return null;
    } catch (e) {
      return 'Could not delete the report: $e';
    }
  }

  /// True when [name] would shadow one of the built-in reports.
  bool shadowsDefault(String name) =>
      ReportService.defaultReports.any((r) => r.name == name.trim());

  /// How many tasks a filter currently matches.
  ///
  /// This is the practical check on a filter expression. The engine ignores an
  /// attribute it does not recognise instead of failing, so a typo such as
  /// `statuss:pending` quietly matches everything — a count shown while typing
  /// makes that visible immediately, which validation alone cannot do.
  Future<int> previewMatchCount(String? filterExpression) async {
    final List<TaskForReplica> tasks = await Replica.getAllTasksFromReplica();
    return VirtualFilterEngine.applyFilter(tasks, filterExpression).length;
  }
}
