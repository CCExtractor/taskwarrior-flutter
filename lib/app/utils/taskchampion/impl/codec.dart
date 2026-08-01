import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

// ignore: avoid_classes_with_only_static_members
class Codec {
  static int fold(Iterable<int> bytes) =>
      bytes.reduce((x, y) => x * pow(2, 8) + y as int);

  static Iterable<int> unfold(int n) => [
        for (var i in [3, 2, 1, 0]) (n ~/ pow(256, i)) % 256
      ];

  static String decode(Uint8List bytes) {
    assert(fold(bytes.take(4)) == bytes.length,
        'ensure first four bytes represent the length of the message');
    return utf8.decode(bytes.sublist(4));
  }

  static Uint8List encode(String string) {
    var utf8Encoded = utf8.encode(string);
    var byteLength = utf8Encoded.length + 4;
    return Uint8List.fromList(
        unfold(byteLength).followedBy(utf8Encoded).toList());
  }
}
