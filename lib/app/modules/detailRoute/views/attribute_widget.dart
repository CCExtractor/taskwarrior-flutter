import 'package:flutter/material.dart';
import 'package:taskwarrior/app/models/task_attribute.dart';
import 'package:taskwarrior/app/modules/detailRoute/controllers/detail_route_controller.dart';
import 'package:taskwarrior/app/modules/detailRoute/views/attribute_card.dart';
import 'package:taskwarrior/app/modules/detailRoute/views/date_time_widget.dart';
import 'package:taskwarrior/app/modules/detailRoute/views/description_widget.dart';
import 'package:taskwarrior/app/modules/detailRoute/views/priority_widget.dart';
import 'package:taskwarrior/app/modules/detailRoute/views/project_widget.dart';
import 'package:taskwarrior/app/modules/detailRoute/views/start_widget.dart';
import 'package:taskwarrior/app/modules/detailRoute/views/status_widget.dart';
import 'package:taskwarrior/app/modules/detailRoute/views/tags_widget.dart';
import 'package:taskwarrior/app/utils/taskfunctions/format_attribute_value.dart';

/// Picks the editor widget for a single task attribute.
class AttributeWidget extends StatelessWidget {
  const AttributeWidget({
    required this.controller,
    required this.attribute,
    required this.value,
    required this.isEditable,
    required this.use24HourFormat,
    super.key,
  });

  final DetailRouteController controller;
  final TaskAttribute attribute;
  final dynamic value;
  final bool isEditable;
  final bool use24HourFormat;

  void _onChanged(dynamic newValue) =>
      controller.setAttribute(attribute, newValue);

  @override
  Widget build(BuildContext context) {
    final String name = attribute.name;
    final String? displayValue =
        formatAttributeValue(value, use24HourFormat: use24HourFormat);

    switch (attribute) {
      case TaskAttribute.description:
        return DescriptionWidget(
          controller: controller,
          name: name,
          value: displayValue,
          callback: _onChanged,
          isEditable: isEditable,
        );
      case TaskAttribute.status:
        return StatusWidget(
          name: name,
          value: displayValue,
          callback: _onChanged,
        );
      case TaskAttribute.start:
        return StartWidget(
          name: name,
          value: displayValue,
          callback: _onChanged,
          isEditable: isEditable,
        );
      case TaskAttribute.due:
      case TaskAttribute.wait:
      case TaskAttribute.until:
        return DateTimeWidget(
          name: name,
          value: value as DateTime?,
          displayValue: displayValue,
          callback: _onChanged,
          globalKey: controller.tourKeyFor(attribute)!,
          isEditable: isEditable,
        );
      case TaskAttribute.priority:
        return PriorityWidget(
          name: name,
          value: displayValue,
          callback: _onChanged,
          globalKey: controller.tourKeyFor(attribute)!,
          isEditable: isEditable,
        );
      case TaskAttribute.project:
        return ProjectWidget(
          controller: controller,
          name: name,
          value: displayValue,
          callback: _onChanged,
          isEditable: isEditable,
        );
      case TaskAttribute.tags:
        return TagsWidget(
          controller: controller,
          name: name,
          value: displayValue,
          isEditable: isEditable,
        );
      case TaskAttribute.entry:
      case TaskAttribute.modified:
      case TaskAttribute.end:
      case TaskAttribute.urgency:
        return AttributeCard(
          name: name,
          value: displayValue,
          isEditable: isEditable && !attribute.isDisplayOnly,
        );
    }
  }
}
