// ignore_for_file: use_build_context_synchronously
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taskwarrior/app/modules/home/controllers/home_controller.dart';
import 'package:taskwarrior/app/modules/home/controllers/widget.controller.dart';
import 'package:taskwarrior/app/utils/constants/taskwarrior_colors.dart';
import 'package:taskwarrior/app/utils/constants/taskwarrior_fonts.dart';
import 'package:taskwarrior/app/utils/language/sentence_manager.dart';
import 'package:taskwarrior/app/utils/taskfunctions/taskparser.dart';
import 'package:taskwarrior/app/utils/themes/theme_extension.dart';

class AddTaskBottomSheet extends StatelessWidget {
  final HomeController homeController;
  const AddTaskBottomSheet({required this.homeController, super.key});
  @override
  Widget build(BuildContext context) {
    TaskwarriorColorTheme tColors = Theme.of(context).extension<TaskwarriorColorTheme>()!;
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: SingleChildScrollView(
          child: AlertDialog(
            surfaceTintColor: tColors.dialogBackgroundColor,
            shadowColor: tColors.dialogBackgroundColor,
            backgroundColor: tColors.dialogBackgroundColor,
            title: Center(
              child: Text(
                SentenceManager(
                        currentLanguage: homeController.selectedLanguage.value)
                    .sentences
                    .addTaskTitle,
                style: TextStyle(
                  color: tColors.primaryTextColor
                  ),
              ),
            ),
            content: Form(
              key: homeController.formKey,
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    const SizedBox(height: 8),
                    buildName(tColors),
                    const SizedBox(height: 12),
                    buildDueDate(context, tColors),
                    const SizedBox(height: 8),
                    buildPriority(tColors),
                    buildTags(tColors),
                  ],
                ),
              ),
            ),
            actions: <Widget>[
              buildCancelButton(context, homeController, tColors),
              buildAddButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTags(TaskwarriorColorTheme tColors){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Obx(
          () => Wrap(
            spacing: 8.0,
            runSpacing: 4.0,
            children: buildTagChips(),
          ),
        ),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: homeController.tagcontroller,
                style: 
                TextStyle(
                  color: tColors.primaryTextColor
                )
                ,
                decoration: InputDecoration(
                  hintText: SentenceManager(
                          currentLanguage:
                              homeController.selectedLanguage.value)
                      .sentences
                      .addTaskAddTags,
                  hintStyle: TextStyle(
                    color: tColors.primaryTextColor
                  ),
                ),
                onFieldSubmitted: (tag) {
                  addTag(tag.trim());
                },
                onChanged: (value) {
                  String trimmedString = value.trim();
                  if (value.endsWith(" ") &&
                      trimmedString.split(' ').length == 1) {
                    addTag(trimmedString);
                  }
                },
              ),
            ),
            IconButton(
              onPressed: () {
                addTag(homeController.tagcontroller.text.trim());
              },
              icon: const Icon(Icons.add),
            ),
          ],
        ),
      ],
    );
  }

  List<Widget> buildTagChips() {
    return homeController.tags.map<Widget>((tag) {
      return InputChip(
        label: Text(tag),
        onDeleted: () {
          removeTag(tag);
        },
      );
    }).toList();
  }

  Widget buildName(TaskwarriorColorTheme tColors) => TextFormField(
        autofocus: true,
        controller: homeController.namecontroller,
        style: TextStyle(
          color: tColors.primaryTextColor,
        ),
        decoration: InputDecoration(
          hintText: SentenceManager(
                  currentLanguage: homeController.selectedLanguage.value)
              .sentences
              .addTaskEnterTask,
          hintStyle: TextStyle(
            color: tColors.primaryTextColor,
          ),
        ),
        validator: (name) => name != null && name.isEmpty
            ? SentenceManager(
                    currentLanguage: homeController.selectedLanguage.value)
                .sentences
                .addTaskFieldCannotBeEmpty
            : null,
      );

  Widget buildDueDate(BuildContext context, TaskwarriorColorTheme tColors) => Row(
        children: [
          Text(
            SentenceManager(
                    currentLanguage: homeController.selectedLanguage.value)
                .sentences
                .addTaskDue,
            style: GoogleFonts.poppins(
              color: tColors.primaryTextColor,
              fontWeight: TaskWarriorFonts.bold,
              height: 3.3,
            ),
          ),
          Expanded(
            child: GestureDetector(
                child: Obx(
              () => TextFormField(
                style: homeController.inThePast.value
                    ? TextStyle(color: TaskWarriorColors.red)
                    : TextStyle(
                        color: tColors.primaryTextColor
                      ),
                readOnly: true,
                controller:
                    TextEditingController(text: homeController.dueString.value),
                decoration: InputDecoration(
                  hintText: SentenceManager(
                          currentLanguage:
                              homeController.selectedLanguage.value)
                      .sentences
                      .addTaskTitle,
                  hintStyle: homeController.inThePast.value
                      ? TextStyle(color: TaskWarriorColors.red)
                      : Theme.of(context).textTheme.bodyLarge,
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12.0, vertical: 16.0),
                ),
                onTap: () async {
                  var date = await showDatePicker(
                    builder: (BuildContext context, Widget? child) {
                      return Theme(
                        data: Theme.of(context),
                        child: child!,
                      );
                    },
                    fieldHintText: "Month/Date/Year",
                    context: context,
                    initialDate: homeController.due.value ?? DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2037, 12, 31),
                  );
                  if (date != null) {
                    var time = await showTimePicker(
                      builder: (BuildContext context, Widget? child) {
                        return Theme(
                          data: Theme.of(context).copyWith(
                            textTheme: const TextTheme(),
                            colorScheme: Theme.of(context).colorScheme
                          ),
                          child: Obx(() => MediaQuery(
                              data: MediaQuery.of(context).copyWith(
                                alwaysUse24HourFormat:
                                    homeController.change24hr.value,
                              ),
                              child: child!)),
                        );
                      },
                      context: context,
                      initialTime: TimeOfDay.fromDateTime(
                          homeController.due.value ?? DateTime.now()),
                    );
                    // print("date$date Time : $time");
                    if (time != null) {
                      var dateTime = date.add(
                        Duration(
                          hours: time.hour,
                          minutes: time.minute,
                        ),
                      );
                      // print(dateTime);
                      homeController.due.value = dateTime.toUtc();

                      // print("due value ${homeController.due}");
                      homeController.dueString.value =
                          DateFormat("dd-MM-yyyy HH:mm").format(dateTime);
                      // print(homeController.dueString.value);
                      if (dateTime.isBefore(DateTime.now())) {
                        //Try changing the color. in the settings and Due display.

                        homeController.inThePast.value = true;

                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(
                              SentenceManager(
                                      currentLanguage:
                                          homeController.selectedLanguage.value)
                                  .sentences
                                  .addTaskTimeInPast,
                              style: TextStyle(
                                color: tColors.primaryTextColor
                              ),
                            ),
                            backgroundColor: tColors.secondaryBackgroundColor,
                            duration: const Duration(seconds: 2)));
                      } else {
                        homeController.inThePast.value = false;
                      }

                      // setState(() {});
                    }
                  }
                },
              ),
            )),
          ),
        ],
      );

  Widget buildPriority(TaskwarriorColorTheme tColors) => Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "${SentenceManager(
                        currentLanguage: homeController.selectedLanguage.value)
                    .sentences
                    .addTaskPriority} :",
                style: GoogleFonts.poppins(
                  fontWeight: TaskWarriorFonts.bold,
                  color: tColors.primaryTextColor,
                ),
                textAlign: TextAlign.left,
              ),
              const SizedBox(width: 2,),
              Obx(
                () => Row(
                  children: [
                    for(int i=0;i<homeController.priorityList.length;i++)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 2.5),
                        child: GestureDetector(
                          onTap: () {
                            homeController.priority.value = homeController.priorityList[i];
                            debugPrint(homeController.priority.value);
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 100),
                            height: 30,
                            width: 37,
                            decoration: BoxDecoration(

                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: homeController.priority.value == homeController.priorityList[i]
                                    ? tColors.primaryTextColor!
                                    : tColors.primaryBackgroundColor!,
                              )
                            ),
                            child: Center(
                              child: Text(
                                homeController.priorityList[i],
                                textAlign: TextAlign.center,
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 17,
                                  color: homeController.priorityColors[i]
                                ),
                              ),
                            ),
                          ),

                        ),
                      )

                  ],
                ),
              )
            ],
          ),
        ],
      );

  Widget buildCancelButton(
          BuildContext context, HomeController homeController, TaskwarriorColorTheme tColors) =>
      TextButton(
        child: Text(
          SentenceManager(
                  currentLanguage: homeController.selectedLanguage.value)
              .sentences
              .addTaskCancel,
          style: TextStyle(
            color: tColors.primaryTextColor,
          ),
        ),
        onPressed: () {
          Navigator.of(context).pop("cancel");
          homeController.namecontroller.text = '';
          homeController.dueString.value = "";
          homeController.priority.value = 'M';
          homeController.tagcontroller.text = '';
          homeController.tags.value = [];
          homeController.update();
        },
      );

  Widget buildAddButton(BuildContext context) {
    TaskwarriorColorTheme tColors = Theme.of(context).extension<TaskwarriorColorTheme>()!;
    return TextButton(
      child: Text(
        SentenceManager(
                        currentLanguage: homeController.selectedLanguage.value)
            .sentences
            .addTaskAdd,
        style: TextStyle(
          color: tColors.primaryTextColor,
        ),
      ),
      onPressed: () async {
        // print(homeController.formKey.currentState);
        if (homeController.formKey.currentState!.validate()) {
          try {
            var task = taskParser(homeController.namecontroller.text)
                .rebuild((b) => b..due = homeController.due.value)
                .rebuild((p) => p..priority = homeController.priority.value);
            if (homeController.tagcontroller.text != "") {
              homeController.tags.add(homeController.tagcontroller.text.trim());
            }
            if (homeController.tags.isNotEmpty) {
              task = task.rebuild((t) => t..tags.replace(homeController.tags));
            }
            Get.find<HomeController>().mergeTask(task);
            // print(task);

            // StorageWidget.of(context).mergeTask(task);
            homeController.namecontroller.text = '';
            homeController.dueString.value = "";
            homeController.priority.value = 'M';
            homeController.tagcontroller.text = '';
            homeController.tags.value = [];
            homeController.update();
            // Navigator.of(context).pop();
            Get.back();
            if (Platform.isAndroid) {
              WidgetController widgetController =
                  Get.put(WidgetController());
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
                    color: tColors.primaryTextColor,
                  ),
                ),
                backgroundColor: tColors.secondaryBackgroundColor,
                duration: const Duration(seconds: 2)));

            final SharedPreferences prefs =
                await SharedPreferences.getInstance();
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
                    color: tColors.primaryTextColor,
                  ),
                ),
                backgroundColor: tColors.secondaryBackgroundColor,
                duration: const Duration(seconds: 2)));
            log(e.toString());
          }
        }
      },
    );
  }

  void addTag(String tag) {
    if (tag.isNotEmpty) {
      String trimmedString = tag.trim();
      List<String> tags = trimmedString.split(" ");
      for(tag in tags){
        if(checkTagIfExists(tag)) {
          removeTag(tag);
        }
        homeController.tags.add(tag);
      }
      homeController.tagcontroller.text = '';
    }
  }
  bool checkTagIfExists(String tag){
    return homeController.tags.contains(tag);
  }
  void removeTag(String tag) {
    homeController.tags.remove(tag);
  }
}
