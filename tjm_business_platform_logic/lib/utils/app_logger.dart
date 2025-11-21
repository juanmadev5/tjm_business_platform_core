import 'package:logger/logger.dart';

class AppLogger {
  static final AppLogger _instance = AppLogger._internal();
  factory AppLogger() => _instance;
  AppLogger._internal();

  Logger logger = Logger(
    printer: PrettyPrinter(
      colors: true,
      printEmojis: true,
      dateTimeFormat: DateTimeFormat.onlyTime,
    ),
  );

  /// Log a message at level [Level.debug].
  void d(
    dynamic message, {
    DateTime? time,
    Object? error,
    StackTrace? stackTrace,
  }) {
    logger.d(
      "DEBUG --- $message",
      time: time,
      error: error,
      stackTrace: stackTrace,
    );
  }

  /// Log a message at level [Level.info].
  void i(
    dynamic message, {
    DateTime? time,
    Object? error,
    StackTrace? stackTrace,
  }) => logger.i(
    "INFO --- $message",
    time: time,
    error: error,
    stackTrace: stackTrace,
  );

  /// Log a message at level [Level.warning].
  void w(
    dynamic message, {
    DateTime? time,
    Object? error,
    StackTrace? stackTrace,
  }) => logger.w(
    "WARNING --- $message",
    time: time,
    error: error,
    stackTrace: stackTrace,
  );

  /// Log a message at level [Level.error].
  void e(
    dynamic message, {
    DateTime? time,
    Object? error,
    StackTrace? stackTrace,
  }) => logger.e(
    "ERROR --- $message",
    time: time,
    error: error,
    stackTrace: stackTrace,
  );

  /// Log a message at level [Level.fatal].
  void f(
    dynamic message, {
    DateTime? time,
    Object? error,
    StackTrace? stackTrace,
  }) => logger.f(
    "FATAL --- $message",
    time: time,
    error: error,
    stackTrace: stackTrace,
  );
}
