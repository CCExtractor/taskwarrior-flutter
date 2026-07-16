import 'dart:convert';

import 'package:taskwarrior/app/v3/models/annotation.dart';

class TaskForReplica {
  final int? modified;
  final int? entry;
  final String? due;
  final String? start;
  final String? wait;

  final String? status;
  final String? description;
  final List<String>? tags;
  final String uuid;
  final String? priority;
  final String? project;

  // Attributes surfaced from the TaskChampion Rust serializer.
  final bool? isBlocked;
  final bool? isBlocking;
  final List<String>? depends;
  final String? recur;
  final List<Annotation>? annotations;

  TaskForReplica({
    this.modified,
    this.entry,
    this.due,
    this.start,
    this.wait,
    this.status,
    this.description,
    this.tags,
    required this.uuid,
    this.priority,
    this.project,
    this.isBlocked,
    this.isBlocking,
    this.depends,
    this.recur,
    this.annotations,
  });

  static bool _parseBool(dynamic value) {
    if (value is bool) return value;
    return value?.toString().toLowerCase() == 'true';
  }

  factory TaskForReplica.fromJson(Map<String, dynamic> json) {
    return TaskForReplica(
      modified: json['modified'] is int
          ? json['modified'] as int
          : int.tryParse('${json['modified']}'),
      entry: json['entry'] is int
          ? json['entry'] as int
          : int.tryParse('${json['entry']}'),
      due: json['due'] != null
          ? DateTime.fromMillisecondsSinceEpoch(
                  (int.tryParse(json['due'].toString()) ?? 0) * 1000,
                  isUtc: true)
              .toUtc()
              .toString()
          : null,
      start: json['start'] != null
          ? DateTime.fromMillisecondsSinceEpoch(
                  (int.tryParse(json['start'].toString()) ?? 0) * 1000,
                  isUtc: true)
              .toUtc()
              .toString()
          : null,
      wait: json['wait'] != null
          ? DateTime.fromMillisecondsSinceEpoch(
                  (int.tryParse(json['wait'].toString()) ?? 0) * 1000,
                  isUtc: true)
              .toUtc()
              .toString()
          : null,
      status: json['status']?.toString(),
      description: json['description']?.toString(),
      tags: (json['tags'] is List)
          ? (json['tags'] as List).map((e) => e.toString()).toList()
          : (json['tags'] is String && json['tags'].toString().isNotEmpty)
              ? json['tags'].toString().split(' ')
              : null,
      uuid: json['uuid']?.toString() ?? '',
      priority: json['priority']?.toString(),
      project: json['project']?.toString(),
      isBlocked:
          json['is_blocked'] != null ? _parseBool(json['is_blocked']) : null,
      isBlocking:
          json['is_blocking'] != null ? _parseBool(json['is_blocking']) : null,
      depends: (json['depends'] is List)
          ? (json['depends'] as List).map((e) => e.toString()).toList()
          : null,
      recur: (json['recur'] != null && json['recur'].toString().isNotEmpty)
          ? json['recur'].toString()
          : null,
      annotations: (json['annotations'] is List)
          ? (json['annotations'] as List)
              .map((e) => Annotation.fromJson(Map<String, dynamic>.from(e)))
              .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (modified != null) 'modified': modified,
      if (entry != null) 'entry': entry,
      if (due != null) 'due': due,
      if (start != null) 'start': start,
      if (wait != null) 'wait': wait,
      if (status != null) 'status': status,
      if (description != null) 'description': description,
      if (tags != null) 'tags': tags,
      'uuid': uuid,
      if (priority != null) 'priority': priority,
      if (project != null) 'project': project,
      if (isBlocked != null) 'is_blocked': isBlocked,
      if (isBlocking != null) 'is_blocking': isBlocking,
      if (depends != null) 'depends': depends,
      if (recur != null) 'recur': recur,
      if (annotations != null)
        'annotations': annotations!.map((a) => a.toJson()).toList(),
    };
  }

  TaskForReplica copyWith({
    int? modified,
    int? entry,
    String? due,
    String? start,
    String? wait,
    String? status,
    String? description,
    List<String>? tags,
    String? uuid,
    String? priority,
    String? project,
    bool? isBlocked,
    bool? isBlocking,
    List<String>? depends,
    String? recur,
    List<Annotation>? annotations,
  }) {
    return TaskForReplica(
      modified: modified ?? this.modified,
      entry: entry ?? this.entry,
      due: due ?? this.due,
      start: start ?? this.start,
      wait: wait ?? this.wait,
      status: status ?? this.status,
      description: description ?? this.description,
      tags: tags ?? this.tags,
      uuid: uuid ?? this.uuid,
      priority: priority ?? this.priority,
      project: project ?? this.project,
      isBlocked: isBlocked ?? this.isBlocked,
      isBlocking: isBlocking ?? this.isBlocking,
      depends: depends ?? this.depends,
      recur: recur ?? this.recur,
      annotations: annotations ?? this.annotations,
    );
  }

