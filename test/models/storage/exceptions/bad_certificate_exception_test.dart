import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:taskwarrior/app/models/storage/exceptions/bad_certificate_exception.dart';
import 'bad_certificate_exception_test.mocks.dart';

@GenerateMocks([X509Certificate])
void main() {
  group('BadCertificateException', () {
    test('should create an instance with correct properties', () {
      final home = Directory('/mock/home');
      final mockCertificate = MockX509Certificate();

      final exception =
          BadCertificateException(home: home, certificate: mockCertificate);

      expect(exception.home, home);
      expect(exception.certificate, mockCertificate);
    });
  });
}
