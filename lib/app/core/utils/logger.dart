import 'package:logger/logger.dart';

/// Structured logger for AllerRisk.
/// Each layer has a prefixed logger for easy log filtering.
///
/// Usage:
///   AppLogger.controller.d('Navigation handled');
///   AppLogger.repo.e('DB read failed', error: e, stackTrace: st);
///   AppLogger.service.i('Session restored');
abstract class AppLogger {
  static final _printer = PrettyPrinter(
    methodCount: 1,
    errorMethodCount: 6,
    lineLength: 80,
    colors: true,
    printEmojis: true,
    dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
  );

  static final Logger _base = Logger(printer: _printer);

  /// Use in views / widgets
  static final Logger ui = Logger(
    printer: PrefixPrinter(_printer, debug: '[UI]', info: '[UI]'),
  );

  /// Use in controllers (GetxController)
  static final Logger controller = Logger(
    printer: PrefixPrinter(_printer, debug: '[CTRL]', info: '[CTRL]'),
  );

  /// Use in repositories
  static final Logger repo = Logger(
    printer: PrefixPrinter(_printer, debug: '[REPO]', info: '[REPO]'),
  );

  /// Use in GetxService layers (StorageService, AuthService, etc.)
  static final Logger service = Logger(
    printer: PrefixPrinter(_printer, debug: '[SVC]', info: '[SVC]'),
  );

  /// Generic / catch-all
  static Logger get log => _base;
}
