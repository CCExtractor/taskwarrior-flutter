import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';

import 'package:taskwarrior/config/app_settings.dart';
import 'package:taskwarrior/config/taskwarriorcolors.dart';

class TagFilterMetadata {
  const TagFilterMetadata({
    required this.display,
    required this.selected,
  });

  final String display;
  final bool selected;
}

class TagFilters {
  const TagFilters({
    required this.tagUnion,
    required this.toggleTagUnion,
    required this.tags,
    required this.toggleTagFilter,
  });

  final bool tagUnion;
  final void Function() toggleTagUnion;
  final Map<String, TagFilterMetadata> tags;
  final void Function(String) toggleTagFilter;
}

class TagFiltersWrap extends StatelessWidget {
  const TagFiltersWrap(this.filters, {super.key});

  final TagFilters filters;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 4,
      children: [
        FilterChip(
          onSelected: (_) => filters.toggleTagUnion(),
          label: Text(filters.tagUnion ? 'OR' : 'AND',
              style: GoogleFonts.poppins(
                  color: AppSettings.isDarkMode
                      ? TaskWarriorColors.black
                      : TaskWarriorColors.white)),
          backgroundColor: AppSettings.isDarkMode
              ? TaskWarriorColors.kLightSecondaryBackgroundColor
              : TaskWarriorColors.kprimaryBackgroundColor,
        ),
        for (var entry in filters.tags.entries)
          FilterChip(
            onSelected: (_) => filters.toggleTagFilter(entry.key),
            label: Text(
              entry.value.display,
              style: GoogleFonts.poppins(
                  fontWeight: entry.value.selected ? FontWeight.w700 : null,
                  color: AppSettings.isDarkMode
                      ? TaskWarriorColors.black
                      : TaskWarriorColors.white),
            ),
            backgroundColor: AppSettings.isDarkMode
                ? TaskWarriorColors.kLightSecondaryBackgroundColor
                : TaskWarriorColors.kprimaryBackgroundColor,
          ),
      ],
    );
  }
}
