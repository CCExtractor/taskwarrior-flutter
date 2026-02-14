/// Utility class for calculating next recurrence dates.
class RecurrenceEngine {
  /// Given [oldDate] and a [recur] pattern string, returns the next occurrence date.
  /// Supports: daily/1d, weekly/1w, monthly/1m, yearly/1y.
  static DateTime? calculateNextDate(DateTime oldDate, String recur) {
    final r = recur.toLowerCase().trim();
    switch (r) {
      case 'daily':
      case '1d':
        return oldDate.add(const Duration(days: 1));
      case 'weekly':
      case '1w':
        return oldDate.add(const Duration(days: 7));
      case 'monthly':
      case '1m':
        return DateTime(
          oldDate.year,
          oldDate.month + 1,
          oldDate.day,
          oldDate.hour,
          oldDate.minute,
          oldDate.second,
        );
      case 'yearly':
      case '1y':
        return DateTime(
          oldDate.year + 1,
          oldDate.month,
          oldDate.day,
          oldDate.hour,
          oldDate.minute,
          oldDate.second,
        );
      default:
        // Try to parse patterns like "2d", "3w", "6m", "2y"
        final match = RegExp(r'^(\d+)([dwmy])$').firstMatch(r);
        if (match != null) {
          final count = int.parse(match.group(1)!);
          final unit = match.group(2)!;
          switch (unit) {
            case 'd':
              return oldDate.add(Duration(days: count));
            case 'w':
              return oldDate.add(Duration(days: count * 7));
            case 'm':
              return DateTime(
                oldDate.year,
                oldDate.month + count,
                oldDate.day,
                oldDate.hour,
                oldDate.minute,
                oldDate.second,
              );
            case 'y':
              return DateTime(
                oldDate.year + count,
                oldDate.month,
                oldDate.day,
                oldDate.hour,
                oldDate.minute,
                oldDate.second,
              );
          }
        }
        return null;
    }
  }
}
