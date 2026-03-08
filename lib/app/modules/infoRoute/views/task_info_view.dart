import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'package:built_collection/built_collection.dart';
import 'package:taskwarrior/app/modules/detailRoute/bindings/detail_route_binding.dart';
import 'package:taskwarrior/app/modules/detailRoute/views/detail_route_view.dart';
import 'package:taskwarrior/app/modules/home/controllers/home_controller.dart';
// import 'package:taskwarrior/app/utils/taskfunctions/modify.dart';
import 'package:taskwarrior/app/models/json/task.dart';
import 'package:taskwarrior/app/models/json/annotation.dart';
import 'package:taskwarrior/app/utils/themes/theme_extension.dart';
import 'package:taskwarrior/app/utils/constants/taskwarrior_fonts.dart';
import 'package:taskwarrior/app/utils/gen/fonts.gen.dart';
import 'package:taskwarrior/app/utils/app_settings/app_settings.dart';
import 'package:taskwarrior/app/modules/infoRoute/controllers/tasks_info_route_controller.dart';
import 'package:taskwarrior/app/utils/taskfunctions/urgency.dart';
import 'package:taskwarrior/app/modules/taskc_details/bindings/taskc_details_binding.dart';
import 'package:taskwarrior/app/modules/taskc_details/views/taskc_details_view.dart';

class TasksInfoView extends GetView<TasksInfoRouteController> {
  const TasksInfoView({super.key});

  @override
  Widget build(BuildContext context) {
    final tColors = Theme.of(context).extension<TaskwarriorColorTheme>();
    return Obx(() {
      final task = controller.task.value;
      if (task == null || tColors == null) {
        return const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      }
      return Scaffold(
        backgroundColor: tColors.primaryBackgroundColor,
        appBar: AppBar(
          backgroundColor: tColors.primaryBackgroundColor,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          scrolledUnderElevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Get.back(),
          ),
          title: const Text(
            "task Info",
            style: TextStyle(
              fontFamily: FontFamily.poppins,
              fontWeight: TaskWarriorFonts.medium,
              fontSize: TaskWarriorFonts.fontSizeLarge,
            ),
          ),
          actions: [
            Padding(padding: const EdgeInsets.only(right: 12),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: IconButton(
                icon: Icon(Icons.add, color: Colors.black,),
                // onPressed: () async{
                //   final homeController = Get.find<HomeController>();
                //   if (homeController.taskchampion.value) {
                    
                //     Get.to(
                //       () => TaskcDetailsView(),
                //       binding: TaskcDetailsBinding(),
                //       arguments: task,
                //     );
                //   } else{
                //     Get.to(
                //     () => DetailRouteView(),
                //     binding: DetailRouteBinding(),
                //     arguments: ["uuid", task.uuid],
                //   );
                //   }
                //   await controller.loadTask();
                //  },
                onPressed: () async {
                final homeController = Get.find<HomeController>();
                if (homeController.taskchampion.value) {
                  final dbTask =
                      await homeController.taskdb.getTaskByUuid(controller.uuid);
                  if (dbTask != null) {
                    await Get.to(
                      () => TaskcDetailsView(),
                      binding: TaskcDetailsBinding(),
                      arguments: dbTask,
                    );
                    // await controller.loadTask();
                  }
                } 
                else if (homeController.taskReplica.value) {
                  final replicaTask = homeController.tasksFromReplica
                      .firstWhereOrNull((t) => t.uuid == controller.uuid);
                  if (replicaTask != null) {
                    await Get.to(
                      () => TaskcDetailsView(),
                      binding: TaskcDetailsBinding(),
                      arguments: replicaTask,
                    );
                    // await controller.loadTask();
                  }
                } 
                else {
                  Get.to(
                    () => DetailRouteView(),
                    binding: DetailRouteBinding(),
                    arguments: ["uuid", controller.uuid],
                  );
                }
                await controller.loadTask();
               }
               ),
             ),
            ),
          ],
        ),
        body: buildBody(task, tColors),
      );
    });
  }

  Widget buildBody(Task task, TaskwarriorColorTheme tColors) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(left: 14, right: 14, top: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          taskInfoCard(task, tColors),
          const SizedBox(height: 20),
          actionButtons(task),
          const SizedBox(height: 20),
          annotationSection(task, tColors),
        ],
      ),
    );
  }

Widget taskInfoCard(Task task, TaskwarriorColorTheme tColors) {
  return Container(
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: Colors.grey.shade600),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 14,
              height: 14,
              decoration: BoxDecoration(
                color: getPriorityColor(task.priority),
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                task.description,
                style: TextStyle(
                  fontFamily: FontFamily.poppins,
                  fontWeight: TaskWarriorFonts.medium,
                  fontSize: TaskWarriorFonts.fontSizeLarge,
                  color: tColors.primaryTextColor,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _richInfo("id: ", task.id?.toString() ?? "-", tColors),
            Text(
              task.status,
              style: TextStyle(
                fontFamily: FontFamily.poppins,
                fontSize: TaskWarriorFonts.fontSizeMedium,
                fontWeight: TaskWarriorFonts.medium,
                color: tColors.primaryTextColor,
              ),
            ),
            _richInfo("urg: ", urgency(task).toStringAsFixed(3), tColors, ),
          ],
        ),
        const SizedBox(height: 8),
        _richInfo("entry: ", formatDate(task.entry), tColors),
        const SizedBox(height: 6),
        _richInfo(
          "mod: ", task.modified != null ? formatDate(task.modified!) : "-", tColors,  ),
        const SizedBox(height: 6),
          _richInfo("due: ", task.due != null ? formatDate(task.due!) : "-", tColors, ),
        const SizedBox(height: 6),
        _richInfo("project: ", task.project ?? "-", tColors),
        const SizedBox(height: 6),
        _richInfo("tags: ", task.tags != null && task.tags!.isNotEmpty ? task.tags!.join(" ") : "-", tColors, ),
        const SizedBox(height: 6),
        _richInfo("priority: ", task.priority ?? "-", tColors),
      ],
    ),
  );
}

