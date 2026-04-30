import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// AllerRisk typography — Plus Jakarta Sans as branding tool (DESIGN.md §3)
///
/// Display & Headlines: weight 700, tight letter-spacing (-0.02em) — "news-header"
/// Title Layer: 22px / 600 — "prominent and reassuring"
/// Body & Labels: 14px, line-height 1.6 — legible for medical information
/// Contrast as Hierarchy: pair display-md metric with label-sm descriptor
abstract class AppTypography {
  static TextTheme get textTheme => TextTheme(
    // ── Display ──────────────────────────────────────────────
    displayLarge: GoogleFonts.plusJakartaSans(
      fontSize: 57,
      fontWeight: FontWeight.w700,
      letterSpacing: -0.02 * 57,
      height: 1.12,
      color: AppColors.onSurface,
    ),
    displayMedium: GoogleFonts.plusJakartaSans(
      fontSize: 45,
      fontWeight: FontWeight.w700,
      letterSpacing: -0.02 * 45,
      height: 1.16,
      color: AppColors.onSurface,
    ),
    displaySmall: GoogleFonts.plusJakartaSans(
      fontSize: 36,
      fontWeight: FontWeight.w700,
      letterSpacing: -0.02 * 36,
      height: 1.22,
      color: AppColors.onSurface,
    ),

    // ── Headline ─────────────────────────────────────────────
    headlineLarge: GoogleFonts.plusJakartaSans(
      fontSize: 32,
      fontWeight: FontWeight.w700,
      letterSpacing: -0.01 * 32,
      height: 1.25,
      color: AppColors.onSurface,
    ),
    headlineMedium: GoogleFonts.plusJakartaSans(
      fontSize: 28,
      fontWeight: FontWeight.w700,
      letterSpacing: -0.01 * 28,
      height: 1.29,
      color: AppColors.onSurface,
    ),
    headlineSmall: GoogleFonts.plusJakartaSans(
      fontSize: 24,
      fontWeight: FontWeight.w700,
      letterSpacing: -0.005 * 24,
      height: 1.33,
      color: AppColors.onSurface,
    ),

    // ── Title — bridge between clinical data and user ─────────
    titleLarge: GoogleFonts.plusJakartaSans(
      fontSize: 22,
      fontWeight: FontWeight.w600,
      letterSpacing: 0,
      height: 1.27,
      color: AppColors.onSurface,
    ),
    titleMedium: GoogleFonts.plusJakartaSans(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.01 * 16,
      height: 1.5,
      color: AppColors.onSurface,
    ),
    titleSmall: GoogleFonts.plusJakartaSans(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.01 * 14,
      height: 1.43,
      color: AppColors.onSurface,
    ),

    // ── Body — workhorse for complex medical info (1.6 line-height) ──
    bodyLarge: GoogleFonts.plusJakartaSans(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.5,
      height: 1.6,
      color: AppColors.onSurface,
    ),
    bodyMedium: GoogleFonts.plusJakartaSans(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.25,
      height: 1.6,
      color: AppColors.onSurface,
    ),
    bodySmall: GoogleFonts.plusJakartaSans(
      fontSize: 12,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.4,
      height: 1.6,
      color: AppColors.onSurfaceVariant,
    ),

    // ── Label ────────────────────────────────────────────────
    labelLarge: GoogleFonts.plusJakartaSans(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.05 * 14,
      height: 1.43,
      color: AppColors.onSurface,
    ),
    labelMedium: GoogleFonts.plusJakartaSans(
      fontSize: 12,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.05 * 12,
      height: 1.33,
      color: AppColors.onSurface,
    ),
    labelSmall: GoogleFonts.plusJakartaSans(
      fontSize: 11,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.05 * 11,
      height: 1.45,
      color: AppColors.onSurfaceVariant,
    ),
  );
}
