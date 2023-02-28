// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

import 'package:taskwarrior/config/app_settings.dart';
import 'package:taskwarrior/model/storage/storage_widget.dart';
import 'package:taskwarrior/views/home/home.dart';
import 'package:taskwarrior/widgets/project_filter.dart';
import 'package:taskwarrior/widgets/tag_filter.dart';

class FilterDrawer extends StatelessWidget {
  const FilterDrawer(this.filters, {Key? key}) : super(key: key);

  final Filters filters;

  @override
  Widget build(BuildContext context) {
    var storageWidget = StorageWidget.of(context);
    return Drawer(
      backgroundColor: AppSettings.isDarkMode
          ? Color.fromARGB(255, 29, 29, 29)
          : Colors.white,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: ListView(
            primary: false,
            key: const PageStorageKey('tags-filter'),
            children: [
              Card(
                child: ListTile(
                  title: Text(
                    'filter:${filters.pendingFilter ? 'status : pending' : 'status : archived'}',
                  ),
                  onTap: filters.togglePendingFilter,
                  tileColor: AppSettings.isDarkMode
                      ? Color.fromARGB(255, 48, 46, 46)
                      : Color.fromARGB(255, 220, 216, 216),
                  textColor: AppSettings.isDarkMode
                      ? Colors.white
                      : Color.fromARGB(255, 48, 46, 46),
                ),
              ),
              const Divider(),
              ProjectsColumn(
                filters.projects,
                filters.projectFilter,
                filters.toggleProjectFilter,
              ),
              const Divider(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: TagFiltersWrap(filters.tagFilters),
              ),
              const Divider(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  'Sort By : ',
                  style: TextStyle(
                      color: (AppSettings.isDarkMode
                          ? Colors.white
                          : Colors.black),
                      fontStyle: FontStyle.normal,
                      fontSize: 20),
                  textAlign: TextAlign.left,
                ),
              ),
              const Divider(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
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
                              )
                            : Text(sort),
                        selected: false,
                        onSelected: (_) {
                          if (storageWidget.selectedSort == '$sort+') {
                            storageWidget.selectSort('$sort-');
                          } else {
                            storageWidget.selectSort('$sort+');
                          }
                        },
                        labelStyle: TextStyle(
                            color: AppSettings.isDarkMode
                                ? Colors.black
                                : Colors.white),
                        backgroundColor: AppSettings.isDarkMode
                            ? Color.fromARGB(255, 220, 216, 216)
                            : Color.fromARGB(255, 48, 46, 46),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// class TagFilterMetadata {
//   const TagFilterMetadata({
//     required this.display,
//     required this.selected,
//   });

//   final String display;
//   final bool selected;
// }

// class TagFilters {
//   const TagFilters({
//     required this.tagUnion,
//     required this.toggleTagUnion,
//     required this.tags,
//     required this.toggleTagFilter,
//   });

//   final bool tagUnion;
//   final void Function() toggleTagUnion;
//   final Map<String, TagFilterMetadata> tags;
//   final void Function(String) toggleTagFilter;
// }

// class TagFiltersWrap extends StatelessWidget {
//   const TagFiltersWrap(this.filters, {super.key});

//   final TagFilters filters;

//   @override
//   Widget build(BuildContext context) {
//     return Wrap(
//       spacing: 4,
//       children: [
//         FilterChip(
//             onSelected: (_) => filters.toggleTagUnion(),
//             label: Text(filters.tagUnion ? 'OR' : 'AND',
//                 style: GoogleFonts.firaMono())),
//         for (var entry in filters.tags.entries)
//           FilterChip(
//             onSelected: (_) => filters.toggleTagFilter(entry.key),
//             label: Text(
//               entry.value.display,
//               style: GoogleFonts.firaMono(
//                 fontWeight: entry.value.selected ? FontWeight.w700 : null,
//               ),
//             ),
//           ),
//       ],
//     );
//   }
// }
