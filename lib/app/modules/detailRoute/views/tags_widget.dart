import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taskwarrior/app/modules/detailRoute/controllers/detail_route_controller.dart';
import 'package:taskwarrior/app/modules/detailRoute/views/attribute_card.dart';
import 'package:taskwarrior/app/modules/detailRoute/views/tags_route.dart';
import 'package:taskwarrior/app/utils/themes/theme_extension.dart';

/// Shows the task's tags and opens [TagsRoute] to edit them.
class TagsWidget extends StatelessWidget {
  const TagsWidget({
    required this.controller,
    required this.name,
    required this.value,
    this.isEditable = true,
    super.key,
  });

  final DetailRouteController controller;
  final String name;
  final String? value;
  final bool isEditable;

  @override
  Widget build(BuildContext context) {
    TaskwarriorColorTheme tColors =
        Theme.of(context).extension<TaskwarriorColorTheme>()!;
    return AttributeCard(
      name: name,
      value: value,
      isEditable: isEditable,
      cardColor: tColors.primaryBackgroundColor,
      tileColor: tColors.secondaryBackgroundColor,
      onTap: () => Get.to(() => TagsRoute(controller: controller)),
    );
  }
}
