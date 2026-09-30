import 'package:flutter/material.dart';
import 'package:taskwarrior/app/modules/detailRoute/controllers/detail_route_controller.dart';
import 'package:taskwarrior/app/modules/detailRoute/views/detail_route_dialog_action.dart';
import 'package:taskwarrior/app/utils/themes/theme_extension.dart';

/// Lists the pending old/new values and lets the user submit them.
class ReviewChangesDialog extends StatelessWidget {
  final DetailRouteController controller;
  const ReviewChangesDialog({required this.controller, super.key});

  /// Resolves to `true` when the changes were submitted and saved.
  static Future<bool> show(
      BuildContext context, DetailRouteController controller) async {
    final bool? saved = await showDialog<bool>(
      context: context,
      builder: (context) => ReviewChangesDialog(controller: controller),
    );
    return saved ?? false;
  }

  @override
  Widget build(BuildContext context) {
    TaskwarriorColorTheme tColors =
        Theme.of(context).extension<TaskwarriorColorTheme>()!;
    final sentences = controller.sentences;
    return AlertDialog(
      scrollable: true,
      title: Text(
        '${sentences.reviewChanges}:',
        style: TextStyle(
          color: tColors.primaryTextColor,
        ),
      ),
      content: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Text(
          controller.changesSummary,
          style: TextStyle(
            color: tColors.primaryTextColor,
          ),
        ),
      ),
      actions: [
        DetailRouteDialogAction(
          label: sentences.cancel,
          color: tColors.primaryTextColor,
          onPressed: () => Navigator.of(context).pop(false),
        ),
        DetailRouteDialogAction(
          label: sentences.submit,
          color: tColors.primaryBackgroundColor,
          onPressed: () => Navigator.of(context).pop(controller.saveChanges()),
        ),
      ],
    );
  }
}