  /// Computes the task's urgency using Taskwarrior's standard algorithm and its
  /// built-in default coefficients.
  ///
  /// TaskChampion (the storage/sync layer this app embeds) does not compute or
  /// store urgency — it is a Taskwarrior-CLI concept — so we reproduce the
  /// formula here from the attributes the Rust serializer surfaces. Urgency is a
  /// weighted sum of independent terms; the default coefficients match upstream
  /// Taskwarrior (Task.cpp `urgency_c`):
  ///
  ///   priority H/M/L = 6.0 / 3.9 / 1.8   due = 12.0     next(tag) = 15.0
  ///   active = 4.0    age = 2.0 (over 365d)    annotations = 1.0
  ///   tags = 1.0      project = 1.0    blocking = 8.0   blocked = -5.0
  ///   waiting = -3.0
  ///
  /// `scheduled` (+5.0) and user-defined attributes/coefficients are omitted:
  /// TaskChampion does not surface a scheduled date, and there are no UDAs here.
  ///
  /// [clock] overrides "now" (for age/due/waiting) so the result is testable.
  double computeUrgency({DateTime? clock}) {
    final DateTime now = (clock ?? DateTime.now()).toUtc();
    double urgency = 0.0;

    // Priority.
    switch (priority) {
      case 'H':
        urgency += 6.0;
        break;
      case 'M':
        urgency += 3.9;
        break;
      case 'L':
        urgency += 1.8;
        break;
    }

    // Belongs to a project.
    if (project != null && project!.isNotEmpty) urgency += 1.0;

    // Active (has been started).
    if (start != null && start!.isNotEmpty) urgency += 4.0;

    // Tags: 1 -> 0.8, 2 -> 0.9, 3+ -> 1.0. The special "next" tag adds 15.0.
    final List<String> tagList = tags ?? const <String>[];
    if (tagList.length == 1) {
      urgency += 0.8;
    } else if (tagList.length == 2) {
      urgency += 0.9;
    } else if (tagList.length >= 3) {
      urgency += 1.0;
    }
    if (tagList.contains('next')) urgency += 15.0;

    // Annotations: 1 -> 0.8, 2 -> 0.9, 3+ -> 1.0.
    final int annCount = annotations?.length ?? 0;
    if (annCount == 1) {
      urgency += 0.8;
    } else if (annCount == 2) {
      urgency += 0.9;
    } else if (annCount >= 3) {
      urgency += 1.0;
    }

    // Age: linear ramp from 0 to 1 over 365 days since entry, coefficient 2.0.
    if (entry != null) {
      final DateTime entryDate =
          DateTime.fromMillisecondsSinceEpoch(entry! * 1000, isUtc: true);
      final double ageDays = now.difference(entryDate).inSeconds / 86400.0;
      const double maxAge = 365.0;
      final double ageTerm =
          ageDays >= maxAge ? 1.0 : (ageDays <= 0 ? 0.0 : ageDays / maxAge);
      urgency += 2.0 * ageTerm;
    }

    // Due: ramp mapping ~21 days around the due date to 0.2..1.0, coefficient 12.
    final DateTime? dueDate = _parseDate(due);
    if (dueDate != null) {
      final double daysOverdue = now.difference(dueDate).inSeconds / 86400.0;
      double term;
      if (daysOverdue >= 7.0) {
        term = 1.0;
      } else if (daysOverdue >= -14.0) {
        term = ((daysOverdue + 14.0) * 0.8 / 21.0) + 0.2;
      } else {
        term = 0.2;
      }
      urgency += 12.0 * term;
    }

    // Waiting (wait date in the future).
    final DateTime? waitDate = _parseDate(wait);
    if (waitDate != null && waitDate.isAfter(now)) urgency -= 3.0;

    // Dependency relationships.
    if (isBlocking == true) urgency += 8.0;
    if (isBlocked == true) urgency -= 5.0;

    return urgency;
  }

  static DateTime? _parseDate(String? value) {
    if (value == null || value.isEmpty) return null;
    final DateTime? parsed = DateTime.tryParse(value);
    if (parsed != null) return parsed.toUtc();
    final int? epoch = int.tryParse(value);
    if (epoch != null) {
      return DateTime.fromMillisecondsSinceEpoch(epoch * 1000, isUtc: true);
    }
    return null;
  }

  @override
  String toString() => 'TaskForReplica(${jsonEncode(toJson())})';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TaskForReplica &&
        other.modified == modified &&
        other.due == due &&
        other.start == start &&
        other.wait == wait &&
        other.status == status &&
        other.description == description &&
        _listEquals(other.tags, tags) &&
        other.uuid == uuid &&
        other.priority == priority &&
        other.isBlocked == isBlocked &&
        other.isBlocking == isBlocking &&
        _listEquals(other.depends, depends) &&
        other.recur == recur;
  }

  @override
  int get hashCode => Object.hash(modified, due, status, description, uuid,
      priority, tags == null ? 0 : tags.hashCode, start, wait);

  static bool _listEquals(List? a, List? b) {
    if (a == null && b == null) return true;
    if (a == null || b == null) return false;
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }
}
