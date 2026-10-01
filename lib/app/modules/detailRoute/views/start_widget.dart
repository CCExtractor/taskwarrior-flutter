import 'package:flutter/material.dart';
import 'package:taskwarrior/app/modules/detailRoute/views/attribute_card.dart';

/// Toggles the start time: clears it when set, otherwise starts the task now.
class StartWidget extends StatelessWidget {
  const StartWidget({
    required this.name,
    required this.value,
    required this.callback,
    this.isEditable = true,
    super.key,
  });

  final String name;
  final String? value;
  final bool isEditable;
  final void Function(dynamic) callback;

  @override
  Widget build(BuildContext context) {
    return AttributeCard(
      name: name,
      value: value,
      isEditable: isEditable,
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
    );
  }
}
