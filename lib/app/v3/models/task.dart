import 'package:flutter/material.dart';
import "./annotation.dart";

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
  final List<String>? tags;
  // newer feilds in CCSync Model
  final String? start;
  final String? wait;
  final String? rtype;
  final String? recur;
  final List<String>? depends;
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
        urgency: json['urgency'].toDouble(),
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
        annotations: <Annotation>[]);
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

  @override
  String toString() {
    return "TaskForC(${toJson().toString()})";
  }
}
