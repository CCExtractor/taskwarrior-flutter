// test/annotation_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:taskwarrior/app/models/json/annotation.dart';

void main() {
  group('Annotation', () {
    late Annotation annotation;
    late DateTime entry;
    late String description;

    setUp(() {
      entry = DateTime.now().toUtc(); // Ensure the DateTime is in UTC
      description = 'Test description';

      annotation = Annotation((b) => b
        ..entry = entry
        ..description = description);
    });

    test('should correctly initialize with given parameters', () {
      expect(annotation.entry, entry);
      expect(annotation.description, description);
    });

    test('should correctly convert to JSON', () {
      final json = annotation.toJson();
      expect(DateFormat("yyyyMMdd'T'HH").format(DateTime.parse(json['entry'])),
          DateFormat("yyyyMMdd'T'HH").format(entry));
      expect(json['description'], description);
    });

    test('should correctly create from JSON', () {
      final json = {
        'entry': entry.toIso8601String(),
        'description': description,
      };
      final newAnnotation = Annotation.fromJson(json);
      expect(newAnnotation.entry, entry);
      expect(newAnnotation.description, description);
    });
  });
}
