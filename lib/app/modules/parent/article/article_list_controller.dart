import 'package:get/get.dart';
import '../../../data/models/article_model.dart';
import '../../../data/repositories/interfaces/i_article_repository.dart';

class ArticleListController extends GetxController {
  final IArticleRepository _repository = Get.find<IArticleRepository>();

  final RxList<Article> articles = <Article>[].obs;
  final RxBool isLoading = true.obs;
  final Rx<ArticleCategory> selectedCategory = ArticleCategory.all.obs;
  final RxString searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchArticles();

    // Listen for category/search changes
    debounce(
      searchQuery,
      (_) => fetchArticles(),
      time: const Duration(milliseconds: 500),
    );
    ever(selectedCategory, (_) => fetchArticles());
  }

  Future<void> fetchArticles() async {
    try {
      isLoading.value = true;
      final result = await _repository.getPublishedArticles(
        category: selectedCategory.value == ArticleCategory.all
            ? null
            : selectedCategory.value,
        searchQuery: searchQuery.value.isEmpty ? null : searchQuery.value,
        limit: 50,
      );
      articles.assignAll(result);
    } catch (e) {
      Get.snackbar('Error', 'Gagal memuat artikel');
    } finally {
      isLoading.value = false;
    }
  }

  void updateSearch(String query) {
    searchQuery.value = query;
  }

  void setCategory(ArticleCategory category) {
    selectedCategory.value = category;
  }
}
