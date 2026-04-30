import 'package:intl/intl.dart';

class AppFormatters {
  /// e.g. "12 Ags 2024"
  static String dateShort(DateTime date) {
    return DateFormat('dd MMM yyyy', 'id').format(date);
  }

  /// e.g. "12 Agustus 2024"
  static String dateLong(DateTime date) {
    return DateFormat('dd MMMM yyyy', 'id').format(date);
  }

  /// e.g. "12 Ags 2024, 14:30"
  static String dateTime(DateTime date) {
    return DateFormat('dd MMM yyyy, HH:mm', 'id').format(date);
  }

  /// Format decimal numbers to max 1 decimal point
  static String score(double value) {
    return value.toStringAsFixed(1);
  }
}