Widget _richInfo(
  String label,
  String value,
  TaskwarriorColorTheme tColors,
) {
  return RichText(
    text: TextSpan(
      style: TextStyle(
        fontFamily: FontFamily.poppins,
        fontSize: TaskWarriorFonts.fontSizeMedium,
      ),
      children: [
        TextSpan(
          text: label,
          style: TextStyle(color: Colors.grey),
        ),
        TextSpan(
          text: value,
          style: TextStyle(
            color: tColors.primaryTextColor,
            fontSize: TaskWarriorFonts.fontSizeMedium - 1,
          ),
        ),
      ],
    ),
  );
}
  Widget actionButtons(Task task) {
    final homeController = Get.find<HomeController>();
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        actionButton("done", const Color.fromARGB(255, 54, 188, 58), () {
          controller.loadTask();
        }),
        actionButton("start", const Color.fromARGB(255, 206, 190, 47), () {
          controller.loadTask();
        }),
        actionButton("wait", const Color.fromARGB(255, 35, 110, 240), () {
          controller.loadTask();
        }),
        actionButton("delete", const Color.fromARGB(255, 219, 28, 14), () {
          controller.loadTask();
        }),
      ],
    );
}
  Widget actionButton(
      String text, Color color, VoidCallback onPressed) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      onPressed: onPressed,
      child: Text(text, style: const TextStyle(fontFamily: FontFamily.poppins, fontWeight: TaskWarriorFonts.medium, fontSize: TaskWarriorFonts.fontSizeMedium)),
    );
  }

  Widget annotationSection(Task task, TaskwarriorColorTheme tColors) {
    final homeController = Get.find<HomeController>();
    final annotations = task.annotations ?? BuiltList<Annotation>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey.shade600,
            ),
            onPressed: () =>
                openAnnotationDialog(task, null),
            child: const Text("new annotation", style: TextStyle(fontFamily: FontFamily.poppins, fontWeight: TaskWarriorFonts.medium, fontSize: TaskWarriorFonts.fontSizeLarge)),
          ),
        ),
        const SizedBox(height: 10),
        const Text(
          "Annotations",
          style: TextStyle(
            fontFamily: FontFamily.poppins,
            fontSize: TaskWarriorFonts.fontSizeMedium,
            fontWeight: TaskWarriorFonts.medium,
          ),
        ),
        const SizedBox(height: 10),
        
        if (annotations.isNotEmpty)
          ...annotations.asMap().entries.map((entry) {
            final index = entry.key;
            final annotation = entry.value;

            return Card(
              color: tColors.secondaryBackgroundColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                title: Text(annotation.description),
                subtitle: Text(formatDate(annotation.entry)),
                onTap: () =>
                    openAnnotationDialog(task, index),
              ),
            );
          }),
      ],
    );
  }

  void openAnnotationDialog(Task task, int? index) {
    final homeController = Get.find<HomeController>();
    final annotations = task.annotations ?? BuiltList<Annotation>();

    final textController = TextEditingController(
      text: (index != null && index < annotations.length)
          ? annotations[index].description
          : "",
    );
    Get.dialog(
      AlertDialog(
        title: Text(index == null
            ? "New Annotation"
            : "Edit Annotation"),
        content: TextField(
          controller: textController,
          maxLines: null,
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () async{
              final text = textController.text.trim();
              if (text.isEmpty) {
                Get.back();
                return;
              }
              final updatedTask = task.rebuild((b) {
                b.annotations ??= ListBuilder<Annotation>();
                if (index == null) {
                  b.annotations!.add(
                    Annotation((a) => a
                      ..description = text
                      ..entry = DateTime.now().toUtc()),
                  );
                } else if (index < b.annotations!.length) {
                  b.annotations![index] =
                      b.annotations![index]
                          .rebuild((a) =>
                              a..description = text);
                }
              });
              // homeController.mergeTask(updatedTask);
              final homeController = Get.find<HomeController>();
                if (homeController.taskReplica.value) {
                await homeController.mergeReplica(updatedTask);
              } 
              else if (homeController.taskchampion.value) {
                final taskForC =
                    homeController.convertTaskToTaskForC(updatedTask);
                await homeController.mergeTaskChampion(taskForC);
              } 
              else {
                homeController.mergeTask(updatedTask);
              }
               Get.back();
              await controller.loadTask();
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }
  String formatDate(DateTime date) {
    final format =
        AppSettings.use24HourFormatRx.value
            ? 'EEE, yyyy-MM-dd HH:mm:ss'
            : 'EEE, yyyy-MM-dd hh:mm:ss a';
    return DateFormat(format).format(date.toLocal());
  }

  Color getPriorityColor(String? priority) {
    switch (priority) {
      case 'H':
        return Colors.red;
      case 'M':
        return Colors.yellow;
      case 'L':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
}