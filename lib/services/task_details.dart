// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';

import 'package:built_collection/built_collection.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import 'package:taskwarrior/config/app_settings.dart';
import 'package:taskwarrior/config/taskwarriorcolors.dart';
import 'package:taskwarrior/config/taskwarriorfonts.dart';
import 'package:taskwarrior/model/storage/storage_widget.dart';
import 'package:taskwarrior/views/home/home.dart';
import 'package:taskwarrior/widgets/pallete.dart';
import 'package:taskwarrior/widgets/taskdetails.dart';
import 'package:taskwarrior/widgets/taskw.dart';

class DetailRoute extends StatefulWidget {
  const DetailRoute(this.uuid, {super.key});

  final String uuid;

  @override
  State<DetailRoute> createState() => _DetailRouteState();
}

class _DetailRouteState extends State<DetailRoute> {
  late Modify modify;
  bool onedit = false;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    var storageWidget = StorageWidget.of(context);
    modify = Modify(
      getTask: storageWidget.getTask,
      mergeTask: storageWidget.mergeTask,
      uuid: widget.uuid,
    );
  }

  void Function(dynamic) callback(String name) {
    return (newValue) {
      modify.set(name, newValue);
      onedit = true;
      setState(() {});
    };
  }

  void saveChanges() async {
    var now = DateTime.now().toUtc();

    modify.save(
      modified: () => now,
    );
    onedit = true;
    setState(() {});
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          'Task Updated',
          style: TextStyle(
            color: AppSettings.isDarkMode
                ? TaskWarriorColors.kprimaryTextColor
                : TaskWarriorColors.kLightPrimaryTextColor,
          ),
        ),
        backgroundColor: AppSettings.isDarkMode
            ? TaskWarriorColors.ksecondaryBackgroundColor
            : TaskWarriorColors.kLightSecondaryBackgroundColor,
        duration: const Duration(seconds: 2)));
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) async {
        if (didPop || !onedit) {
          // print(onedit);

          await Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => const HomePage()),
              (Route<dynamic> route) => false);
        }
        // ignore: use_build_context_synchronously
        return showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              surfaceTintColor: AppSettings.isDarkMode
                  ? TaskWarriorColors.kdialogBackGroundColor
                  : TaskWarriorColors.kLightDialogBackGroundColor,
              shadowColor: AppSettings.isDarkMode
                  ? TaskWarriorColors.kdialogBackGroundColor
                  : TaskWarriorColors.kLightDialogBackGroundColor,
              backgroundColor: AppSettings.isDarkMode
                  ? TaskWarriorColors.kdialogBackGroundColor
                  : TaskWarriorColors.kLightDialogBackGroundColor,
              title: Text(
                'Do you want to save changes?',
                style: TextStyle(
                  color: AppSettings.isDarkMode
                      ? TaskWarriorColors.white
                      : TaskWarriorColors.black,
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    saveChanges();
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      HomePage.routeName,
                      (route) => false,
                    );
                    setState(() {});
                  },
                  child: Text(
                    'Yes',
                    style: TextStyle(
                      color: AppSettings.isDarkMode
                          ? TaskWarriorColors.white
                          : TaskWarriorColors.black,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      HomePage.routeName,
                      (route) => false,
                    );
                  },
                  child: Text(
                    'No',
                    style: TextStyle(
                      color: AppSettings.isDarkMode
                          ? TaskWarriorColors.white
                          : TaskWarriorColors.black,
                    ),
                  ),
                ),
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
              ],
            );
          },
        );
      },
      child: Scaffold(
        backgroundColor: AppSettings.isDarkMode
            ? TaskWarriorColors.kprimaryBackgroundColor
            : TaskWarriorColors.kLightPrimaryBackgroundColor,
        appBar: AppBar(
          leading: BackButton(color: TaskWarriorColors.white),
          backgroundColor: Palette.kToDark,
          title: Text(
            'id: ${(modify.id == 0) ? '-' : modify.id}',
            style: TextStyle(
              color: TaskWarriorColors.white,
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.only(left: 8.0, right: 8.0),
          child: ListView(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 2),
            children: [
              for (var entry in {
                'description': modify.draft.description,
                'status': modify.draft.status,
                'entry': modify.draft.entry,
                'modified': modify.draft.modified,
                'start': modify.draft.start,
                'end': modify.draft.end,
                'due': modify.draft.due,
                'wait': modify.draft.wait,
                'until': modify.draft.until,
                'priority': modify.draft.priority,
                'project': modify.draft.project,
                'tags': modify.draft.tags,
                //'annotations': modify.draft.annotations,
                //'udas': modify.draft.udas,
                'urgency': urgency(modify.draft),
                //'uuid': modify.draft.uuid,
              }.entries)
                AttributeWidget(
                  name: entry.key,
                  value: entry.value,
                  callback: callback(entry.key),
                ),
            ],
          ),
        ),
        floatingActionButton: (modify.changes.isEmpty)
            ? null
            : FloatingActionButton(
                backgroundColor: AppSettings.isDarkMode
                    ? TaskWarriorColors.black
                    : TaskWarriorColors.white,
                foregroundColor: AppSettings.isDarkMode
                    ? TaskWarriorColors.white
                    : TaskWarriorColors.black,
                splashColor: AppSettings.isDarkMode
                    ? TaskWarriorColors.black
                    : TaskWarriorColors.white,
                heroTag: "btn1",
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
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
                          'Review changes:',
                          style: TextStyle(
                            color: AppSettings.isDarkMode
                                ? TaskWarriorColors.white
                                : TaskWarriorColors.black,
                          ),
                        ),
                        content: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Text(
                            modify.changes.entries
                                .map((entry) => '${entry.key}:\n'
                                    '  old: ${entry.value['old']}\n'
                                    '  new: ${entry.value['new']}')
                                .toList()
                                .join('\n'),
                            style: TextStyle(
                              color: AppSettings.isDarkMode
                                  ? TaskWarriorColors.white
                                  : TaskWarriorColors.black,
                            ),
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
                              saveChanges();
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
                      );
                    },
                  );
                },
                child: const Icon(Icons.save),
              ),
      ),
    );
  }
}

