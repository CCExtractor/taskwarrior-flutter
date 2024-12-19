import 'package:flutter_test/flutter_test.dart';
import 'package:taskwarrior/app/utils/taskserver/taskrc.dart';
import 'package:taskwarrior/app/utils/taskserver/server.dart';
import 'package:taskwarrior/app/utils/taskserver/credentials.dart';
import 'package:taskwarrior/app/utils/taskserver/pem_file_paths.dart';

void main() {
  group('Taskrc', () {
    test('Taskrc constructor sets fields correctly', () {
      const server = Server(address: 'example.com', port: 8080);
      const credentials = Credentials(org: 'org', user: 'user', key: 'key');
      const pemFilePaths = PemFilePaths(
        ca: 'path/to/ca.pem',
        certificate: 'path/to/cert.pem',
        key: 'path/to/key.pem',
      );
      final taskrc = Taskrc(
        server: server,
        credentials: credentials,
        pemFilePaths: pemFilePaths,
      );

      expect(taskrc.server, server);
      expect(taskrc.credentials, credentials);
      expect(taskrc.pemFilePaths, pemFilePaths);
    });

    test('Taskrc.fromString parses valid taskrc string', () {
      const taskrcString = '''
taskd.server=example.com:8080
taskd.credentials=org/user/key
taskd.ca=path/to/ca.pem
taskd.certificate=path/to/cert.pem
taskd.key=path/to/key.pem
''';
      final taskrc = Taskrc.fromString(taskrcString);

      expect(taskrc.server, isA<Server>());
      expect(taskrc.credentials, isA<Credentials>());
      expect(taskrc.pemFilePaths, isA<PemFilePaths>());
    });

    test('Taskrc.fromMap parses valid taskrc map', () {
      final taskrcMap = {
        'taskd.server': 'example.com:8080',
        'taskd.credentials': 'org/user/key',
        'taskd.ca': 'path/to/ca.pem',
        'taskd.certificate': 'path/to/cert.pem',
        'taskd.key': 'path/to/key.pem',
      };
      final taskrc = Taskrc.fromMap(taskrcMap);

      expect(taskrc.server, isA<Server>());
      expect(taskrc.credentials, isA<Credentials>());
      expect(taskrc.pemFilePaths, isA<PemFilePaths>());
    });

    test('Taskrc.fromMap handles missing optional fields', () {
      final taskrcMap = {
        'taskd.ca': 'path/to/ca.pem',
        'taskd.certificate': 'path/to/cert.pem',
        'taskd.key': 'path/to/key.pem',
      };
      final taskrc = Taskrc.fromMap(taskrcMap);

      expect(taskrc.server, isNull);
      expect(taskrc.credentials, isNull);
      expect(taskrc.pemFilePaths, isA<PemFilePaths>());
    });
  });
}
