import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/theme/app_theme.dart';
import '../../../routes/app_routes.dart';
import '../../../core/widgets/article_card.dart';
import '../../../core/widgets/doctor_nav_bar.dart';
import '../../../core/utils/formatters.dart';
import 'dashboard_controller.dart';

class DashboardView extends GetView<DashboardController> {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        titleSpacing: AppDimensions.md,
        title: Obx(() => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Selamat pagi,',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: AppColors.onSurfaceVariant,
                letterSpacing: 0.3,
              ),
            ),
            Text(
              'Dr. ${controller.doctorName}',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w700,
                color: AppColors.onSurface,
                height: 1.1,
              ),
            ),
          ],
        )),
        actions: [
          IconButton(
            icon: const Badge(
              child: Icon(Icons.notifications_outlined),
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return RefreshIndicator(
          onRefresh: controller.loadDashboard,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(AppDimensions.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildVerificationBadge(),
                const SizedBox(height: AppDimensions.xxxl),
                _buildSummaryCards(),
                const SizedBox(height: AppDimensions.xxxl),
                Text(
                  'Distribusi Risiko Pasien',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: AppDimensions.md),
                _buildRiskDistributionChart(context),
                const SizedBox(height: AppDimensions.xxxl),
                _buildSectionHeader(
                  context: context,
                  title: 'Pasien Risiko Tinggi',
                  actionText: 'Lihat Semua',
                  onAction: () => Get.toNamed(Routes.PATIENT_LIST),
                ),
                const SizedBox(height: AppDimensions.sm),
                _buildHighRiskPatientsList(),
                const SizedBox(height: AppDimensions.xxxl),
                _buildSectionHeader(
                  context: context,
                  title: 'Artikel Terbaru Saya',
                  actionText: 'Tulis Artikel',
                  onAction: () => Get.toNamed(Routes.ARTICLE_EDITOR),
                ),
                const SizedBox(height: AppDimensions.sm),
                _buildMyArticles(),
                const SizedBox(height: AppDimensions.xxl),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildVerificationBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.sm, vertical: AppDimensions.xs),
      decoration: BoxDecoration(
        color: AppColors.success.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.check_circle, size: 16, color: AppColors.success),
          const SizedBox(width: 4),
          Text(
            'STR Terverifikasi',
            style: TextStyle(color: AppColors.success, fontWeight: FontWeight.bold, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCards() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final cardWidth = (constraints.maxWidth - AppDimensions.md) / 2;
        return Wrap(
          spacing: AppDimensions.md,
          runSpacing: AppDimensions.md,
          children: [
            _buildSummaryCard(
              width: cardWidth,
              title: 'Total Pasien',
              value: controller.totalPatients.value.toString(),
              icon: Icons.people,
              color: AppColors.primary,
            ),
            _buildSummaryCard(
              width: cardWidth,
              title: 'Pasien Baru (7 hr)',
              value: controller.newPatientsThisWeek.value.toString(),
              icon: Icons.person_add,
              color: AppColors.secondary,
            ),
            _buildSummaryCard(
              width: cardWidth,
              title: 'Risiko Tinggi',
              value: controller.riskDistribution['high'].toString(),
              icon: Icons.warning_amber_rounded,
              color: AppColors.riskHigh,
            ),
            _buildSummaryCard(
              width: cardWidth,
              title: 'Artikel Saya',
              value: controller.myArticles.length.toString(),
              icon: Icons.article,
              color: AppColors.success,
            ),
          ],
        );
      },
    );
  }

  Widget _buildSummaryCard({
    required double width,
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      width: width,
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        boxShadow: AppTheme.ambientShadow,
      ),
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: color, size: 28),
              const SizedBox(height: AppDimensions.sm),
              Text(
                value,
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              Text(
                title,
                style: TextStyle(fontSize: 12, color: AppColors.onSurface.withValues(alpha: 0.7)),
              ),
            ],
          ),
      ),
    );
  }

  Widget _buildRiskDistributionChart(BuildContext context) {
    final Map<String, int> dist = controller.riskDistribution;
    final int total = dist.values.fold(0, (sum, val) => sum + val);

    if (total == 0) {
      return Container(
        height: 200,
        alignment: Alignment.center,
        child: Text(
          'Belum ada data asesmen',
          style: TextStyle(color: AppColors.onSurface.withValues(alpha: 0.5)),
        ),
      );
    }

    return SizedBox(
      height: 200,
      child: Row(
        children: [
          Expanded(
            child: PieChart(
              PieChartData(
                sectionsSpace: 2,
                centerSpaceRadius: 40,
                sections: [
                  PieChartSectionData(
                    color: AppColors.riskLow,
                    value: dist['low']!.toDouble(),
                    title: '${(dist['low']! / total * 100).toStringAsFixed(0)}%',
                    radius: 40,
                    titleStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  PieChartSectionData(
                    color: AppColors.riskMedium,
                    value: dist['medium']!.toDouble(),
                    title: '${(dist['medium']! / total * 100).toStringAsFixed(0)}%',
                    radius: 40,
                    titleStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  PieChartSectionData(
                    color: AppColors.riskHigh,
                    value: dist['high']!.toDouble(),
                    title: '${(dist['high']! / total * 100).toStringAsFixed(0)}%',
                    radius: 40,
                    titleStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildChartLegend(color: AppColors.riskHigh, text: 'Tinggi (${dist['high']})'),
              const SizedBox(height: 8),
              _buildChartLegend(color: AppColors.riskMedium, text: 'Sedang (${dist['medium']})'),
              const SizedBox(height: 8),
              _buildChartLegend(color: AppColors.riskLow, text: 'Rendah (${dist['low']})'),
            ],
          ),
          const SizedBox(width: AppDimensions.lg),
        ],
      ),
    );
  }

  Widget _buildChartLegend({required Color color, required String text}) {
    return Row(
      children: [
        Container(width: 12, height: 12, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 8),
        Text(text, style: const TextStyle(fontSize: 14)),
      ],
    );
  }

  Widget _buildSectionHeader({
    required BuildContext context,
    required String title,
    required String actionText,
    required VoidCallback onAction,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        TextButton(
          onPressed: onAction,
          child: Text(actionText),
        ),
      ],
    );
  }

  Widget _buildHighRiskPatientsList() {
    if (controller.recentHighRiskPatients.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(AppDimensions.lg),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppColors.surfaceContainer,
          borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        ),
        child: const Text('Tidak ada pasien risiko tinggi baru.'),
      );
    }

    return Column(
      children: controller.recentHighRiskPatients.map((patient) {
        return Container(
          margin: const EdgeInsets.only(bottom: AppDimensions.sm),
          decoration: BoxDecoration(
            color: AppColors.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
            boxShadow: AppTheme.ambientShadow,
          ),
          child: Material(
            color: Colors.transparent,
            child: ListTile(
            leading: CircleAvatar(
              backgroundColor: AppColors.riskHigh.withValues(alpha: 0.2),
              child: const Icon(Icons.warning_rounded, color: AppColors.riskHigh),
            ),
            title: Text(patient.child.name, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text('Skor: ${patient.latestAssessment?.score.toStringAsFixed(1) ?? "-"} • ${AppFormatters.dateShort(patient.latestAssessment?.assessedAt ?? DateTime.now())}'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Get.toNamed(Routes.PATIENT_DETAIL, arguments: patient),
          ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildMyArticles() {
    if (controller.myArticles.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(AppDimensions.lg),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppColors.surfaceContainer,
          borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        ),
        child: const Text('Anda belum menulis artikel.'),
      );
    }

    return Column(
      children: controller.myArticles.map((article) {
        return ArticleCard(
          title: article.title,
          category: article.category.name, // Use the label extension if available, but name is string
          date: AppFormatters.dateShort(article.publishedAt ?? article.createdAt),
          doctorName: article.authorName,
          imageUrl: article.coverImageUrl,
          onTap: () => Get.toNamed(Routes.PARENT_ARTICLE_DETAIL, arguments: article),
        );
      }).toList(),
    );
  }
}
