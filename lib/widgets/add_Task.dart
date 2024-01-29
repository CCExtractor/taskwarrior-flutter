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
  const AddTaskBottomSheet({super.key});

  @override
  _AddTaskBottomSheetState createState() => _AddTaskBottomSheetState();
}

class _AddTaskBottomSheetState extends State<AddTaskBottomSheet> {
  final formKey = GlobalKey<FormState>();
  final namecontroller = TextEditingController();
  DateTime? due;
  String dueString = '';
  String priority = 'M';
  final tagcontroller = TextEditingController();
  List<String> tags = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    tagcontroller.dispose();
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
                controller: tagcontroller,
                style: TextStyle(
                  color: AppSettings.isDarkMode ? Colors.white : Colors.black,
                ),
                decoration: InputDecoration(
                  hintText: 'Add tags',
                  hintStyle: TextStyle(
                    color: AppSettings.isDarkMode ? Colors.white : Colors.red,
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
                addTag(tagcontroller.text.trim());
              },
              icon: const Icon(Icons.add), // Plus icon
            ),
          ],
        ),
      ],
    );
  }

  List<Widget> buildTagChips() {
    return tags.map<Widget>((tag) {
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
                  text: (due != null) ? dueString : null,
                ),
                decoration: InputDecoration(
                  hintText: 'Select due date',
                  hintStyle: TextStyle(
                    color: AppSettings.isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
                onTap: () async {
                  var date = await showDatePicker(
                    builder: (BuildContext context, Widget? child) {
                      return Theme(
                        data: Theme.of(context).copyWith(
                          colorScheme: AppSettings.isDarkMode
                              ? const ColorScheme(
                                  brightness: Brightness.dark,
                                  primary: Colors.white,
                                  onPrimary: Colors.black,
                                  secondary: Colors.black,
                                  onSecondary: Colors.white,
                                  error: Colors.red,
                                  onError: Colors.black,
                                  background: Colors.black,
                                  onBackground: Colors.white,
                                  surface: Colors.black,
                                  onSurface: Colors.white,
                                )
                              : const ColorScheme(
                                  brightness: Brightness.light,
                                  primary: Colors.black,
                                  onPrimary: Colors.white,
                                  secondary: Colors.white,
                                  onSecondary: Colors.black,
                                  error: Colors.red,
                                  onError: Colors.white,
                                  background: Colors.white,
                                  onBackground: Colors.black,
                                  surface: Colors.white,
                                  onSurface: Colors.black,
                                ),
                        ),
                        child: child!,
                      );
                    },
                    fieldHintText: "Month/Date/Year",
                    context: context,
                    initialDate: due ?? DateTime.now(),
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
                                ? const ColorScheme(
                                    brightness: Brightness.dark,
                                    primary: Colors.white,
                                    onPrimary: Colors.black,
                                    secondary: Color.fromARGB(255, 70, 68, 68),
                                    onSecondary: Colors.white,
                                    error: Colors.red,
                                    onError: Colors.black,
                                    background: Colors.black,
                                    onBackground: Colors.white,
                                    surface: Colors.black,
                                    onSurface: Colors.white,
                                  )
                                : const ColorScheme(
                                    brightness: Brightness.light,
                                    primary: Colors.black,
                                    onPrimary: Colors.white,
                                    secondary: Colors.white,
                                    onSecondary: Colors.black,
                                    error: Colors.red,
                                    onError: Colors.white,
                                    background: Colors.white,
                                    onBackground: Colors.black,
                                    surface: Colors.white,
                                    onSurface: Colors.black,
                                  ),
                          ),
                          child: child!,
                        );
                      },
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
          try {
            var task = taskParser(namecontroller.text)
                .rebuild((b) => b..due = due)
                .rebuild((p) => p..priority = priority);
            if (tagcontroller.text != "") {
              tags.add(tagcontroller.text.trim());
            }
            if (tags.isNotEmpty) {
              task = task.rebuild((t) => t..tags.replace(tags));
            }

            StorageWidget.of(context).mergeTask(task);
            namecontroller.text = '';
            due = null;
            priority = 'M';
            tagcontroller.text = '';
            tags = [];
            setState(() {});
            Navigator.of(context).pop();
            widgetController.fetchAllData();

            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(
                'Task Added Successfully, Tap to Edit',
                style: TextStyle(
                  color: AppSettings.isDarkMode ? Colors.white : Colors.black,
                ),
              ),
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
              content: Text(
                e.message,
                style: TextStyle(
                  color: AppSettings.isDarkMode ? Colors.white : Colors.black,
                ),
              ),
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

  void addTag(String tag) {
    if (tag.isNotEmpty) {
      setState(() {
        String trimmedString = tag.trim();
        tags.add(trimmedString);
        tagcontroller.text = '';
      });
    }
  }

  void removeTag(String tag) {
    setState(() {
      tags.remove(tag);
    });
  }
}