class AttributeWidget extends StatelessWidget {
  const AttributeWidget({
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
    var localValue = (value is DateTime)
        ? DateFormat.yMEd().add_jms().format(value.toLocal())
        : ((value is BuiltList) ? (value).toBuilder() : value);

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
        );
      case 'wait':
        return DateTimeWidget(
          name: name,
          value: localValue,
          callback: callback,
        );
      case 'until':
        return DateTimeWidget(
          name: name,
          value: localValue,
          callback: callback,
        );
      case 'priority':
        return PriorityWidget(
          name: name,
          value: localValue,
          callback: callback,
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
      //   case 'annotations':
      //     return AnnotationsWidget(
      //       name: name,
      //       value: localValue,
      //       callback: callback,
      //     );
      default:
        return Card(
          color: AppSettings.isDarkMode
              ? TaskWarriorColors.ksecondaryBackgroundColor
              : TaskWarriorColors.kLightSecondaryBackgroundColor,
          child: ListTile(
            textColor: AppSettings.isDarkMode
                ? TaskWarriorColors.kprimaryTextColor
                : TaskWarriorColors.kLightSecondaryTextColor,
            title: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  Text(
                    '$name:'.padRight(13),
                    style: TextStyle(
                      color: AppSettings.isDarkMode
                          ? TaskWarriorColors.white
                          : TaskWarriorColors.black,
                    ),
                  ),
                  Text(
                    localValue?.toString() ?? "not selected",
                    style: TextStyle(
                      color: AppSettings.isDarkMode
                          ? TaskWarriorColors.white
                          : TaskWarriorColors.black,
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
    return Card(
      color: AppSettings.isDarkMode
          ? TaskWarriorColors.ksecondaryBackgroundColor
          : TaskWarriorColors.kLightSecondaryBackgroundColor,
      child: ListTile(
        textColor: AppSettings.isDarkMode
            ? TaskWarriorColors.kprimaryTextColor
            : TaskWarriorColors.ksecondaryTextColor,
        title: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              RichText(
                text: TextSpan(
                  children: <TextSpan>[
                    TextSpan(
                      text: '$name:'.padRight(13),
                      style: GoogleFonts.poppins(
                        fontWeight: TaskWarriorFonts.bold,
                        fontSize: 15,
                        color: AppSettings.isDarkMode
                            ? TaskWarriorColors.white
                            : TaskWarriorColors.black,
                      ),
                    ),
                    TextSpan(
                      text:
                          '${(value as ListBuilder?)?.build() ?? 'not selected'}',
                      style: TextStyle(
                        color: AppSettings.isDarkMode
                            ? TaskWarriorColors.white
                            : TaskWarriorColors.black,
                      ),
                    ),
                  ],
                ),
              ),
              // Text(
              //   '${'$name:  '}${(value as ListBuilder?)?.build()}',
              //   style: GoogleFonts.poppins(),
              // ),
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
// class AnnotationsWidget extends StatelessWidget {
//   const AnnotationsWidget({
//     required this.name,
//     required this.value,
//     required this.callback,
//     super.key,
//   });

//   final String name;
//   final dynamic value;
//   final void Function(dynamic) callback;

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       child: ListTile(
//         title: SingleChildScrollView(
//           scrollDirection: Axis.horizontal,
//           child: Row(
//             children: [
//               Text(
//                 (value == null)
//                     ? '${'$name:'.padRight(13)}null'
//                     : '${'$name:'.padRight(13)}${(value as ListBuilder).length} annotation(s)',
//                 style: GoogleFonts.poppins(),
//               ),
//             ],
//           ),
//         ),
//         onTap: () => Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) => AnnotationsRoute(
//               value: value,
//               callback: callback,
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }