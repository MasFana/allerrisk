import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_colors.dart';
import 'app_typography.dart';
import 'app_dimensions.dart';

/// AllerRisk ThemeData — "The Clinical Curator"
///
/// Key rules from DESIGN.md:
///   • No 1px solid borders (the No-Line Rule)
///   • Surface hierarchy via background shifts, not dividers
///   • Gradient CTA buttons (primary → primary-container, 135°)
///   • Glassmorphism for floating nav/modals (backdrop-blur 12–20px)
///   • Ambient shadows only: blur 32px, y 8px, rgba tint of on-surface
abstract class AppTheme {
  // ── Light Theme ───────────────────────────────────────────────
  static ThemeData get light => _build(Brightness.light);

  // ── Dark Theme ────────────────────────────────────────────────
  static ThemeData get dark => _build(Brightness.dark);

  static ThemeData _build(Brightness brightness) {
    final isDark = brightness == Brightness.dark;

    final colorScheme = isDark
        ? ColorScheme.fromSeed(
            seedColor: AppColors.primary,
            brightness: Brightness.dark,
          ).copyWith(
            primary: AppColors.primary,
            onPrimary: AppColors.onPrimary,
            primaryContainer: AppColors.onPrimaryContainer,
            secondary: AppColors.secondary,
            tertiary: AppColors.tertiary,
            error: AppColors.error,
            surface: AppColors.surfaceDark,
            onSurface: AppColors.onSurfaceDark,
            onSurfaceVariant: AppColors.onSurfaceVariantDark,
            outline: AppColors.outlineVariantDark,
            outlineVariant: AppColors.outlineVariantDark,
          )
        : ColorScheme.fromSeed(
            seedColor: AppColors.primary,
            brightness: Brightness.light,
          ).copyWith(
            primary: AppColors.primary,
            onPrimary: AppColors.onPrimary,
            primaryContainer: AppColors.primaryContainer,
            onPrimaryContainer: AppColors.onPrimaryContainer,
            secondary: AppColors.secondary,
            onSecondary: AppColors.onSecondary,
            secondaryContainer: AppColors.secondaryContainer,
            onSecondaryContainer: AppColors.onSecondaryContainer,
            tertiary: AppColors.tertiary,
            onTertiary: AppColors.onTertiary,
            tertiaryContainer: AppColors.tertiaryContainer,
            onTertiaryContainer: AppColors.onTertiaryContainer,
            error: AppColors.error,
            onError: AppColors.onError,
            errorContainer: AppColors.errorContainer,
            onErrorContainer: AppColors.onErrorContainer,
            surface: AppColors.surface,
            onSurface: AppColors.onSurface,
            onSurfaceVariant: AppColors.onSurfaceVariant,
            outline: AppColors.outline,
            outlineVariant: AppColors.outlineVariant,
          );

    final textTheme = AppTypography.textTheme;

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      brightness: brightness,
      textTheme: textTheme,

      // ── Scaffold ──────────────────────────────────────────────
      scaffoldBackgroundColor: isDark
          ? AppColors.surfaceDark
          : AppColors.surface,

      // ── AppBar — no elevation, transparent, no border ─────────
      appBarTheme: AppBarTheme(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: isDark ? AppColors.onSurfaceDark : AppColors.onSurface,
        systemOverlayStyle: isDark
            ? SystemUiOverlayStyle.light
            : SystemUiOverlayStyle.dark,
        titleTextStyle: textTheme.titleLarge?.copyWith(
          color: isDark ? AppColors.onSurfaceDark : AppColors.onSurface,
        ),
        iconTheme: IconThemeData(
          color: isDark ? AppColors.onSurfaceDark : AppColors.onSurface,
        ),
      ),

      // ── Card — no hard borders, tonal lift ───────────────────
      cardTheme: CardThemeData(
        elevation: AppDimensions.elevationNone,
        color: isDark
            ? AppColors.surfaceContainerLowDark
            : AppColors.surfaceContainerLowest,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        ),
        clipBehavior: Clip.antiAlias,
      ),

