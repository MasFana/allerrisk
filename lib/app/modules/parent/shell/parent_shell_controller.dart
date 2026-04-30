import 'package:get/get.dart';

import '../../../data/models/assessment_result_model.dart';
import '../../../routes/app_routes.dart';
import '../../../core/services/auth_service.dart';

class ParentShellController extends GetxController {
  // ── Tab State ──────────────────────────────────────────────────
  final RxInt currentIndex = 0.obs;

  /// Latest assessment result – populated by AssessmentController on submit.
  final Rxn<AssessmentResult> latestResult = Rxn<AssessmentResult>();
  final RxBool showResultDetail = false.obs;

  // ── Navigation ─────────────────────────────────────────────────

  void switchTab(int index) {
    // When navigating to Hasil (index 2) via the bottom nav, show all children
    // by clearing the activeChild selection. This ensures the Hasil tab shows
    // grouped history for all anak when opened from the nav.
    if (index == 2) {
      try {
        final AuthService _auth = Get.find<AuthService>();
        // clear active child (persisted) — fire & forget
        _auth.setActiveChild('');
      } catch (_) {
        // ignore if auth service not available
      }
      // Ensure embedded detail is closed when switching to Hasil
      showResultDetail.value = false;
    }
    currentIndex.value = index;
  }

  /// Called by AssessmentController after a successful submission.
  /// Stores the result and switches to the HASIL tab (index 2).
  void setResultAndSwitch(AssessmentResult result) {
    latestResult.value = result;
    showResultDetail.value = false;
    currentIndex.value = 2;
  }

  /// Open the full result detail inside the shell (keeps bottom nav)
  void openResultDetail(AssessmentResult result) {
    latestResult.value = result;
    showResultDetail.value = true;
    currentIndex.value = 2;
  }

  void closeResultDetail() {
    showResultDetail.value = false;
  }

  void goToSettings() => Get.toNamed(Routes.PARENT_SETTINGS);
  void goToChildProfile() => Get.toNamed(Routes.CHILD_LIST);
  void goToAssessmentHistory(String childId) {
    // If a specific childId is provided, set it as active then open Hasil.
    try {
      final AuthService _auth = Get.find<AuthService>();
      _auth.setActiveChild(childId);
    } catch (_) {}

    // Switch to the Hasil (history) tab inside the shell
    showResultDetail.value = false;
    switchTab(2);
  }
}
