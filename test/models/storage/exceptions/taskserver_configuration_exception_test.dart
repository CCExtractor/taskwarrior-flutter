import 'package:flutter_test/flutter_test.dart';
import 'package:taskwarrior/app/models/storage/exceptions/taskserver_configuration_exception.dart';

void main() {
  group('TaskserverConfigurationException', () {
    test('should create an instance with correct message', () {
      const message = 'Configuration error';
      final exception = TaskserverConfigurationException(message);

      expect(exception.message, message);
      expect(exception.toString(), message);
    });
  });
}
