// ignore_for_file: file_names

import 'package:flutter/material.dart';

import 'package:intl/intl.dart';

import 'package:taskwarrior/config/app_settings.dart';

class DateTimeWidget extends StatelessWidget {
  const DateTimeWidget({
    Key? key,
    required this.name,
    required this.value,
    required this.callback,
  }) : super(key: key);

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
          child: Row(
            children: [
              Text(
                '${'$name:'.padRight(13)}$value',
              ),
            ],
          ),
        ),
        onTap: () async {
          var initialDate = DateFormat("dd-MM-yyyy HH:mm").parse(
              value ?? DateFormat("dd-MM-yyyy HH:mm").format(DateTime.now()));
          // var initialDate = DateTime.tryParse('$value') ?? DateTime.now();
          var date = await showDatePicker(
            context: context,
            initialDate: initialDate,
            firstDate: DateTime(1990), // >= 1980-01-01T00:00:00.000Z
            lastDate: DateTime(2037, 12, 31), // < 2038-01-19T03:14:08.000Z
          );
          if (date != null) {
            var time = await showTimePicker(
              context: context,
              initialTime: TimeOfDay.fromDateTime(initialDate),
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
              return callback(dateTime.toUtc());
            }
          }
        },
        onLongPress: () => callback(null),
      ),
    );
  }
}

class StartWidget extends StatelessWidget {
  const StartWidget({
    required this.name,
    required this.value,
    required this.callback,
    Key? key,
  }) : super(key: key);

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
          child: Row(
            children: [
              Text(
                '${'$name:'.padRight(13)}$value',
              ),
            ],
          ),
        ),
        onTap: () {
          if (value != null) {
            callback(null);
          } else {
            var now = DateTime.now().toUtc();
            callback(DateTime.utc(
              now.year,
              now.month,
              now.day,
              now.hour,
              now.minute,
              now.second,
            ));
          }
        },
      ),
    );
  }
}
