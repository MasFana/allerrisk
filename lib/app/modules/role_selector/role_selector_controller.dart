import 'package:get/get.dart';
import '../../data/models/user_model.dart';
import '../../routes/app_routes.dart';

class RoleSelectorController extends GetxController {
  final Rx<UserRole?> selectedRole = Rx<UserRole?>(null);

  void selectRole(UserRole role) {
    selectedRole.value = role;
  }

  void continueToLogin() {
    if (selectedRole.value != null) {
      Get.toNamed(Routes.LOGIN, arguments: {'role': selectedRole.value});
    }
  }
}
