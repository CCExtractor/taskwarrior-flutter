import 'dart:collection';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taskwarrior/app/utils/taskfunctions/taskparser.dart';
import 'package:taskwarrior/app/modules/home/controllers/widget.controller.dart';
import 'package:taskwarrior/app/data/services/ics_parser_service.dart';
import 'package:taskwarrior/app/modules/home/controllers/home_controller.dart';
import 'package:taskwarrior/app/v3/champion/replica.dart';
import 'package:shared_preferences/shared_preferences.dart';

class IcsImportController extends GetxController {
  final isLoading = false.obs;
  final errorMessage = ''.obs;
  final parsedTasks = <IcsParsedTask>[].obs;
  final selectedTasks = <bool>[].obs;

  final HomeController homeController;

  IcsImportController(this.homeController);

  Future<void> pickAndParseFile() async {
    try {
      errorMessage.value = '';
      
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.any,
      );

      if (result == null) return; // User canceled

      String? filePath = result.files.single.path;
      if (filePath == null || !filePath.toLowerCase().endsWith('.ics')) {
        errorMessage.value = "Please select a valid .ics file.";
        return;
      }

      isLoading.value = true;
      String fileContent = await File(filePath).readAsString();

      // Ensure responsiveness by running the parse step on a separate Isolate
      final tasks = await compute(IcsParserService.parseIcsContent, fileContent);
      
      parsedTasks.assignAll(tasks);

      // Prevent duplicate imports by default-unchecking tasks that already exist
      bool isReplica = homeController.taskReplica.value || homeController.taskchampion.value;
      final existingDescriptions = isReplica 
          ? homeController.tasksFromReplica.map((t) => t.description).toSet()
          : homeController.tasks.map((t) => t.description).toSet();
          
      selectedTasks.assignAll(
        List.generate(tasks.length, (i) => !existingDescriptions.contains(tasks[i].description))
      );

    } catch (e) {
      errorMessage.value = "Failed to parse calendar file.";
      Get.snackbar(
        'Invalid Calendar File',
        'This file appears to be corrupted or not a valid .ics format.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void toggleSelection(int index) {
    selectedTasks[index] = !selectedTasks[index];
  }

  bool get hasSelection => selectedTasks.any((s) => s);

  Future<void> importSelectedTasks(BuildContext context) async {
    try {
      isLoading.value = true;

      bool isReplica = homeController.taskReplica.value || homeController.taskchampion.value;
      for (int i = 0; i < parsedTasks.length; i++) {
        if (!selectedTasks[i]) continue;

        final task = parsedTasks[i];
        
        if (isReplica) {
            final result = await Replica.addTaskToReplica(HashMap<String, dynamic>.from({
              "description": task.description,
              "due": task.due?.toUtc().toIso8601String(),
              "priority": "M", // Default Medium priority
              "project": task.project,
              "tags": task.tags,
            }));
            if (result == "err") {
              debugPrint("Failed to import task: ${task.description}");
            }
        } else {
            var rTask = taskParser(task.description).rebuild((b) {
              b.due = task.due?.toUtc();
              b.priority = "M";
              b.project = task.project;
              if (task.tags.isNotEmpty) {
                b.tags.replace(task.tags);
              }
            });
            homeController.mergeTask(rTask);
        }
      }

      final SharedPreferences prefs = await SharedPreferences.getInstance();
      bool value = prefs.getBool('sync-OnTaskCreate') ?? false;

      if (isReplica) {
          if (value) {
             homeController.refreshReplicaTasks();
          }
          await homeController.refreshReplicaTaskList();
      } else {
          homeController.update();
          if (Platform.isAndroid || Platform.isIOS) {
            WidgetController widgetController = Get.put(WidgetController());
            widgetController.fetchAllData();
            widgetController.update();
          }
          if (value) {
            homeController.synchronize(context, true);
          }
      }

      Get.back(); // close the ICS import bottom sheet
      Get.back(); // close the underlying Add Task bottom sheet
      
      Get.snackbar(
        'Success',
        'ICS Tasks imported successfully!',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      errorMessage.value = "Import failed: $e";
    } finally {
      isLoading.value = false;
    }
  }
}
