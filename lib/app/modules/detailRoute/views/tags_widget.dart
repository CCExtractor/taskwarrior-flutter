// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:built_collection/built_collection.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loggy/loggy.dart';
import 'package:taskwarrior/app/modules/detailRoute/controllers/tags_controller.dart';
import 'package:taskwarrior/app/utils/app_settings/app_settings.dart';

import 'package:taskwarrior/app/utils/constants/constants.dart';
import 'package:taskwarrior/app/utils/constants/utilites.dart';
import 'package:taskwarrior/app/utils/gen/fonts.gen.dart';
import 'package:taskwarrior/app/utils/language/sentence_manager.dart';
import 'package:taskwarrior/app/utils/themes/theme_extension.dart';

class TagsWidget extends StatelessWidget {
  const TagsWidget({
    required this.name,
    required this.value,
    required this.callback,
    this.isEditable = true,
    super.key,
  });

  final String name;
  final dynamic value;
  final void Function(dynamic) callback;
  final bool isEditable;

  @override
  Widget build(BuildContext context) {
    TaskwarriorColorTheme tColors =
        Theme.of(context).extension<TaskwarriorColorTheme>()!;
    final Color? textColor = isEditable
        ? tColors.primaryTextColor
        : tColors.primaryDisabledTextColor;

    return Card(
      color: tColors.primaryBackgroundColor,
      child: ListTile(
        enabled: isEditable,
        tileColor: tColors.secondaryBackgroundColor,
        textColor: textColor,
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
                        fontWeight: TaskWarriorFonts.bold,
                        fontSize: TaskWarriorFonts.fontSizeMedium,
                        color: textColor,
                      ),
                    ),
                    TextSpan(
                      text: '${(value as ListBuilder?)?.build()}',
                      style: TextStyle(
                        fontFamily: FontFamily.poppins,
                        fontSize: TaskWarriorFonts.fontSizeMedium,
                        color: textColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        onTap: () => Get.to(
          () => const TagsRoute(),
          binding: BindingsBuilder(() {
            Get.put(TagsController()
              ..init(
                value: value as ListBuilder<String>?,
                callbackFn: (r) => callback(r),
              ));
          }),
        ),
      ),
    );
  }
}

class TagsRoute extends GetView<TagsController> {
  const TagsRoute({super.key});

  @override
  Widget build(BuildContext context) {
    TaskwarriorColorTheme tColors =
        Theme.of(context).extension<TaskwarriorColorTheme>()!;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: TaskWarriorColors.kprimaryBackgroundColor,
        title: Text(
          SentenceManager(currentLanguage: AppSettings.selectedLanguage)
              .sentences
              .tags,
          style: GoogleFonts.poppins(color: TaskWarriorColors.white),
        ),
        leading: BackButton(
          color: TaskWarriorColors.white,
        ),
      ),
      backgroundColor: tColors.secondaryBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: Obx(() {
            final draftTags = controller.draftTags.value;
            final pendingTags = controller.pendingTags;
            return SingleChildScrollView(
              padding: const EdgeInsets.only(
                  left: 10, top: 10, right: 10, bottom: 0),
              child: Wrap(
                spacing: 8,
                runSpacing: 4,
                children: [
                  if (draftTags != null)
                    for (var tag in draftTags.build())
                      FilterChip(
                        backgroundColor: TaskWarriorColors.lightGrey,
                        onSelected: (_) => controller.removeTag(tag),
                        label: Text(
                          '+$tag ${pendingTags[tag]?.frequency ?? 0}',
                        ),
                      ),
                  if (draftTags == null)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(15, 18, 0, 10),
                      child: Text(
                        SentenceManager(
                          currentLanguage: AppSettings.selectedLanguage,
                        ).sentences.addedTagsWillAppearHere,
                        style: GoogleFonts.poppins(
                            fontStyle: FontStyle.italic,
                            color: tColors.primaryTextColor),
                      ),
                    ),
                  Divider(
                    color: tColors.dividerColor,
                  ),
                  for (var tag in pendingTags.entries.where((tag) =>
                      !(draftTags?.build().contains(tag.key) ?? false)))
                    FilterChip(
                      backgroundColor: TaskWarriorColors.grey,
                      onSelected: (_) => controller.addTags([tag.key]),
                      label: Text(
                        '${tag.key} ${tag.value.frequency}',
                      ),
                    ),
                ],
              ),
            );
          }),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: tColors.primaryTextColor,
        foregroundColor: tColors.secondaryBackgroundColor,
        splashColor: tColors.primaryTextColor,
        heroTag: "btn4",
        onPressed: () {
          final formKey = GlobalKey<FormState>();
          final textController = TextEditingController();
          showDialog(
            context: context,
            builder: (context) => Utils.showAlertDialog(
              scrollable: true,
              title: Text(
                SentenceManager(
                  currentLanguage: AppSettings.selectedLanguage,
                ).sentences.addTag,
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
                  validator: (value) {
                    final tags = controller.parseTags(value ?? '');

                    if (tags.isEmpty) {
                      return "Please enter a tag";
                    }

                    for (final tag in tags) {
                      if (tag.contains(' ')) {
                        return "Tags cannot contain spaces";
                      }

                      if (controller.draftTags.value?.build().contains(tag) ??
                          false) {
                        return "Tag already exists";
                      }
                    }

                    return null;
                  },
                  autofocus: true,
                  controller: textController,
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Get.back();
                  },
                  child: Text(
                    SentenceManager(
                      currentLanguage: AppSettings.selectedLanguage,
                    ).sentences.cancel,
                    style: TextStyle(
                      color: tColors.primaryTextColor,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      try {
                        final tags = controller.parseTags(textController.text);
                        controller.addTags(tags);
                        Get.back();
                      } on FormatException catch (e, trace) {
                        logError(e, trace);
                      }
                    }
                  },
                  child: Text(
                    SentenceManager(
                      currentLanguage: AppSettings.selectedLanguage,
                    ).sentences.submit,
                    style: TextStyle(
                      color: tColors.primaryTextColor,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
