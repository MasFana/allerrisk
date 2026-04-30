import 'package:get/get.dart';
import 'child_profile_controller.dart';

class ChildProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ChildProfileController>(() => ChildProfileController());
  }
}
