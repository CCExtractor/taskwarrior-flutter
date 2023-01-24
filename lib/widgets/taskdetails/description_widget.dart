import 'package:flutter/material.dart';
import 'package:loggy/loggy.dart';
import 'package:taskwarrior/config/app_settings.dart';
import '../task_details_tableUI.dart';

class DescriptionWidget extends StatelessWidget {
  const DescriptionWidget(
      {required this.name,
      required this.value,
      required this.callback,
      Key? key})
      : super(key: key);

  final String name;
  final dynamic value;
  final void Function(dynamic) callback;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppSettings.isDarkMode
          ? const Color.fromARGB(255, 57, 57, 57)
          : Colors.white,
      child: ListTile(
        textColor: AppSettings.isDarkMode
            ? Colors.white
            : const Color.fromARGB(255, 48, 46, 46),
        title: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: TaskDetailsTableUI(
            name: '$name',
            value: '$value',
          ),
        ),
        onTap: () {
          var controller = TextEditingController(
            text: value,
          );
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              scrollable: true,
              title: const Text('Edit description'),
              content: TextField(
                autofocus: true,
                maxLines: null,
                controller: controller,
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    try {
                      callback(controller.text);
                      Navigator.of(context).pop();
                    } on FormatException catch (e, trace) {
                      logError(e, trace);
                    }
                  },
                  child: const Text('Submit'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class ProjectWidget extends StatelessWidget {
  const ProjectWidget(
      {required this.name,
      required this.value,
      required this.callback,
      Key? key})
      : super(key: key);

  final String name;
  final dynamic value;
  final void Function(dynamic) callback;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppSettings.isDarkMode
          ? const Color.fromARGB(255, 57, 57, 57)
          : Colors.white,
      child: ListTile(
        textColor: AppSettings.isDarkMode
            ? Colors.white
            : const Color.fromARGB(255, 48, 46, 46),
        title: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child:TaskDetailsTableUI(
            name: '$name',
            value: '$value',
          ),
        ),
        onTap: () {
          var controller = TextEditingController(
            text: value,
          );
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              scrollable: true,
              title: const Text('Edit project'),
              content: TextField(
                autofocus: true,
                maxLines: null,
                controller: controller,
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    try {
                      callback(
                          (controller.text == '') ? null : controller.text);
                      Navigator.of(context).pop();
                    } on FormatException catch (e, trace) {
                      logError(e, trace);
                    }
                  },
                  child: const Text('Submit'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
