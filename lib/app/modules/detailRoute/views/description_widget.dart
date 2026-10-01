import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taskwarrior/app/modules/detailRoute/controllers/detail_route_controller.dart';
import 'package:taskwarrior/app/modules/detailRoute/views/attribute_card.dart';
import 'package:taskwarrior/app/modules/detailRoute/views/detail_route_dialog_action.dart';
import 'package:taskwarrior/app/utils/constants/utilites.dart';
import 'package:taskwarrior/app/utils/themes/theme_extension.dart';

/// Edits the description in a dialog; an empty description is rejected.
class DescriptionWidget extends StatelessWidget {
  const DescriptionWidget({
    required this.controller,
    required this.name,
    required this.value,
    required this.callback,
    this.isEditable = true,
    super.key,
  });

  final DetailRouteController controller;
  final String name;
  final String? value;
  final void Function(dynamic) callback;
  final bool isEditable;

  void _showEditDialog(BuildContext context) {
    TaskwarriorColorTheme tColors =
        Theme.of(context).extension<TaskwarriorColorTheme>()!;
    final sentences = controller.sentences;
    controller.prepareDescriptionEdit(value ?? '');
    showDialog(
      context: context,
      builder: (context) => Obx(
        () => Utils.showAlertDialog(
          scrollable: true,
          title: Text(
            sentences.editDescription,
            style: TextStyle(
              color: tColors.primaryTextColor,
            ),
          ),
          content: TextField(
            style: TextStyle(
              color: tColors.primaryTextColor,
            ),
            decoration: InputDecoration(
              errorText: controller.descriptionErrorText.value,
              errorStyle: const TextStyle(
                color: Colors.red,
              ),
            ),
            autofocus: true,
            maxLines: null,
            controller: controller.descriptionController,
          ),
          actions: [
            DetailRouteDialogAction(
              label: sentences.cancel,
              color: tColors.primaryTextColor,
              onPressed: () => Navigator.of(context).pop(),
            ),
            DetailRouteDialogAction(
              label: sentences.submit,
              color: tColors.primaryTextColor,
              onPressed: () {
                if (controller.validateDescription()) {
                  callback(controller.descriptionController.text);
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AttributeCard(
      name: name,
      value: value,
      isEditable: isEditable,
      onTap: () => _showEditDialog(context),
    );
  }
}
