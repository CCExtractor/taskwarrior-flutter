// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:built_collection/built_collection.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loggy/loggy.dart';
import 'package:taskwarrior/app/models/tag_meta_data.dart';
import 'package:taskwarrior/app/modules/home/controllers/home_controller.dart';
import 'package:taskwarrior/app/utils/constants/constants.dart';
import 'package:taskwarrior/app/utils/constants/utilites.dart';
import 'package:taskwarrior/app/utils/app_settings/app_settings.dart';

class TagsWidget extends StatelessWidget {
  const TagsWidget({
    required this.name,
    required this.value,
    required this.callback,
    super.key,
  });

  final String name;
  final ListBuilder<String>? value;
  final void Function(ListBuilder<String>?) callback;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppSettings.isDarkMode
          ? TaskWarriorColors.ksecondaryBackgroundColor
          : TaskWarriorColors.kLightSecondaryBackgroundColor,
      child: ListTile(
        textColor: AppSettings.isDarkMode
            ? TaskWarriorColors.kprimaryTextColor
            : TaskWarriorColors.ksecondaryTextColor,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name,
              style: TextStyle(
                color: AppSettings.isDarkMode
                    ? TaskWarriorColors.kprimaryTextColor
                    : TaskWarriorColors.ksecondaryTextColor,
              ),
            ),
            Wrap(
              spacing: 8.0,
              runSpacing: 4.0,
              children: value?.build().map((tag) {
                    return Chip(
                      label: Text(tag),
                      backgroundColor: AppSettings.isDarkMode
                          ? TaskWarriorColors.kprimaryBackgroundColor
                          : TaskWarriorColors.kLightPrimaryBackgroundColor,
                      labelStyle: TextStyle(
                        color: AppSettings.isDarkMode
                            ? TaskWarriorColors.kprimaryTextColor
                            : TaskWarriorColors.ksecondaryTextColor,
                      ),
                    );
                  }).toList() ??
                  [],
            ),
          ],
        ),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TagsRoute(
              value: value,
              callback: callback,
            ),
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

  void _addTag(String tag) {
    if (tag.isNotEmpty) {
      if (draftTags == null) {
        draftTags = ListBuilder([tag]);
      } else {
        draftTags!.add(tag);
      }
      widget.callback(draftTags);
      setState(() {});
    }
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

  void _editTag(String oldTag, String newTag) {
    if (newTag.isNotEmpty && !newTag.contains(" ")) {
      _removeTag(oldTag);
      _addTag(newTag);
    }
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: TaskWarriorColors.kprimaryBackgroundColor,
        title: Text(
          'Tags',
          style: GoogleFonts.poppins(color: TaskWarriorColors.white),
        ),
        leading: BackButton(
          color: TaskWarriorColors.white,
        ),
      ),
      backgroundColor: AppSettings.isDarkMode
          ? TaskWarriorColors.kprimaryBackgroundColor
          : TaskWarriorColors.kLightPrimaryBackgroundColor,
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
                      onSelected: (_) => _showEditTagDialog(tag),
                      label: Text(
                        '+$tag ${_pendingTags?[tag]?.frequency ?? 0}',
                      ),
                    ),
                if (draftTags == null)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(15, 18, 0, 10),
                    child: Text(
                      'Added tags will appear here',
                      style: GoogleFonts.poppins(
                          fontStyle: FontStyle.italic,
                          color: AppSettings.isDarkMode
                              ? TaskWarriorColors.kprimaryTextColor
                              : TaskWarriorColors.kLightPrimaryTextColor),
                    ),
                  ),
                Divider(
                  color: AppSettings.isDarkMode
                      ? const Color.fromARGB(255, 192, 192, 192)
                      : TaskWarriorColors.kprimaryBackgroundColor,
                ),
                if (_pendingTags != null)
                  for (var tag in _pendingTags!.entries.where((tag) =>
                      !(draftTags?.build().contains(tag.key) ?? false)))
                    FilterChip(
                      backgroundColor: TaskWarriorColors.grey,
                      onSelected: (_) => _addTag(tag.key),
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
        backgroundColor: AppSettings.isDarkMode
            ? TaskWarriorColors.black
            : TaskWarriorColors.white,
        foregroundColor: AppSettings.isDarkMode
            ? TaskWarriorColors.white
            : TaskWarriorColors.black,
        splashColor: AppSettings.isDarkMode
            ? TaskWarriorColors.black
            : TaskWarriorColors.white,
        heroTag: "btn4",
        onPressed: () {
          final formKey = GlobalKey<FormState>();
          var controller = TextEditingController();
          showDialog(
            context: context,
            builder: (context) => Utils.showAlertDialog(
              scrollable: true,
              title: Text(
                'Add tag',
                style: TextStyle(
                  color: AppSettings.isDarkMode
                      ? TaskWarriorColors.white
                      : TaskWarriorColors.black,
                ),
              ),
              content: Form(
                key: formKey,
                child: TextFormField(
                  style: TextStyle(
                    color: AppSettings.isDarkMode
                        ? TaskWarriorColors.white
                        : TaskWarriorColors.black,
                  ),
                  validator: (value) {
                    if (value != null) {
                      if (value.isNotEmpty && value.contains(" ")) {
                        return "Tags cannot contain spaces";
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
                    Get.back();
                  },
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                      color: AppSettings.isDarkMode
                          ? TaskWarriorColors.white
                          : TaskWarriorColors.black,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      try {
                        validateTaskTags(controller.text);
                        _addTag(controller.text);
                        Get.back();
                      } on FormatException catch (e, trace) {
                        logError(e, trace);
                      }
                    }
                  },
                  child: Text(
                    'Submit',
                    style: TextStyle(
                      color: AppSettings.isDarkMode
                          ? TaskWarriorColors.black
                          : TaskWarriorColors.black,
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

  void _showEditTagDialog(String oldTag) {
    final formKey = GlobalKey<FormState>();
    var controller = TextEditingController(text: oldTag);
    showDialog(
      context: context,
      builder: (context) => Utils.showAlertDialog(
        scrollable: true,
        title: Text(
          'Edit tag',
          style: TextStyle(
            color: AppSettings.isDarkMode
                ? TaskWarriorColors.white
                : TaskWarriorColors.black,
          ),
        ),
        content: Form(
          key: formKey,
          child: TextFormField(
            style: TextStyle(
              color: AppSettings.isDarkMode
                  ? TaskWarriorColors.white
                  : TaskWarriorColors.black,
            ),
            validator: (value) {
              if (value != null) {
                if (value.isNotEmpty && value.contains(" ")) {
                  return "Tags cannot contain spaces";
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
              Get.back();
            },
            child: Text(
              'Cancel',
              style: TextStyle(
                color: AppSettings.isDarkMode
                    ? TaskWarriorColors.white
                    : TaskWarriorColors.black,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                try {
                  validateTaskTags(controller.text);
                  _editTag(oldTag, controller.text);
                  Get.back();
                } on FormatException catch (e, trace) {
                  logError(e, trace);
                }
              }
            },
            child: Text(
              'Submit',
              style: TextStyle(
                color: AppSettings.isDarkMode
                    ? TaskWarriorColors.black
                    : TaskWarriorColors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

void validateTaskTags(String tag) {
  if (tag.isEmpty) {
    throw const FormatException("Tag cannot be empty");
  }
  if (tag.contains(" ")) {
    throw const FormatException("Tags cannot contain spaces");
  }
}
