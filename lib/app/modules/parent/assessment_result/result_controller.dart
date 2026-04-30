import 'package:get/get.dart';

import '../../../data/models/assessment_result_model.dart';
import '../../../routes/app_routes.dart';
import '../shell/parent_shell_controller.dart';

class ResultController extends GetxController {
  // Passed from AssessmentController via Get.offNamed(..., arguments: result)
  // (kept for backward compat with the pushed ASSESSMENT_RESULT route)
  late final AssessmentResult result;

  @override
  void onInit() {
    super.onInit();
    final arg = Get.arguments;
    if (arg is AssessmentResult) {
      result = arg;
    } else {
      // Fallback — should not happen in normal shell flow
      Get.offAllNamed(Routes.PARENT_HOME);
    }
  }

  /// Navigates back to the Parent shell. If this view was pushed on top of the
  /// shell, pop to reveal the bottom navigation; otherwise navigate to the
  /// parent shell route.
  void goHome() {
    if (Get.isRegistered<ParentShellController>()) {
      // If previous route exists (pushed), go back to reveal shell
      try {
        Get.back();
        return;
      } catch (_) {
        // fallback
        Get.offAllNamed(Routes.PARENT_HOME);
      }
    } else {
      Get.offAllNamed(Routes.PARENT_HOME);
    }
  }

  void goToHistory() {
    if (Get.isRegistered<ParentShellController>()) {
      Get.find<ParentShellController>().switchTab(2);
    } else {
      Get.toNamed(Routes.ASSESSMENT_HISTORY);
    }
  }

  void retakeAssessment() {
    // When used as a pushed route, switch shell to assessment tab
    if (Get.isRegistered<ParentShellController>()) {
      Get.find<ParentShellController>().switchTab(1);
      Get.offAllNamed(Routes.PARENT_HOME);
    } else {
      Get.offAllNamed(Routes.PARENT_HOME);
    }
  }
}
