// ignore_for_file: use_build_context_synchronously
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taskwarrior/app/modules/home/controllers/home_controller.dart';
import 'package:taskwarrior/app/modules/home/controllers/widget.controller.dart';
import 'package:taskwarrior/app/utils/constants/taskwarrior_colors.dart';
import 'package:taskwarrior/app/utils/constants/taskwarrior_fonts.dart';
import 'package:taskwarrior/app/utils/taskfunctions/taskparser.dart';
import 'package:taskwarrior/app/utils/theme/app_settings.dart';

class AddTaskBottomSheet extends StatelessWidget {
  final HomeController homeController;
  const AddTaskBottomSheet({required this.homeController, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: SingleChildScrollView(
          child: AlertDialog(
            surfaceTintColor: AppSettings.isDarkMode
                ? TaskWarriorColors.kdialogBackGroundColor
                : TaskWarriorColors.kLightDialogBackGroundColor,
            shadowColor: AppSettings.isDarkMode
                ? TaskWarriorColors.kdialogBackGroundColor
                : TaskWarriorColors.kLightDialogBackGroundColor,
            backgroundColor: AppSettings.isDarkMode
                ? TaskWarriorColors.kdialogBackGroundColor
                : TaskWarriorColors.kLightDialogBackGroundColor,
            title: Center(
              child: Text(
                'Add Task',
                style: TextStyle(
                  color: AppSettings.isDarkMode
                      ? TaskWarriorColors.white
                      : TaskWarriorColors.black,
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
                    buildName(),
                    const SizedBox(height: 12),
                    buildDueDate(context),
                    const SizedBox(height: 8),
                    buildPriority(),
                    buildTags(),
                  ],
                ),
              ),
            ),
            actions: <Widget>[
              buildCancelButton(context),
              buildAddButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTags() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 8.0,
          runSpacing: 4.0,
          children: buildTagChips(),
        ),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: homeController.tagcontroller,
                style: TextStyle(
                  color: AppSettings.isDarkMode
                      ? TaskWarriorColors.white
                      : TaskWarriorColors.black,
                ),
                decoration: InputDecoration(
                  hintText: 'Add tags',
                  hintStyle: TextStyle(
                    color: AppSettings.isDarkMode
                        ? TaskWarriorColors.white
                        : TaskWarriorColors.black,
                  ),
                ),
                onFieldSubmitted: (tag) {
                  addTag(tag.trim());
                },
              ),
            ),
            // Replace ElevatedButton with IconButton
            IconButton(
              onPressed: () {
                addTag(homeController.tagcontroller.text.trim());
              },
              icon: const Icon(Icons.add), // Plus icon
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

  Widget buildName() => TextFormField(
        autofocus: true,
        controller: homeController.namecontroller,
        style: TextStyle(
          color: AppSettings.isDarkMode
              ? TaskWarriorColors.white
              : TaskWarriorColors.black,
        ),
        decoration: InputDecoration(
          hintText: 'Enter Task',
          hintStyle: TextStyle(
            color: AppSettings.isDarkMode
                ? TaskWarriorColors.white
                : TaskWarriorColors.black,
          ),
        ),
        validator: (name) => name != null && name.isEmpty
            ? 'You cannot leave this field empty!'
            : null,
      );

  Widget buildDueDate(BuildContext context) => Row(
        children: [
          Text(
            "Due : ",
            style: GoogleFonts.poppins(
              color: AppSettings.isDarkMode
                  ? TaskWarriorColors.white
                  : TaskWarriorColors.black,
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
                        color: AppSettings.isDarkMode
                            ? TaskWarriorColors.white
                            : TaskWarriorColors.black,
                      ),
                readOnly: true,
                controller: TextEditingController(
                  text: homeController.dueString.value
                ),
                decoration: InputDecoration(
                  hintText: 'Select due date',
                  hintStyle: homeController.inThePast.value
                      ? TextStyle(color: TaskWarriorColors.red)
                      : TextStyle(
                          color: AppSettings.isDarkMode
                              ? TaskWarriorColors.white
                              : TaskWarriorColors.black,
                        ),
                ),
                onTap: () async {
                  var date = await showDatePicker(
                    builder: (BuildContext context, Widget? child) {
                      return Theme(
                        data: Theme.of(context).copyWith(
                          colorScheme: AppSettings.isDarkMode
                              ? ColorScheme(
                                  brightness: Brightness.dark,
                                  primary: TaskWarriorColors.white,
                                  onPrimary: TaskWarriorColors.black,
                                  secondary: TaskWarriorColors.black,
                                  onSecondary: TaskWarriorColors.white,
                                  error: TaskWarriorColors.red,
                                  onError: TaskWarriorColors.black,
                                  surface: TaskWarriorColors.black,
                                  onSurface: TaskWarriorColors.white,
                                )
                              : ColorScheme(
                                  brightness: Brightness.light,
                                  primary: TaskWarriorColors.black,
                                  onPrimary: TaskWarriorColors.white,
                                  secondary: TaskWarriorColors.white,
                                  onSecondary: TaskWarriorColors.black,
                                  error: TaskWarriorColors.red,
                                  onError: TaskWarriorColors.white,
                                  surface: TaskWarriorColors.white,
                                  onSurface: TaskWarriorColors.black,
                                ),
                        ),
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
                            colorScheme: AppSettings.isDarkMode
                                ? ColorScheme(
                                    brightness: Brightness.dark,
                                    primary: TaskWarriorColors.white,
                                    onPrimary: TaskWarriorColors.black,
                                    secondary: TaskWarriorColors.black,
                                    onSecondary: TaskWarriorColors.white,
                                    error: TaskWarriorColors.red,
                                    onError: TaskWarriorColors.black,
                                    surface: TaskWarriorColors.black,
                                    onSurface: TaskWarriorColors.white,
                                  )
                                : ColorScheme(
                                    brightness: Brightness.light,
                                    primary: TaskWarriorColors.black,
                                    onPrimary: TaskWarriorColors.white,
                                    secondary: TaskWarriorColors.white,
                                    onSecondary: TaskWarriorColors.black,
                                    error: TaskWarriorColors.red,
                                    onError: TaskWarriorColors.white,
                                    surface: TaskWarriorColors.white,
                                    onSurface: TaskWarriorColors.black,
                                  ),
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
                    print("date$date Time : $time");
                    if (time != null) {
                      var dateTime = date.add(
                        Duration(
                          hours: time.hour,
                          minutes: time.minute,
                        ),
                      );
                      print(dateTime);
                      homeController.due.value = dateTime.toUtc();

                      print("due value ${homeController.due}");
                      homeController.dueString.value =
                          DateFormat("dd-MM-yyyy HH:mm").format(dateTime);
                      print(homeController.dueString.value);
                      if (dateTime.isBefore(DateTime.now())) {
                        //Try changing the color. in the settings and Due display.

                        homeController.inThePast.value = true;

                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(
                              "The selected time is in the past.",
                              style: TextStyle(
                                color: AppSettings.isDarkMode
                                    ? TaskWarriorColors.kprimaryTextColor
                                    : TaskWarriorColors.kLightPrimaryTextColor,
                              ),
                            ),
                            backgroundColor: AppSettings.isDarkMode
                                ? TaskWarriorColors.ksecondaryBackgroundColor
                                : TaskWarriorColors
                                    .kLightSecondaryBackgroundColor,
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

  Widget buildPriority() => Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Priority :  ',
                style: GoogleFonts.poppins(
                  fontWeight: TaskWarriorFonts.bold,
                  color: AppSettings.isDarkMode
                      ? TaskWarriorColors.white
                      : TaskWarriorColors.black,
                ),
                textAlign: TextAlign.left,
              ),
              DropdownButton<String>(
                dropdownColor: AppSettings.isDarkMode
                    ? TaskWarriorColors.kdialogBackGroundColor
                    : TaskWarriorColors.kLightDialogBackGroundColor,
                value: homeController.priority.value,
                elevation: 16,
                style: GoogleFonts.poppins(
                  color: AppSettings.isDarkMode
                      ? TaskWarriorColors.white
                      : TaskWarriorColors.black,
                ),
                underline: Container(
                  height: 1.5,
                  color: AppSettings.isDarkMode
                      ? TaskWarriorColors.kdialogBackGroundColor
                      : TaskWarriorColors.kLightDialogBackGroundColor,
                ),
                onChanged: (String? newValue) {
                  homeController.priority.value = newValue!;
                },
                items: <String>['H', 'M', 'L', 'None']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text('  $value'),
                  );
                }).toList(),
              )
            ],
          ),
        ],
      );

  Widget buildCancelButton(BuildContext context) => TextButton(
        child: Text(
          'Cancel',
          style: TextStyle(
            color: AppSettings.isDarkMode
                ? TaskWarriorColors.white
                : TaskWarriorColors.black,
          ),
        ),
        onPressed: () => Navigator.of(context).pop("cancel"),
      );

  Widget buildAddButton(BuildContext context) {
    WidgetController widgetController = Get.put(WidgetController(context));

    return TextButton(
      child: Text(
        "Add",
        style: TextStyle(
          color: AppSettings.isDarkMode
              ? TaskWarriorColors.white
              : TaskWarriorColors.black,
        ),
      ),
      onPressed: () async {
        print(homeController.formKey.currentState);
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
            print(task);

            // StorageWidget.of(context).mergeTask(task);
            homeController.namecontroller.text = '';
            homeController.due.value = null;
            homeController.priority.value = 'M';
            homeController.tagcontroller.text = '';
            homeController.tags.value = [];
            homeController.update();
            // Navigator.of(context).pop();
            Get.back();
            widgetController.fetchAllData();

            homeController.update();

            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(
                  'Task Added Successfully. Tap to Edit',
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
                    color: AppSettings.isDarkMode
                        ? TaskWarriorColors.kprimaryTextColor
                        : TaskWarriorColors.kLightPrimaryTextColor,
                  ),
                ),
                backgroundColor: AppSettings.isDarkMode
                    ? TaskWarriorColors.ksecondaryBackgroundColor
                    : TaskWarriorColors.kLightSecondaryBackgroundColor,
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
      homeController.tags.add(trimmedString);
      homeController.tagcontroller.text = '';
    }
  }

  void removeTag(String tag) {
    homeController.tags.remove(tag);
  }
}
