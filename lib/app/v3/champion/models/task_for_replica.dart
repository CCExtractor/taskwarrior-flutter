import 'dart:convert';

import 'package:taskwarrior/app/models/task_like.dart';
import 'package:taskwarrior/app/models/task_urgency.dart';
import 'package:taskwarrior/app/v3/models/annotation.dart';

/// The TaskChampion-path task model. Stores `entry`/`modified` as epoch
/// seconds; see [TaskLike] for the normalized cross-model accessors.
class TaskForReplica implements TaskLike {
  final int? modified;
  final int? entry;
  @override
  final String? due;
  @override
  final String? start;
  @override
  final String? wait;

  @override
  final String? status;
  @override
  final String? description;
  @override
  final List<String>? tags;
  @override
  final String uuid;
  @override
  final String? priority;
  @override
  final String? project;

  // Attributes surfaced from the TaskChampion Rust serializer.
  @override
  final bool? isBlocked;
  @override
  final bool? isBlocking;
  @override
  final List<String>? depends;
  @override
  final String? recur;
  @override
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

  /// Normalized creation time. This model stores `entry` as epoch seconds.
  @override
  DateTime? get entryDate => epochToDate(entry);

  /// Normalized last-modified time, stored as epoch seconds.
  @override
  DateTime? get modifiedDate => epochToDate(modified);

  /// Computes this task's urgency with Taskwarrior's standard algorithm.
  /// The formula and its coefficients live in [computeTaskUrgency], shared
  /// with every other task model via [TaskLike].
  double computeUrgency({DateTime? clock}) =>
      computeTaskUrgency(this, clock: clock);

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
