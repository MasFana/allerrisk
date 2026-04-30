import 'package:intl/intl.dart';

/// Pure-function validators for form fields — no Flutter dependencies.
abstract class Validators {
  /// Email format validation (RFC-simplified)
  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) return 'Email wajib diisi.';
    final emailRegex = RegExp(r'^[\w\-\.]+@([\w\-]+\.)+[\w\-]{2,}$');
    if (!emailRegex.hasMatch(value.trim())) return 'Format email tidak valid.';
    return null;
  }

  /// Password — minimum 8 characters
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'Kata sandi wajib diisi.';
    if (value.length < 8) return 'Kata sandi minimal 8 karakter.';
    return null;
  }

  /// Confirm-password match
  static String? validateConfirmPassword(String? value, String password) {
    final base = validatePassword(value);
    if (base != null) return base;
    if (value != password) return 'Kata sandi tidak cocok.';
    return null;
  }

  /// Required (non-empty) field
  static String? validateRequired(String? value, {String? fieldName}) {
    if (value == null || value.trim().isEmpty) {
      return '${fieldName ?? 'Kolom ini'} wajib diisi.';
    }
    return null;
  }

  /// Nomor STR — exactly 11 digits
  static String? validateStr(String? value) {
    if (value == null || value.trim().isEmpty) return 'Nomor STR wajib diisi.';
    final cleaned = value.replaceAll(RegExp(r'\s+'), '');
    if (!RegExp(r'^\d{11}$').hasMatch(cleaned)) {
      return 'Nomor STR harus 11 digit.';
    }
    return null;
  }

  /// Positive decimal number (weight, height)
  static String? validatePositiveDecimal(String? value, {String? fieldName}) {
    if (value == null || value.trim().isEmpty) return null; // optional fields
    final parsed = double.tryParse(value.replaceAll(',', '.'));
    if (parsed == null || parsed <= 0) {
      return '${fieldName ?? 'Nilai'} harus berupa angka positif.';
    }
    return null;
  }

  /// Date of birth — must not be in the future, child < 18 years
  static String? validateDateOfBirth(DateTime? value) {
    if (value == null) return 'Tanggal lahir wajib diisi.';
    final now = DateTime.now();
    if (value.isAfter(now)) return 'Tanggal lahir tidak boleh di masa depan.';
    final ageYears = now.year - value.year;
    if (ageYears > 18) return 'Usia anak tidak boleh lebih dari 18 tahun.';
    return null;
  }
}

/// Date and number formatters using Indonesian locale.
abstract class Formatters {
  static final DateFormat _dayMonthYear = DateFormat('dd MMM yyyy', 'id');
  static final DateFormat _dayMonth = DateFormat('d MMM', 'id');
  static final DateFormat _monthYear = DateFormat('MMM yyyy', 'id');
  static final DateFormat _timeHm = DateFormat('HH:mm', 'id');
  static final DateFormat _fullDateTime = DateFormat('d MMM yyyy, HH:mm', 'id');

  /// e.g. "10 Jan 2025"
  static String date(DateTime dt) => _dayMonthYear.format(dt);

  /// e.g. "10 Jan"
  static String dayMonth(DateTime dt) => _dayMonth.format(dt);

  /// e.g. "Jan 2025"
  static String monthYear(DateTime dt) => _monthYear.format(dt);

  /// e.g. "14:30"
  static String time(DateTime dt) => _timeHm.format(dt);

  /// e.g. "10 Jan 2025, 14:30"
  static String dateTime(DateTime dt) => _fullDateTime.format(dt);

  /// Relative time — "2 jam lalu", "kemarin", etc.
  static String relative(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 1) return 'Baru saja';
    if (diff.inMinutes < 60) return '${diff.inMinutes} menit lalu';
    if (diff.inHours < 24) return '${diff.inHours} jam lalu';
    if (diff.inDays == 1) return 'Kemarin';
    if (diff.inDays < 7) return '${diff.inDays} hari lalu';
    if (diff.inDays < 30) return '${diff.inDays ~/ 7} minggu lalu';
    if (diff.inDays < 365) return '${diff.inDays ~/ 30} bulan lalu';
    return '${diff.inDays ~/ 365} tahun lalu';
  }

  /// Format assessment score — "7.5 / 10.0"
  static String score(double value) => '${value.toStringAsFixed(1)} / 10.0';

  /// Age display in Indonesian — "3 tahun 2 bulan" / "8 bulan"
  static String ageDisplay(DateTime dob) {
    final now = DateTime.now();
    final months = (now.year - dob.year) * 12 + (now.month - dob.month);
    if (months < 12) return '$months bulan';
    final years = months ~/ 12;
    final rem = months % 12;
    return rem == 0 ? '$years tahun' : '$years tahun $rem bulan';
  }

  /// Decimal with optional comma replacement for input display
  static String decimal(double? value, {int places = 1}) {
    if (value == null) return '-';
    return value.toStringAsFixed(places);
  }
}
