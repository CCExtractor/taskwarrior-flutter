import 'package:flutter_test/flutter_test.dart';
import 'package:taskwarrior/app/utils/taskfunctions/validate.dart';

void main() {
  test('validateTaskDescription', () {
    expect(() => validateTaskDescription('Write test cases'), returnsNormally);

    expect(() => validateTaskDescription(''), throwsFormatException);

    expect(() => validateTaskDescription('Do something\\'), throwsFormatException);
  });

  test('validateTaskProject', () {
    expect(() => validateTaskProject('Personal'), returnsNormally);

    expect(() => validateTaskProject('Work\\'), throwsFormatException);
  });

  test('validateTaskTags', () {
    expect(() => validateTaskTags('important'), returnsNormally);

    expect(() => validateTaskTags('urgent tasks'), throwsFormatException);
  });
}
