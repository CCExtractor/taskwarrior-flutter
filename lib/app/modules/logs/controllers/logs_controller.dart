import 'package:get/get.dart';
import 'package:taskwarrior/app/utils/debug_logger/log_databse_helper.dart';

class LogsController extends GetxController {
  final LogDatabaseHelper _logDatabaseHelper = LogDatabaseHelper();
  var logs = <Map<String, dynamic>>[].obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    loadLogs();
  }

  Future<void> loadLogs() async {
    isLoading.value = true;
    final fetchedLogs = await _logDatabaseHelper.getLogs();
    logs.assignAll(fetchedLogs); // Update the RxList
    isLoading.value = false;
  }

  Future<void> clearLogs() async {
    await _logDatabaseHelper.clearLogs();
    loadLogs();
  }
}
