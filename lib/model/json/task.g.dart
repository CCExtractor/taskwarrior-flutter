// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<Task> _$taskSerializer = new _$TaskSerializer();

class _$TaskSerializer implements StructuredSerializer<Task> {
  @override
  final Iterable<Type> types = const [Task, _$Task];
  @override
  final String wireName = 'Task';

  @override
  Iterable<Object?> serialize(Serializers serializers, Task object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'status',
      serializers.serialize(object.status,
          specifiedType: const FullType(String)),
      'uuid',
      serializers.serialize(object.uuid, specifiedType: const FullType(String)),
      'entry',
      serializers.serialize(object.entry,
          specifiedType: const FullType(DateTime)),
      'description',
      serializers.serialize(object.description,
          specifiedType: const FullType(String)),
    ];
    Object? value;
    value = object.id;
    if (value != null) {
      result
        ..add('id')
        ..add(serializers.serialize(value, specifiedType: const FullType(int)));
    }
    value = object.start;
    if (value != null) {
      result
        ..add('start')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(DateTime)));
    }
    value = object.end;
    if (value != null) {
      result
        ..add('end')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(DateTime)));
    }
    value = object.due;
    if (value != null) {
      result
        ..add('due')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(DateTime)));
    }
    value = object.until;
    if (value != null) {
      result
        ..add('until')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(DateTime)));
    }
    value = object.wait;
    if (value != null) {
      result
        ..add('wait')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(DateTime)));
    }
    value = object.modified;
    if (value != null) {
      result
        ..add('modified')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(DateTime)));
    }
    value = object.scheduled;
    if (value != null) {
      result
        ..add('scheduled')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(DateTime)));
    }
    value = object.recur;
    if (value != null) {
      result
        ..add('recur')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.mask;
    if (value != null) {
      result
        ..add('mask')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.imask;
    if (value != null) {
      result
        ..add('imask')
        ..add(serializers.serialize(value, specifiedType: const FullType(int)));
    }
    value = object.parent;
    if (value != null) {
      result
        ..add('parent')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.project;
    if (value != null) {
      result
        ..add('project')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.priority;
    if (value != null) {
      result
        ..add('priority')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.depends;
    if (value != null) {
      result
        ..add('depends')
        ..add(serializers.serialize(value,
            specifiedType:
                const FullType(BuiltList, const [const FullType(String)])));
    }
    value = object.tags;
    if (value != null) {
      result
        ..add('tags')
        ..add(serializers.serialize(value,
            specifiedType:
                const FullType(BuiltList, const [const FullType(String)])));
    }
    value = object.annotations;
    if (value != null) {
      result
        ..add('annotations')
        ..add(serializers.serialize(value,
            specifiedType:
                const FullType(BuiltList, const [const FullType(Annotation)])));
    }
    value = object.udas;
    if (value != null) {
      result
        ..add('udas')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.urgency;
    if (value != null) {
      result
        ..add('urgency')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(double)));
    }
    return result;
  }

  @override
  Task deserialize(Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new TaskBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'id':
          result.id = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int?;
          break;
        case 'status':
          result.status = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'uuid':
          result.uuid = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'entry':
          result.entry = serializers.deserialize(value,
              specifiedType: const FullType(DateTime))! as DateTime;
          break;
        case 'description':
          result.description = serializers.deserialize(value,
              specifiedType: const FullType(String))! as String;
          break;
        case 'start':
          result.start = serializers.deserialize(value,
              specifiedType: const FullType(DateTime)) as DateTime?;
          break;
        case 'end':
          result.end = serializers.deserialize(value,
              specifiedType: const FullType(DateTime)) as DateTime?;
          break;
        case 'due':
          result.due = serializers.deserialize(value,
              specifiedType: const FullType(DateTime)) as DateTime?;
          break;
        case 'until':
          result.until = serializers.deserialize(value,
              specifiedType: const FullType(DateTime)) as DateTime?;
          break;
        case 'wait':
          result.wait = serializers.deserialize(value,
              specifiedType: const FullType(DateTime)) as DateTime?;
          break;
        case 'modified':
          result.modified = serializers.deserialize(value,
              specifiedType: const FullType(DateTime)) as DateTime?;
          break;
        case 'scheduled':
          result.scheduled = serializers.deserialize(value,
              specifiedType: const FullType(DateTime)) as DateTime?;
          break;
        case 'recur':
          result.recur = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'mask':
          result.mask = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'imask':
          result.imask = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int?;
          break;
        case 'parent':
          result.parent = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'project':
          result.project = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'priority':
          result.priority = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'depends':
          result.depends.replace(serializers.deserialize(value,
                  specifiedType: const FullType(
                      BuiltList, const [const FullType(String)]))!
              as BuiltList<Object?>);
          break;
        case 'tags':
          result.tags.replace(serializers.deserialize(value,
                  specifiedType: const FullType(
                      BuiltList, const [const FullType(String)]))!
              as BuiltList<Object?>);
          break;
        case 'annotations':
          result.annotations.replace(serializers.deserialize(value,
                  specifiedType: const FullType(
                      BuiltList, const [const FullType(Annotation)]))!
              as BuiltList<Object?>);
          break;
        case 'udas':
          result.udas = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'urgency':
          result.urgency = serializers.deserialize(value,
              specifiedType: const FullType(double)) as double?;
          break;
      }
    }

    return result.build();
  }
}

