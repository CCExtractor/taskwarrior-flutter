// ignore_for_file: depend_on_referenced_packages, deprecated_member_use

import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:taskwarrior/app/modules/detailRoute/controllers/detail_route_controller.dart';
import 'package:taskwarrior/app/modules/detailRoute/views/dateTimePicker.dart';
import 'package:taskwarrior/app/modules/detailRoute/views/description_widget.dart';
import 'package:taskwarrior/app/modules/detailRoute/views/priority_widget.dart';
import 'package:taskwarrior/app/modules/detailRoute/views/status_widget.dart';
import 'package:taskwarrior/app/modules/detailRoute/views/tags_widget.dart';
import 'package:taskwarrior/app/utils/constants/constants.dart';
import 'package:taskwarrior/app/utils/gen/fonts.gen.dart';
import 'package:taskwarrior/app/utils/language/sentence_manager.dart';
import 'package:taskwarrior/app/utils/app_settings/app_settings.dart';
import 'package:taskwarrior/app/utils/themes/theme_extension.dart';

class DetailRouteView extends GetView<DetailRouteController> {
  const DetailRouteView({super.key});

  @override
  Widget build(BuildContext context) {
    controller.initDetailsPageTour();
    controller.showDetailsPageTour(context);
    TaskwarriorColorTheme tColors =
        Theme.of(context).extension<TaskwarriorColorTheme>()!;
    return WillPopScope(
      onWillPop: () async {
        if (!controller.onEdit.value) {
          debugPrint(
              'DetailRouteView: No edits made, navigating back without prompt.');
          // Get.offAll(() => const HomeView());
          Navigator.of(context).pop();
          // Get.toNamed(Routes.HOME);
          return false;
        }
        debugPrint(
            'DetailRouteView: Unsaved edits detected, prompting user for action.');

        bool? save = await showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              backgroundColor: tColors.dialogBackgroundColor,
              title: Text(
                SentenceManager(currentLanguage: AppSettings.selectedLanguage)
                    .sentences
                    .saveChangesConfirmation,
                style: TextStyle(
                  color: tColors.primaryTextColor,
                ),
              ),
              actions: [
                // YES → save and pop
                TextButton(
                  onPressed: () {
                    // Get.back(); // Close the dialog first
                    // // Wait for dialog to fully close before showing snackbar
                    // Future.delayed(const Duration(milliseconds: 100), () {
                    //   controller.saveChanges();
                    // });

                    controller.saveChanges();
                    Navigator.of(context).pop(true);
                  },
                  child: Text(
                    SentenceManager(
                            currentLanguage: AppSettings.selectedLanguage)
                        .sentences
                        .yes,
                    style: TextStyle(
                      color: tColors.primaryTextColor,
                    ),
                  ),
                ),

                // NO → discard and pop
                TextButton(
                  onPressed: () {
                    // Get.offAll(() => const HomeView());
                    Navigator.of(context).pop(false);
                  },
                  child: Text(
                    SentenceManager(
                            currentLanguage: AppSettings.selectedLanguage)
                        .sentences
                        .no,
                    style: TextStyle(
                      color: tColors.primaryTextColor,
                    ),
                  ),
                ),

                // CANCEL → stay on page
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(null);
                  },
                  child: Text(
                    SentenceManager(
                            currentLanguage: AppSettings.selectedLanguage)
                        .sentences
                        .cancel,
                    style: TextStyle(
                      color: tColors.primaryTextColor,
                    ),
                  ),
                ),
              ],
            );
          },
        );
        if (save == null) {
          // Cancel → stay
          return false;
        }
        // Yes (true) or No (false) → both allow popping the screen
        return true;
      },
      child: Scaffold(
        backgroundColor: tColors.primaryBackgroundColor,
        appBar: AppBar(
            leading: BackButton(color: TaskWarriorColors.white),
            backgroundColor: Palette.kToDark,
            title: Text(
              '${SentenceManager(currentLanguage: AppSettings.selectedLanguage).sentences.detailPageID}: ${(controller.modify.id == 0) ? '-' : controller.modify.id}',
              style: TextStyle(
                color: TaskWarriorColors.white,
              ),
            )),
        body: Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0),
            child: Obx(
              () => ListView(
                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 2),
                children: [
                  for (var entry in {
                    'description': controller.descriptionValue.value,
                    'status': controller.statusValue.value,
                    'entry': controller.entryValue.value,
                    'modified': controller.modifiedValue.value,
                    'start': controller.startValue.value,
                    'end': controller.endValue.value,
                    'due': controller.dueValue.value,
                    'wait': controller.waitValue.value,
                    'until': controller.untilValue.value,
                    'priority': controller.priorityValue?.value,
                    'project': controller.projectValue?.value,
                    'tags': controller.tagsValue?.value,
                    'urgency': controller.urgencyValue.value,
                  }.entries)
                    AttributeWidget(
                      name: entry.key,
                      value: entry.value,
                      callback: (newValue) =>
                          controller.setAttribute(entry.key, newValue),
                      waitKey: controller.waitKey,
                      dueKey: controller.dueKey,
                      untilKey: controller.untilKey,
                      priorityKey: controller.priorityKey,
                    ),
                ],
              ),
            )),

        // SAVE BUTTON — Bottom Right

        floatingActionButton: Obx(() {
          if (!controller.onEdit.value) {
            return const SizedBox.shrink();
          }

          return FloatingActionButton(
            onPressed: () => _showReviewChangesDialog(context, tColors),
            backgroundColor: tColors.primaryTextColor,
            foregroundColor: tColors.secondaryBackgroundColor,
            splashColor: tColors.primaryTextColor,
            child: const Icon(Icons.save),
          );
        }),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      ),
    );
  }

  // REVIEW CHANGES DIALOG
  void _showReviewChangesDialog(
      BuildContext context, TaskwarriorColorTheme tColors) {
    final sentences =
        SentenceManager(currentLanguage: AppSettings.selectedLanguage)
            .sentences;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          scrollable: true,
          title: Text(
            '${sentences.reviewChanges}:',
            style: TextStyle(color: tColors.primaryTextColor),
          ),
          content: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Text(
              controller.modify.changes.entries
                  .map((entry) => '${entry.key}:\n'
                      '  ${sentences.oldChanges}: ${entry.value['old']}\n'
                      '  ${sentences.newChanges}: ${entry.value['new']}')
                  .toList()
                  .join('\n'),
              style: TextStyle(color: tColors.primaryTextColor),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Get.back(),
              child: Text(
                sentences.cancel,
                style: TextStyle(color: tColors.primaryTextColor),
              ),
            ),
            TextButton(
              onPressed: () {
                Get.back();
                controller.saveChanges();

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(sentences.taskUpdated),
                    behavior: SnackBarBehavior.floating,
                    duration: const Duration(seconds: 2),
                  ),
                );
              },
              child: Text(
                sentences.submit,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }
}

