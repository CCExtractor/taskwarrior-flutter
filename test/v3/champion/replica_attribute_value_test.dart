import 'package:flutter_test/flutter_test.dart';
import 'package:taskwarrior/app/v3/champion/replica.dart';

void main() {
  group('Replica.attributeValueToString', () {
    test('formats UTC DateTime as RFC3339 with T separator', () {
      final due = DateTime.utc(2026, 10, 3, 12, 0, 0);
      final encoded = Replica.attributeValueToString(due);

      expect(encoded, '2026-10-03T12:00:00.000Z');
      expect(encoded.contains(' '), isFalse);
      expect(DateTime.parse(encoded), due);
    });

    test('normalizes local DateTime to UTC before encoding', () {
      final local = DateTime(2026, 10, 3, 17, 30);
      final encoded = Replica.attributeValueToString(local);

      expect(encoded, local.toUtc().toIso8601String());
      expect(encoded.contains('T'), isTrue);
    });

    test('stringifies non-DateTime values with toString', () {
      expect(Replica.attributeValueToString('buy milk'), 'buy milk');
      expect(Replica.attributeValueToString('H'), 'H');
      expect(Replica.attributeValueToString(42), '42');
    });

    test('Dart DateTime.toString is not accepted as-is by RFC3339 parsers', () {
      // Documents the bug this helper fixes: space-separated form fails
      // chrono's DateTime<Utc> parse used by the Rust FFI.
      final due = DateTime.utc(2026, 10, 3, 12, 0, 0);
      expect(due.toString(), '2026-10-03 12:00:00.000Z');
      expect(Replica.attributeValueToString(due), isNot(due.toString()));
    });
  });
}