class _$Task extends Task {
  @override
  final int? id;
  @override
  final String status;
  @override
  final String uuid;
  @override
  final DateTime entry;
  @override
  final String description;
  @override
  final DateTime? start;
  @override
  final DateTime? end;
  @override
  final DateTime? due;
  @override
  final DateTime? until;
  @override
  final DateTime? wait;
  @override
  final DateTime? modified;
  @override
  final DateTime? scheduled;
  @override
  final String? recur;
  @override
  final String? mask;
  @override
  final int? imask;
  @override
  final String? parent;
  @override
  final String? project;
  @override
  final String? priority;
  @override
  final BuiltList<String>? depends;
  @override
  final BuiltList<String>? tags;
  @override
  final BuiltList<Annotation>? annotations;
  @override
  final String? udas;
  @override
  final double? urgency;

  factory _$Task([void Function(TaskBuilder)? updates]) =>
      (new TaskBuilder()..update(updates))._build();

  _$Task._(
      {this.id,
      required this.status,
      required this.uuid,
      required this.entry,
      required this.description,
      this.start,
      this.end,
      this.due,
      this.until,
      this.wait,
      this.modified,
      this.scheduled,
      this.recur,
      this.mask,
      this.imask,
      this.parent,
      this.project,
      this.priority,
      this.depends,
      this.tags,
      this.annotations,
      this.udas,
      this.urgency})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(status, r'Task', 'status');
    BuiltValueNullFieldError.checkNotNull(uuid, r'Task', 'uuid');
    BuiltValueNullFieldError.checkNotNull(entry, r'Task', 'entry');
    BuiltValueNullFieldError.checkNotNull(description, r'Task', 'description');
  }

  @override
  Task rebuild(void Function(TaskBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  TaskBuilder toBuilder() => new TaskBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Task &&
        id == other.id &&
        status == other.status &&
        uuid == other.uuid &&
        entry == other.entry &&
        description == other.description &&
        start == other.start &&
        end == other.end &&
        due == other.due &&
        until == other.until &&
        wait == other.wait &&
        modified == other.modified &&
        scheduled == other.scheduled &&
        recur == other.recur &&
        mask == other.mask &&
        imask == other.imask &&
        parent == other.parent &&
        project == other.project &&
        priority == other.priority &&
        depends == other.depends &&
        tags == other.tags &&
        annotations == other.annotations &&
        udas == other.udas &&
        urgency == other.urgency;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc(
            $jc(
                $jc(
                    $jc(
                        $jc(
                            $jc(
                                $jc(
                                    $jc(
                                        $jc(
                                            $jc(
                                                $jc(
                                                    $jc(
                                                        $jc(
                                                            $jc(
                                                                $jc(
                                                                    $jc(
                                                                        $jc(
                                                                            $jc($jc($jc($jc($jc(0, id.hashCode), status.hashCode), uuid.hashCode), entry.hashCode),
                                                                                description.hashCode),
                                                                            start.hashCode),
                                                                        end.hashCode),
                                                                    due.hashCode),
                                                                until.hashCode),
                                                            wait.hashCode),
                                                        modified.hashCode),
                                                    scheduled.hashCode),
                                                recur.hashCode),
                                            mask.hashCode),
                                        imask.hashCode),
                                    parent.hashCode),
                                project.hashCode),
                            priority.hashCode),
                        depends.hashCode),
                    tags.hashCode),
                annotations.hashCode),
            udas.hashCode),
        urgency.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'Task')
          ..add('id', id)
          ..add('status', status)
          ..add('uuid', uuid)
          ..add('entry', entry)
          ..add('description', description)
          ..add('start', start)
          ..add('end', end)
          ..add('due', due)
          ..add('until', until)
          ..add('wait', wait)
          ..add('modified', modified)
          ..add('scheduled', scheduled)
          ..add('recur', recur)
          ..add('mask', mask)
          ..add('imask', imask)
          ..add('parent', parent)
          ..add('project', project)
          ..add('priority', priority)
          ..add('depends', depends)
          ..add('tags', tags)
          ..add('annotations', annotations)
          ..add('udas', udas)
          ..add('urgency', urgency))
        .toString();
  }
}

class TaskBuilder implements Builder<Task, TaskBuilder> {
  _$Task? _$v;

  int? _id;
  int? get id => _$this._id;
  set id(int? id) => _$this._id = id;

  String? _status;
  String? get status => _$this._status;
  set status(String? status) => _$this._status = status;

