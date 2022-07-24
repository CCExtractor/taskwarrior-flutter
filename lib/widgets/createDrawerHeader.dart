// ignore_for_file: prefer_const_constructors, file_names

import 'package:flutter/material.dart';

Widget createDrawerHeader() {
  return ListTile(
    contentPadding: EdgeInsets.all(8.0),
    leading: CircleAvatar(
      backgroundColor: Colors.transparent,
    ),
    title: Text(
      'Taskwarrior',
      style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.w500),
    ),
  );
}
