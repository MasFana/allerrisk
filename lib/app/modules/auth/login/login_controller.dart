import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/repositories/interfaces/i_auth_repository.dart';
import '../../../routes/app_routes.dart';
import '../../../data/models/user_model.dart';
import '../../../core/widgets/error_snackbar.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/demo_accounts.dart';

class LoginController extends GetxController {
  final IAuthRepository _authRepo = Get.find<IAuthRepository>();
  
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  
  final RxBool isLoading = false.obs;
  final RxBool obscurePassword = true.obs;
  final Rxn<UserRole> role = Rxn<UserRole>();

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args != null && args is Map && args.containsKey('role')) {
      role.value = args['role'] as UserRole;
    }

    _prefillDemoCredentials();
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  void togglePasswordVisibility() {
    obscurePassword.toggle();
  }

  /// TODO(real-auth): Remove demo autofill once real authentication is implemented.
  void _prefillDemoCredentials() {
    emailController.text = DemoAccounts.emailForRole(role.value);
    passwordController.text = DemoAccounts.demoPassword;
  }

  /// TODO(real-auth): Remove quick-switch demo login shortcuts.
  void useDemoAccount(UserRole selectedRole) {
    role.value = selectedRole;
    _prefillDemoCredentials();
  }

  Future<void> login() async {
    if (!formKey.currentState!.validate()) return;

    isLoading.value = true;
    try {
      final user = await _authRepo.login(
        emailController.text.trim(),
        passwordController.text,
      );
      
      if (user.role.name == 'doctor') {
        Get.offAllNamed(Routes.DOCTOR_SHELL);
      } else {
        Get.offAllNamed(Routes.PARENT_HOME);
      }
    } catch (e) {
      AppSnackbar.showError(title: AppStrings.errorGeneral, message: e.toString().replaceAll('Exception: ', ''));
    } finally {
      isLoading.value = false;
    }
  }
}
