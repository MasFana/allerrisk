/// Layout constants — spacing scale, radius, elevation, breakpoints.
abstract class AppDimensions {
  // ── Spacing Scale ────────────────────────────────────────────
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
  static const double xxl = 48.0;

  /// 3xl — "Optical Breathing Room" between major clinical sections
  static const double xxxl = 64.0;

  // ── Border Radius ────────────────────────────────────────────
  static const double radiusXs = 4.0;
  static const double radiusSm = 8.0;
  static const double radiusMd = 12.0;
  static const double radiusLg = 16.0;
  static const double radiusXl = 24.0;

  /// 9999 — pill shape for chips and risk badges
  static const double radiusPill = 9999.0;

  // ── Icon Sizes ───────────────────────────────────────────────
  static const double iconSm = 16.0;
  static const double iconMd = 24.0;
  static const double iconLg = 32.0;

  // ── Avatar Sizes ─────────────────────────────────────────────
  static const double avatarSm = 32.0;
  static const double avatarMd = 48.0;
  static const double avatarLg = 64.0;

  // ── Elevation ────────────────────────────────────────────────
  static const double elevationNone = 0.0;
  static const double elevationLow = 1.0;
  static const double elevationMid = 3.0;

  /// Floating elements (Modals, FABs) — keep ambient, never harsh
  static const double elevationFloat = 6.0;

  // ── Glassmorphism ────────────────────────────────────────────
  static const double blurSm = 12.0;
  static const double blurLg = 20.0;

  // ── Bottom Nav ───────────────────────────────────────────────
  static const double bottomNavHeight = 72.0;
  static const double appBarHeight = 56.0;

  // ── Risk Meter ───────────────────────────────────────────────
  static const double riskMeterDefault = 200.0;
  static const double riskMeterStrokeWidth = 8.0;

  // ── Card / Input ─────────────────────────────────────────────
  static const double cardPadding = 20.0;
  static const double inputBottomBorderWidth = 1.5;

  // ── Breakpoints ───────────────────────────────────────────────
  static const double breakpointMobile = 600.0;
  static const double breakpointTablet = 900.0;
}
