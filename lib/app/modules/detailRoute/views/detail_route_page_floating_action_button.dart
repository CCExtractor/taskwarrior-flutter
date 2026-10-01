import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taskwarrior/app/modules/detailRoute/controllers/detail_route_controller.dart';
import 'package:taskwarrior/app/modules/detailRoute/views/review_changes_dialog.dart';
import 'package:taskwarrior/app/utils/themes/theme_extension.dart';

class DetailRoutePageFloatingActionButton extends StatelessWidget {
  final DetailRouteController controller;
  const DetailRoutePageFloatingActionButton(
      {required this.controller, super.key});

  @override
  Widget build(BuildContext context) {
    TaskwarriorColorTheme tColors =
        Theme.of(context).extension<TaskwarriorColorTheme>()!;
    return Obx(
      () => controller.hasPendingChanges.value
          ? FloatingActionButton(
              backgroundColor: tColors.primaryTextColor,
              foregroundColor: tColors.secondaryBackgroundColor,
              splashColor: tColors.primaryTextColor,
              heroTag: "btn1",
              onPressed: () async {
                if (await ReviewChangesDialog.show(context, controller) &&
                    context.mounted) {
                  Navigator.of(context).pop();
                }
              },
              child: const Icon(Icons.save),
            )
          : const SizedBox.shrink(),
    );
  }
}
