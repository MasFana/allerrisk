import 'package:flutter/widgets.dart';

/// Small responsive helpers used across the app to compute sane sizes
/// based on the available screen height or a specific available height.
///
/// Keeping these in one place makes it easier to tune breakpoints and
/// keep UI behaviors consistent between widgets.

/// Clamp a size computed from a fraction of the screen height into
/// a [minVal]..[maxVal] range. Useful for list/card heights that should
/// scale on taller screens but remain usable on short screens.

double responsiveClampHeight(
  BuildContext context, {
  double ratio = 0.18,
  double minVal = 56.0,
  double maxVal = double.infinity,
}) {
  final screenH = MediaQuery.of(context).size.height;
  final candidate = screenH * ratio;
  return (candidate).clamp(minVal, maxVal) as double;
}

/// Clamp a size computed from a fraction of the screen width into
/// a [minVal]..[maxVal] range. Useful for horizontally-scrolling card
/// widths that should scale with screen width.

double responsiveClampWidth(
  BuildContext context, {
  double ratio = 0.45,
  double minVal = 120.0,
  double maxVal = double.infinity,
}) {
  final screenW = MediaQuery.of(context).size.width;
  final candidate = screenW * ratio;
  return (candidate).clamp(minVal, maxVal) as double;
}

/// Compute a size for the risk meter (or any widget that should be
/// proportional to an available height). [availHeight] is typically
/// the max height provided by a LayoutBuilder constraint. The result
/// is clamped between [minVal] and [maxVal] after applying [factor].

double responsiveMeterSizeFromAvailable(
  double availHeight, {
  double factor = 0.9,
  double minVal = 56.0,
  double maxVal = 120.0,
}) {
  final candidate = availHeight * factor;
  return (candidate).clamp(minVal, maxVal) as double;
}

/// Compute a responsive font size that respects the system
/// textScaleFactor and clamps to [minVal]..[maxVal]. [base] is the
/// logical font size to scale.

double responsiveFontSize(
  BuildContext context,
  double base, {
  double minVal = 10.0,
  double maxVal = 40.0,
}) {
  final tsf = MediaQuery.textScaleFactorOf(context);
  final candidate = base * tsf;
  return (candidate).clamp(minVal, maxVal) as double;
}
