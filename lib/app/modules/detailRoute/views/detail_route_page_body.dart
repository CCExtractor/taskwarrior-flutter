import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taskwarrior/app/modules/detailRoute/controllers/detail_route_controller.dart';
import 'package:taskwarrior/app/modules/detailRoute/views/attribute_widget.dart';
import 'package:taskwarrior/app/utils/app_settings/app_settings.dart';

class DetailRoutePageBody extends StatelessWidget {
  final DetailRouteController controller;
  const DetailRoutePageBody({required this.controller, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
      // Every reactive value the cards depend on is read here, so the list
      // rebuilds on edits, read-only changes and time-format changes alike.
      child: Obx(() {
        final attributes = controller.attributes;
        final bool use24HourFormat = AppSettings.use24HourFormatRx.value;
        return ListView(
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 2),
          children: [
            for (var entry in attributes.entries)
              AttributeWidget(
                controller: controller,
                attribute: entry.key,
                value: entry.value,
                // Reads isReadOnly, so this Obx subscribes to it.
                isEditable: controller.isAttributeEditable(entry.key),
                use24HourFormat: use24HourFormat,
              ),
          ],
        );
      }),
    );
  }
}
