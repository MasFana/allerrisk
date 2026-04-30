import 'package:get/get.dart';
import 'role_selector_controller.dart';

class RoleSelectorBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RoleSelectorController>(() => RoleSelectorController());
  }
}
