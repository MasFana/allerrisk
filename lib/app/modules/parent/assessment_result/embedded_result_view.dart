import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/allerisk_button.dart';
import '../../../core/widgets/risk_meter_widget.dart';
import '../../../data/models/assessment_result_model.dart';
import '../shell/parent_shell_controller.dart';

class EmbeddedResultView extends StatelessWidget {
  const EmbeddedResultView({super.key});

  @override
  Widget build(BuildContext context) {
    final shell = Get.find<ParentShellController>();
    final result = shell.latestResult.value;
    final theme = Theme.of(context);

    if (result == null) {
      return const Center(child: Text('Tidak ada hasil'));
    }

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.onSurface,
        elevation: 0,
        titleSpacing: AppDimensions.md,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => shell.closeResultDetail(),
        ),
        title: Text(
          'Hasil Asesmen',
          style: theme.textTheme.titleLarge?.copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined, color: AppColors.onSurface),
            onPressed: () {},
          ),
          const SizedBox(width: AppDimensions.xs),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.sm), // reduced spacing
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildScoreCard(theme, result),
            const SizedBox(height: AppDimensions.lg),
            if (result.anaphylaxisOverride) _buildAnaphylaxisWarning(theme),
            _buildBreakdownSection(theme, result),
            const SizedBox(height: AppDimensions.lg),
            _buildRecommendations(theme, result),
            const SizedBox(height: AppDimensions.sm),
            _buildActions(theme, shell),
            const SizedBox(height: AppDimensions.sm),
          ],
        ),
      ),
    );
  }

  Widget _buildScoreCard(ThemeData theme, AssessmentResult result) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.md),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        boxShadow: AppTheme.ambientShadow,
      ),
      child: Column(
        children: [
          RiskMeterWidget(score: result.score, size: 100),
          const SizedBox(height: AppDimensions.sm),
          Text(DateFormat('dd MMMM yyyy, HH:mm', 'id_ID').format(result.assessedAt),
              style: theme.textTheme.labelMedium?.copyWith(color: AppColors.onSurfaceVariant)),
        ],
      ),
    );
  }

  Widget _buildAnaphylaxisWarning(ThemeData theme) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppDimensions.lg),
      padding: const EdgeInsets.all(AppDimensions.sm),
      decoration: BoxDecoration(
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
                        color: AppColors.error, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(
                  'Anak ini pernah mengalami reaksi anafilaksis. Hal ini secara otomatis meningkatkan kategori risiko ke TINGGI. Segera konsultasikan dengan dokter spesialis alergi.',
                  style: theme.textTheme.bodySmall?.copyWith(color: AppColors.onErrorContainer),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBreakdownSection(ThemeData theme, AssessmentResult result) {
    final b = result.breakdown;
    return Container(
      padding: const EdgeInsets.all(AppDimensions.sm),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        boxShadow: AppTheme.ambientShadow,
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Rincian Penilaian', style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: AppDimensions.sm),
          _buildBreakdownBar(theme, 'Genetik', b.geneticScore, AppColors.secondary),
          _buildBreakdownBar(theme, 'Gejala', b.symptomsScore, AppColors.riskHigh),
          _buildBreakdownBar(theme, 'Riwayat Medis', b.historyScore, AppColors.tertiary),
          _buildBreakdownBar(theme, 'Lingkungan', b.environmentScore, AppColors.riskMedium),
        ],
      ),
    );
  }

  Widget _buildBreakdownBar(ThemeData theme, String label, double score, Color color) {
    final pct = (score / 10.0).clamp(0.0, 1.0);
    return Padding(
      padding: const EdgeInsets.only(bottom: AppDimensions.sm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: theme.textTheme.bodySmall?.copyWith(color: AppColors.onSurface, fontWeight: FontWeight.w500)),
              Text(score.toStringAsFixed(1), style: theme.textTheme.bodySmall?.copyWith(color: color, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(AppDimensions.radiusPill),
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

  Widget _buildRecommendations(ThemeData theme, AssessmentResult result) {
    if (result.recommendations.isEmpty) return const SizedBox.shrink();
    return Container(
      padding: const EdgeInsets.all(AppDimensions.sm),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Rekomendasi', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: AppDimensions.sm),
          ...result.recommendations.map((rec) => Padding(
            padding: const EdgeInsets.only(bottom: AppDimensions.xs),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(margin: const EdgeInsets.only(top: 4), width: 6, height: 6, decoration: BoxDecoration(color: AppColors.primary, shape: BoxShape.circle)),
                const SizedBox(width: AppDimensions.sm),
                Expanded(child: Text(rec, style: theme.textTheme.bodyMedium?.copyWith(color: AppColors.onSurface))),
              ],
            ),
          ))
        ],
      ),
    );
  }

  Widget _buildActions(ThemeData theme, ParentShellController shell) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AlleriskButton(
          text: 'Asesmen Ulang',
          icon: Icons.assessment_rounded,
          onPressed: () => shell.switchTab(1),
        ),
        const SizedBox(height: AppDimensions.sm),
        AlleriskButton(
          text: 'Lihat Riwayat',
          isOutlined: true,
          onPressed: () {
            shell.closeResultDetail();
            shell.switchTab(2);
          },
        ),
      ],
    );
  }
}
