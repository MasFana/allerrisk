import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/article_model.dart';
import '../../../core/constants/app_strings.dart';

class ArticleEditorController extends GetxController {

  final formKey = GlobalKey<FormState>();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();
  final TextEditingController imageUrlController = TextEditingController();

  final Rx<Article?> editingArticle = Rx<Article?>(null);
  final Rx<ArticleCategory> selectedCategory = ArticleCategory.foodAllergy.obs;
  final RxString status = ArticleStatus.draft.name.obs;
  final RxBool isSaving = false.obs;
  final RxBool hasUnsavedChanges = false.obs;

  final List<ArticleCategory> categories = [
    ArticleCategory.foodAllergy,
    ArticleCategory.asthma,
    ArticleCategory.eczema,
    ArticleCategory.environment,
    ArticleCategory.parentingTips,
    ArticleCategory.general,
  ];

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args is Article) {
      editingArticle.value = args;
      titleController.text = args.title;
      contentController.text = args.body;
      imageUrlController.text = args.coverImageUrl ?? '';
      
      if (categories.contains(args.category)) {
        selectedCategory.value = args.category;
      }
      status.value = args.status.name;
    }

    // Monitor changes
    titleController.addListener(_markChanged);
    contentController.addListener(_markChanged);
    imageUrlController.addListener(_markChanged);
  }

  void _markChanged() {
    if (!hasUnsavedChanges.value) hasUnsavedChanges.value = true;
  }

  void onCategoryChanged(ArticleCategory? category) {
    if (category != null) {
      selectedCategory.value = category;
      _markChanged();
    }
  }

  Future<void> saveDraft() async {
    status.value = ArticleStatus.draft.name;
    await _saveArticle();
  }

  Future<void> publish() async {
    status.value = ArticleStatus.published.name;
    await _saveArticle();
  }

  Future<void> _saveArticle() async {
    if (!formKey.currentState!.validate()) return;

    isSaving.value = true;
    try {
      // In a real app, this would use IArticleRepository
      // For MVP, we just simulate saving
      await Future.delayed(const Duration(seconds: 1));

      hasUnsavedChanges.value = false;
      Get.back(); // Return to previous screen
      Get.snackbar('Sukses', status.value == ArticleStatus.published.name ? 'Artikel berhasil dipublikasikan' : 'Draft berhasil disimpan');
    } catch (e) {
      Get.snackbar('Error', 'Gagal menyimpan artikel');
    } finally {
      isSaving.value = false;
    }
  }

  Future<bool> onWillPop() async {
    if (hasUnsavedChanges.value) {
      final shouldPop = await Get.dialog<bool>(
        AlertDialog(
          title: const Text(AppStrings.unsavedChanges),
          content: const Text(AppStrings.unsavedChangesDesc),
          actions: [
            TextButton(
              onPressed: () => Get.back(result: true),
              child: const Text(AppStrings.exitWithoutSaving, style: TextStyle(color: Colors.red)),
            ),
            TextButton(
              onPressed: () => Get.back(result: false),
              child: const Text(AppStrings.cancel),
            ),
          ],
        ),
      );
      return shouldPop ?? false;
    }
    return true;
  }

  @override
  void onClose() {
    titleController.removeListener(_markChanged);
    contentController.removeListener(_markChanged);
    imageUrlController.removeListener(_markChanged);
    titleController.dispose();
    contentController.dispose();
    imageUrlController.dispose();
    super.onClose();
  }
}
