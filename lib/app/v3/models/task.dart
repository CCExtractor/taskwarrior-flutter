import 'package:flutter/material.dart';
import 'package:taskwarrior/app/models/task_like.dart';
import "./annotation.dart";

/// The local/Taskserver task model. Stores `entry`/`modified` as strings; see
/// [TaskLike] for the normalized cross-model accessors.
class TaskForC implements TaskLike {
  final int id;
  @override
  final String description;
  @override
  final String? project;
  @override
  final String status;
  @override
  final String? uuid;

  /// Urgency as supplied by the server for this path. The TaskChampion path
  /// has no stored urgency and computes it instead — use [computeUrgency] when
  /// a value is needed regardless of sync mode.
  final double? urgency;
  @override
  final String? priority;
  @override
  final String? due;
  final String? end;
  final String entry;
  final String? modified;
  @override
  final List<String>? tags;
  // newer fields in the TaskChampion model
  @override
  final String? start;
  @override
  final String? wait;
  final String? rtype;
  @override
  final String? recur;
  @override
  final List<String>? depends;
  @override
  final List<Annotation>? annotations;

  TaskForC({
    required this.id,
    required this.description,
    required this.project,
    required this.status,
    required this.uuid,
    required this.urgency,
    required this.priority,
    required this.due,
    required this.end,
    required this.entry,
    required this.modified,
    required this.tags,
    required this.start,
    required this.wait,
    required this.rtype,
    required this.recur,
    required this.depends,
    required this.annotations,
  });

  factory TaskForC.fromJson(Map<String, dynamic> json) {
    debugPrint("Annotation fromJson: ${json['annotations'] == null}");
    return TaskForC(
        id: json['id'],
        description: json['description'],
        project: json['project'],
        status: json['status'],
        uuid: json['uuid'],
        urgency: (json['urgency'] as num?)?.toDouble(),
        priority: json['priority'],
        due: json['due'],
        end: json['end'],
        entry: json['entry'],
        modified: json['modified'],
        tags: json['tags']?.map<String>((tag) => tag.toString()).toList() ?? [],
        start: json['start'],
        wait: json['wait'],
        rtype: json['rtype'],
        recur: json['recur'],
        depends:
            json['depends']?.map<String>((d) => d.toString()).toList() ?? [],
        annotations: (json['annotations'] as List?)
                ?.map((a) => Annotation.fromJson(Map<String, dynamic>.from(a)))
                .toList() ??
            <Annotation>[]);
  }

  Map<String, dynamic> toJson() {
    debugPrint("TAGS: $tags");
    return {
      'id': id,
      'description': description,
      'project': project,
      'status': status,
      'uuid': uuid,
      'urgency': urgency,
      'priority': priority,
      'due': due,
      'end': end,
      'entry': entry,
      'modified': modified,
      'tags': tags,
      'start': start,
      'wait': wait,
      'rtype': rtype,
      'recur': recur,
      'depends': depends,
      'annotations': annotations != null
          ? annotations?.map((a) => a.toJson()).toList()
          : <Map<String, dynamic>>[],
    };
  }

  /// Normalized creation time. This model stores `entry` as a string, in
  /// either ISO-8601 or Taskwarrior's compact form.
  @override
  DateTime? get entryDate => parseTaskDate(entry);

  /// Normalized last-modified time, stored as a string like [entry].
  @override
  DateTime? get modifiedDate => parseTaskDate(modified);

  /// Unknown on this path: deciding whether a dependency is still *unresolved*
  /// requires the full task set, which this model does not carry. Only the
  /// TaskChampion path reports a definite value (see [TaskLike.isBlocked]).
  @override
  bool? get isBlocked => null;

  @override
  bool? get isBlocking => null;

  @override
  String toString() {
    return "TaskForC(${toJson().toString()})";
  }
}
