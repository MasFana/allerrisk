import 'package:get/get.dart';

import 'parent_shell_controller.dart';
import '../home/home_binding.dart';
import '../assessment/assessment_binding.dart';
import '../article/article_list_binding.dart';
import '../assessment_history/history_binding.dart';
import '../settings/settings_binding.dart';

class ParentShellBinding extends Bindings {
  @override
  void dependencies() {
    // Shell controller – eager (not lazy) so child widgets can always find it
    Get.put<ParentShellController>(ParentShellController());

    // Pre-bind all tab controllers
    HomeBinding().dependencies();
    AssessmentBinding().dependencies();
    ArticleListBinding().dependencies();
    // Pre-bind history controller so embedded HistoryView can find it
    HistoryBinding().dependencies();
    // Pre-bind settings controller so the embedded Profile tab can find it
    SettingsBinding().dependencies();
  }
}
