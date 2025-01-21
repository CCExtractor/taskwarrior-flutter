import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taskwarrior/api_service.dart';
import 'package:taskwarrior/app/models/json/task.dart';
import 'package:taskwarrior/app/modules/home/controllers/home_controller.dart';
import 'package:taskwarrior/app/modules/home/controllers/widget.controller.dart';
import 'package:taskwarrior/app/utils/add_task_dialogue/date_picker_input.dart';
import 'package:taskwarrior/app/utils/add_task_dialogue/tags_input.dart';
import 'package:taskwarrior/app/utils/app_settings/app_settings.dart';
import 'package:taskwarrior/app/utils/constants/constants.dart';
import 'package:taskwarrior/app/utils/language/sentence_manager.dart';
import 'package:taskwarrior/app/utils/taskfunctions/add_task_dialog_utils.dart';
import 'package:taskwarrior/app/utils/taskfunctions/tags.dart';
import 'package:taskwarrior/app/utils/taskfunctions/taskparser.dart';

class AddTaskBottomSheet extends StatelessWidget {
  final HomeController homeController;
  final bool forTaskC;
  const AddTaskBottomSheet(
      {required this.homeController, super.key, this.forTaskC = false});

  @override
  Widget build(BuildContext context) {
    const padding = 12.0;
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Form(
        key: homeController.formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(padding),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () {
                      Get.back();
                    },
                    child: const Text("Cancel"),
                  ),
                  Text(
                    SentenceManager(
                            currentLanguage:
                                homeController.selectedLanguage.value)
                        .sentences
                        .addTaskTitle,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      onSaveButtonClicked(context);
                    },
                    child: const Text("Save"),
                  ),
                ],
              ),
            ),
            Flexible(
              child: SingleChildScrollView(
                  child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(padding),
                    child: TextFormField(
                      controller: homeController.namecontroller,
                      validator: (value) =>
                          value!.isEmpty ? "Description cannot be empty" : null,
                      decoration: const InputDecoration(
                        labelText: 'Enter Task Description',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  Padding(
                      padding: const EdgeInsets.all(padding),
                      child: buildProjectInput(context)),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: padding, right: padding, top: padding),
                    child: buildDatePicker(context),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(padding),
                    child: buildPriority(context),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(padding),
                    child: buildTagsInput(context),
                  ),
                  const Padding(padding: EdgeInsets.all(20)),
                ],
              )),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildProjectInput(BuildContext context) => Autocomplete<String>(
        optionsBuilder: (textEditingValue) async {
          Iterable<String> projects = getProjects();
          debugPrint("projects found $projects");
          return projects.where(
              (String project) => project.contains(textEditingValue.text));
        },
        optionsViewBuilder: (context, onAutoCompleteSelect, options) {
          return Align(
            alignment: Alignment.topLeft,
            child: Material(
              elevation: 4.0,
              child: Container(
                width: MediaQuery.of(context).size.width - 12 * 2,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4.0),
                ),
                child: ListView.separated(
                  shrinkWrap: true,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemCount: options.length,
                  separatorBuilder: (context, i) => const Divider(height: 1),
                  itemBuilder: (BuildContext context, int index) {
                    return InkWell(
                      onTap: () {
                        onAutoCompleteSelect(options.elementAt(index));
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 12.0),
                        child: Text(
                          options.elementAt(index),
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          );
        },
        fieldViewBuilder:
            (context, textEditingController, focusNode, onFieldSubmitted) =>
                TextFormField(
          controller: textEditingController,
          decoration: const InputDecoration(
            labelText: 'Project',
            border: OutlineInputBorder(),
          ),
          onChanged: (value) => homeController.projectcontroller.text = value,
          focusNode: focusNode,
        ),
      );

  Widget buildTagsInput(BuildContext context) => AddTaskTagsInput(
        suggestions: tagSet(homeController.storage.data.allData()),
        onTagsChanges: (p0) => homeController.tags.value = p0,
      );

  Widget buildDatePicker(BuildContext context) => AddTaskDatePickerInput(
        onDateChanges: (List<DateTime?> p0) {
          homeController.selectedDates.value = p0;
        },
      );

  Widget buildPriority(BuildContext context) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Obx(
            () => TextField(
              readOnly: true, // Make the field read-only
              controller: TextEditingController(
                text: getPriorityText(homeController
                    .priority.value), // Display the selected priority
              ),
              decoration: InputDecoration(
                labelText: 'Priority',
                border: const OutlineInputBorder(),
                suffixIcon: Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: GestureDetector(
                    onTap: () {
                      debugPrint("Open priority selection.");
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        for (int i = 0;
                            i < homeController.priorityList.length;
                            i++)
                          GestureDetector(
                            onTap: () {
                              homeController.priority.value =
                                  homeController.priorityList[i];
                              debugPrint(homeController.priority.value);
                            },
                            child: AnimatedContainer(
                              margin: const EdgeInsets.only(right: 5),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              duration: const Duration(milliseconds: 200),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: homeController.priority.value ==
                                          homeController.priorityList[i]
                                      ? AppSettings.isDarkMode
                                          ? TaskWarriorColors
                                              .kLightPrimaryBackgroundColor
                                          : TaskWarriorColors
                                              .kprimaryBackgroundColor
                                      : AppSettings.isDarkMode
                                          ? TaskWarriorColors
                                              .kprimaryBackgroundColor
                                          : TaskWarriorColors
                                              .kLightPrimaryBackgroundColor,
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  homeController.priorityList[i],
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: homeController.priorityColors[i],
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      );

  Set<String> getProjects() {
    Iterable<Task> tasks = homeController.storage.data.allData();
    return tasks
        .where((task) => task.project != null)
        .fold(<String>{}, (aggregate, task) => aggregate..add(task.project!));
  }

  void onSaveButtonClickedTaskC(BuildContext context) async {
    if (homeController.formKey.currentState!.validate()) {
      var task = Tasks(
          description: homeController.namecontroller.text,
          status: 'pending',
          priority: homeController.priority.value,
          entry: DateTime.now().toIso8601String(),
          id: 0,
          project: homeController.projectcontroller.text,
          uuid: '',
          urgency: 0,
          due: getDueDate(homeController.selectedDates).toString(),
          end: '',
          modified: 'r');
      await homeController.taskdb.insertTask(task);
      homeController.namecontroller.text = '';
      homeController.due.value = null;
      homeController.priority.value = 'M';
      homeController.projectcontroller.text = '';
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            'Task Added Successfully!',
            style: TextStyle(
              color: AppSettings.isDarkMode
                  ? TaskWarriorColors.kprimaryTextColor
                  : TaskWarriorColors.kLightPrimaryTextColor,
            ),
          ),
          backgroundColor: AppSettings.isDarkMode
              ? TaskWarriorColors.ksecondaryBackgroundColor
              : TaskWarriorColors.kLightSecondaryBackgroundColor,
          duration: const Duration(seconds: 2)));
      Navigator.of(context).pop();
    }
  }

  void onSaveButtonClicked(BuildContext context) async {
    // print(homeController.formKey.currentState);
    if (homeController.formKey.currentState!.validate()) {
      try {
        var task = taskParser(homeController.namecontroller.text)
            .rebuild((b) =>
                b..due = getDueDate(homeController.selectedDates)?.toUtc())
            .rebuild((p) => p..priority = homeController.priority.value)
            .rebuild((t) => t..project = homeController.projectcontroller.text)
            .rebuild((t) =>
                t..wait = getWaitDate(homeController.selectedDates)?.toUtc())
            .rebuild((t) =>
                t..until = getUntilDate(homeController.selectedDates)?.toUtc())
            .rebuild((t) => t
              ..scheduled =
                  getSchedDate(homeController.selectedDates)?.toUtc());
        if (homeController.tags.isNotEmpty) {
          task = task.rebuild((t) => t..tags.replace(homeController.tags));
        }
        Get.find<HomeController>().mergeTask(task);
        homeController.namecontroller.text = '';
        homeController.projectcontroller.text = '';
        homeController.dueString.value = "";
        homeController.priority.value = 'X';
        homeController.tagcontroller.text = '';
        homeController.tags.value = [];
        homeController.update();
        Get.back();
        if (Platform.isAndroid) {
          WidgetController widgetController = Get.put(WidgetController());
          widgetController.fetchAllData();
          widgetController.update();
        }

        homeController.update();

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
              SentenceManager(
                      currentLanguage: homeController.selectedLanguage.value)
                  .sentences
                  .addTaskTaskAddedSuccessfully,
              style: TextStyle(
                color: AppSettings.isDarkMode
                    ? TaskWarriorColors.kprimaryTextColor
                    : TaskWarriorColors.kLightPrimaryTextColor,
              ),
            ),
            backgroundColor: AppSettings.isDarkMode
                ? TaskWarriorColors.ksecondaryBackgroundColor
                : TaskWarriorColors.kLightSecondaryBackgroundColor,
            duration: const Duration(seconds: 2)));

        final SharedPreferences prefs = await SharedPreferences.getInstance();
        bool? value;
        value = prefs.getBool('sync-OnTaskCreate') ?? false;
        // late InheritedStorage storageWidget;
        // storageWidget = StorageWidget.of(context);
        var storageWidget = Get.find<HomeController>();
        if (value) {
          storageWidget.synchronize(context, true);
        }
      } on FormatException catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
              e.message,
              style: TextStyle(
                color: AppSettings.isDarkMode
                    ? TaskWarriorColors.kprimaryTextColor
                    : TaskWarriorColors.kLightPrimaryTextColor,
              ),
            ),
            backgroundColor: AppSettings.isDarkMode
                ? TaskWarriorColors.ksecondaryBackgroundColor
                : TaskWarriorColors.kLightSecondaryBackgroundColor,
            duration: const Duration(seconds: 2)));
      }
    }
  }
}
