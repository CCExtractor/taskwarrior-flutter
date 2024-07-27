// ignore_for_file: use_build_context_synchronously, file_names
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:taskwarrior/api_service.dart';
import 'package:taskwarrior/app/modules/home/controllers/home_controller.dart';
import 'package:taskwarrior/app/utils/constants/taskwarrior_colors.dart';
import 'package:taskwarrior/app/utils/constants/taskwarrior_fonts.dart';

import 'package:taskwarrior/app/utils/app_settings/app_settings.dart';

class AddTaskToTaskcBottomSheet extends StatelessWidget {
  final HomeController homeController;
  const AddTaskToTaskcBottomSheet({super.key, required this.homeController});

  @override
  Widget build(BuildContext context) {
    const title = 'Add Task';
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
                title,
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
                    const SizedBox(height: 8),
                    buildProject(),
                    const SizedBox(height: 12),
                    buildDueDate(context),
                    const SizedBox(height: 8),
                    buildPriority(),
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

  Widget buildProject() => TextFormField(
        autofocus: true,
        controller: homeController.projectcontroller,
        style: TextStyle(
          color: AppSettings.isDarkMode
              ? TaskWarriorColors.white
              : TaskWarriorColors.black,
        ),
        decoration: InputDecoration(
          hintText: 'Enter Project',
          hintStyle: TextStyle(
            color: AppSettings.isDarkMode
                ? TaskWarriorColors.white
                : TaskWarriorColors.black,
          ),
        ),
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
              child: TextFormField(
                style: homeController.inThePast.value
                    ? TextStyle(color: TaskWarriorColors.red)
                    : TextStyle(
                        color: AppSettings.isDarkMode
                            ? TaskWarriorColors.white
                            : TaskWarriorColors.black,
                      ),
                readOnly: true,
                controller: TextEditingController(
                  text: (homeController.due.value != null)
                      ? homeController.dueString.value
                      : null,
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
                          child: MediaQuery(
                              data: MediaQuery.of(context).copyWith(
                                alwaysUse24HourFormat:
                                    homeController.change24hr.value,
                              ),
                              child: child!),
                        );
                      },
                      context: context,
                      initialTime: TimeOfDay.fromDateTime(
                          homeController.due.value ?? DateTime.now()),
                    );
                    if (time != null) {
                      var dateTime = date.add(
                        Duration(
                          hours: time.hour,
                          minutes: time.minute,
                        ),
                      );
                      homeController.due.value = dateTime.toUtc();
                      homeController.dueString.value =
                          DateFormat("yyyy-MM-dd").format(dateTime);
                      if (dateTime.isBefore(DateTime.now())) {
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
                    }
                  }
                },
              ),
            ),
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
              due: homeController.dueString.value,
              //   dueString.toIso8601String(),
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
      },
    );
  }
}
