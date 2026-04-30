import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/widgets/allerisk_text_field.dart';
import '../../../data/models/article_model.dart';
import 'article_editor_controller.dart';

class ArticleEditorView extends GetView<ArticleEditorController> {
  const ArticleEditorView({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
        final shouldPop = await controller.onWillPop();
        if (shouldPop) Get.back();
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        appBar: AppBar(
          title: Obx(() => Text(controller.editingArticle.value == null ? AppStrings.writeNewArticle : AppStrings.edit)),
          actions: [
            Obx(() => TextButton.icon(
              onPressed: controller.isSaving.value ? null : controller.saveDraft,
              icon: Icon(
                Icons.save_outlined,
                color: controller.hasUnsavedChanges.value ? AppColors.primary : AppColors.outline,
              ),
              label: const Text(AppStrings.saveDraft),
            )),
            Obx(() => TextButton.icon(
              onPressed: controller.isSaving.value ? null : controller.publish,
              icon: const Icon(Icons.publish_rounded, color: AppColors.primary),
              label: const Text(AppStrings.publish, style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
            )),
          ],
        ),
      body: Form(
        key: controller.formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppDimensions.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(AppStrings.category, style: Theme.of(context).textTheme.titleSmall),
              const SizedBox(height: AppDimensions.xs),
              Obx(() => Container(
                padding: const EdgeInsets.symmetric(horizontal: AppDimensions.md),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<ArticleCategory>(
                    value: controller.selectedCategory.value,
                    isExpanded: true,
                    onChanged: controller.onCategoryChanged,
                    items: controller.categories.map((c) {
                      return DropdownMenuItem<ArticleCategory>(value: c, child: Text(c.label));
                    }).toList(),
                  ),
                ),
              )),
              const SizedBox(height: AppDimensions.lg),
              
              AlleriskTextField(
                label: AppStrings.articleTitle,
                controller: controller.titleController,
                validator: (v) => v == null || v.isEmpty ? AppStrings.titleRequired : null,
              ),
              const SizedBox(height: AppDimensions.lg),
              
              AlleriskTextField(
                label: AppStrings.imageUrlOptional,
                controller: controller.imageUrlController,
                hint: 'https://...',
              ),
              const SizedBox(height: AppDimensions.lg),
              
              AlleriskTextField(
                label: AppStrings.articleContent,
                hint: AppStrings.articleContentHint,
                controller: controller.contentController,
                maxLines: 15,
                validator: (v) => v == null || v.isEmpty ? AppStrings.contentRequired : null,
              ),
              const SizedBox(height: AppDimensions.xxl),
            ],
          ),
        ),
      ),
      ),
    );
  }
}
