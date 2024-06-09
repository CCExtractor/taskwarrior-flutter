import 'dart:io';

class BadCertificateException implements Exception {
  BadCertificateException({
    required this.home,
    required this.certificate,
  });

  Directory home;
  X509Certificate certificate;
}
