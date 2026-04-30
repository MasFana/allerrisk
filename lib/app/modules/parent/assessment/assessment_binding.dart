import 'package:get/get.dart';
import 'assessment_controller.dart';

class AssessmentBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AssessmentController>(() => AssessmentController());
  }
}
