import 'package:get/get.dart';
import 'package:taskwarrior/app/models/report.dart';
import 'package:taskwarrior/app/services/report_service.dart';
import 'package:taskwarrior/app/services/taskrc_service.dart';
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
    selectedReport.value = report;
    try {
      final List<TaskForReplica> tasks =
          await Replica.getAllTasksFromReplica();
      results.assignAll(ReportService.execute(report, tasks));
    } catch (_) {
      results.clear();
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
}
