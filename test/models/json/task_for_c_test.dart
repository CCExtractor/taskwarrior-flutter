import 'package:flutter_test/flutter_test.dart';
import 'package:taskwarrior/app/v3/models/task.dart';

/// Regression tests for TaskForC.fromJson(), covering two bugs found in a
/// broader audit: annotations were hardcoded to an empty list regardless of
/// the JSON payload, and a nullable `urgency` field was force-called with
/// `.toDouble()` without a null check.
void main() {
  Map<String, dynamic> baseJson() => {
        'id': 1,
        'description': 'desc',
        'project': null,
        'status': 'pending',
        'uuid': 'u1',
        'urgency': 5.5,
        'priority': null,
        'due': null,
        'end': null,
        'entry': '20240101T000000Z',
        'modified': null,
        'tags': null,
        'start': null,
        'wait': null,
        'rtype': null,
        'recur': null,
        'depends': null,
      };

  group('TaskForC.fromJson', () {
    test('deserializes annotations from the payload', () {
      final json = baseJson()
        ..['annotations'] = [
          {'entry': '20240102T000000Z', 'description': 'first note'},
          {'entry': '20240103T000000Z', 'description': 'second note'},
        ];
      final task = TaskForC.fromJson(json);
      expect(task.annotations, isNotNull);
      expect(task.annotations!.length, 2);
      expect(task.annotations![0].description, 'first note');
      expect(task.annotations![1].description, 'second note');
    });

    test('an absent annotations key yields an empty list, not a crash', () {
      final task = TaskForC.fromJson(baseJson());
      expect(task.annotations, isEmpty);
    });

    test('a null urgency does not throw', () {
      final json = baseJson()..['urgency'] = null;
      final task = TaskForC.fromJson(json);
      expect(task.urgency, isNull);
    });

    test('a numeric urgency is parsed correctly', () {
      final json = baseJson()..['urgency'] = 12;
      final task = TaskForC.fromJson(json);
      expect(task.urgency, 12.0);
    });
  });
}
