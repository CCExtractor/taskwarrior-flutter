import 'package:flutter_test/flutter_test.dart';
import 'package:taskwarrior/app/utils/taskserver/taskrc_exception.dart';

void main() {
  group('TaskrcException', () {
    test('TaskrcException constructor sets message correctly', () {
      final exception = TaskrcException('An error occurred');

      expect(exception.message, 'An error occurred');
    });

    test('TaskrcException.toString returns correct message', () {
      final exception = TaskrcException('An error occurred');

      expect(exception.toString(), 'An error occurred');
    });
  });
}
