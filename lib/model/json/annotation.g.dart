// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'annotation.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<Annotation> _$annotationSerializer = new _$AnnotationSerializer();

class _$AnnotationSerializer implements StructuredSerializer<Annotation> {
  @override
  final Iterable<Type> types = const [Annotation, _$Annotation];
  @override
  final String wireName = 'Annotation';

  @override
  Iterable<Object?> serialize(Serializers serializers, Annotation object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'entry',
      serializers.serialize(object.entry,
          specifiedType: const FullType(DateTime)),
      'description',
      serializers.serialize(object.description,
          specifiedType: const FullType(String)),
    ];

    return result;
  }

  @override
  Annotation deserialize(Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new AnnotationBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'entry':
          result.entry = serializers.deserialize(value,
              specifiedType: const FullType(DateTime))! as DateTime;
          break;
        case 'description':
          result.description = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
      }
    }

    return result.build();
  }
}

class _$Annotation extends Annotation {
  @override
  final DateTime entry;
  @override
  final String description;

  factory _$Annotation([void Function(AnnotationBuilder)? updates]) =>
      (new AnnotationBuilder()..update(updates))._build();

  _$Annotation._({required this.entry, required this.description}) : super._() {
    BuiltValueNullFieldError.checkNotNull(entry, r'Annotation', 'entry');
    BuiltValueNullFieldError.checkNotNull(
        description, r'Annotation', 'description');
  }

  @override
  Annotation rebuild(void Function(AnnotationBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AnnotationBuilder toBuilder() => new AnnotationBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Annotation &&
        entry == other.entry &&
        description == other.description;
  }

  @override
  int get hashCode {
    return $jf($jc($jc(0, entry.hashCode), description.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'Annotation')
          ..add('entry', entry)
          ..add('description', description))
        .toString();
  }
}

class AnnotationBuilder implements Builder<Annotation, AnnotationBuilder> {
  _$Annotation? _$v;

  DateTime? _entry;
  DateTime? get entry => _$this._entry;
  set entry(DateTime? entry) => _$this._entry = entry;

  String? _description;
  String? get description => _$this._description;
  set description(String? description) => _$this._description = description;

  AnnotationBuilder();

  AnnotationBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _entry = $v.entry;
      _description = $v.description;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Annotation other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$Annotation;
  }

  @override
  void update(void Function(AnnotationBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  Annotation build() => _build();

  _$Annotation _build() {
    final _$result = _$v ??
        new _$Annotation._(
            entry: BuiltValueNullFieldError.checkNotNull(
                entry, r'Annotation', 'entry'),
            description: BuiltValueNullFieldError.checkNotNull(
                description, r'Annotation', 'description'));
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,deprecated_member_use_from_same_package,lines_longer_than_80_chars,no_leading_underscores_for_local_identifiers,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new,unnecessary_lambdas
