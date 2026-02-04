// lib/app/models/filters.dart

class TagFilterMetadata {
  final String display;
  final bool selected;

  TagFilterMetadata({
    required this.display,
    required this.selected,
  });
}

class TagFilters {
  final bool tagUnion;
  final void Function() toggleTagUnion;
  final Map<String, TagFilterMetadata> tags;
  final void Function(String) toggleTagFilter;

  TagFilters({
    required this.tagUnion,
    required this.toggleTagUnion,
    required this.tags,
    required this.toggleTagFilter,
  });
}

class Filters {
  const Filters({
    required this.pendingFilter,
    required this.waitingFilter,
    required this.completedFilter,
    required this.deletedFilter,
    required this.togglePendingFilter,
    required this.toggleWaitingFilter,
    required this.toggleCompletedFilter,
    required this.toggleDeletedFilter,
    required this.tagFilters,
    required this.projects,
    required this.projectFilter,
    required this.toggleProjectFilter,
  });

  final bool pendingFilter;
  final bool waitingFilter;
  final bool completedFilter;
  final bool deletedFilter;
  final void Function() togglePendingFilter;
  final void Function() toggleWaitingFilter;
  final void Function() toggleCompletedFilter;
  final void Function() toggleDeletedFilter;
  final TagFilters tagFilters;
  final dynamic projects;
  final String projectFilter;
  final void Function(String) toggleProjectFilter;
}