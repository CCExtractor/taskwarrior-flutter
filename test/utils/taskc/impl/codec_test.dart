import 'dart:typed_data';
import 'package:flutter_test/flutter_test.dart';
import 'package:taskwarrior/app/utils/taskc/impl/codec.dart';

void main() {
  group('Codec', () {
    test('fold should combine bytes into an integer', () {
      final bytes = [0, 0, 1, 2];
      final result = Codec.fold(bytes);
      expect(result, 258);
    });

    test('unfold should split an integer into bytes', () {
      const n = 258;
      final result = Codec.unfold(n);
      expect(result, [0, 0, 1, 2]);
    });

    test('decode should decode Uint8List to string', () {
      final bytes = Uint8List.fromList([0, 0, 0, 9, 104, 101, 108, 108, 111]);
      final result = Codec.decode(bytes);
      expect(result, 'hello');
    });

    test('decode should throw assertion error for invalid length', () {
      final bytes = Uint8List.fromList([0, 0, 0, 4, 104, 101, 108, 108, 111]);
      expect(() => Codec.decode(bytes), throwsAssertionError);
    });

    test('encode should encode string to Uint8List', () {
      const string = 'hello';
      final result = Codec.encode(string);
      expect(result, Uint8List.fromList([0, 0, 0, 9, 104, 101, 108, 108, 111]));
    });

    test('encode should handle empty string', () {
      const string = '';
      final result = Codec.encode(string);
      expect(result, Uint8List.fromList([0, 0, 0, 4]));
    });
  });
}
