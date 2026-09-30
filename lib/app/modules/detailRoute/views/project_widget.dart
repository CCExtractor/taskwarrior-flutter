import 'package:flutter/material.dart';
import 'package:taskwarrior/app/modules/detailRoute/controllers/detail_route_controller.dart';
import 'package:taskwarrior/app/modules/detailRoute/views/attribute_card.dart';
import 'package:taskwarrior/app/modules/detailRoute/views/detail_route_dialog_action.dart';
import 'package:taskwarrior/app/utils/constants/utilites.dart';
import 'package:taskwarrior/app/utils/debug_logger/app_logger.dart';
import 'package:taskwarrior/app/utils/themes/theme_extension.dart';

/// Edits the project in a dialog; an empty project clears it.
class ProjectWidget extends StatelessWidget {
  const ProjectWidget({
    required this.controller,
    required this.name,
    required this.value,
    required this.callback,
    this.isEditable = true,
    super.key,
  });

  static const AppLogger _log = AppLogger('DetailRoute');

  final DetailRouteController controller;
  final String? value;
  final String name;
  final void Function(dynamic) callback;
  final bool isEditable;

  void _showEditDialog(BuildContext context) {
    TaskwarriorColorTheme tColors =
        Theme.of(context).extension<TaskwarriorColorTheme>()!;
    final sentences = controller.sentences;
    controller.prepareProjectEdit(value);
    showDialog(
      context: context,
      builder: (context) => Utils.showAlertDialog(
        scrollable: true,
        title: Text(
          sentences.editProject,
          style: TextStyle(
            color: tColors.primaryTextColor,
          ),
        ),
        content: TextField(
          style: TextStyle(
            color: tColors.primaryTextColor,
          ),
          autofocus: true,
          maxLines: null,
          controller: controller.projectController,
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
              final text = controller.projectController.text;
              try {
                callback((text == '') ? null : text);
                Navigator.of(context).pop();
              } on FormatException catch (e, trace) {
                _log.warning('Rejected project "$text"', e, trace);
              }
            },
          ),
        ],
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
