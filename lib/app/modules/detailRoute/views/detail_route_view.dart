import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taskwarrior/app/modules/detailRoute/controllers/detail_route_controller.dart';
import 'package:taskwarrior/app/modules/detailRoute/views/detail_route_page_app_bar.dart';
import 'package:taskwarrior/app/modules/detailRoute/views/detail_route_page_body.dart';
import 'package:taskwarrior/app/modules/detailRoute/views/detail_route_page_floating_action_button.dart';
import 'package:taskwarrior/app/modules/detailRoute/views/unsaved_changes_dialog.dart';
import 'package:taskwarrior/app/utils/themes/theme_extension.dart';

class DetailRouteView extends GetView<DetailRouteController> {
  const DetailRouteView({super.key});

  @override
  Widget build(BuildContext context) {
    TaskwarriorColorTheme tColors =
        Theme.of(context).extension<TaskwarriorColorTheme>()!;
    if (!controller.hasTask) {
      // The controller closes the page in onReady.
      return Scaffold(backgroundColor: tColors.primaryBackgroundColor);
    }
    controller.startTourOnce(context);
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
        if (await _confirmLeave(context) && context.mounted) {
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        backgroundColor: tColors.primaryBackgroundColor,
        appBar: DetailRoutePageAppBar(controller: controller),
        body: DetailRoutePageBody(controller: controller),
        floatingActionButton:
            DetailRoutePageFloatingActionButton(controller: controller),
      ),
    );
  }

  /// Whether the page may close; asks first when there are unsaved edits.
  Future<bool> _confirmLeave(BuildContext context) async {
    if (!controller.onEdit.value) return true;
    final bool? saved = await UnsavedChangesDialog.show(context, controller);
    // Yes (true) or No (false) both leave the page; Cancel (null) stays.
    return saved != null;
  }
}
