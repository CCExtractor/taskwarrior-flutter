import 'package:flutter/foundation.dart';

enum LogLevel { debug, info, warning, error }

/// Tagged, levelled logger.
///
/// Everything goes through [debugPrint], which `main()` overrides to also
/// persist each line to the debug-log database shown on the Logs page.
/// [LogLevel.debug] lines are only emitted in debug builds so routine
/// interaction noise never reaches that database in release.
class AppLogger {
  const AppLogger(this.tag);

  final String tag;

  void debug(String message) {
    if (kDebugMode) _log(LogLevel.debug, message);
  }

  void info(String message) => _log(LogLevel.info, message);

  void warning(String message, [Object? error, StackTrace? stackTrace]) =>
      _log(LogLevel.warning, message, error, stackTrace);

  void error(String message, [Object? error, StackTrace? stackTrace]) =>
      _log(LogLevel.error, message, error, stackTrace);

  void _log(
    LogLevel level,
    String message, [
    Object? error,
    StackTrace? stackTrace,
  ]) {
    final line = StringBuffer('[${level.name.toUpperCase()}] [$tag] $message');
    if (error != null) line.write(': $error');
    debugPrint(line.toString());
    if (stackTrace != null) debugPrint(stackTrace.toString());
  }
}
