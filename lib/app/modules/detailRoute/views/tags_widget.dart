import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taskwarrior/app/modules/detailRoute/controllers/detail_route_controller.dart';
import 'package:taskwarrior/app/modules/detailRoute/views/attribute_card.dart';
import 'package:taskwarrior/app/modules/detailRoute/views/tags_route.dart';

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
    return AttributeCard(
      name: name,
      value: value,
      isEditable: isEditable,
      onTap: () => Get.to(() => TagsRoute(controller: controller)),
    );
  }
}
