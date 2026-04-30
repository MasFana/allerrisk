import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../data/models/article_model.dart';
import '../../../routes/app_routes.dart';
import 'article_list_controller.dart';

class ArticleListView extends GetView<ArticleListController> {
  const ArticleListView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: Column(
          children: [
            // ── Top Bar ──────────────────────────────────────────
            _buildTopBar(theme),

            // ── Medical Disclaimer ───────────────────────────────
            _buildDisclaimer(theme),

            // ── Search Bar ───────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppDimensions.md,
                AppDimensions.sm,
                AppDimensions.md,
                0,
              ),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Cari topik alergi, asma, atau tips kesehatan...',
                  hintStyle: theme.textTheme.bodyMedium?.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
                  prefixIcon: const Icon(
                    Icons.search_rounded,
                    color: AppColors.onSurfaceVariant,
                  ),
                  filled: true,
                  fillColor: AppColors.surfaceContainerLow,
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: AppDimensions.sm,
                  ),
                  border: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(AppDimensions.radiusPill),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(AppDimensions.radiusPill),
                    borderSide: BorderSide.none,
                  ),
                ),
                onChanged: controller.updateSearch,
              ),
            ),

            // ── Category Chips ───────────────────────────────────
            SizedBox(
              height: 52,
              child: Obx(() {
                final selected = controller.selectedCategory.value;
                return ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDimensions.md,
                    vertical: AppDimensions.sm,
                  ),
                  itemCount: ArticleCategory.values.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(width: AppDimensions.xs),
                  itemBuilder: (context, i) {
                    final cat = ArticleCategory.values[i];
                    final isSelected = selected == cat;
                    return GestureDetector(
                      onTap: () => controller.setCategory(cat),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppDimensions.md,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.primary
                              : AppColors.surfaceContainerLow,
                          borderRadius: BorderRadius.circular(
                              AppDimensions.radiusPill),
                          border: Border.all(
                            color: isSelected
                                ? AppColors.primary
                                : AppColors.outlineVariant,
                          ),
                        ),
                        child: Text(
                          cat.label,
                          style: theme.textTheme.labelMedium?.copyWith(
                            color: isSelected
                                ? Colors.white
                                : AppColors.onSurfaceVariant,
                            fontWeight: isSelected
                                ? FontWeight.w700
                                : FontWeight.w400,
                          ),
                        ),
                      ),
                    );
                  },
                );
              }),
            ),

            // ── Article List ─────────────────────────────────────
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(
                    child:
                        CircularProgressIndicator(color: AppColors.primary),
                  );
                }
                if (controller.articles.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.article_outlined,
                          size: 56,
                          color: AppColors.outlineVariant,
                        ),
                        const SizedBox(height: AppDimensions.sm),
                        Text(
                          'Belum ada artikel ditemukan',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: AppColors.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  );
                }
                return ListView.separated(
                  padding: const EdgeInsets.fromLTRB(
                    AppDimensions.md,
                    AppDimensions.sm,
                    AppDimensions.md,
                    AppDimensions.xxl,
                  ),
                  itemCount: controller.articles.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: AppDimensions.sm),
                  itemBuilder: (context, i) =>
                      _buildArticleItem(context, controller.articles[i], theme),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  // ── Top Bar ──────────────────────────────────────────────────────────────

  Widget _buildTopBar(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppDimensions.md,
        AppDimensions.md,
        AppDimensions.md,
        AppDimensions.xs,
      ),
      child: Row(
        children: [
          const Icon(Icons.menu_rounded, color: AppColors.onSurface),
          const SizedBox(width: AppDimensions.sm),
          Text(
            'AllerRisk',
            style: theme.textTheme.titleMedium?.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search_rounded,
                color: AppColors.onSurface),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
          const SizedBox(width: AppDimensions.sm),
          const CircleAvatar(
            radius: 16,
            backgroundColor: AppColors.primaryContainer,
            child: Icon(Icons.person, size: 18, color: AppColors.primary),
          ),
        ],
      ),
    );
  }

  // ── Medical Disclaimer ────────────────────────────────────────────────────

  Widget _buildDisclaimer(ThemeData theme) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: AppDimensions.md,
        vertical: AppDimensions.xs,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.md,
        vertical: AppDimensions.sm,
      ),
      decoration: BoxDecoration(
        color: AppColors.secondaryContainer.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.info_outline_rounded,
            color: AppColors.secondary,
            size: 18,
          ),
          const SizedBox(width: AppDimensions.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Disklaimer Medis',
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: AppColors.secondary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Informasi yang tersedia dalam artikel ini bersifat edukatif dan bukan pengganti saran, diagnosis, atau perawatan medis profesional.',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppColors.onSurface,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Article Item ──────────────────────────────────────────────────────────

  Widget _buildArticleItem(
      BuildContext context, Article article, ThemeData theme) {
    return InkWell(
      onTap: () => Get.toNamed(Routes.PARENT_ARTICLE_DETAIL,
          arguments: article.id),
      borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppDimensions.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cover image
            ClipRRect(
              borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
              child: Stack(
                children: [
                  _buildCoverImage(article),
                  // Category badge overlay
                  Positioned(
                    top: AppDimensions.sm,
                    left: AppDimensions.sm,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppDimensions.sm,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius:
                            BorderRadius.circular(AppDimensions.radiusXs),
                      ),
                      child: Text(
                        article.category.label.toUpperCase(),
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.4,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppDimensions.sm),

            // Title
            Text(
              article.title,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.onSurface,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: AppDimensions.xs),

            // Description snippet
            Text(
              article.body
                  .replaceAll(RegExp(r'<[^>]*>'), '')
                  .trim(),
              style: theme.textTheme.bodySmall?.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: AppDimensions.xs),

            // Read more link
            Row(
              children: [
                Text(
                  'Baca Selengkapnya',
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 4),
                const Icon(Icons.arrow_forward_rounded,
                    color: AppColors.primary, size: 14),
                const Spacer(),
                if (article.publishedAt != null)
                  Text(
                    DateFormat('dd MMM yyyy').format(article.publishedAt!),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCoverImage(Article article) {
    if (article.coverImageUrl != null) {
      return CachedNetworkImage(
        imageUrl: article.coverImageUrl!,
        height: 200,
        width: double.infinity,
        fit: BoxFit.cover,
        placeholder: (context, url) => _imagePlaceholder(),
        errorWidget: (context, url, error) => _imagePlaceholder(),
      );
    }
    return _imagePlaceholder();
  }

  Widget _imagePlaceholder() {
    return Container(
      height: 200,
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1B4332), Color(0xFF2D6A4F)],
        ),
      ),
      child: const Center(
        child: Icon(Icons.article_rounded, size: 48, color: Colors.white24),
      ),
    );
  }
}
