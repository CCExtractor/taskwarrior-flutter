/// Utility class for calculating next recurrence dates.
///
/// Supports all standard Taskwarrior recurrence keywords plus arbitrary
/// Nd / Nw / Nm / Ny patterns.
class RecurrenceEngine {
  /// Given [oldDate] and a [recur] pattern string, returns the next occurrence date.
  static DateTime? calculateNextDate(DateTime oldDate, String recur) {
    final r = recur.toLowerCase().trim();
    switch (r) {
      // ── Daily ────────────────────────────────────────────────────────────────
      case 'daily':
      case '1d':
        return oldDate.add(const Duration(days: 1));

      // ── Weekdays (Mon–Fri only) ───────────────────────────────────────────
      case 'weekdays':
        return _nextWeekday(oldDate);

      // ── Weekly ───────────────────────────────────────────────────────────
      case 'weekly':
      case '1w':
      case 'sennight':
        return oldDate.add(const Duration(days: 7));

      // ── Biweekly / Fortnight ─────────────────────────────────────────────
      case 'biweekly':
      case 'fortnight':
      case '2w':
        return oldDate.add(const Duration(days: 14));

      // ── Monthly ──────────────────────────────────────────────────────────
      case 'monthly':
      case '1m':
        return _addMonths(oldDate, 1);

      // ── Bimonthly ────────────────────────────────────────────────────────
      case 'bimonthly':
      case '2m':
        return _addMonths(oldDate, 2);

      // ── Quarterly ────────────────────────────────────────────────────────
      case 'quarterly':
      case '3m':
        return _addMonths(oldDate, 3);

      // ── Semi-annual ──────────────────────────────────────────────────────
      case 'semiannual':
      case '6m':
        return _addMonths(oldDate, 6);

      // ── Yearly / Annual ──────────────────────────────────────────────────
      case 'yearly':
      case 'annual':
      case '1y':
        return _addYears(oldDate, 1);

      default:
        // Try to parse generic patterns like "2d", "3w", "6m", "2y"
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
              return _addMonths(oldDate, count);
            case 'y':
              return _addYears(oldDate, count);
          }
        }
        return null;
    }
  }

  // ── Private helpers ────────────────────────────────────────────────────────

  /// Advance [date] by [months], clamping to valid day-of-month.
  static DateTime _addMonths(DateTime date, int months) {
    int newMonth = date.month + months;
    int newYear = date.year + (newMonth - 1) ~/ 12;
    newMonth = ((newMonth - 1) % 12) + 1;
    final lastDay = DateTime(newYear, newMonth + 1, 0).day;
    final day = date.day.clamp(1, lastDay);
    return DateTime(
        newYear, newMonth, day, date.hour, date.minute, date.second);
  }

  /// Advance [date] by [years], clamping to valid day-of-month (Feb 29 → Feb 28).
  static DateTime _addYears(DateTime date, int years) {
    final newYear = date.year + years;
    final lastDay = DateTime(newYear, date.month + 1, 0).day;
    final day = date.day.clamp(1, lastDay);
    return DateTime(
        newYear, date.month, day, date.hour, date.minute, date.second);
  }

  /// Return the next weekday (Mon–Fri) strictly after [date].
  static DateTime _nextWeekday(DateTime date) {
    DateTime next = date.add(const Duration(days: 1));
    while (
        next.weekday == DateTime.saturday || next.weekday == DateTime.sunday) {
      next = next.add(const Duration(days: 1));
    }
    return next;
  }
}
