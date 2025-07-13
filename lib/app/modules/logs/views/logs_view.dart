import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taskwarrior/app/utils/debug_logger/log_databse_helper.dart';
import '../controllers/logs_controller.dart';

class LogsView extends GetView<LogsController> {
  const LogsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Debug Logs'),
        actions: [
          Obx(
            () => IconButton(
              icon: const Icon(Icons.refresh),
              onPressed:
                  controller.isLoading.value ? null : controller.loadLogs,
              tooltip: 'Refresh Logs',
            ),
          ),
          Obx(
            () => IconButton(
              icon: const Icon(Icons.delete_forever),
              onPressed:
                  controller.isLoading.value ? null : controller.clearLogs,
              tooltip: 'Clear All Logs',
            ),
          ),
        ],
      ),
      body: Obx(
        () {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          } else if (controller.logs.isEmpty) {
            return const Center(
              child: Text(
                'No debug logs found.',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            );
          } else {
            return ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: controller.logs.length,
              itemBuilder: (context, index) {
                final log = controller.logs[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          log[LogDatabaseHelper.columnMessage] ?? 'No message',
                          style: const TextStyle(fontSize: 15),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Timestamp: ${log[LogDatabaseHelper.columnTimestamp] ?? 'N/A'}',
                          style:
                              const TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
