import 'package:flutter/material.dart';
import 'package:taskwarrior/app/modules/detailRoute/controllers/detail_route_controller.dart';
import 'package:taskwarrior/app/modules/detailRoute/views/detail_route_dialog_action.dart';
import 'package:taskwarrior/app/utils/themes/theme_extension.dart';

/// Asked when leaving the page with unsaved edits. Pops with `true` (saved),
/// `false` (discarded) or `null` (cancelled, or the save failed: stay).
class UnsavedChangesDialog extends StatelessWidget {
  final DetailRouteController controller;
  const UnsavedChangesDialog({required this.controller, super.key});

  static Future<bool?> show(
      BuildContext context, DetailRouteController controller) {
    return showDialog<bool>(
      context: context,
      builder: (context) => UnsavedChangesDialog(controller: controller),
    );
  }

  @override
  Widget build(BuildContext context) {
    TaskwarriorColorTheme tColors =
        Theme.of(context).extension<TaskwarriorColorTheme>()!;
    final sentences = controller.sentences;
    return AlertDialog(
      backgroundColor: tColors.dialogBackgroundColor,
      title: Text(
        sentences.saveChangesConfirmation,
        style: TextStyle(
          color: tColors.primaryTextColor,
        ),
      ),
      actions: [
        DetailRouteDialogAction(
          label: sentences.yes,
          color: tColors.primaryTextColor,
          onPressed: () =>
              Navigator.of(context).pop(controller.saveChanges() ? true : null),
        ),
        DetailRouteDialogAction(
          label: sentences.no,
          color: tColors.primaryTextColor,
          onPressed: () => Navigator.of(context).pop(false),
        ),
        DetailRouteDialogAction(
          label: sentences.cancel,
          color: tColors.primaryTextColor,
          onPressed: () => Navigator.of(context).pop(null),
        ),
      ],
    );
  }
}
