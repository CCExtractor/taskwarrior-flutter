// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously, file_names

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:taskwarrior/config/app_settings.dart';
import 'package:taskwarrior/controller/WidgetController.dart';
import 'package:taskwarrior/model/storage/storage_widget.dart';
import 'package:taskwarrior/services/notification_services.dart';
import 'package:taskwarrior/widgets/taskfunctions/taskparser.dart';
import 'package:taskwarrior/widgets/taskw.dart';

class AddTaskBottomSheet extends StatefulWidget {
  const AddTaskBottomSheet({Key? key}) : super(key: key);
  @override
  _AddTaskBottomSheetState createState() => _AddTaskBottomSheetState();
}

class _AddTaskBottomSheetState extends State<AddTaskBottomSheet> {
  final formKey = GlobalKey<FormState>();
  final namecontroller = TextEditingController();
  DateTime? due;
  String dueString = '';
  String priority = 'M';

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    namecontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const title = 'Add Task';

    return Center(
      child: SingleChildScrollView(
        child: AlertDialog(
          surfaceTintColor: AppSettings.isDarkMode
              ? const Color.fromARGB(255, 25, 25, 25)
              : Colors.white,
          backgroundColor: AppSettings.isDarkMode
              ? const Color.fromARGB(255, 25, 25, 25)
              : Colors.white,
          title: Center(
            child: Text(
              title,
              style: TextStyle(
                color: AppSettings.isDarkMode ? Colors.white : Colors.black,
              ),
            ),
          ),
          content: Form(
            key: formKey,
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
    );
  }

  Widget buildName() => TextFormField(
        controller: namecontroller,
        style: TextStyle(
          color: AppSettings.isDarkMode ? Colors.white : Colors.black,
        ),
        decoration: InputDecoration(
          hintText: 'Enter Task',
          hintStyle: TextStyle(
            color: AppSettings.isDarkMode ? Colors.white : Colors.black,
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
              color: AppSettings.isDarkMode ? Colors.white : Colors.black,
              fontWeight: FontWeight.bold,
              height: 3.3,
            ),
          ),
          Expanded(
            child: GestureDetector(
              child: TextFormField(
                style: TextStyle(
                  color: AppSettings.isDarkMode ? Colors.white : Colors.black,
                ),
                readOnly: true,
                controller: TextEditingController(
                  text: (due != null) ? dueString : "  Select due date",
                ),
                decoration: InputDecoration(
                  hintText: 'Select due date',
                  hintStyle: TextStyle(
                    color: AppSettings.isDarkMode ? Colors.white : Colors.black,
                  ),
                  errorText: (due == null) ? 'Due date is required' : null,
                ),
                validator: (name) => name != null && name.isEmpty
                    ? 'due date is required'
                    : null,
                onTap: () async {
                  var date = await showDatePicker(
                    builder: (context, child) {
                      return Theme(
                        data: Theme.of(context).copyWith(
                          colorScheme: ColorScheme(
                            brightness: AppSettings.isDarkMode
                                ? Brightness.dark
                                : Brightness.light,
                            primary: AppSettings.isDarkMode
                                ? Colors.white
                                : const Color(0xFF191919),
                            onPrimary: AppSettings.isDarkMode
                                ? const Color(0xFF191919)
                                : Colors.white,
                            secondary: AppSettings.isDarkMode
                                ? Colors.white
                                : const Color(0xFF191919),
                            onSecondary: AppSettings.isDarkMode
                                ? Colors.white
                                : const Color(0xFF191919),
                            error: Colors.red,
                            onError: Colors.red,
                            background: AppSettings.isDarkMode
                                ? const Color(0xFF191919)
                                : Colors.white,
                            onBackground: AppSettings.isDarkMode
                                ? const Color(0xFF191919)
                                : Colors.white,
                            surface: AppSettings.isDarkMode
                                ? const Color(0xFF191919)
                                : Colors.white,
                            onSurface: AppSettings.isDarkMode
                                ? Colors.white
                                : const Color(0xFF191919),
                          ),
                        ),
                        child: child!,
                      );
                    },
                    context: context,
                    initialDate: due ?? DateTime.now(),
                    firstDate: DateTime(1990),
                    lastDate: DateTime(2037, 12, 31),
                  );
                  if (date != null) {
                    var time = await showTimePicker(
                      context: context,
                      initialTime:
                          TimeOfDay.fromDateTime(due ?? DateTime.now()),
                    );
                    if (time != null) {
                      var dateTime = date.add(
                        Duration(
                          hours: time.hour,
                          minutes: time.minute,
                        ),
                      );
                      dateTime = dateTime.add(
                        Duration(
                          hours: time.hour - dateTime.hour,
                        ),
                      );
                      due = dateTime.toUtc();
                      NotificationService notificationService =
                          NotificationService();
                      notificationService.initiliazeNotification();

                      if ((dateTime.millisecondsSinceEpoch -
                              DateTime.now().millisecondsSinceEpoch) >
                          0) {
                        notificationService.sendNotification(
                            dateTime, namecontroller.text);
                      }

                      dueString =
                          DateFormat("dd-MM-yyyy HH:mm").format(dateTime);
                    }
                    setState(() {});
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
                  fontWeight: FontWeight.bold,
                  color: AppSettings.isDarkMode ? Colors.white : Colors.black,
                ),
                textAlign: TextAlign.left,
              ),
              DropdownButton<String>(
                dropdownColor: AppSettings.isDarkMode
                    ? const Color.fromARGB(255, 25, 25, 25)
                    : Colors.white,
                value: priority,
                elevation: 16,
                style: GoogleFonts.poppins(
                  color: AppSettings.isDarkMode ? Colors.white : Colors.black,
                ),
                underline: Container(
                  height: 1.5,
                  color: AppSettings.isDarkMode
                      ? const Color.fromARGB(255, 25, 25, 25)
                      : Colors.white,
                ),
                onChanged: (String? newValue) {
                  setState(() {
                    priority = newValue!;
                  });
                },
                items: <String>['H', 'M', 'L']
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
            color: AppSettings.isDarkMode ? Colors.white : Colors.black,
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
          color: AppSettings.isDarkMode ? Colors.white : Colors.black,
        ),
      ),
      onPressed: () async {
        if (formKey.currentState!.validate()) {
          if (due == null) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: const Text(
                  'Due date cannot be empty. Please select a due date.'),
              backgroundColor:
                  AppSettings.isDarkMode ? Colors.black : Colors.white,
              duration: const Duration(seconds: 2),
            ));
            return;
          }
          try {
            var task = taskParser(namecontroller.text)
                .rebuild((b) => b..due = due)
                .rebuild((p) => p..priority = priority);

            StorageWidget.of(context).mergeTask(task);
            namecontroller.text = '';
            due = null;
            priority = 'M';
            setState(() {});
            Navigator.of(context).pop();
            widgetController.fetchAllData();

            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: const Text('Task Added Successfully, Tap to Edit'),
              backgroundColor:
                  AppSettings.isDarkMode ? Colors.black : Colors.white,
              duration: const Duration(seconds: 2),
            ));

            final SharedPreferences prefs =
                await SharedPreferences.getInstance();
            bool? value;
            value = prefs.getBool('sync-OnTaskCreate') ?? false;
            late InheritedStorage storageWidget;
            storageWidget = StorageWidget.of(context);
            if (value) {
              storageWidget.synchronize(context, true);
            }
          } on FormatException catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(e.message),
              backgroundColor: AppSettings.isDarkMode
                  ? const Color.fromARGB(255, 61, 61, 61)
                  : const Color.fromARGB(255, 39, 39, 39),
              duration: const Duration(seconds: 2),
            ));
            log(e.toString());
          }
        }
      },
    );
  }
}
