import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/allerisk_button.dart';
import '../../../core/widgets/risk_meter_widget.dart';
import '../../../data/models/assessment_result_model.dart';
import 'result_controller.dart';

class ResultView extends GetView<ResultController> {
  const ResultView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final result = controller.result;

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        title: const Text('Hasil Asesmen'),
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.onSurface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: controller.goHome,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.sm),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── Risk Score Card ──────────────────────────────────
            _buildScoreCard(theme, result),
            const SizedBox(height: AppDimensions.lg),
            // ── Anaphylaxis Warning ──────────────────────────────
            if (result.anaphylaxisOverride)
              _buildAnaphylaxisWarning(theme),
            // ── Criterion Breakdown ──────────────────────────────
            _buildBreakdownSection(theme, result),
            const SizedBox(height: AppDimensions.lg),
            // ── Recommendations ──────────────────────────────────
            _buildRecommendations(theme, result),
            const SizedBox(height: AppDimensions.lg),
            // ── Action Buttons ───────────────────────────────────
            _buildActions(theme),
            const SizedBox(height: AppDimensions.lg),
          ],
        ),
      ),
    );
  }

  // ── Score Card ─────────────────────────────────────────────────

  Widget _buildScoreCard(ThemeData theme, AssessmentResult result) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.lg),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(AppDimensions.radiusXl),
        // Rule 2: ambient shadow only — no colored tint
        boxShadow: AppTheme.ambientShadow,
      ),
      child: Column(
        children: [
          RiskMeterWidget(score: result.score),
          const SizedBox(height: AppDimensions.md),
          Text(
            DateFormat('dd MMMM yyyy, HH:mm', 'id_ID')
                .format(result.assessedAt),
            style: theme.textTheme.labelMedium
                ?.copyWith(color: AppColors.onSurfaceVariant),
          ),
        ],
      ),
    );
  }

  // ── Anaphylaxis Warning ────────────────────────────────────────

  Widget _buildAnaphylaxisWarning(ThemeData theme) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppDimensions.xxxl),
      padding: const EdgeInsets.all(AppDimensions.md),
      decoration: BoxDecoration(
        // Rule 1: no Border.all — use background colour only
        color: AppColors.errorContainer,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.warning_amber_rounded,
              color: AppColors.error, size: AppDimensions.iconLg),
          const SizedBox(width: AppDimensions.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('⚠ Riwayat Anafilaksis Terdeteksi',
                    style: theme.textTheme.titleSmall?.copyWith(
                        color: AppColors.error,
                        fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(
                  'Anak ini pernah mengalami reaksi anafilaksis. Hal ini secara otomatis meningkatkan kategori risiko ke TINGGI. Segera konsultasikan dengan dokter spesialis alergi.',
                  style: theme.textTheme.bodySmall
                      ?.copyWith(color: AppColors.onErrorContainer),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Criterion Breakdown ────────────────────────────────────────

  Widget _buildBreakdownSection(
      ThemeData theme, AssessmentResult result) {
    final b = result.breakdown;
    return _buildCard(
      theme: theme,
      title: 'Rincian Penilaian',
      icon: Icons.bar_chart_rounded,
      child: Column(
        children: [
          _buildBreakdownBar(theme, 'Genetik',
              b.geneticScore, AppColors.secondary),
          _buildBreakdownBar(theme, 'Gejala',
              b.symptomsScore, AppColors.riskHigh),
          _buildBreakdownBar(theme, 'Riwayat Medis',
              b.historyScore, AppColors.tertiary),
          _buildBreakdownBar(theme, 'Lingkungan',
              b.environmentScore, AppColors.riskMedium),
        ],
      ),
    );
  }

  Widget _buildBreakdownBar(
      ThemeData theme, String label, double score, Color color) {
    // Score is 0.0–10.0 per criterion
    final pct = (score / 10.0).clamp(0.0, 1.0);
    return Padding(
      padding: const EdgeInsets.only(bottom: AppDimensions.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label,
                  style: theme.textTheme.bodySmall?.copyWith(
                      color: AppColors.onSurface,
                      fontWeight: FontWeight.w500)),
              Text(score.toStringAsFixed(1),
                  style: theme.textTheme.bodySmall?.copyWith(
                      color: color, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius:
                BorderRadius.circular(AppDimensions.radiusPill),
            child: LinearProgressIndicator(
              value: pct,
              minHeight: 8,
              backgroundColor: AppColors.surfaceContainerHighest,
              valueColor: AlwaysStoppedAnimation(color),
            ),
          ),
        ],
      ),
    );
  }

  // ── Recommendations ────────────────────────────────────────────

  Widget _buildRecommendations(
      ThemeData theme, AssessmentResult result) {
    if (result.recommendations.isEmpty) return const SizedBox.shrink();

    return _buildCard(
      theme: theme,
      title: 'Rekomendasi',
      icon: Icons.tips_and_updates_rounded,
      child: Column(
        children: result.recommendations
            .map(
              (rec) => Padding(
                padding:
                    const EdgeInsets.only(bottom: AppDimensions.sm),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 4),
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: AppDimensions.sm),
                    Expanded(
                      child: Text(rec,
                          style: theme.textTheme.bodyMedium
                              ?.copyWith(color: AppColors.onSurface)),
                    ),
                  ],
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  // ── Actions ────────────────────────────────────────────────────

  Widget _buildActions(ThemeData theme) {
    return Column(
      children: [
        AlleriskButton(
          onPressed: controller.goHome,
          icon: Icons.home_rounded,
          text: 'Kembali ke Beranda',
        ),
        const SizedBox(height: AppDimensions.sm),
        AlleriskButton(
          onPressed: controller.goToHistory,
          icon: Icons.history_rounded,
          text: 'Lihat Riwayat Asesmen',
          isOutlined: true,
        ),
      ],
    );
  }

  // ── Shared Card ────────────────────────────────────────────────

  Widget _buildCard({
    required ThemeData theme,
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.md),
      margin:
          const EdgeInsets.only(bottom: AppDimensions.md),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        boxShadow: AppTheme.ambientShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon,
                  color: AppColors.primary,
                  size: AppDimensions.iconMd),
              const SizedBox(width: AppDimensions.sm),
              Text(title,
                  style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.onSurface)),
            ],
          ),
          // Rule 1: No divider line — use spacing only
          const SizedBox(height: AppDimensions.md),
          child,
        ],
      ),
    );
  }
}
