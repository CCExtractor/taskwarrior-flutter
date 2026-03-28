// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:built_collection/built_collection.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loggy/loggy.dart';
import 'package:taskwarrior/app/models/tag_meta_data.dart';
import 'package:taskwarrior/app/modules/home/controllers/home_controller.dart';
import 'package:taskwarrior/app/utils/app_settings/app_settings.dart';

import 'package:taskwarrior/app/utils/constants/constants.dart';
import 'package:taskwarrior/app/utils/constants/utilites.dart';
import 'package:taskwarrior/app/utils/gen/fonts.gen.dart';
import 'package:taskwarrior/app/utils/language/sentence_manager.dart';
import 'package:taskwarrior/app/utils/taskfunctions/validate.dart';
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
          TagsRoute(
            value: value,
            callback: callback,
          ),
        ),
      ),
    );
  }
}

class TagsRoute extends StatefulWidget {
  const TagsRoute({required this.value, required this.callback, super.key});

  final ListBuilder<String>? value;
  final void Function(ListBuilder<String>?) callback;

  @override
  TagsRouteState createState() => TagsRouteState();
}

class TagsRouteState extends State<TagsRoute> {
  Map<String, TagMetadata>? _pendingTags;
  ListBuilder<String>? draftTags;

  List<String> _parseTags(String input) {
    return input
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();
  }

  void _addTags(List<String> tags) {
    if (tags.isEmpty) return;

    draftTags ??= ListBuilder<String>();

    for (final tag in tags) {
      if (!draftTags!.build().contains(tag)) {
        draftTags!.add(tag);
      }
    }

    widget.callback(draftTags);
    setState(() {});
  }

  void _removeTag(String tag) {
    if (draftTags!.length == 1) {
      draftTags!.remove(tag);
      draftTags = null;
    } else {
      draftTags!.remove(tag);
    }
    widget.callback(draftTags ?? ListBuilder([]));
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    draftTags = widget.value;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _initialize();
  }

  Future<void> _initialize() async {
    _pendingTags = Get.find<HomeController>().pendingTags;
    setState(() {});
  }

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
          child: SingleChildScrollView(
            padding:
                const EdgeInsets.only(left: 10, top: 10, right: 10, bottom: 0),
            child: Wrap(
              spacing: 8,
              runSpacing: 4,
              children: [
                if (draftTags != null)
                  for (var tag in draftTags!.build())
                    FilterChip(
                      backgroundColor: TaskWarriorColors.lightGrey,
                      onSelected: (_) => _removeTag(tag),
                      label: Text(
                        '+$tag ${_pendingTags?[tag]?.frequency ?? 0}',
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
                if (_pendingTags != null)
                  for (var tag in _pendingTags!.entries.where((tag) =>
                      !(draftTags?.build().contains(tag.key) ?? false)))
                    FilterChip(
                      backgroundColor: TaskWarriorColors.grey,
                      onSelected: (_) => _addTags([tag.key]),
                      label: Text(
                        '${tag.key} ${tag.value.frequency}',
                      ),
                    ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: tColors.primaryTextColor,
        foregroundColor: tColors.secondaryBackgroundColor,
        splashColor: tColors.primaryTextColor,
        heroTag: "btn4",
        onPressed: () {
          final formKey = GlobalKey<FormState>();
          var controller = TextEditingController();
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
                    final tags = _parseTags(value ?? '');

                    if (tags.isEmpty) {
                      return "Please enter a tag";
                    }

                    for (final tag in tags) {
                      if (tag.contains(' ')) {
                        return "Tags cannot contain spaces";
                      }

                      if (draftTags?.build().contains(tag) ?? false) {
                        return "Tag already exists";
                      }
                    }

                    return null;
                  },
                  autofocus: true,
                  controller: controller,
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    // Navigator.of(context).pop();
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
                        final tags = _parseTags(controller.text);
                        _addTags(tags);
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
