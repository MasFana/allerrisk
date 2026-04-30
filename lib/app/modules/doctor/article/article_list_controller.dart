import 'package:get/get.dart';
import '../../../data/repositories/interfaces/i_article_repository.dart';
import '../../../data/models/article_model.dart';
import '../../../core/services/auth_service.dart';
import '../../../routes/app_routes.dart';

class DoctorArticleListController extends GetxController {
  final IArticleRepository _articleRepository = Get.find<IArticleRepository>();
  final AuthService _authService = Get.find<AuthService>();

  final RxList<Article> articles = <Article>[].obs;
  final RxBool isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    loadArticles();
  }

  Future<void> loadArticles() async {
    isLoading.value = true;
    try {
      final doctorId = _authService.currentUser.value?.id ?? '';
      final results = await _articleRepository.getArticlesByAuthor(doctorId);
      
      // Sort newest first
      results.sort((a, b) => (b.publishedAt ?? b.createdAt).compareTo(a.publishedAt ?? a.createdAt));
      articles.value = results;
    } catch (e) {
      Get.snackbar('Error', 'Gagal memuat daftar artikel: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void openEditor([Article? article]) {
    Get.toNamed(Routes.ARTICLE_EDITOR, arguments: article)?.then((_) {
      // Reload articles when returning from editor
      loadArticles();
    });
  }

  Future<void> deleteArticle(String id) async {
    // In a real app we'd call _articleRepository.deleteArticle(id)
    // For MVP with mock, let's just remove from the list
    articles.removeWhere((a) => a.id == id);
    Get.snackbar('Sukses', 'Artikel berhasil dihapus');
  }
}
