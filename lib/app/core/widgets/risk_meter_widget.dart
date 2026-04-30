import 'package:flutter/material.dart';
import 'dart:math';
import '../theme/app_colors.dart';
import '../theme/app_dimensions.dart';
import '../utils/responsive.dart';

/// Animated arc gauge — "Clinical Curator" spec.
///
/// • 220° sweep from bottom-left (starts at ~160° from positive-x-axis)
/// • 8px stroke
/// • Zone colours inline: primary → tertiary → error
/// • Animated tween 0 → score, 1200ms, Curves.easeOutCubic
/// • Borderless pill chip for risk level (background.withOpacity(0.15))
class RiskMeterWidget extends StatefulWidget {
  final double score; // 0.0 to 10.0
  final double size;
  final bool animate;

  const RiskMeterWidget({
    super.key,
    required this.score,
    this.size = AppDimensions.riskMeterDefault,
    this.animate = true,
  });

  @override
  State<RiskMeterWidget> createState() => _RiskMeterWidgetState();
}

class _RiskMeterWidgetState extends State<RiskMeterWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scoreAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _scoreAnim = Tween<double>(begin: 0, end: widget.score).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );
    if (widget.animate) {
      _controller.forward();
    } else {
      _controller.value = 1.0;
    }
  }

  @override
  void didUpdateWidget(RiskMeterWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.score != widget.score) {
      _scoreAnim = Tween<double>(
        begin: _scoreAnim.value,
        end: widget.score,
      ).animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
      );
      _controller
        ..reset()
        ..forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scoreAnim,
      builder: (context, _) {
        final score = _scoreAnim.value;
        final riskColor = _getRiskColor(score);
        final riskLabel = _getRiskLabel(widget.score); // use final score for label

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: widget.size,
              height: widget.size * 0.62,
              child: CustomPaint(
                painter: _ArcGaugePainter(
                  score: score,
                  strokeWidth: AppDimensions.riskMeterStrokeWidth,
                ),
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.only(top: widget.size * 0.18),
                    child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          widget.score.toStringAsFixed(1),
                          style: TextStyle(
                            fontSize: responsiveFontSize(
                              context,
                              widget.size * 0.233,
                              minVal: 12.0,
                              maxVal: 40.0,
                            ),
                            fontWeight: FontWeight.w700,
                            color: AppColors.onSurface,
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          riskLabel.toUpperCase(),
                          style: TextStyle(
                            fontSize: responsiveFontSize(
                              context,
                              widget.size * 0.091,
                              minVal: 8.0,
                              maxVal: 14.0,
                            ),
                            fontWeight: FontWeight.w600,
                            color: AppColors.onSurfaceVariant,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppDimensions.sm),
            // Borderless pill chip — Rule 6
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.md,
                vertical: AppDimensions.xs,
              ),
              decoration: BoxDecoration(
                color: riskColor.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(AppDimensions.radiusPill),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 7,
                    height: 7,
                    decoration: BoxDecoration(
                      color: riskColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'RISIKO ${riskLabel.toUpperCase()}',
                    style: TextStyle(
                      fontSize: responsiveFontSize(context, 12.0, minVal: 10.0, maxVal: 16.0),
                      fontWeight: FontWeight.w700,
                      color: riskColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Color _getRiskColor(double s) {
    if (s < 4.0) return AppColors.riskLow;
    if (s < 7.0) return AppColors.riskMedium;
    return AppColors.riskHigh;
  }

  String _getRiskLabel(double s) {
    if (s < 4.0) return 'Rendah';
    if (s < 7.0) return 'Sedang';
    return 'Tinggi';
  }
}

/// 220° arc gauge painter.
/// Starts at 160° from positive-x-axis (bottom-left), sweeps 220°.
class _ArcGaugePainter extends CustomPainter {
  final double score; // animated 0–10
  final double strokeWidth;

  // 220° total sweep, starting from bottom-left
  static const double _startAngleDeg = 160.0;
  static const double _sweepDeg = 220.0;

  const _ArcGaugePainter({
    required this.score,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height * 0.85);
    final radius = (size.width / 2) - strokeWidth;
    final rect = Rect.fromCircle(center: center, radius: radius);

    final startAngle = _startAngleDeg * pi / 180;
    final totalSweep = _sweepDeg * pi / 180;

    // ── Background track ──────────────────────────────────────────
    final bgPaint = Paint()
      ..color = AppColors.surfaceContainerHighest
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(rect, startAngle, totalSweep, false, bgPaint);

    // ── Coloured value arc ─────────────────────────────────────────
    final fraction = (score / 10.0).clamp(0.0, 1.0);
    final valueSweep = totalSweep * fraction;

    if (valueSweep <= 0) return;

    // Zone boundaries (fraction of 0–10)
    const lowEnd = 4.0 / 10.0;   // 0.4
    const medEnd = 7.0 / 10.0;   // 0.7

    if (fraction <= lowEnd) {
      // All green
      _drawArc(canvas, rect, startAngle, valueSweep, AppColors.riskLow);
    } else if (fraction <= medEnd) {
      // Green portion + amber portion
      final lowSweep = totalSweep * lowEnd;
      _drawArc(canvas, rect, startAngle, lowSweep, AppColors.riskLow);
      final ambSweep = valueSweep - lowSweep;
      _drawArc(canvas, rect, startAngle + lowSweep, ambSweep, AppColors.riskMedium);
    } else {
      // Full green + full amber + red portion
      final lowSweep = totalSweep * lowEnd;
      final medSweep = totalSweep * (medEnd - lowEnd);
      final redSweep = valueSweep - lowSweep - medSweep;
      _drawArc(canvas, rect, startAngle, lowSweep, AppColors.riskLow);
      _drawArc(canvas, rect, startAngle + lowSweep, medSweep, AppColors.riskMedium);
      _drawArc(canvas, rect, startAngle + lowSweep + medSweep, redSweep, AppColors.riskHigh);
    }

    // ── Pointer needle ─────────────────────────────────────────────
    final needleAngle = startAngle + valueSweep;
    final needleStart = center;
    final needleEnd = Offset(
      center.dx + (radius - strokeWidth * 1.5) * cos(needleAngle),
      center.dy + (radius - strokeWidth * 1.5) * sin(needleAngle),
    );

    final needlePaint = Paint()
      ..color = AppColors.onSurface.withValues(alpha: 0.75)
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(needleStart, needleEnd, needlePaint);

    // Centre dot
    canvas.drawCircle(
      center,
      4,
      Paint()..color = AppColors.onSurface.withValues(alpha: 0.85),
    );
  }

  void _drawArc(Canvas c, Rect r, double start, double sweep, Color color) {
    c.drawArc(
      r,
      start,
      sweep,
      false,
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(covariant _ArcGaugePainter old) =>
      old.score != score || old.strokeWidth != strokeWidth;
}
