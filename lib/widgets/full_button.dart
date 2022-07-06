// ignore_for_file: deprecated_member_use, prefer_const_constructors_in_immutables, use_key_in_widget_constructors, must_be_immutable

import 'package:flutter/material.dart';

class FormSubmitButton extends StatelessWidget {
  final Function() onPressed;
  String type;
  FormSubmitButton({required this.onPressed, required this.type});

  @override
  Widget build(BuildContext context) => ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: const StadiumBorder(),
          onPrimary: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
        ),
        onPressed: onPressed,
        child: Text(type),
      );
}
