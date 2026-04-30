import 'package:get/get.dart';

import '../../../core/services/auth_service.dart';
import '../../../data/models/article_model.dart';
import '../../../data/models/assessment_result_model.dart';
import '../../../data/models/child_profile_model.dart';
import '../../../data/repositories/interfaces/i_article_repository.dart';
import '../../../data/repositories/interfaces/i_assessment_repository.dart';
import '../../../data/repositories/interfaces/i_child_repository.dart';
import '../../../routes/app_routes.dart';
import '../shell/parent_shell_controller.dart';

class HomeController extends GetxController {
  final IChildRepository _childRepo = Get.find<IChildRepository>();
  final IAssessmentRepository _assessmentRepo =
      Get.find<IAssessmentRepository>();
  final IArticleRepository _articleRepo = Get.find<IArticleRepository>();
  final AuthService _auth = Get.find<AuthService>();

  final RxList<ChildProfile> children = <ChildProfile>[].obs;
  final RxBool isLoading = true.obs;
  final RxMap<String, AssessmentResult?> latestResults =
      <String, AssessmentResult?>{}.obs;
  final RxList<Article> featuredArticles = <Article>[].obs;
  final RxString activeChildId = ''.obs;

  String get parentName =>
      _auth.currentUser.value?.name.split(' ').first ?? 'Orang Tua';

  ChildProfile? get activeChild {
    if (children.isEmpty) return null;
    final selectedId = activeChildId.value;
    for (final child in children) {
      if (child.id == selectedId) return child;
    }
    return children.first;
  }

  AssessmentResult? get activeChildLatestResult {
    final child = activeChild;
    if (child == null) return null;
    return latestResults[child.id];
  }

  List<AssessmentResult> get recentAssessments {
    final results = latestResults.values.whereType<AssessmentResult>().toList()
      ..sort((a, b) => b.assessedAt.compareTo(a.assessedAt));
    return results.take(3).toList();
  }

  @override
  void onInit() {
    super.onInit();
    activeChildId.value = _auth.activeChildId.value;
    loadData();
  }

  Future<void> loadData() async {
    isLoading.value = true;
    try {
      final parentId = _auth.currentUser.value?.id ?? '';
      if (parentId.isEmpty) return;

      final childList = await _childRepo.getChildren(parentId);
      children.assignAll(childList);

      final assessmentFutures = childList.map(
        (child) => _assessmentRepo.getLatestAssessment(child.id),
      );
      final results = await Future.wait(assessmentFutures);

      latestResults.assignAll({
        for (var i = 0; i < childList.length; i++) childList[i].id: results[i],
      });

      final selectedId = _auth.activeChildId.value;
      if (childList.isNotEmpty) {
        final resolvedId = childList.any((child) => child.id == selectedId)
            ? selectedId
            : childList.first.id;
        await selectActiveChild(resolvedId, persist: selectedId != resolvedId);
      } else {
        activeChildId.value = '';
      }

      featuredArticles.assignAll(
        await _articleRepo.getPublishedArticles(limit: 3),
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal memuat data: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> selectActiveChild(String childId, {bool persist = true}) async {
    activeChildId.value = childId;
    if (persist) {
      await _auth.setActiveChild(childId);
    }
  }

  Future<void> startAssessment() async {
    final child = activeChild;
    if (child == null) {
      goToChildList();
      return;
    }
    await selectActiveChild(child.id);
    if (Get.isRegistered<ParentShellController>()) {
      Get.find<ParentShellController>().switchTab(1);
      return;
    }
    Get.toNamed(Routes.ASSESSMENT);
  }

  void goToChildList() => Get.toNamed(Routes.CHILD_LIST);

  Future<void> goToAssessment(String childId) async {
    await selectActiveChild(childId);
    Get.toNamed(Routes.ASSESSMENT);
  }

  Future<void> goToAssessmentHistory(String childId) async {
    await selectActiveChild(childId);
    if (Get.isRegistered<ParentShellController>()) {
      Get.find<ParentShellController>().switchTab(2);
    } else {
      Get.toNamed(Routes.ASSESSMENT_HISTORY);
    }
  }

  void goToSettings() => Get.toNamed(Routes.PARENT_SETTINGS);

  void goToArticles() => Get.toNamed(Routes.PARENT_ARTICLES);

  void goToArticle(String articleId) =>
      Get.toNamed(Routes.PARENT_ARTICLE_DETAIL, arguments: articleId);
}
