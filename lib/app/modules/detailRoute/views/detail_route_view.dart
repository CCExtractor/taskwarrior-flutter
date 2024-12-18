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
    TaskwarriorColorTheme tColors = Theme.of(context).extension<TaskwarriorColorTheme>()!;
    return WillPopScope(
      onWillPop: () async {
        if (!controller.onEdit.value) {
          // Get.offAll(() => const HomeView());
          Get.back();
          // Get.toNamed(Routes.HOME);
          return false;
        }

        bool? save = await showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              backgroundColor: tColors.dialogBackgroundColor,
              title: Text(
                'Do you want to save changes?',
                style: TextStyle(
                  color: tColors.primaryTextColor,
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    controller.saveChanges();
                    // Get.offAll(() => const HomeView());

                    Get.back();
                  },
                  child: Text(
                    'Yes',
                    style: TextStyle(
                      color: tColors.primaryTextColor,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    // Get.offAll(() => const HomeView());

                    Get.back();
                  },
                  child: Text(
                    'No',
                    style: TextStyle(
                      color: tColors.primaryTextColor,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Get.back();
                  },
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                      color: tColors.primaryTextColor,
                    ),
                  ),
                ),
              ],
            );
          },
        );
        return save == true;
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
                  padding:
                      const EdgeInsets.symmetric(vertical: 4, horizontal: 2),
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
          floatingActionButton: controller.modify.changes.isEmpty
              ? const SizedBox.shrink()
              : FloatingActionButton(
                  backgroundColor: tColors.primaryTextColor,
                  foregroundColor: tColors.secondaryBackgroundColor,
                  splashColor: tColors.primaryTextColor,
                  heroTag: "btn1",
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          scrollable: true,
                          title: Text(
                            'Review changes:',
                            style: TextStyle(
                              color: tColors.primaryTextColor,
                            ),
                          ),
                          content: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Text(
                              controller.modify.changes.entries
                                  .map((entry) => '${entry.key}:\n'
                                      '  old: ${entry.value['old']}\n'
                                      '  new: ${entry.value['new']}')
                                  .toList()
                                  .join('\n'),
                              style: TextStyle(
                                color: tColors.primaryTextColor,
                              ),
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Get.back();
                              },
                              child: Text(
                                'Cancel',
                                style: TextStyle(
                                  color: tColors.primaryTextColor,
                                ),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                controller.saveChanges();
                              },
                              child: Text(
                                'Submit',
                                style: TextStyle(
                                  color: tColors.primaryBackgroundColor,
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: const Icon(Icons.save),
                )),
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
        ? DateFormat.yMEd().add_jms().format(value.toLocal())
        : ((value is BuiltList) ? (value).toBuilder() : value);
    TaskwarriorColorTheme tColors = Theme.of(context).extension<TaskwarriorColorTheme>()!;
    switch (name) {
      case 'description':
        return DescriptionWidget(
          name: name,
          value: localValue,
          callback: callback,
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
        );
      case 'due':
        return DateTimeWidget(
          name: name,
          value: localValue,
          callback: callback,
          globalKey: dueKey,
        );
      case 'wait':
        return DateTimeWidget(
          name: name,
          value: localValue,
          callback: callback,
          globalKey: waitKey,
        );
      case 'until':
        return DateTimeWidget(
          name: name,
          value: localValue,
          callback: callback,
          globalKey: untilKey,
        );
      case 'priority':
        return PriorityWidget(
          name: name,
          value: localValue,
          callback: callback,
          globalKey: priorityKey,
        );
      case 'project':
        return ProjectWidget(
          name: name,
          value: localValue,
          callback: callback,
        );
      case 'tags':
        return TagsWidget(
          name: name,
          value: localValue,
          callback: callback,
        );
      default:
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
                        color: tColors.primaryTextColor,
                    ),
                  ),
                  Text(
                    localValue?.toString() ?? "not selected",
                    style: TextStyle(
                      fontFamily: FontFamily.poppins,
                      fontSize: TaskWarriorFonts.fontSizeMedium,
                      color: tColors.primaryTextColor,
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

class TagsWidget extends StatelessWidget {
  const TagsWidget({
    required this.name,
    required this.value,
    required this.callback,
    super.key,
  });

  final String name;
  final dynamic value;
  final void Function(dynamic) callback;
  @override
  Widget build(BuildContext context) {
  TaskwarriorColorTheme tColors = Theme.of(context).extension<TaskwarriorColorTheme>()!;
    return Card(
      color: tColors.secondaryBackgroundColor,
      child: ListTile(
        textColor: tColors.primaryTextColor,
        title: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              RichText(
                text: TextSpan(
                  children: <TextSpan>[
                    TextSpan(
                        text: '$name:'.padRight(13),
                        style: TextStyle(
                          fontFamily: FontFamily.poppins,
                          fontWeight: FontWeight.bold,
                          fontSize: TaskWarriorFonts.fontSizeMedium,
                          color: tColors.primaryTextColor,
                        )
                        // style: GoogleFonts.poppins(
                        //   fontWeight: TaskWarriorFonts.bold,
                        //   fontSize: TaskWarriorFonts.fontSizeMedium,
                        //   color: AppSettings.isDarkMode
                        //       ? TaskWarriorColors.white
                        //       : TaskWarriorColors.black,
                        // ),
                        ),
                    TextSpan(
                      text:
                          '${(value as ListBuilder?)?.build() ?? 'not selected'}',
                      style: TextStyle(
                        color: tColors.primaryTextColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        onTap: () => Get.to(
          TagsRoute(
            value: value,
            callback: callback,
          ),
        ),
      ),
    );
  }
}
