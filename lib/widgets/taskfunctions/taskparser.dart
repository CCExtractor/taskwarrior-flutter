// ignore_for_file: depend_on_referenced_packages

import 'package:petitparser/petitparser.dart';
import 'package:uuid/uuid.dart';

import 'package:taskwarrior/model/json.dart';

class Tag {
  const Tag(this.tag);

  final String tag;

  // @override
  // String toString() => 'Tag($tag)';
}

class Attribute {
  const Attribute(
    this.key,
    this.value,
  );

  final String key;
  final String? value;

  // @override
  // String toString() => 'Attribute($key, $value)';
}

Parser wordPrimitive() => (char(' ').not() & any()).plus().flatten();

Parser attributeNamePrimitive() =>
    string('status') |
    string('statu') |
    string('stat') |
    string('project') |
    string('projec') |
    string('proje') |
    string('proj') |
    string('pro') |
    string('priority') |
    string('priorit') |
    string('priori') |
    string('prior') |
    string('prio') |
    string('pri') |
    string('scheduled') |
    string('schedule') |
    string('schedul') |
    string('schedu') |
    string('sched') |
    string('sche') |
    string('sch') |
    string('sc') |
    string('due') |
    string('wait') |
    string('until');

Parser tagPrimitive() =>
    (char('+') & wordPrimitive()).pick(1).cast<String>().map(Tag.new);
Parser attributePrimitive() =>
    (attributeNamePrimitive() & char(':') & wordPrimitive().optional())
        .map((value) => Attribute(value[0], value[2]));
Parser descriptionWordPrimitive() => wordPrimitive();

final add = (epsilon() & endOfInput()) |
    (tagPrimitive() | attributePrimitive() | descriptionWordPrimitive())
        .separatedBy(
      char(' '),
      includeSeparators: false,
    );

Task taskParser(String task) {
  var now = DateTime.now().toUtc();
  var uuid = const Uuid().v1();
  var description =
      (add.parse(task).value as Iterable).whereType<String>().join(' ');
  var draft = Task(
    (b) => b
      ..description = description
      ..status = 'pending'
      ..uuid = uuid
      ..entry = now
      ..start = now
      ..modified = now,
  );
  for (var match in add.parse(task).value) {
    if (match is Attribute) {
      var value = match.value;
      value = (value != null && value.startsWith('\'') && value.endsWith('\''))
          ? value.substring(1, value.length - 1)
          : value;
      switch (match.key) {
        case 'stat':
        case 'statu':
        case 'status':
          draft = draft.rebuild((b) => b..status = value);
          break;
        case 'pro':
        case 'proj':
        case 'proje':
        case 'projec':
        case 'project':
          draft = draft.rebuild((b) => b..project = value);
          break;
        case 'pri':
        case 'prio':
        case 'prior':
        case 'priori':
        case 'priorit':
        case 'priority':
          draft = draft.rebuild((b) => b..priority = value);
          break;
        case 'due':
          draft = draft.rebuild(
            (b) =>
                b..due = (value == null) ? null : DateTime.parse(value).toUtc(),
          );
          break;
        case 'wait':
          draft = draft.rebuild(
            (b) => b
              ..wait = (value == null) ? null : DateTime.parse(value).toUtc(),
          );
          break;
        case 'until':
          draft = draft.rebuild(
            (b) => b
              ..until = (value == null) ? null : DateTime.parse(value).toUtc(),
          );
          break;
      }
    } else if (match is Tag) {
      draft = draft.rebuild((b) => b..tags = (b.tags..add(match.tag)));
    }
  }
  return draft;
}