class AttributeWidget extends StatelessWidget {
  const AttributeWidget({
    required this.name,
    required this.value,
    required this.callback,
    required this.waitKey,
    required this.dueKey,
    required this.priorityKey,
    required this.untilKey,
    super.key,
  });

  final String name;
  final dynamic value;
  final void Function(dynamic) callback;
  final GlobalKey waitKey;
  final GlobalKey dueKey;
  final GlobalKey untilKey;
  final GlobalKey priorityKey;

  @override
  Widget build(BuildContext context) {
    var localValue = (value is DateTime)
        ? DateFormat(AppSettings.use24HourFormatRx.value
                ? 'EEE, yyyy-MM-dd HH:mm:ss'
                : 'EEE, yyyy-MM-dd hh:mm:ss a')
            .format(value.toLocal())
        : ((value is BuiltList) ? (value).toBuilder() : value);
    TaskwarriorColorTheme tColors =
        Theme.of(context).extension<TaskwarriorColorTheme>()!;
    // Get the controller to check if the task is read-only
    final DetailRouteController controller = Get.find<DetailRouteController>();

    // Always allow status to be edited, but respect read-only for other attributes
    final bool isEditable = !controller.isReadOnly.value || name == 'status';

    switch (name) {
      case 'description':
        return DescriptionWidget(
          name: name,
          value: localValue,
          callback: callback,
          isEditable: isEditable,
        );
      case 'status':
        return StatusWidget(
          name: name,
          value: localValue,
          callback: callback,
        );
      case 'start':
        return StartWidget(
          name: name,
          value: localValue,
          callback: callback,
          isEditable: isEditable,
        );
      case 'due':
        return DateTimeWidget(
          name: name,
          value: localValue,
          callback: callback,
          globalKey: dueKey,
          isEditable: isEditable,
        );
      case 'wait':
        return DateTimeWidget(
          name: name,
          value: localValue,
          callback: callback,
          globalKey: waitKey,
          isEditable: isEditable,
        );
      case 'until':
        return DateTimeWidget(
          name: name,
          value: localValue,
          callback: callback,
          globalKey: untilKey,
          isEditable: isEditable,
        );
      case 'priority':
        return PriorityWidget(
          name: name,
          value: localValue,
          callback: callback,
          globalKey: priorityKey,
          isEditable: isEditable,
        );
      case 'project':
        return ProjectWidget(
          name: name,
          value: localValue,
          callback: callback,
          isEditable: isEditable,
        );
      case 'tags':
        return TagsWidget(
          name: name,
          value: localValue,
          callback: callback,
          isEditable: isEditable,
        );
      default:
        final Color? textColor =
            (isEditable && !['entry', 'modified', 'urgency'].contains(name))
                ? tColors.primaryTextColor
                : tColors.primaryDisabledTextColor;

        return Card(
          color: tColors.secondaryBackgroundColor,
          child: ListTile(
            textColor: tColors.primaryTextColor,
            title: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  Text(
                    '$name:'.padRight(13),
                    style: TextStyle(
                      fontFamily: FontFamily.poppins,
                      fontWeight: TaskWarriorFonts.bold,
                      fontSize: TaskWarriorFonts.fontSizeMedium,
                      color: textColor,
                    ),
                  ),
                  Text(
                    localValue?.toString() ??
                        SentenceManager(
                                currentLanguage: AppSettings.selectedLanguage)
                            .sentences
                            .notSelected,
                    style: TextStyle(
                      fontFamily: FontFamily.poppins,
                      fontSize: TaskWarriorFonts.fontSizeMedium,
                      color: textColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
    }
  }
}
