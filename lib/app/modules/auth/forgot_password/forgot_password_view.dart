import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/widgets/allerisk_text_field.dart';
import '../../../core/widgets/allerisk_button.dart';
import '../../../core/utils/validators.dart';
import 'forgot_password_controller.dart';

class ForgotPasswordView extends GetView<ForgotPasswordController> {
  const ForgotPasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text(''),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.xl),
          child: Form(
            key: controller.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: AppDimensions.xl),
                Text(
                  AppStrings.forgotPasswordTitle,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.onSurface,
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppDimensions.sm),
                Text(
                   'Masukkan alamat email Anda dan kami akan mengirimkan instruksi untuk mengatur ulang kata sandi Anda.',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppColors.onSurfaceVariant,
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppDimensions.xxl),
                AlleriskTextField(
                  label: AppStrings.email,
                  hint: 'Masukkan email terdaftar',
                  controller: controller.emailController,
                  validator: Validators.validateEmail,
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: Icons.email_rounded,
                ),
                const SizedBox(height: AppDimensions.xxl),
                Obx(() => AlleriskButton(
                  text: AppStrings.sendResetLink,
                  onPressed: controller.sendResetLink,
                  isLoading: controller.isLoading.value,
                )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
