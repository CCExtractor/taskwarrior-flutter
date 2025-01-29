import 'package:flutter_test/flutter_test.dart';
import 'package:taskwarrior/app/utils/taskfunctions/validate.dart';

void main() {
  group('Validate Utils', () {
    test('validateTaskDescription throws FormatException for empty description',
        () {
      expect(() => validateTaskDescription(''), throwsFormatException);
    });

    test(
        'validateTaskDescription throws FormatException for trailing backslash',
        () {
      expect(() => validateTaskDescription('Task description\\'),
          throwsFormatException);
    });

    test('validateTaskDescription does not throw for valid description', () {
      expect(() => validateTaskDescription('Valid task description'),
          returnsNormally);
    });

    test('validateTaskProject throws FormatException for trailing backslash',
        () {
      expect(() => validateTaskProject('Project\\'), throwsFormatException);
    });

    test('validateTaskProject does not throw for valid project', () {
      expect(() => validateTaskProject('ValidProject'), returnsNormally);
    });

    test('validateTaskTags throws FormatException for tag with space', () {
      expect(() => validateTaskTags('invalid tag'), throwsFormatException);
    });

    test('validateTaskTags does not throw for valid tag', () {
      expect(() => validateTaskTags('validTag'), returnsNormally);
    });
  });
}
