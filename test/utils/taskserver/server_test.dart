import 'package:flutter_test/flutter_test.dart';
import 'package:taskwarrior/app/utils/taskserver/server.dart';
import 'package:taskwarrior/app/utils/taskserver/taskrc_exception.dart';

void main() {
  group('Server', () {
    test('Server constructor sets fields correctly', () {
      const server = Server(
        address: 'example.com',
        port: 8080,
      );

      expect(server.address, 'example.com');
      expect(server.port, 8080);
    });

    test('Server.fromString parses valid server string', () {
      final server = Server.fromString('example.com:8080');

      expect(server.address, 'example.com');
      expect(server.port, 8080);
    });

    test(
        'Server.fromString throws TaskrcException for invalid format without colon',
        () {
      expect(() => Server.fromString('example.com8080'),
          throwsA(isA<TaskrcException>()));
    });

    test('Server.fromString throws TaskrcException for invalid port', () {
      expect(() => Server.fromString('example.com:invalid'),
          throwsA(isA<TaskrcException>()));
    });

    test('Server.toString returns correct string representation', () {
      const server = Server(
        address: 'example.com',
        port: 8080,
      );

      expect(server.toString(), 'example.com:8080');
    });
  });
}
