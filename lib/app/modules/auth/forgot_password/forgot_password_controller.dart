import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/widgets/error_snackbar.dart';

class ForgotPasswordController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final RxBool isLoading = false.obs;
  
  @override
  void onClose() {
    emailController.dispose();
    super.onClose();
  }

  Future<void> sendResetLink() async {
    if (!formKey.currentState!.validate()) return;
    
    isLoading.value = true;
    try {
      // Mock network delay
      await Future.delayed(const Duration(milliseconds: 1000));
      AppSnackbar.showSuccess(
        title: 'Check your email',
        message: 'Password reset instructions have been sent successfully.',
      );
      Future.delayed(const Duration(seconds: 2), () {
        if (Get.isSnackbarOpen) Get.closeAllSnackbars();
        Get.back();
      });
    } catch (e) {
      AppSnackbar.showError(title: 'Request Failed', message: e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
