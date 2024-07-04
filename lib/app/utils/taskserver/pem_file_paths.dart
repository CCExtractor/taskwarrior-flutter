import 'dart:io';

class PemFilePaths {
  const PemFilePaths({
    this.ca,
    this.certificate,
    this.key,
    this.serverCert,
  });

  factory PemFilePaths.fromTaskrc(Map taskrc) {
    return PemFilePaths(
      ca: taskrc['taskd.ca'],
      certificate: taskrc['taskd.certificate'],
      key: taskrc['taskd.key'],
    );
  }

  final String? ca;
  final String? certificate;
  final String? key;
  final String? serverCert;

  SecurityContext securityContext() {
    var context = (ca != null && File(ca!).existsSync())
        ? (SecurityContext()..setTrustedCertificates(ca!))
        : SecurityContext(withTrustedRoots: true);
    if (certificate != null && File(certificate!).existsSync()) {
      context.useCertificateChain(certificate!);
    }
    if (key != null && File(key!).existsSync()) {
      context.usePrivateKey(key!);
    }
    return context;
  }

  bool savedServerCertificateMatches(X509Certificate badServerCert) {
    if (serverCert != null) {
      if (File(serverCert!).existsSync()) {
        return File(serverCert!).readAsStringSync() == badServerCert.pem;
      }
    }
    return false;
  }

  Map get map => {
        'taskd.ca': ca,
        'taskd.certificate': certificate,
        'taskd.key': key,
        'server.cert': serverCert,
      }..removeWhere((_, value) => value == null);
}
