// ignore_for_file: depend_on_referenced_packages

import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

import 'package:taskwarrior/model/json.dart';

part 'annotation.g.dart';

abstract class Annotation implements Built<Annotation, AnnotationBuilder> {
  factory Annotation([void Function(AnnotationBuilder) updates]) = _$Annotation;
  Annotation._();

  static Annotation fromJson(dynamic json) {
    return serializers.deserializeWith(Annotation.serializer, json)!;
  }

  DateTime get entry;
  String get description;

  Map toJson() =>
      serializers.serializeWith(Annotation.serializer, this)! as Map;

  static Serializer<Annotation> get serializer => _$annotationSerializer;
}
