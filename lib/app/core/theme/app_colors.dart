import 'package:flutter/material.dart';

/// AllerRisk design token colors — "The Clinical Curator"
/// Seed: #2C7A5C | Secondary: #1D5FA8 | Tertiary: #C4940A
abstract class AppColors {
  // ── Brand Seeds ───────────────────────────────────────────────
  static const Color primary = Color(0xFF2C7A5C);
  static const Color primaryDark = Color(0xFF056145);
  static const Color primaryContainer = Color(0xFFA5F3CE);
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color onPrimaryContainer = Color(0xFF002116);

  static const Color secondary = Color(0xFF1D5FA8);
  static const Color secondaryContainer = Color(0xFFD3E4FF);
  static const Color onSecondary = Color(0xFFFFFFFF);
  static const Color onSecondaryContainer = Color(0xFF001C3A);

  static const Color tertiary = Color(0xFFC4940A);
  static const Color tertiaryContainer = Color(0xFFFFDFA0);
  static const Color onTertiary = Color(0xFFFFFFFF);
  static const Color onTertiaryContainer = Color(0xFF281900);

  static const Color error = Color(0xFFB3261E);
  static const Color errorContainer = Color(0xFFF9DEDC);
  static const Color onError = Color(0xFFFFFFFF);
  static const Color onErrorContainer = Color(0xFF410E0B);

  // ── Neutral / Surface Hierarchy ───────────────────────────────
  /// Level 0 (Base)
  static const Color surface = Color(0xFFF9F9FF);

  /// Level 1 (Sub-sectioning)
  static const Color surfaceContainerLow = Color(0xFFF1F3FF);

  /// Level 2 (Active Cards — max pop)
  static const Color surfaceContainerLowest = Color(0xFFFFFFFF);

  /// Level 3 (Interactive Overlays)
  static const Color surfaceContainerHigh = Color(0xFFE4E8F4);
  static const Color surfaceContainerHighest = Color(0xFFDEE2EE);

  static const Color surfaceDim = Color(0xFFDADAE7);
  static const Color surfaceBright = Color(0xFFF9F9FF);
  static const Color surfaceContainer = Color(0xFFF1F3FF);

  static const Color success = Color(0xFF1E8E3E);

  static const Color onSurface = Color(0xFF111827);
  static const Color onSurfaceVariant = Color(0xFF3F4943);
  static const Color outline = Color(0xFF737B73);
  static const Color outlineVariant = Color(0xFFC2C8BC);

  // ── Dark Theme Surfaces ──────────────────────────────────────
  static const Color surfaceDark = Color(0xFF0F1412);
  static const Color surfaceContainerLowDark = Color(0xFF1C211F);
  static const Color surfaceContainerLowestDark = Color(0xFF0A0F0D);
  static const Color surfaceContainerHighDark = Color(0xFF2D3330);
  static const Color onSurfaceDark = Color(0xFFE1E3E0);
  static const Color onSurfaceVariantDark = Color(0xFFC2C8BC);
  static const Color outlineVariantDark = Color(0xFF404943);

  // ── Risk Level Colors ────────────────────────────────────────
  static const Color riskLow = Color(0xFF2C7A5C);
  static const Color riskLowContainer = Color(0xFFCDF3E1);
  static const Color riskMedium = Color(0xFFC4940A);
  static const Color riskMediumContainer = Color(0xFFFFF3CC);
  static const Color riskHigh = Color(0xFFB3261E);
  static const Color riskHighContainer = Color(0xFFF9DEDC);

  // ── Utility ──────────────────────────────────────────────────
  static const Color transparent = Colors.transparent;
  static const Color black = Color(0xFF000000);
  static const Color white = Color(0xFFFFFFFF);

  // ── Glassmorphism ────────────────────────────────────────────
  /// 80% opacity surface for glassmorphic overlays
  static Color get glassSurface => surface.withValues(alpha: 0.80);
  static Color get glassSurfaceDark => surfaceDark.withValues(alpha: 0.80);

  // ── Ghost Border (accessibility fallback) ────────────────────
  /// outlineVariant at 15% opacity — "suggestion of a line"
  static Color get ghostBorder => outlineVariant.withValues(alpha: 0.15);
}
