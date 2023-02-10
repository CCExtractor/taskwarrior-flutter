// ignore_for_file: use_key_in_widget_constructors, must_be_immutable

import 'package:flutter/material.dart';

class DrawerTile extends StatelessWidget {
  Widget? title;
  void Function()? onTap;

  DrawerTile({required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: title,
      onTap: onTap,
    );
  }
}
