import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/widgets/article_card.dart';
import 'article_list_controller.dart';

class DoctorArticleListView extends GetView<DoctorArticleListController> {
  const DoctorArticleListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: const Text(AppStrings.myArticles),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => controller.openEditor(),
        icon: const Icon(Icons.edit),
        label: const Text(AppStrings.writeArticle),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.articles.isEmpty) {
          return _buildEmptyState(context);
        }

        return RefreshIndicator(
          onRefresh: controller.loadArticles,
          child: ListView.separated(
            padding: const EdgeInsets.all(AppDimensions.md),
            itemCount: controller.articles.length,
            separatorBuilder: (_, _) => const SizedBox(height: AppDimensions.sm),
            itemBuilder: (context, index) {
              final article = controller.articles[index];
              return Dismissible(
                key: Key(article.id),
                background: Container(
                  color: AppColors.error,
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: AppDimensions.lg),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                direction: DismissDirection.endToStart,
                onDismissed: (_) => controller.deleteArticle(article.id),
                confirmDismiss: (_) async {
                  return await Get.dialog<bool>(
                    AlertDialog(
                      title: const Text(AppStrings.deleteArticleTitle),
                      content: const Text(AppStrings.deleteArticleConfirm),
                      actions: [
                        TextButton(onPressed: () => Get.back(result: false), child: const Text(AppStrings.cancel)),
                        TextButton(
                          onPressed: () => Get.back(result: true),
                          child: const Text(AppStrings.delete, style: TextStyle(color: AppColors.error)),
                        ),
                      ],
                    ),
                  ) ?? false;
                },
                child: ArticleCard(
                  title: article.title,
                  category: article.category.name,
                  date: 'Hari ini', // Replace with formatter if available
                  doctorName: article.authorName,
                  imageUrl: article.coverImageUrl,
                  onTap: () => controller.openEditor(article),
                ),
              );
            },
          ),
        );
      }),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.article_outlined, size: 64, color: AppColors.outline),
          const SizedBox(height: AppDimensions.md),
          Text(
            AppStrings.noArticlesYet,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: AppDimensions.sm),
          Text(
            AppStrings.shareMedicalKnowledge,
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.onSurface.withValues(alpha: 0.6)),
          ),
          const SizedBox(height: AppDimensions.lg),
          ElevatedButton.icon(
            onPressed: () => controller.openEditor(),
            icon: const Icon(Icons.edit),
            label: const Text(AppStrings.writeArticle),
          ),
        ],
      ),
    );
  }
}
