import 'package:flutter/material.dart';

/// Dart extension methods used project-wide.

// ── String Extensions ─────────────────────────────────────────────────────
extension StringValidator on String {
  /// True if looks like a valid email address
  bool get isValidEmail =>
      RegExp(r'^[\w\-\.]+@([\w\-]+\.)+[\w\-]{2,}$').hasMatch(trim());

  /// True if at least 8 characters
  bool get isValidPassword => trim().length >= 8;

  /// Title-cases every word: "hello world" → "Hello World"
  String get toTitleCase => split(
    ' ',
  ).map((w) => w.isEmpty ? w : w[0].toUpperCase() + w.substring(1)).join(' ');

  /// Returns null if the string is empty/blank, otherwise returns itself.
  String? get nullIfEmpty => trim().isEmpty ? null : this;

  /// Capitalises only the first character.
  String get capitalised =>
      isEmpty ? this : '${this[0].toUpperCase()}${substring(1)}';
}

// ── Nullable String ───────────────────────────────────────────────────────
extension NullableString on String? {
  bool get isNullOrEmpty => this == null || this!.trim().isEmpty;
  String get orEmpty => this ?? '';
}

// ── DateTime Extensions ───────────────────────────────────────────────────
extension DateTimeHelper on DateTime {
  /// Returns age in months from this date to now.
  int get ageInMonths {
    final now = DateTime.now();
    return (now.year - year) * 12 + (now.month - month);
  }

  /// True if within the same calendar day as now.
  bool get isToday {
    final now = DateTime.now();
    return year == now.year && month == now.month && day == now.day;
  }

  /// True if day before today.
  bool get isYesterday {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return year == yesterday.year &&
        month == yesterday.month &&
        day == yesterday.day;
  }

  /// Returns start-of-day (midnight).
  DateTime get startOfDay => DateTime(year, month, day);
}

// ── BuildContext Shortcuts ────────────────────────────────────────────────
extension ContextHelper on BuildContext {
  ThemeData get theme => Theme.of(this);
  ColorScheme get colors => Theme.of(this).colorScheme;
  TextTheme get textTheme => Theme.of(this).textTheme;
  Size get screenSize => MediaQuery.sizeOf(this);
  double get screenWidth => MediaQuery.sizeOf(this).width;
  double get screenHeight => MediaQuery.sizeOf(this).height;
  bool get isDark => Theme.of(this).brightness == Brightness.dark;
}

// ── Color with named alpha ────────────────────────────────────────────────
extension ColorAlpha on Color {
  /// Same as withValues(alpha:) but expressed as a [0..1] opacity double.
  Color withOpacity01(double opacity) =>
      withValues(alpha: opacity.clamp(0.0, 1.0));
}

// ── Double / num ──────────────────────────────────────────────────────────
extension NumClamped on double {
  double clamp01() => clamp(0.0, 1.0).toDouble();
}

// ── List ──────────────────────────────────────────────────────────────────
extension ListUtils<T> on List<T> {
  /// Returns first element matching [test], or null if not found.
  T? firstWhereOrNull(bool Function(T) test) {
    for (final e in this) {
      if (test(e)) return e;
    }
    return null;
  }
}
