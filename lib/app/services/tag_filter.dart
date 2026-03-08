import 'package:flutter/material.dart';
import 'package:taskwarrior/app/models/tag_filters.dart';

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
          label: Text(filters.tagUnion ? 'OR' : 'AND'),
        ),
        for (var entry in filters.tags.entries)
          FilterChip(
            onSelected: (_) => filters.toggleTagFilter(entry.key),
            label: Text(entry.value.display),
          ),
      ],
    );
  }
}
