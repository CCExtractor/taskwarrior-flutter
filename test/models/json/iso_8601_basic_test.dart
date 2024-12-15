import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:taskwarrior/app/models/json/iso_8601_basic.dart';
import 'package:taskwarrior/app/models/json/serializers.dart';

void main() {
  group('Iso8601BasicDateTimeSerializer', () {
    late Iso8601BasicDateTimeSerializer serializer;
    late DateTime dateTime;
    late DateFormat dateFormat;

    setUp(() {
      serializer = Iso8601BasicDateTimeSerializer();
      dateTime = DateTime.utc(2024, 12, 12, 13, 30, 40, 495);
      dateFormat = DateFormat('yMMddTHHmmss\'Z\'');
    });

    test('should throw ArgumentError if dateTime is not in UTC', () {
      expect(
        () => serializer.serialize(serializers, dateTime.toLocal()),
        throwsArgumentError,
      );
    });

    test('should correctly serialize UTC dateTime', () {
      final serialized = serializer.serialize(serializers, dateTime);
      expect(serialized, dateFormat.format(dateTime));
    });
  });
}
