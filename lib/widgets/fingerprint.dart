import 'package:crypto/crypto.dart';
import 'package:pem/pem.dart';

String fingerprint(String pemContents) {
  var firstCertificateBlock = decodePemBlocks(
    PemLabel.certificate,
    pemContents,
  ).first;

  return '${sha1.convert(firstCertificateBlock)}';
}
