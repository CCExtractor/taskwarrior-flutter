import 'dart:convert';

class TaskForReplica {
  final int? modified;
  final String? due;
  final String? start;
  final String? wait;

  final String? status;
  final String? description;
  final String? entry;
  final List<String>? tags;
  final String uuid;
  final String? priority;
  final String? project;

  // Recurrence fields
  final String? recur;
  final String? rtype;
  final String? mask;
  final String? imask;
  final String? parent;

  TaskForReplica({
    this.modified,
    this.due,
    this.start,
    this.wait,
    this.status,
    this.description,
    this.entry,
    this.tags,
    required this.uuid,
    this.priority,
    this.project,
    this.recur,
    this.rtype,
    this.mask,
    this.imask,
    this.parent,
  });

  static String? _parseDate(dynamic value) {
    if (value == null) return null;
    final raw = value.toString().trim();
    if (raw.isEmpty) return null;
    final epoch = int.tryParse(raw);
    if (epoch != null) {
      return DateTime.fromMillisecondsSinceEpoch(epoch * 1000, isUtc: true)
          .toUtc()
          .toIso8601String();
    }
    final parsed = DateTime.tryParse(raw);
    return parsed?.toUtc().toIso8601String();
  }

  factory TaskForReplica.fromJson(Map<String, dynamic> json) {
    return TaskForReplica(
      modified: json['modified'] is int
          ? json['modified'] as int
          : int.tryParse('${json['modified']}'),
      due: _parseDate(json['due']),
      start: _parseDate(json['start']),
      wait: _parseDate(json['wait']),
      status: json['status']?.toString(),
      description: json['description']?.toString(),
      entry: _parseDate(json['entry']),
      tags: (json['tags'] is List)
          ? (json['tags'] as List).map((e) => e.toString()).toList()
          : (json['tags'] is String && json['tags'].toString().isNotEmpty)
              ? json['tags'].toString().split(' ')
              : null,
      uuid: json['uuid']?.toString() ?? '',
      priority: json['priority']?.toString(),
      project: json['project']?.toString(),
      recur: json['recur']?.toString(),
      rtype: json['rtype']?.toString(),
      mask: json['mask']?.toString(),
      imask: json['imask']?.toString(),
      parent: json['parent']?.toString(),
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
      if (entry != null) 'entry': entry,
      if (tags != null) 'tags': tags,
      'uuid': uuid,
      if (priority != null) 'priority': priority,
      if (project != null) 'project': project,
      if (recur != null) 'recur': recur,
      if (rtype != null) 'rtype': rtype,
      if (mask != null) 'mask': mask,
      if (imask != null) 'imask': imask,
      if (parent != null) 'parent': parent,
    };
  }

  TaskForReplica copyWith({
    int? modified,
    String? due,
    String? start,
    String? wait,
    String? status,
    String? description,
    String? entry,
    List<String>? tags,
    String? uuid,
    String? priority,
    String? project,
    String? recur,
    String? rtype,
    String? mask,
    String? imask,
    String? parent,
  }) {
    return TaskForReplica(
      modified: modified ?? this.modified,
      due: due ?? this.due,
      start: start ?? this.start,
      wait: wait ?? this.wait,
      status: status ?? this.status,
      description: description ?? this.description,
      entry: entry ?? this.entry,
      tags: tags ?? this.tags,
      uuid: uuid ?? this.uuid,
      priority: priority ?? this.priority,
      project: project ?? this.project,
      recur: recur ?? this.recur,
      rtype: rtype ?? this.rtype,
      mask: mask ?? this.mask,
      imask: imask ?? this.imask,
      parent: parent ?? this.parent,
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
        other.entry == entry &&
        _listEquals(other.tags, tags) &&
        other.uuid == uuid &&
        other.priority == priority &&
        other.recur == recur &&
        other.rtype == rtype;
  }

  @override
  int get hashCode => Object.hash(
      modified,
      due,
      status,
      description,
      uuid,
      priority,
      tags == null ? 0 : tags.hashCode,
      start,
      wait,
      recur,
      rtype,
      entry);

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