  String? _uuid;
  String? get uuid => _$this._uuid;
  set uuid(String? uuid) => _$this._uuid = uuid;

  DateTime? _entry;
  DateTime? get entry => _$this._entry;
  set entry(DateTime? entry) => _$this._entry = entry;

  String? _description;
  String? get description => _$this._description;
  set description(String? description) => _$this._description = description;

  DateTime? _start;
  DateTime? get start => _$this._start;
  set start(DateTime? start) => _$this._start = start;

  DateTime? _end;
  DateTime? get end => _$this._end;
  set end(DateTime? end) => _$this._end = end;

  DateTime? _due;
  DateTime? get due => _$this._due;
  set due(DateTime? due) => _$this._due = due;

  DateTime? _until;
  DateTime? get until => _$this._until;
  set until(DateTime? until) => _$this._until = until;

  DateTime? _wait;
  DateTime? get wait => _$this._wait;
  set wait(DateTime? wait) => _$this._wait = wait;

  DateTime? _modified;
  DateTime? get modified => _$this._modified;
  set modified(DateTime? modified) => _$this._modified = modified;

  DateTime? _scheduled;
  DateTime? get scheduled => _$this._scheduled;
  set scheduled(DateTime? scheduled) => _$this._scheduled = scheduled;

  String? _recur;
  String? get recur => _$this._recur;
  set recur(String? recur) => _$this._recur = recur;

  String? _mask;
  String? get mask => _$this._mask;
  set mask(String? mask) => _$this._mask = mask;

  int? _imask;
  int? get imask => _$this._imask;
  set imask(int? imask) => _$this._imask = imask;

  String? _parent;
  String? get parent => _$this._parent;
  set parent(String? parent) => _$this._parent = parent;

  String? _project;
  String? get project => _$this._project;
  set project(String? project) => _$this._project = project;

  String? _priority;
  String? get priority => _$this._priority;
  set priority(String? priority) {
    if (priority != 'None') {
      _$this._priority = priority;
    }
  }

  ListBuilder<String>? _depends;
  ListBuilder<String> get depends =>
      _$this._depends ??= new ListBuilder<String>();
  set depends(ListBuilder<String>? depends) => _$this._depends = depends;

  ListBuilder<String>? _tags;
  ListBuilder<String> get tags => _$this._tags ??= new ListBuilder<String>();
  set tags(ListBuilder<String>? tags) => _$this._tags = tags;

  ListBuilder<Annotation>? _annotations;
  ListBuilder<Annotation> get annotations =>
      _$this._annotations ??= new ListBuilder<Annotation>();
  set annotations(ListBuilder<Annotation>? annotations) =>
      _$this._annotations = annotations;

  String? _udas;
  String? get udas => _$this._udas;
  set udas(String? udas) => _$this._udas = udas;

  double? _urgency;
  double? get urgency => _$this._urgency;
  set urgency(double? urgency) => _$this._urgency = urgency;

  TaskBuilder();

  TaskBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _status = $v.status;
      _uuid = $v.uuid;
      _entry = $v.entry;
      _description = $v.description;
      _start = $v.start;
      _end = $v.end;
      _due = $v.due;
      _until = $v.until;
      _wait = $v.wait;
      _modified = $v.modified;
      _scheduled = $v.scheduled;
      _recur = $v.recur;
      _mask = $v.mask;
      _imask = $v.imask;
      _parent = $v.parent;
      _project = $v.project;
      _priority = $v.priority;
      _depends = $v.depends?.toBuilder();
      _tags = $v.tags?.toBuilder();
      _annotations = $v.annotations?.toBuilder();
      _udas = $v.udas;
      _urgency = $v.urgency;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Task other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$Task;
  }

  @override
  void update(void Function(TaskBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  Task build() => _build();

  _$Task _build() {
    _$Task _$result;
    try {
      _$result = _$v ??
          new _$Task._(
              id: id,
              status: BuiltValueNullFieldError.checkNotNull(
                  status, r'Task', 'status'),
              uuid:
                  BuiltValueNullFieldError.checkNotNull(uuid, r'Task', 'uuid'),
              entry: BuiltValueNullFieldError.checkNotNull(
                  entry, r'Task', 'entry'),
              description: BuiltValueNullFieldError.checkNotNull(
                  description, r'Task', 'description'),
              start: start,
              end: end,
              due: due,
              until: until,
              wait: wait,
              modified: modified,
              scheduled: scheduled,
              recur: recur,
              mask: mask,
              imask: imask,
              parent: parent,
              project: project,
              priority: priority,
              depends: _depends?.build(),
              tags: _tags?.build(),
              annotations: _annotations?.build(),
              udas: udas,
              urgency: urgency);
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'depends';
        _depends?.build();
        _$failedField = 'tags';
        _tags?.build();
        _$failedField = 'annotations';
        _annotations?.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            r'Task', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,deprecated_member_use_from_same_package,lines_longer_than_80_chars,no_leading_underscores_for_local_identifiers,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new,unnecessary_lambdas