      // ── Elevated Button — gradient fill via custom widget ─────
      // Base theme just shapes; AlleriskButton handles gradients.
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.onPrimary,
          elevation: AppDimensions.elevationNone,
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.lg,
            vertical: AppDimensions.md,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusXl),
          ),
          textStyle: textTheme.labelLarge?.copyWith(
            letterSpacing: 0.05 * 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // ── Text Button ───────────────────────────────────────────
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          textStyle: textTheme.labelLarge,
        ),
      ),

      // ── Input — Soft Underline (no box) ───────────────────────
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: isDark
            ? AppColors.surfaceContainerLowDark
            : AppColors.surfaceContainerLow,
        border: const UnderlineInputBorder(
          borderSide: BorderSide(
            color: AppColors.outlineVariant,
            width: AppDimensions.inputBottomBorderWidth,
          ),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: isDark
                ? AppColors.outlineVariantDark
                : AppColors.outlineVariant,
            width: AppDimensions.inputBottomBorderWidth,
          ),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: AppColors.primary,
            width: AppDimensions.inputBottomBorderWidth + 0.5,
          ),
        ),
        errorBorder: const UnderlineInputBorder(
          borderSide: BorderSide(
            color: AppColors.error,
            width: AppDimensions.inputBottomBorderWidth,
          ),
        ),
        focusedErrorBorder: const UnderlineInputBorder(
          borderSide: BorderSide(
            color: AppColors.error,
            width: AppDimensions.inputBottomBorderWidth + 0.5,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.md,
          vertical: AppDimensions.md,
        ),
        labelStyle: textTheme.bodyMedium?.copyWith(
          color: isDark
              ? AppColors.onSurfaceVariantDark
              : AppColors.onSurfaceVariant,
        ),
        hintStyle: textTheme.bodyMedium?.copyWith(
          color:
              (isDark
                      ? AppColors.onSurfaceVariantDark
                      : AppColors.onSurfaceVariant)
                  .withValues(alpha: 0.6),
        ),
      ),

      // ── Divider — kept minimal (line rule) ────────────────────
      dividerTheme: const DividerThemeData(
        color: Colors.transparent,
        space: 0,
        thickness: 0,
      ),

      // ── Bottom Navigation ─────────────────────────────────────
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        elevation: 0,
        backgroundColor: isDark
            ? AppColors.surfaceContainerHighDark.withValues(alpha: 0.95)
            : AppColors.surfaceContainerLowest.withValues(alpha: 0.95),
        selectedItemColor: AppColors.primary,
        unselectedItemColor: isDark
            ? AppColors.onSurfaceVariantDark
            : AppColors.onSurfaceVariant,
        selectedLabelStyle: textTheme.labelSmall,
        unselectedLabelStyle: textTheme.labelSmall,
        type: BottomNavigationBarType.fixed,
      ),

      // ── Chip ─────────────────────────────────────────────────
      chipTheme: ChipThemeData(
        backgroundColor: isDark
            ? AppColors.surfaceContainerHighDark
            : AppColors.surfaceContainerLow,
        labelStyle: textTheme.labelMedium,
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.md,
          vertical: AppDimensions.xs,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusPill),
        ),
        side: BorderSide.none,
      ),

      // ── Dialog ────────────────────────────────────────────────
      dialogTheme: DialogThemeData(
        backgroundColor: isDark
            ? AppColors.surfaceContainerLowDark
            : AppColors.surface,
        elevation: AppDimensions.elevationFloat,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusXl),
        ),
        titleTextStyle: textTheme.headlineSmall,
        contentTextStyle: textTheme.bodyMedium,
      ),

      // ── Bottom Sheet ──────────────────────────────────────────
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: isDark
            ? AppColors.surfaceContainerLowDark
            : AppColors.surface,
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppDimensions.radiusXl),
          ),
        ),
      ),

      // ── Snackbar ─────────────────────────────────────────────
      snackBarTheme: SnackBarThemeData(
        backgroundColor: isDark
            ? AppColors.surfaceContainerHighDark
            : AppColors.onSurface,
        contentTextStyle: textTheme.bodyMedium?.copyWith(
          color: isDark ? AppColors.onSurface : AppColors.surface,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // ── Shared shadow — ambient, never pure black ─────────────────
  static List<BoxShadow> get ambientShadow => [
    BoxShadow(
      color: AppColors.onSurface.withValues(alpha: 0.06),
      blurRadius: 32,
      offset: const Offset(0, 8),
    ),
  ];

  // ── CTA gradient — primary to primaryDark at 135° ────────────
  static const LinearGradient ctaGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [AppColors.primaryDark, AppColors.primary],
    transform: GradientRotation(2.356),
  );
}
