import 'package:flutter/material.dart';

class TaskForC {
  final int id;
  final String description;
  final String? project;
  final String status;
  final String? uuid;
  final double? urgency;
  final String? priority;
  final String? due;
  final String? end;
  final String entry;
  final String? modified;
  final List<dynamic>? tags;

  TaskForC(
      {required this.id,
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
      required this.tags});

  factory TaskForC.fromJson(Map<String, dynamic> json) {
    return TaskForC(
        id: json['id'],
        description: json['description'],
        project: json['project'],
        status: json['status'],
        uuid: json['uuid'],
        urgency: json['urgency'].toDouble(),
        priority: json['priority'],
        due: json['due'],
        end: json['end'],
        entry: json['entry'],
        modified: json['modified'],
        tags: json['tags']);
  }
  factory TaskForC.fromDbJson(Map<String, dynamic> json) {
    debugPrint("FROM: $json");
    return TaskForC(
        id: json['id'],
        description: json['description'],
        project: json['project'],
        status: json['status'],
        uuid: json['uuid'],
        urgency: json['urgency'].toDouble(),
        priority: json['priority'],
        due: json['due'],
        end: json['end'],
        entry: json['entry'],
        modified: json['modified'],
        tags: json['tags'].toString().split(' '));
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
      'tags': tags
    };
  }

  Map<String, dynamic> toDbJson() {
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
      'tags': tags != null ? tags?.join(" ") : ""
    };
  }
}
