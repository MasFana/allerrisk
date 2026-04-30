import 'package:get/get.dart';

import '../../../core/services/auth_service.dart';
import '../../../data/models/assessment_result_model.dart';
import '../../../data/models/article_model.dart';
import '../../../data/models/child_profile_model.dart';
import '../../../data/repositories/interfaces/i_assessment_repository.dart';
import '../../../data/repositories/interfaces/i_article_repository.dart';
import '../../../data/repositories/interfaces/i_child_repository.dart';
import '../../../routes/app_routes.dart';
import '../shell/parent_shell_controller.dart';

class HistoryController extends GetxController {
  final IAssessmentRepository _repo = Get.find<IAssessmentRepository>();
  final IArticleRepository _articleRepo = Get.find<IArticleRepository>();
  final AuthService _auth = Get.find<AuthService>();

  final RxList<AssessmentResult> history = <AssessmentResult>[].obs;
  final RxBool isLoading = true.obs;

  // Children map when showing all history
  final IChildRepository _childRepo = Get.find<IChildRepository>();
  final RxMap<String, ChildProfile> children = <String, ChildProfile>{}.obs;
  final RxList<String> childOrder = <String>[].obs;

  // Related articles driven by latest result
  final RxList<Article> relatedArticles = <Article>[].obs;
  String? _lastRelatedForResultId;

  @override
  void onInit() {
    super.onInit();
    // Load initial history
    loadHistory();
  }

  Future<void> loadHistory() async {
    isLoading.value = true;
    try {
      // Always show history across all children on the History tab
      history.value = await _repo.getAllHistory();

      // Load child profiles for grouping
      final parentId = _auth.currentUser.value?.id;
      if (parentId != null && parentId.isNotEmpty) {
        try {
          final childList = await _childRepo.getChildren(parentId);
          children.clear();
          for (var c in childList) {
            children[c.id] = c;
          }
          childOrder.assignAll(childList.map((c) => c.id));
        } catch (e) {
          // If child fetching fails, clear map but keep history
          children.clear();
          childOrder.clear();
        }
      } else {
        children.clear();
        childOrder.clear();
      }
    } catch (e) {
      Get.snackbar('Error', 'Gagal memuat riwayat: $e',
          snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  void viewResult(AssessmentResult result) {
    // If running inside the parent shell, open the detail embedded (keeps bottom nav).
    if (Get.isRegistered<ParentShellController>()) {
      Get.find<ParentShellController>().openResultDetail(result);
    } else {
      Get.toNamed(Routes.ASSESSMENT_RESULT, arguments: result);
    }
  }

  void goHome() => Get.offAllNamed(Routes.PARENT_HOME);

  /// Ensures related articles are loaded for [latest]. Uses a simple
  /// heuristic to map assessment payload to an ArticleCategory.
  Future<void> ensureRelatedFor(AssessmentResult? latest) async {
    final id = latest?.id;
    if (id == null) {
      relatedArticles.clear();
      _lastRelatedForResultId = null;
      return;
    }
    if (_lastRelatedForResultId == id) return; // already loaded
    _lastRelatedForResultId = id;

    try {
      final category = _mapResultToCategory(latest);
      final articles = await _articleRepo.getPublishedArticles(
        category: category,
        limit: 1,
      );
      relatedArticles.assignAll(articles);
    } catch (e) {
      // non-fatal
      relatedArticles.clear();
    }
  }

  ArticleCategory _mapResultToCategory(AssessmentResult? r) {
    if (r == null) return ArticleCategory.general;
    final p = r.payload;
    // Priority mapping
    if (p.hasAnaphylaxis || p.hasGiReaction || p.hasUrticaria) {
      return ArticleCategory.foodAllergy;
    }
    if (p.hasWheeze || p.hasRhinitis) return ArticleCategory.asthma;
    if (p.hasDermatitis || p.hasChronicDrySkin) return ArticleCategory.eczema;
    if (p.hasPets || p.highDustEnv || p.nearPollution) return ArticleCategory.environment;
    return ArticleCategory.parentingTips;
  }
}
