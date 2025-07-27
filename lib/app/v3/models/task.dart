import 'package:flutter/foundation.dart';
import 'package:taskwarrior/app/v3/models/annotation.dart';

class TaskForC {
  final int id;
  final String description;
  final String? project;
  final String status;
  final String? uuid;
  final double? urgency;
  final String? priority;
  final String? due;
  final String? start; // Added: Corresponds to Go's 'Start'
  final String? end;
  final String entry;
  final String? wait; // Added: Corresponds to Go's 'Wait'
  final String? modified;
  final List<String>? tags; // Changed to List<String> to match Go's []string
  final List<String>? depends; // Added: Corresponds to Go's 'Depends'
  final String? rtype; // Added: Corresponds to Go's 'RType'
  final String? recur; // Added: Corresponds to Go's 'Recur'
  final List<Annotation>?
      annotations; // Added: Corresponds to Go's 'Annotations'

  TaskForC({
    required this.id,
    required this.description,
    this.project, // Made nullable to match Go's typical handling of empty strings for non-required fields
    required this.status,
    this.uuid,
    this.urgency,
    this.priority,
    this.due,
    this.start,
    this.end,
    required this.entry,
    this.wait,
    this.modified,
    this.tags,
    this.depends,
    this.rtype,
    this.recur,
    this.annotations,
  });

  // Factory constructor for parsing JSON from API responses
  factory TaskForC.fromJson(Map<String, dynamic> json) {
    return TaskForC(
      id: json['id'],
      description: json['description'],
      project: json['project'],
      status: json['status'],
      uuid: json['uuid'],
      // Safely parse urgency as double, handling potential null or int from JSON
      urgency: (json['urgency'] as num?)?.toDouble(),
      priority: json['priority'],
      due: json['due'],
      start: json['start'],
      end: json['end'],
      entry: json['entry'],
      wait: json['wait'],
      modified: json['modified'],
      // Ensure tags are parsed as List<String>
      tags: (json['tags'] as List?)?.map((e) => e.toString()).toList(),
      // Ensure depends are parsed as List<String>
      depends: (json['depends'] as List?)?.map((e) => e.toString()).toList(),
      rtype: json['rtype'],
      recur: json['recur'],
      // Parse list of annotation maps into list of Annotation objects
      annotations: (json['annotations'] as List?)
          ?.map((e) => Annotation.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  // Method to convert TaskForC object to a JSON map for API requests
  Map<String, dynamic> toJson() {
    debugPrint("TAGS TO JSON: $tags");
    return {
      'id': id,
      'description': description,
      'project': project,
      'status': status,
      'uuid': uuid,
      'urgency': urgency,
      'priority': priority,
      'due': due,
      'start': start,
      'end': end,
      'entry': entry,
      'wait': wait,
      'modified': modified,
      'tags': tags,
      'depends': depends,
      'rtype': rtype,
      'recur': recur,
      // Convert list of Annotation objects to list of JSON maps
      'annotations': annotations?.map((e) => e.toJson()).toList(),
    };
  }
}
