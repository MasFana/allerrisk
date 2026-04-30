import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../routes/app_routes.dart';
import '../shell/parent_shell_controller.dart';
import '../../../data/models/assessment_result_model.dart';
import '../../../data/models/article_model.dart';
import '../../../data/models/child_profile_model.dart';
import '../../../core/widgets/article_card.dart';
import '../../../core/widgets/child_avatar_widget.dart';
import 'history_controller.dart';

class HistoryView extends GetView<HistoryController> {
  const HistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        title: const Text('Riwayat Asesmen'),
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.onSurface,
        elevation: 0,
      ),
      body: Obx(() {
        final ParentShellController? shell = Get.isRegistered<ParentShellController>() ? Get.find<ParentShellController>() : null;
        final latest = shell?.latestResult.value;

        // Ensure related articles are loaded for latest result
        controller.ensureRelatedFor(latest);

        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          );
        }

        if (controller.history.isEmpty && latest == null) {
          return _buildEmpty(theme);
        }

        return RefreshIndicator(
          onRefresh: controller.loadHistory,
          color: AppColors.primary,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(
                AppDimensions.sm, AppDimensions.sm,
                AppDimensions.sm, AppDimensions.lg),
            children: () {
              final widgets = <Widget>[];

              // Top: latest result + related article
              if (latest != null) {
                widgets.add(_buildLatestTile(context, latest, theme, shell));
                if (controller.relatedArticles.isNotEmpty) {
                  widgets.add(const SizedBox(height: AppDimensions.sm));
                  widgets.add(Padding(
                    padding: const EdgeInsets.only(bottom: AppDimensions.sm),
                    child: _buildRelatedArticleCard(context, controller.relatedArticles.first, theme),
                  ));
                }
              }

              // Build grouped history, excluding latest (to avoid duplication)
              final filtered = controller.history.where((h) => h.id != latest?.id).toList();
              final Map<String, List<AssessmentResult>> grouped = {};
              for (var r in filtered) {
                grouped.putIfAbsent(r.childId, () => []).add(r);
              }

              // Determine order: prefer controller.childOrder, then any remaining keys
              final order = <String>[];
              order.addAll(controller.childOrder);
              for (var k in grouped.keys) {
                if (!order.contains(k)) order.add(k);
              }

              // For each child group, render a header + its results
              for (var childId in order) {
                final child = controller.children[childId];
                widgets.add(Padding(
                  padding: const EdgeInsets.symmetric(vertical: AppDimensions.sm),
                  child: Row(
                    children: [
                      // Child avatar
                      Padding(
                        padding: const EdgeInsets.only(right: AppDimensions.sm),
                        child: child != null
                            ? SizedBox(width: 40, height: 40, child: ChildAvatarWidget(name: child.name, imageUrl: child.photoUrl, radius: 20))
                            : const SizedBox(width: 40, height: 40),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(child?.name ?? 'Anak', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                            if (child != null)
                              Text('${child.ageDisplay} • ${child.gender == Gender.male ? 'Laki-laki' : 'Perempuan'}', style: theme.textTheme.bodySmall?.copyWith(color: AppColors.onSurfaceVariant)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ));

                final items = grouped[childId] ?? [];
                if (items.isEmpty) {
                  widgets.add(Padding(
                    padding: const EdgeInsets.only(bottom: AppDimensions.sm),
                    child: Text('Belum ada riwayat untuk anak ini', style: theme.textTheme.bodySmall?.copyWith(color: AppColors.onSurfaceVariant)),
                  ));
                } else {
                  for (var r in items) {
                    widgets.add(_buildHistoryTile(context, r, theme));
                  }
                }
              }

              // If there were no groups and no latest, show empty
              if (widgets.isEmpty) {
                widgets.add(_buildEmpty(theme));
              }

              return widgets;
            }(),
          ),
        );
      }),
    );
  }

  Widget _buildHistoryTile(
      BuildContext context, AssessmentResult result, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppDimensions.sm),
      child: InkWell(
        onTap: () => controller.viewResult(result),
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        child: Container(
          padding: const EdgeInsets.all(AppDimensions.sm),
          decoration: BoxDecoration(
            color: AppColors.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
            border: Border.all(
              color: result.level.color.withValues(alpha: 0.3),
            ),
          ),
          child: Row(
            children: [
              // ── Risk level icon ───────────────────────────────
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: result.level.containerColor,
                  borderRadius:
                      BorderRadius.circular(AppDimensions.radiusMd),
                ),
                child: Center(
                  child: Text(
                    result.score.toStringAsFixed(1),
                    style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: result.level.color),
                  ),
                ),
              ),
              const SizedBox(width: AppDimensions.md),
              // ── Details ───────────────────────────────────────
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLevelBadge(theme, result),
                    const SizedBox(height: 2),
                    Text(
                      DateFormat('dd MMMM yyyy, HH:mm', 'id_ID')
                          .format(result.assessedAt),
                      style: theme.textTheme.bodySmall
                          ?.copyWith(color: AppColors.onSurfaceVariant),
                    ),
                    if (result.anaphylaxisOverride) ...[
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.warning_amber_rounded,
                              size: 12, color: AppColors.error),
                          const SizedBox(width: 4),
                          Text('Riwayat Anafilaksis',
                              style: theme.textTheme.labelSmall
                                  ?.copyWith(color: AppColors.error)),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              const Icon(Icons.chevron_right,
                  color: AppColors.onSurfaceVariant),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLevelBadge(ThemeData theme, AssessmentResult result) {
    return Container(
      padding:
          const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: result.level.containerColor,
        borderRadius:
            BorderRadius.circular(AppDimensions.radiusPill),
      ),
      child: Text(result.level.label,
          style: theme.textTheme.labelSmall?.copyWith(
              color: result.level.color,
              fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildLatestTile(BuildContext context, AssessmentResult result, ThemeData theme, ParentShellController? shell) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppDimensions.sm),
      child: InkWell(
        onTap: () => controller.viewResult(result),
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        child: Container(
          padding: const EdgeInsets.all(AppDimensions.sm),
          decoration: BoxDecoration(
            color: AppColors.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
            border: Border.all(
              color: result.level.color.withValues(alpha: 0.3),
            ),
          ),
          child: Row(
            children: [
              // ── Risk level icon ───────────────────────────────
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: result.level.containerColor,
                  borderRadius:
                      BorderRadius.circular(AppDimensions.radiusMd),
                ),
                child: Center(
                  child: Text(
                    result.score.toStringAsFixed(1),
                    style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: result.level.color),
                  ),
                ),
              ),
              const SizedBox(width: AppDimensions.md),
              // ── Details ───────────────────────────────────────
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(result.level.label,
                        style: theme.textTheme.titleMedium?.copyWith(
                            color: AppColors.onSurface,
                            fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text(
                      DateFormat('dd MMMM yyyy, HH:mm', 'id_ID')
                          .format(result.assessedAt),
                      style: theme.textTheme.bodySmall
                          ?.copyWith(color: AppColors.onSurfaceVariant),
                    ),
                    if (result.anaphylaxisOverride) ...[
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const Icon(Icons.warning_amber_rounded,
                              size: 12, color: AppColors.error),
                          const SizedBox(width: 6),
                          Text('Riwayat Anafilaksis',
                              style: theme.textTheme.labelSmall
                                  ?.copyWith(color: AppColors.error)),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => controller.viewResult(result),
                    child: const Text('Lihat Detail'),
                  ),
                  const SizedBox(height: 4),
                  TextButton(
                    onPressed: () {
                      if (Get.isRegistered<ParentShellController>()) {
                        Get.find<ParentShellController>().switchTab(1);
                      } else {
                        Get.toNamed(Routes.ASSESSMENT);
                      }
                    },
                    child: const Text('Asesmen Ulang'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRelatedArticleCard(BuildContext context, Article article, ThemeData theme) {
    return ArticleCard(
      title: article.title,
      category: article.category.label,
      date: DateFormat('dd MMM yyyy', 'id_ID').format(article.publishedAt ?? article.createdAt),
      doctorName: article.authorName,
      imageUrl: article.coverImageUrl,
      onTap: () => Get.toNamed(Routes.PARENT_ARTICLE_DETAIL, arguments: article.id),
    );
  }

  Widget _buildEmpty(ThemeData theme) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.history_rounded,
                size: 64, color: AppColors.outlineVariant),
            const SizedBox(height: AppDimensions.md),
            Text('Belum Ada Riwayat',
                style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.onSurface)),
            const SizedBox(height: AppDimensions.sm),
            Text(
              'Asesmen yang pernah dilakukan akan muncul di sini.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium
                  ?.copyWith(color: AppColors.onSurfaceVariant),
            ),
          ],
        ),
      ),
    );
  }
}
