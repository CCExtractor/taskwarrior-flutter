// ignore_for_file: depend_on_referenced_packages

import 'dart:convert';

import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

import 'package:taskwarrior/model/json.dart';
import 'package:taskwarrior/widgets/taskw.dart';

part 'task.g.dart';

final coreAttributes = [
  'id',
  'status',
  'uuid',
  'entry',
  'description',
  'start',
  'end',
  'due',
  'until',
  'wait',
  'modified',
  'scheduled',
  'recur',
  'mask',
  'imask',
  'parent',
  'project',
  'priority',
  'depends',
  'tags',
  'annotations',
  'urgency',
];

abstract class Task implements Built<Task, TaskBuilder> {
  factory Task([void Function(TaskBuilder) updates]) = _$Task;
  Task._() {
    validateTaskDescription(description);
    if (project != null) {
      validateTaskProject(project!);
    }
    if (tags != null) {
      tags!.forEach(validateTaskTags);
    }
  }

  static Task fromJson(Map json) {
    var udas = Map.of(json)
      ..removeWhere((key, _) => coreAttributes.contains(key));
    var result = Map.of(json)
      ..removeWhere((key, _) => !coreAttributes.contains(key))
      ..['depends'] = ((x) => (x is String) ? x.split(',') : x)(json['depends'])
      ..['imask'] = (json['imask'] as num?)?.toInt()
      ..['udas'] = (udas.isEmpty) ? null : jsonEncode(udas);
    return serializers.deserializeWith(Task.serializer, result)!;
  }

  Map<String, dynamic> toJson() {
    var result = serializers.serializeWith(Task.serializer, this)!
        as Map<String, dynamic>;

    if (result['depends'] != null) {
      result['depends'] = (result['depends'] as List).join(',');
    }

    if (result['udas'] != null) {
      var udas = Map<String, dynamic>.of(json.decode(result['udas']));
      result
        ..remove('udas')
        ..addAll(udas);
    }

    return result;
  }

  int? get id;
  String get status;
  String get uuid;
  DateTime get entry;
  String get description;
  DateTime? get start;
  DateTime? get end;
  DateTime? get due;
  DateTime? get until;
  DateTime? get wait;
  DateTime? get modified;
  DateTime? get scheduled;
  String? get recur;
  String? get mask;
  int? get imask;
  String? get parent;
  String? get project;
  String? get priority;
  BuiltList<String>? get depends;
  BuiltList<String>? get tags;
  BuiltList<Annotation>? get annotations;
  String? get udas;
  double? get urgency;

  static Serializer<Task> get serializer => _$taskSerializer;
}
