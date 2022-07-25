// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taskwarrior/model/storage/storage_widget.dart';

class SortDrawer extends StatefulWidget {
  const SortDrawer({Key? key}) : super(key: key);

  @override
  _SortDrawerState createState() => _SortDrawerState();
}

class _SortDrawerState extends State<SortDrawer> {
  @override
  Widget build(BuildContext context) {
    var storageWidget = StorageWidget.of(context);

    return Scaffold(
        body: Column(children: <Widget>[
      Align(
          alignment: AlignmentDirectional.centerStart,
          child: Padding(
            padding: const EdgeInsets.all(4),
            child: Wrap(
              spacing: 8,
              runSpacing: 4,
              children: [
                for (var sort in [
                  'Created',
                  'Modified',
                  'Start Time',
                  'Due till',
                  'Priority',
                  'Project',
                  'Tags',
                  'Urgency',
                ])
                  ChoiceChip(
                    label: (storageWidget.selectedSort.startsWith(sort))
                        ? Text(
                            storageWidget.selectedSort,
                            style: GoogleFonts.firaMono(
                              fontWeight: FontWeight.w700,
                            ),
                          )
                        : Text(sort, style: GoogleFonts.firaMono()),
                    selected: false,
                    onSelected: (_) {
                      if (storageWidget.selectedSort == '$sort+') {
                        storageWidget.selectSort('$sort-');
                      } else {
                        storageWidget.selectSort('$sort+');
                      }
                    },
                  ),
              ],
            ),
          ))
    ]));
  }
}
