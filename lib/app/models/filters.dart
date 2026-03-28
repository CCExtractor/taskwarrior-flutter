// lib/app/models/filters.dart

import 'package:taskwarrior/app/models/tag_filters.dart';


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