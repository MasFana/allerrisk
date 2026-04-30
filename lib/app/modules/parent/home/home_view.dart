import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/utils/responsive.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/child_avatar_widget.dart';
import '../../../core/widgets/risk_meter_widget.dart';
import '../../../data/models/article_model.dart';
import '../../../core/widgets/article_card.dart';
import '../../../data/models/assessment_result_model.dart';
import '../../../data/models/child_profile_model.dart';
import '../shell/parent_shell_controller.dart';
import 'home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }

          return RefreshIndicator(
            onRefresh: controller.loadData,
            color: AppColors.primary,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(
                AppDimensions.md,
                AppDimensions.md,
                AppDimensions.md,
                AppDimensions.xxxl,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTopBar(theme),
                  const SizedBox(height: AppDimensions.lg),
                  _buildHeroCard(theme),
                  const SizedBox(height: AppDimensions.lg),
                  _buildChildrenSection(theme),
                  const SizedBox(height: AppDimensions.lg),
                  _buildRecentAssessments(theme),
                  const SizedBox(height: AppDimensions.lg),
                  _buildArticleSection(theme),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildTopBar(ThemeData theme) {
    return Row(
      children: [
        GestureDetector(
          onTap: () => Get.find<ParentShellController>().goToSettings(),
          child: CircleAvatar(
            radius: 22,
            backgroundColor: AppColors.primaryContainer,
            child: Text(
              controller.parentName.substring(0, 1).toUpperCase(),
              style: theme.textTheme.titleSmall?.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
        const SizedBox(width: AppDimensions.sm),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Halo, ${controller.parentName}',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppColors.onSurface,
                ),
              ),
              Text(
                'Pantau risiko alergi anak secara berkala',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: AppColors.surfaceContainerLow,
            borderRadius: BorderRadius.circular(AppDimensions.radiusPill),
          ),
          child: IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.notifications_none_rounded,
              color: AppColors.onSurface,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeroCard(ThemeData theme) {
    final child = controller.activeChild;
    final result = controller.activeChildLatestResult;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppDimensions.lg),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.primaryDark, AppColors.primary],
        ),
        borderRadius: BorderRadius.circular(AppDimensions.radiusXl),
      ),
      child: child == null
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Mulai dengan menambahkan profil anak',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: AppDimensions.sm),
                Text(
                  'Setelah profil dibuat, Anda bisa menjalankan asesmen dan memantau hasilnya dari beranda.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.white.withValues(alpha: 0.86),
                  ),
                ),
                const SizedBox(height: AppDimensions.lg),
                FilledButton(
                  onPressed: controller.goToChildList,
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        AppDimensions.radiusPill,
                      ),
                    ),
                  ),
                  child: const Text('Tambah Anak'),
                ),
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            child.name,
                            style: theme.textTheme.headlineSmall?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            child.ageDisplay,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: Colors.white.withValues(alpha: 0.86),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppDimensions.sm,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.14),
                        borderRadius: BorderRadius.circular(
                          AppDimensions.radiusPill,
                        ),
                      ),
                      child: Text(
                        result?.level.label ?? 'Belum ada hasil',
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppDimensions.lg),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(AppDimensions.md),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.10),
                    borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: _HeroMetric(
                          label: 'Skor terakhir',
                          value: result != null
                              ? result.score.toStringAsFixed(1)
                              : '—',
                        ),
                      ),
                      Expanded(
                        child: _HeroMetric(
                          label: 'Tanggal',
                          value: result != null
                              ? DateFormat(
                                  'dd MMM yyyy',
                                  'id_ID',
                                ).format(result.assessedAt)
                              : 'Belum ada',
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppDimensions.lg),
                Wrap(
                  spacing: AppDimensions.sm,
                  runSpacing: AppDimensions.sm,
                  children: [
                    FilledButton(
                      onPressed: () {
                        controller.startAssessment();
                      },
                      style: FilledButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            AppDimensions.radiusPill,
                          ),
                        ),
                      ),
                      child: Text(
                        result == null
                            ? 'Mulai Asesmen Pertama'
                            : 'Asesmen Ulang',
                      ),
                    ),
                    OutlinedButton(
                      onPressed: controller.goToChildList,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        side: BorderSide(
                          color: Colors.white.withValues(alpha: 0.5),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            AppDimensions.radiusPill,
                          ),
                        ),
                      ),
                      child: const Text('Kelola Profil Anak'),
                    ),
                  ],
                ),
              ],
            ),
    );
  }

  Widget _buildChildrenSection(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(
          title: 'Profil Anak',
          actionLabel: 'Kelola',
          onTap: controller.goToChildList,
        ),
        const SizedBox(height: AppDimensions.sm),
        if (controller.children.isEmpty)
          _buildEmptyCard(
            theme,
            icon: Icons.child_care_rounded,
            title: 'Belum ada profil anak',
            subtitle:
                'Tambahkan profil anak untuk mulai asesmen dan memantau riwayat risikonya.',
            cta: 'Tambah Profil',
            onTap: controller.goToChildList,
          )
        else
          LayoutBuilder(
            builder: (context, constraints) {
              final listH = responsiveClampHeight(
                context,
                ratio: 0.18,
                minVal: 100.0,
                maxVal: 140.0,
              );
              return SizedBox(
                height: listH,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: controller.children.length + 1,
                  separatorBuilder: (_, _) =>
                      const SizedBox(width: AppDimensions.sm),
                  itemBuilder: (_, index) {
                    if (index == controller.children.length) {
                      return _AddChildCard(onTap: controller.goToChildList);
                    }
                    final child = controller.children[index];
                    final isActive = controller.activeChildId.value == child.id;
                    final result = controller.latestResults[child.id];
                    return _ChildSwitcherCard(
                      child: child,
                      result: result,
                      isActive: isActive,
                      onTap: () {
                        controller.selectActiveChild(child.id);
                      },
                    );
                  },
                ),
              );
            },
          ),
      ],
    );
  }

  Widget _buildRecentAssessments(ThemeData theme) {
    final activeChild = controller.activeChild;
    final activeResult = controller.activeChildLatestResult;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(
          title: 'Ringkasan Risiko',
          actionLabel: activeChild == null ? null : 'Riwayat',
          onTap: activeChild == null
              ? null
              : () {
                  controller.goToAssessmentHistory(activeChild.id);
                },
        ),
        const SizedBox(height: AppDimensions.sm),
        if (activeChild == null)
          _buildEmptyCard(
            theme,
            icon: Icons.assessment_outlined,
            title: 'Belum ada asesmen',
            subtitle: 'Pilih atau tambahkan anak untuk memulai asesmen.',
            cta: 'Tambah Profil Anak',
            onTap: controller.goToChildList,
          )
        else
          Container(
            padding: const EdgeInsets.all(AppDimensions.md),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerLowest,
              borderRadius: BorderRadius.circular(AppDimensions.radiusXl),
              boxShadow: AppTheme.ambientShadow,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    ChildAvatarWidget(
                      name: activeChild.name,
                      radius: 20,
                      riskLevel: _riskKey(activeResult?.level),
                    ),
                    const SizedBox(width: AppDimensions.sm),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            activeChild.name,
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: AppColors.onSurface,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            activeResult == null
                                ? 'Belum ada hasil asesmen'
                                : 'Terakhir diperbarui ${DateFormat('dd MMM yyyy', 'id_ID').format(activeResult.assessedAt)}',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: AppColors.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        controller.startAssessment();
                      },
                      child: Text(activeResult == null ? 'Mulai' : 'Ulangi'),
                    ),
                  ],
                ),
                const SizedBox(height: AppDimensions.md),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            activeResult?.level.label ?? 'Siap untuk asesmen',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                              color:
                                  activeResult?.level.color ??
                                  AppColors.primary,
                            ),
                          ),
                          const SizedBox(height: AppDimensions.xs),
                          Text(
                            activeResult == null
                                ? 'Jawab 4 langkah pertanyaan untuk mendapatkan stratifikasi risiko.'
                                : 'Gunakan hasil ini untuk memantau perubahan risiko secara berkala.',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: AppColors.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (activeResult != null)
                      LayoutBuilder(
                        builder: (context, constraints) {
                          final availH = constraints.maxHeight.isFinite
                              ? constraints.maxHeight
                              : MediaQuery.of(context).size.height;
                          final meterSize = responsiveMeterSizeFromAvailable(
                            availH,
                            factor: 0.9,
                            minVal: 56.0,
                            maxVal: 120.0,
                          );

                          return RiskMeterWidget(
                            score: activeResult.score,
                            size: meterSize,
                          );
                        },
                      ),
                  ],
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildArticleSection(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(
          title: 'Artikel Edukasi',
          actionLabel: 'Lihat Semua',
          onTap: controller.goToArticles,
        ),
        const SizedBox(height: AppDimensions.sm),
        if (controller.featuredArticles.isEmpty)
          _buildEmptyCard(
            theme,
            icon: Icons.menu_book_outlined,
            title: 'Belum ada artikel',
            subtitle: 'Artikel edukasi akan muncul di sini.',
          )
        else
          Column(
            children: controller.featuredArticles
                .map(
                  (article) => Padding(
                    padding: const EdgeInsets.only(bottom: AppDimensions.sm),
                    child: ArticleCard(
                      title: article.title,
                      category: article.category.label,
                      date: DateFormat('dd MMM yyyy', 'id_ID').format(article.publishedAt ?? article.createdAt),
                      doctorName: article.authorName,
                      imageUrl: article.coverImageUrl,
                      onTap: () => controller.goToArticle(article.id),
                    ),
                  ),
                )
                .toList(),
          ),
      ],
    );
  }

  Widget _buildEmptyCard(
    ThemeData theme, {
    required IconData icon,
    required String title,
    required String subtitle,
    String? cta,
    VoidCallback? onTap,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppDimensions.lg),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(AppDimensions.radiusXl),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(AppDimensions.sm),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerLow,
              borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
            ),
            child: Icon(icon, color: AppColors.primary),
          ),
          const SizedBox(height: AppDimensions.md),
          Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              color: AppColors.onSurface,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppDimensions.xs),
          Text(
            subtitle,
            style: theme.textTheme.bodySmall?.copyWith(
              color: AppColors.onSurfaceVariant,
            ),
          ),
          if (cta != null && onTap != null) ...[
            const SizedBox(height: AppDimensions.md),
            TextButton(onPressed: onTap, child: Text(cta)),
          ],
        ],
      ),
    );
  }

  String? _riskKey(RiskLevel? level) {
    switch (level) {
      case RiskLevel.low:
        return 'low';
      case RiskLevel.medium:
        return 'medium';
      case RiskLevel.high:
        return 'high';
      case null:
        return null;
    }
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final String? actionLabel;
  final VoidCallback? onTap;

  const _SectionHeader({required this.title, this.actionLabel, this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: theme.textTheme.titleLarge?.copyWith(
              color: AppColors.onSurface,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        if (actionLabel != null)
          TextButton(onPressed: onTap, child: Text(actionLabel!)),
      ],
    );
  }
}

