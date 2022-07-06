// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateTimePicker extends StatefulWidget {
  final DateTime dateTime;
  const DateTimePicker({Key? key, required this.dateTime}) : super(key: key);
  @override
  // ignore: library_private_types_in_public_api
  _DateTimePickerState createState() => _DateTimePickerState();
}

class _DateTimePickerState extends State<DateTimePicker> {
  late DateTime dateTime = widget.dateTime;
  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      RaisedButton(
        onPressed: () {
          showDatePicker(
            context: context,
            initialDate: dateTime,
            firstDate: DateTime(2000),
            lastDate: DateTime(2050),
          ).then((value) {
            showTimePicker(
              context: context,
              initialTime: TimeOfDay.fromDateTime(dateTime),
            ).then((value) {
              if (value != null) {
                setState(() {
                  dateTime = DateTime(dateTime.year, dateTime.month,
                      dateTime.day, value.hour, value.minute);
                });
              }
            });
          });
        },
        child: Text(
          DateFormat('yyyy-MM-dd – kk:mm').format(dateTime),
          style: const TextStyle(fontSize: 18),
        ),
      ),
    ]);
  }
}
