// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';

import 'package:built_collection/built_collection.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import 'package:taskwarrior/config/app_settings.dart';
import 'package:taskwarrior/model/storage/storage_widget.dart';
import 'package:taskwarrior/views/home/home.dart';
import 'package:taskwarrior/widgets/pallete.dart';
import 'package:taskwarrior/widgets/taskdetails.dart';
import 'package:taskwarrior/widgets/taskw.dart';

class DetailRoute extends StatefulWidget {
  const DetailRoute(this.uuid, {Key? key}) : super(key: key);

  final String uuid;

  @override
  State<DetailRoute> createState() => _DetailRouteState();
}

class _DetailRouteState extends State<DetailRoute> {
  late Modify modify;

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
      setState(() {});
    };
  }

  void saveChanges() async {
    var now = DateTime.now().toUtc();
    modify.save(
      modified: () => now,
    );
    setState(() {});
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text('Task Updated'),
        backgroundColor: AppSettings.isDarkMode
            ? const Color.fromARGB(255, 61, 61, 61)
            : const Color.fromARGB(255, 39, 39, 39),
        duration: const Duration(seconds: 2)));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        backgroundColor: AppSettings.isDarkMode
            ? const Color.fromARGB(255, 29, 29, 29)
            : Colors.white,
        appBar: AppBar(
          leading: const BackButton(color: Colors.white),
          backgroundColor: Palette.kToDark,
          title: Text(
            'id: ${(modify.id == 0) ? '-' : modify.id}',
            style: GoogleFonts.firaMono(color: Colors.white),
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
                heroTag: "btn1",
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        scrollable: true,
                        title: const Text('Review changes:'),
                        content: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Text(
                            modify.changes.entries
                                .map((entry) => '${entry.key}:\n'
                                    '  old: ${entry.value['old']}\n'
                                    '  new: ${entry.value['new']}')
                                .toList()
                                .join('\n'),
                            style: GoogleFonts.firaMono(),
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('Cancel'),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              saveChanges();
                            },
                            child: const Text('Submit'),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: const Icon(Icons.save),
              ),
      ),
      onWillPop: () async {
        if (modify.changes.isNotEmpty) {
          return await showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('Do you want to save changes?'),
                actions: [
                  TextButton(
                    onPressed: () {
                      saveChanges();
                      Navigator.of(context).pop();
                      setState(() {});
                    },
                    child: const Text('Yes'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pushNamedAndRemoveUntil(
                        HomePage.routeName,
                        (route) => false,
                      );
                    },
                    child: const Text('No'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Cancel'),
                  ),
                ],
              );
            },
          );
        } else {
          return await Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => HomePage()),
              (Route<dynamic> route) => false);
        }
      },
    );
  }
}

class AttributeWidget extends StatelessWidget {
  const AttributeWidget({
    required this.name,
    required this.value,
    required this.callback,
    Key? key,
  }) : super(key: key);

  final String name;
  final dynamic value;
  final void Function(dynamic) callback;

  @override
  Widget build(BuildContext context) {
    // DateTime format =
    //     (value is DateTime) ? (value).toLocal() : DateTime.now().toUtc();
    var localValue = (value is DateTime)
        ? // now = (value as DateTime).toLocal(),
        // '${format.day}-${format.month}-${format.year} ${format.hour}:${format.minute}'
        //DateFormat("dd-MM-yyyy HH:mm").format(value)
        DateFormat.yMEd().add_jms().format(DateTime.now())
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
              ? const Color.fromARGB(255, 57, 57, 57)
              : Colors.white,
          child: ListTile(
            textColor: AppSettings.isDarkMode
                ? Colors.white
                : const Color.fromARGB(255, 48, 46, 46),
            title: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  Text(
                    '${'$name:'.padRight(13)}$localValue',
                    style: TextStyle(
                      color:
                          AppSettings.isDarkMode ? Colors.white : Colors.black,
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
    Key? key,
  }) : super(key: key);

  final String name;
  final dynamic value;
  final void Function(dynamic) callback;
  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppSettings.isDarkMode
          ? const Color.fromARGB(255, 57, 57, 57)
          : Colors.white,
      child: ListTile(
        textColor: AppSettings.isDarkMode
            ? Colors.white
            : const Color.fromARGB(255, 48, 46, 46),
        title: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              Text(
                '${'$name:  '}${(value as ListBuilder?)?.build()}',
                style: GoogleFonts.firaMono(),
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
//                 style: GoogleFonts.firaMono(),
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
