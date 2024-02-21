// ignore_for_file: prefer_const_constructors, file_names

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taskwarrior/config/taskwarriorfonts.dart';

Widget createDrawerHeader() {
  return ListTile(
    contentPadding: EdgeInsets.all(8.0),
    leading: CircleAvatar(
      backgroundColor: Colors.transparent,
    ),
    title: Text(
      'Taskwarrior',
      style: GoogleFonts.poppins(
        fontSize: 30.0,
        fontWeight: TaskWarriorFonts.medium,
      ),
    ),
  );
}
