import 'package:intl/intl.dart';

/// Formats a task attribute value for display; `null` stays `null` so callers
/// can show their own "not selected" text. Dates are shown in local time.
String? formatAttributeValue(Object? value, {required bool use24HourFormat}) {
  if (value == null) return null;
  if (value is DateTime) {
    return DateFormat(use24HourFormat
            ? 'EEE, yyyy-MM-dd HH:mm:ss'
            : 'EEE, yyyy-MM-dd hh:mm:ss a')
        .format(value.toLocal());
  }
  return value.toString();
}
