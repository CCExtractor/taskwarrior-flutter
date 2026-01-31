class Filters {
  const Filters({
    required this.pendingFilter,
    required this.waitingFilter,
    required this.completedFilter,  // NEW
    required this.deletedFilter,    // NEW
    required this.togglePendingFilter,
    required this.toggleWaitingFilter,
    required this.toggleCompletedFilter,  // NEW
    required this.toggleDeletedFilter,    // NEW
    required this.tagFilters,
    required this.projects,
    required this.projectFilter,
    required this.toggleProjectFilter,
  });

  final bool pendingFilter;
  final bool waitingFilter;
  final bool completedFilter;  // NEW
  final bool deletedFilter;    // NEW
  final void Function() togglePendingFilter;
  final void Function() toggleWaitingFilter;
  final void Function() toggleCompletedFilter;  // NEW
  final void Function() toggleDeletedFilter;    // NEW
  final TagFilters tagFilters;
  final dynamic projects;
  final String projectFilter;
  final void Function(String) toggleProjectFilter;
}