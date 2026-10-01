import 'package:flutter/material.dart';
import 'package:taskwarrior/app/modules/detailRoute/views/attribute_card.dart';

/// Cycles pending -> completed -> deleted -> pending on tap. Always editable.
class StatusWidget extends StatelessWidget {
  const StatusWidget({
    required this.name,
    required this.value,
    required this.callback,
    super.key,
  });

  final String name;
  final String? value;
  final void Function(dynamic) callback;

  @override
  Widget build(BuildContext context) {
    return AttributeCard(
      name: name,
      value: value,
      onTap: () {
        switch (value) {
          case 'pending':
            return callback('completed');
          case 'completed':
            return callback('deleted');
          case 'deleted':
            return callback('pending');
        }
      },
    );
  }
}
