// ignore_for_file: use_build_context_synchronously, file_names
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:taskwarrior/api_service.dart';
import 'package:taskwarrior/app/modules/home/controllers/home_controller.dart';
import 'package:taskwarrior/app/utils/constants/taskwarrior_colors.dart';
import 'package:taskwarrior/app/utils/constants/taskwarrior_fonts.dart';
import 'package:taskwarrior/app/utils/themes/theme_extension.dart';

class AddTaskToTaskcBottomSheet extends StatelessWidget {
  final HomeController homeController;
  const AddTaskToTaskcBottomSheet({super.key, required this.homeController});

  @override
  Widget build(BuildContext context) {
    const title = 'Add Task';
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
                title,
                style: TextStyle(
                  color: tColors.primaryTextColor,
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
                    buildName(context, tColors),
                    const SizedBox(height: 8),
                    buildProject(context, tColors),
                    const SizedBox(height: 12),
                    buildDueDate(context, tColors),
                    const SizedBox(height: 8),
                    buildPriority(context, tColors),
                  ],
                ),
              ),
            ),
            actions: <Widget>[
              buildCancelButton(context, tColors),
              buildAddButton(context, tColors),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildName(BuildContext context,TaskwarriorColorTheme tColors) => TextFormField(
        autofocus: true,
        controller: homeController.namecontroller,
        style: TextStyle(
          color: tColors.primaryTextColor,
        ),
        decoration: InputDecoration(
          hintText: 'Enter Task',
          hintStyle: TextStyle(
            color: tColors.primaryTextColor,
          ),
        ),
        validator: (name) => name != null && name.isEmpty
            ? 'You cannot leave this field empty!'
            : null,
      );

  Widget buildProject(BuildContext context, TaskwarriorColorTheme tColors) => TextFormField(
        autofocus: true,
        controller: homeController.projectcontroller,
        style: TextStyle(
          color: tColors.primaryTextColor,
        ),
        decoration: InputDecoration(
          hintText: 'Enter Project',
          hintStyle: TextStyle(
            color: tColors.primaryTextColor,
          ),
        ),
      );

  Widget buildDueDate(BuildContext context, TaskwarriorColorTheme tColors) => Row(
        children: [
          Text(
            "Due : ",
            style: GoogleFonts.poppins(
              color: tColors.primaryTextColor,
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
                        color: tColors.primaryTextColor,
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
                          color: tColors.primaryTextColor,
                        ),
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
                                color: tColors.primaryTextColor,
                              ),
                            ),
                            backgroundColor: tColors.secondaryBackgroundColor,
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

  Widget buildPriority(BuildContext context, TaskwarriorColorTheme tColors) => Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Priority :  ',
                style: GoogleFonts.poppins(
                  fontWeight: TaskWarriorFonts.bold,
                  color: tColors.primaryTextColor,
                ),
                textAlign: TextAlign.left,
              ),
              DropdownButton<String>(
                dropdownColor: tColors.dialogBackgroundColor,
                value: homeController.priority.value,
                elevation: 16,
                style: GoogleFonts.poppins(
                  color: tColors.primaryTextColor,
                ),
                underline: Container(
                  height: 1.5,
                  color: tColors.dialogBackgroundColor,
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

  Widget buildCancelButton(BuildContext context, TaskwarriorColorTheme tColors) => TextButton(
        child: Text(
          'Cancel',
          style: TextStyle(
            color: tColors.primaryTextColor,
          ),
        ),
        onPressed: () => Navigator.of(context).pop("cancel"),
      );

  Widget buildAddButton(BuildContext context, TaskwarriorColorTheme tColors) {
    return TextButton(
      child: Text(
        "Add",
        style: TextStyle(
          color: tColors.primaryTextColor,
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
                  color: tColors.primaryTextColor,
                ),
              ),
              backgroundColor: tColors.primaryBackgroundColor,
              duration: const Duration(seconds: 2)));
          Navigator.of(context).pop();
        }
      },
    );
  }
}
