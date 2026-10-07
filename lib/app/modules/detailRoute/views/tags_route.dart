import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taskwarrior/app/modules/detailRoute/controllers/detail_route_controller.dart';
import 'package:taskwarrior/app/modules/detailRoute/views/detail_route_dialog_action.dart';
import 'package:taskwarrior/app/utils/constants/constants.dart';
import 'package:taskwarrior/app/utils/constants/utilites.dart';
import 'package:taskwarrior/app/utils/gen/fonts.gen.dart';
import 'package:taskwarrior/app/utils/themes/theme_extension.dart';
import 'package:taskwarrior/app/widgets/taskwarrior_page_app_bar.dart';

/// Full-screen tag editor: tap a chip to remove it, tap a known tag to add
/// it, or add new ones with the button. All state lives in [controller].
class TagsRoute extends StatelessWidget {
  const TagsRoute({required this.controller, super.key});

  final DetailRouteController controller;

  void _showAddTagDialog(BuildContext context) {
    TaskwarriorColorTheme tColors =
        Theme.of(context).extension<TaskwarriorColorTheme>()!;
    final sentences = controller.sentences;
    final formKey = GlobalKey<FormState>();
    controller.prepareTagEdit();
    showDialog(
      context: context,
      builder: (context) => Utils.showAlertDialog(
        scrollable: true,
        title: Text(
          sentences.addTag,
          style: TextStyle(
            color: tColors.primaryTextColor,
          ),
        ),
        content: Form(
          key: formKey,
          child: TextFormField(
            style: TextStyle(
              color: tColors.primaryTextColor,
            ),
            validator: controller.validateTags,
            autofocus: true,
            controller: controller.tagController,
          ),
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
              if (formKey.currentState!.validate()) {
                controller.addTags(DetailRouteController.parseTags(
                    controller.tagController.text));
                Navigator.of(context).pop();
              }
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    TaskwarriorColorTheme tColors =
        Theme.of(context).extension<TaskwarriorColorTheme>()!;
    return Scaffold(
      appBar: TaskWarriorPageAppBar(
        title: TaskWarriorPageAppBar.titleText(controller.sentences.tags),
      ),
      backgroundColor: tColors.secondaryBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: SingleChildScrollView(
            padding:
                const EdgeInsets.only(left: 10, top: 10, right: 10, bottom: 0),
            child: Obx(() {
              final tags = controller.currentTags;
              final knownTags = controller.knownTags;
              return Wrap(
                spacing: 8,
                runSpacing: 4,
                children: [
                  for (var tag in tags)
                    FilterChip(
                      backgroundColor: TaskWarriorColors.lightGrey,
                      onSelected: (_) => controller.removeTag(tag),
                      label: Text(
                        '+$tag ${knownTags[tag]?.frequency ?? 0}',
                      ),
                    ),
                  if (tags.isEmpty)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(15, 18, 0, 10),
                      child: Text(
                        controller.sentences.addedTagsWillAppearHere,
                        style: TextStyle(
                          fontFamily: FontFamily.poppins,
                          fontStyle: FontStyle.italic,
                          color: tColors.primaryTextColor,
                        ),
                      ),
                    ),
                  Divider(
                    color: tColors.dividerColor,
                  ),
                  for (var tag in knownTags.entries
                      .where((tag) => !tags.contains(tag.key)))
                    FilterChip(
                      backgroundColor: TaskWarriorColors.grey,
                      onSelected: (_) => controller.addTags([tag.key]),
                      label: Text(
                        '${tag.key} ${tag.value.frequency}',
                      ),
                    ),
                ],
              );
            }),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: tColors.primaryTextColor,
        foregroundColor: tColors.secondaryBackgroundColor,
        splashColor: tColors.primaryTextColor,
        heroTag: "btn4",
        onPressed: () => _showAddTagDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}
