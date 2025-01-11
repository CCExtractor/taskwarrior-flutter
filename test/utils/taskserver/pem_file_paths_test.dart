import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:taskwarrior/app/utils/taskserver/pem_file_paths.dart';

class MockX509Certificate implements X509Certificate {
  @override
  final String pem;

  MockX509Certificate(this.pem);

  @override
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  group('PemFilePaths', () {
    setUp(() {
      // Create test directory and files if they don't exist
      Directory('test/fixtures').createSync(recursive: true);
      File('test/fixtures/server.pem')
          .writeAsStringSync('matching-pem-content');
    });

    tearDown(() {
      // Clean up test files
      if (File('test/fixtures/server.pem').existsSync()) {
        File('test/fixtures/server.pem').deleteSync();
      }
    });

    test('PemFilePaths constructor sets fields correctly', () {
      const pemFilePaths = PemFilePaths(
        ca: 'path/to/ca.pem',
        certificate: 'path/to/cert.pem',
        key: 'path/to/key.pem',
        serverCert: 'path/to/server.pem',
      );

      expect(pemFilePaths.ca, 'path/to/ca.pem');
      expect(pemFilePaths.certificate, 'path/to/cert.pem');
      expect(pemFilePaths.key, 'path/to/key.pem');
      expect(pemFilePaths.serverCert, 'path/to/server.pem');
    });

    test('PemFilePaths.fromTaskrc parses taskrc correctly', () {
      final taskrc = {
        'taskd.ca': 'path/to/ca.pem',
        'taskd.certificate': 'path/to/cert.pem',
        'taskd.key': 'path/to/key.pem',
      };
      final pemFilePaths = PemFilePaths.fromTaskrc(taskrc);

      expect(pemFilePaths.ca, 'path/to/ca.pem');
      expect(pemFilePaths.certificate, 'path/to/cert.pem');
      expect(pemFilePaths.key, 'path/to/key.pem');
      expect(pemFilePaths.serverCert, isNull);
    });

    test('PemFilePaths.securityContext creates SecurityContext correctly', () {
      const pemFilePaths = PemFilePaths(
        ca: 'test/fixtures/ca.pem',
        certificate: 'test/fixtures/cert.pem',
        key: 'test/fixtures/key.pem',
      );

      final context = pemFilePaths.securityContext();

      expect(context, isA<SecurityContext>());
    });

    test(
        'PemFilePaths.savedServerCertificateMatches returns true for matching certificates',
        () {
      const pemFilePaths = PemFilePaths(
        serverCert: 'test/fixtures/server.pem',
      );
      final badServerCert = MockX509Certificate('matching-pem-content');

      final result = pemFilePaths.savedServerCertificateMatches(badServerCert);

      expect(result, true);
    });

    test(
        'PemFilePaths.savedServerCertificateMatches returns false for non-matching certificates',
        () {
      const pemFilePaths = PemFilePaths(
        serverCert: 'test/fixtures/server.pem',
      );
      final badServerCert = MockX509Certificate('non-matching-pem-content');

      // Write the non-matching content to the server cert file for the test
      File('test/fixtures/server.pem')
          .writeAsStringSync('different-pem-content');

      final result = pemFilePaths.savedServerCertificateMatches(badServerCert);

      expect(result, false);
    });

    test('PemFilePaths.map returns correct map representation', () {
      const pemFilePaths = PemFilePaths(
        ca: 'path/to/ca.pem',
        certificate: 'path/to/cert.pem',
        key: 'path/to/key.pem',
        serverCert: 'path/to/server.pem',
      );

      final map = pemFilePaths.map;

      expect(map, {
        'taskd.ca': 'path/to/ca.pem',
        'taskd.certificate': 'path/to/cert.pem',
        'taskd.key': 'path/to/key.pem',
        'server.cert': 'path/to/server.pem',
      });
    });

    test('PemFilePaths.map omits null values', () {
      const pemFilePaths = PemFilePaths(
        ca: 'path/to/ca.pem',
        certificate: 'path/to/cert.pem',
        key: null,
        serverCert: null,
      );

      final map = pemFilePaths.map;

      expect(map, {
        'taskd.ca': 'path/to/ca.pem',
        'taskd.certificate': 'path/to/cert.pem',
      });
    });
  });
}
