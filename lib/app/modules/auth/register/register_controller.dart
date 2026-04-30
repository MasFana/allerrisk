import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/repositories/interfaces/i_auth_repository.dart';
import '../../../data/models/user_model.dart';
import '../../../routes/app_routes.dart';
import '../../../core/widgets/error_snackbar.dart';

class RegisterController extends GetxController {
  final IAuthRepository _authRepo = Get.find<IAuthRepository>();
  
  final formKey = GlobalKey<FormState>();
  
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  
  // Doctor specifics
  final strNumberController = TextEditingController();
  final specialtyController = TextEditingController();
  final clinicNameController = TextEditingController();
  
  final RxBool isLoading = false.obs;
  final RxBool obscurePassword = true.obs;
  final RxBool obscureConfirmPassword = true.obs;
  
  late final Rx<UserRole> selectedRole;

  @override
  void onInit() {
    super.onInit();
    final argsRole = Get.arguments?['role'] as UserRole?;
    selectedRole = (argsRole ?? UserRole.parent).obs;
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    strNumberController.dispose();
    specialtyController.dispose();
    clinicNameController.dispose();
    super.onClose();
  }

  void togglePasswordVisibility() => obscurePassword.toggle();
  void toggleConfirmPasswordVisibility() => obscureConfirmPassword.toggle();

  Future<void> register() async {
    if (!formKey.currentState!.validate()) return;

    isLoading.value = true;
    try {
      if (selectedRole.value == UserRole.doctor) {
        await _authRepo.registerDoctor(
          name: nameController.text.trim(),
          email: emailController.text.trim(),
          password: passwordController.text,
          strNumber: strNumberController.text.trim(),
          specialty: specialtyController.text.trim(),
          clinicName: clinicNameController.text.trim().isEmpty ? null : clinicNameController.text.trim(),
        );
        Get.offAllNamed(Routes.DOCTOR_DASHBOARD);
      } else {
        await _authRepo.registerParent(
          name: nameController.text.trim(),
          email: emailController.text.trim(),
          password: passwordController.text,
        );
        Get.offAllNamed(Routes.PARENT_HOME);
      }
    } catch (e) {
      AppSnackbar.showError(title: 'Registrasi Gagal', message: e.toString().replaceAll('Exception: ', ''));
    } finally {
      isLoading.value = false;
    }
  }
}
