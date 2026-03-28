// lib/app/models/tag_filters.dart

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
