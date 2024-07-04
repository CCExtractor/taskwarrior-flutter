// ignore_for_file: depend_on_referenced_packages

import 'package:built_collection/built_collection.dart';
import 'package:built_value/serializer.dart';
import 'package:built_value/standard_json_plugin.dart';
import 'package:taskwarrior/app/models/json/annotation.dart';
import 'package:taskwarrior/app/models/json/iso_8601_basic.dart';
import 'package:taskwarrior/app/models/json/task.dart';



part 'serializers.g.dart';

@SerializersFor([
  Annotation,
  Task,
])
final Serializers serializers = (_$serializers.toBuilder()
      ..add(Iso8601BasicDateTimeSerializer())
      ..addPlugin(StandardJsonPlugin()))
    .build();
