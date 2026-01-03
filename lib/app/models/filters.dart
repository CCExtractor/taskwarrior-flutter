import 'package:taskwarrior/app/services/tag_filter.dart';

class Filters {
  const Filters({
    required this.pendingFilter,
    required this.waitingFilter,
    required this.deletedFilter,
    required this.togglePendingFilter,
    required this.toggleWaitingFilter,
    required this.tagFilters,
    required this.projects,
    required this.projectFilter,
    required this.toggleProjectFilter,
  });

  final bool pendingFilter;
  final bool waitingFilter;
  final bool deletedFilter;

  final void Function() togglePendingFilter;
  final void Function() toggleWaitingFilter;

  final TagFilters tagFilters;
  final dynamic projects;
  final String projectFilter;
  final void Function(String) toggleProjectFilter;
}