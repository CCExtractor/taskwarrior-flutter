// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:built_collection/built_collection.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loggy/loggy.dart';

import 'package:taskwarrior/config/app_settings.dart';
import 'package:taskwarrior/config/taskwarriorcolors.dart';
import 'package:taskwarrior/model/storage/storage_widget.dart';
import 'package:taskwarrior/widgets/taskw.dart';

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
    return Card(
      child: ListTile(
        tileColor: AppSettings.isDarkMode
            ? const Color.fromARGB(255, 55, 54, 54)
            : TaskWarriorColors.white,
        textColor: AppSettings.isDarkMode
            ? TaskWarriorColors.white
            : const Color.fromARGB(255, 48, 46, 46),
        title: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              Text(
                '${'$name:'.padRight(13)}${(value as ListBuilder?)?.build()}',
              ),
            ],
          ),
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
      // Add this condition to ensure the tag is not empty
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
    _pendingTags = StorageWidget.of(context).pendingTags;
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
                      onSelected: (_) => _removeTag(tag),
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
            builder: (context) => AlertDialog(
              surfaceTintColor: AppSettings.isDarkMode
                  ? TaskWarriorColors.kdialogBackGroundColor
                  : TaskWarriorColors.kLightDialogBackGroundColor,
              shadowColor: AppSettings.isDarkMode
                  ? TaskWarriorColors.kdialogBackGroundColor
                  : TaskWarriorColors.kLightDialogBackGroundColor,
              backgroundColor: AppSettings.isDarkMode
                  ? TaskWarriorColors.kdialogBackGroundColor
                  : TaskWarriorColors.kLightDialogBackGroundColor,
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
                    Navigator.of(context).pop();
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
                        Navigator.of(context).pop();
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
}
