// ignore_for_file: depend_on_referenced_packages

import 'package:intl/intl.dart';

import 'package:built_value/iso_8601_date_time_serializer.dart';
import 'package:built_value/serializer.dart';

/// > Dates are rendered in ISO 8601 combined date and time in UTC format using
/// > the template: `YYYYMMDDTHHMMSSZ`. An example: `20120110T231200Z`. No other
/// > formats are supported.  --
/// > <https://taskwarrior.org/docs/design/task.html#type_date>.
final DateFormat iso8601Basic = DateFormat('yMMddTHHmmss\'Z\'');

class Iso8601BasicDateTimeSerializer extends Iso8601DateTimeSerializer {
  @override
  Object serialize(Serializers serializers, DateTime dateTime,
      {FullType specifiedType = FullType.unspecified}) {
    if (!dateTime.isUtc) {
      throw ArgumentError.value(
          dateTime, 'dateTime', 'Must be in utc for serialization.');
    }

    return iso8601Basic.format(dateTime);
  }
}
