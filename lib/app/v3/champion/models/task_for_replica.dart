import 'dart:convert';

class TaskForReplica {
  final int? modified;
  final String? due;
  final String? start;
  final String? wait;

  final String? status;
  final String? description;
  final List<String>? tags;
  final String uuid;
  final String? priority;
  final String? project;

  TaskForReplica({
    this.modified,
    this.due,
    this.start,
    this.wait,
    this.status,
    this.description,
    this.tags,
    required this.uuid,
    this.priority,
    this.project,
  });

  factory TaskForReplica.fromJson(Map<String, dynamic> json) {
    return TaskForReplica(
      modified: json['modified'] is int
          ? json['modified'] as int
          : int.tryParse('${json['modified']}'),
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
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (modified != null) 'modified': modified,
      if (due != null) 'due': due,
      if (start != null) 'start': start,
      if (wait != null) 'wait': wait,
      if (status != null) 'status': status,
      if (description != null) 'description': description,
      if (tags != null) 'tags': tags,
      'uuid': uuid,
      if (priority != null) 'priority': priority,
      if (project != null) 'project': project,
    };
  }

  TaskForReplica copyWith({
    int? modified,
    String? due,
    String? start,
    String? wait,
    String? status,
    String? description,
    List<String>? tags,
    String? uuid,
    String? priority,
  }) {
    return TaskForReplica(
      modified: modified ?? this.modified,
      due: due ?? this.due,
      start: start ?? this.start,
      wait: wait ?? this.wait,
      status: status ?? this.status,
      description: description ?? this.description,
      tags: tags ?? this.tags,
      uuid: uuid ?? this.uuid,
      priority: priority ?? this.priority,
      project: project ?? project,
    );
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
        other.priority == priority;
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
