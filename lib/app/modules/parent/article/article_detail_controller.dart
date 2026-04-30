import 'package:get/get.dart';
import '../../../data/models/article_model.dart';
import '../../../data/repositories/interfaces/i_article_repository.dart';

class ArticleDetailController extends GetxController {
  final IArticleRepository _repository = Get.find<IArticleRepository>();

  final Rx<Article?> article = Rx<Article?>(null);
  final RxBool isLoading = true.obs;

  late final String articleId;

  @override
  void onInit() {
    super.onInit();
    articleId = Get.arguments as String;
    fetchArticleDetail();
  }

  Future<void> fetchArticleDetail() async {
    try {
      isLoading.value = true;
      final result = await _repository.getArticleById(articleId);
      article.value = result;
    } catch (e) {
      Get.snackbar('Error', 'Gagal memuat detail artikel');
    } finally {
      isLoading.value = false;
    }
  }
}