class _HeroMetric extends StatelessWidget {
  final String label;
  final String value;

  const _HeroMetric({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.labelSmall?.copyWith(
            color: Colors.white.withValues(alpha: 0.72),
            letterSpacing: 0.4,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: theme.textTheme.titleMedium?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _ChildSwitcherCard extends StatelessWidget {
  final ChildProfile child;
  final AssessmentResult? result;
  final bool isActive;
  final VoidCallback onTap;

  const _ChildSwitcherCard({
    required this.child,
    required this.result,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        width: responsiveClampWidth(
          context,
          ratio: 0.45,
          minVal: 120.0,
          maxVal: 180.0,
        ),
        padding: const EdgeInsets.all(AppDimensions.md),
        decoration: BoxDecoration(
          color: isActive
              ? AppColors.primary.withValues(alpha: 0.08)
              : AppColors.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(AppDimensions.radiusXl),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                ChildAvatarWidget(
                  name: child.name,
                  radius: 18,
                  riskLevel: result?.level.name,
                ),
                const Spacer(),
                if (isActive)
                  const Icon(
                    Icons.check_circle_rounded,
                    color: AppColors.primary,
                    size: 18,
                  ),
              ],
            ),
            const Spacer(),
            Text(
              child.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.titleSmall?.copyWith(
                color: AppColors.onSurface,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              child.ageDisplay,
              style: theme.textTheme.bodySmall?.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: AppDimensions.xs),
            Text(
              result == null
                  ? 'Belum ada asesmen'
                  : '${result!.score.toStringAsFixed(1)} • ${result!.level.label}',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.labelSmall?.copyWith(
                color: result?.level.color ?? AppColors.primary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AddChildCard extends StatelessWidget {
  final VoidCallback onTap;

  const _AddChildCard({required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: responsiveClampWidth(
          context,
          ratio: 0.33,
          minVal: 96.0,
          maxVal: 140.0,
        ),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerLow,
          borderRadius: BorderRadius.circular(AppDimensions.radiusXl),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(AppDimensions.sm),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerLowest,
                borderRadius: BorderRadius.circular(AppDimensions.radiusPill),
              ),
              child: const Icon(Icons.add_rounded, color: AppColors.primary),
            ),
            const SizedBox(height: AppDimensions.sm),
            Text(
              'Tambah Anak',
              style: theme.textTheme.labelLarge?.copyWith(
                color: AppColors.onSurface,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}


