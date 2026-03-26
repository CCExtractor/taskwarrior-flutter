import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taskwarrior/app/modules/home/controllers/home_controller.dart';
import 'package:taskwarrior/app/modules/ics_import/controllers/ics_import_controller.dart';
import 'package:taskwarrior/app/utils/themes/theme_extension.dart';

class IcsImportBottomSheet extends StatefulWidget {
  final HomeController homeController;

  const IcsImportBottomSheet({Key? key, required this.homeController}) : super(key: key);

  @override
  State<IcsImportBottomSheet> createState() => _IcsImportBottomSheetState();
}

class _IcsImportBottomSheetState extends State<IcsImportBottomSheet> {
  late final IcsImportController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(IcsImportController(widget.homeController));
  }

  @override
  void dispose() {
    Get.delete<IcsImportController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    TaskwarriorColorTheme tColors = Theme.of(context).extension<TaskwarriorColorTheme>()!;

    return Container(
      padding: const EdgeInsets.all(16.0),
      height: MediaQuery.of(context).size.height * 0.7,
      decoration: BoxDecoration(
        color: tColors.dialogBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Import ICS File", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: tColors.primaryTextColor)),
              IconButton(icon: Icon(Icons.close, color: tColors.primaryTextColor), onPressed: () => Get.back()),
            ],
          ),
          const SizedBox(height: 16),
          Center(
            child: ElevatedButton.icon(
              onPressed: () async {
                await controller.pickAndParseFile();
              },
              icon: Icon(Icons.calendar_month, color: tColors.secondaryBackgroundColor),
              label: Text('Select .ics File', style: TextStyle(color: tColors.secondaryBackgroundColor)),
              style: ElevatedButton.styleFrom(backgroundColor: tColors.primaryTextColor),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return Center(child: CircularProgressIndicator(color: tColors.primaryTextColor));
              }

              if (controller.errorMessage.value.isNotEmpty) {
                return Center(
                  child: Text(
                    controller.errorMessage.value,
                    style: const TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                );
              }

              if (controller.parsedTasks.isEmpty) {
                return Center(child: Text("No tasks found or file not loaded.", style: TextStyle(color: tColors.primaryTextColor)));
              }

              return ListView.builder(
                itemCount: controller.parsedTasks.length,
                itemBuilder: (context, index) {
                  final task = controller.parsedTasks[index];
                  return CheckboxListTile(
                    activeColor: tColors.primaryTextColor,
                    checkColor: tColors.secondaryBackgroundColor,
                    title: Text(task.description, style: TextStyle(color: tColors.primaryTextColor)),
                    subtitle: Text(task.due != null ? task.due!.toLocal().toString() : "No due date", style: TextStyle(color: tColors.primaryTextColor?.withOpacity(0.7))),
                    value: controller.selectedTasks[index],
                    onChanged: (val) {
                      controller.toggleSelection(index);
                    },
                  );
                },
              );
            }),
          ),
          const SizedBox(height: 16),
          Obx(() {
            if (controller.parsedTasks.isNotEmpty && !controller.isLoading.value) {
              return SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: controller.hasSelection ? () => controller.importSelectedTasks(context) : null,
                  style: ElevatedButton.styleFrom(backgroundColor: tColors.primaryTextColor),
                  child: Text('Import Selected Tasks', style: TextStyle(color: tColors.secondaryBackgroundColor)),
                ),
              );
            }
            return const SizedBox.shrink();
          }),
        ],
      ),
    );
  }
}
