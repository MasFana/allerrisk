import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/widgets/allerisk_text_field.dart';
import '../../../core/widgets/allerisk_button.dart';
import '../../../core/utils/validators.dart';
import '../../../routes/app_routes.dart';
import '../../../data/models/user_model.dart';
import 'login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});

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
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppDimensions.xl),
          child: Form(
            key: controller.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: AppDimensions.xxxl),
                Obx(() {
                  final selectedRole = controller.role.value;
                  final isDoctor = selectedRole == UserRole.doctor;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Role label — small caps eyebrow
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppDimensions.sm,
                          vertical: AppDimensions.xs,
                        ),
                        decoration: BoxDecoration(
                          color: isDoctor
                              ? AppColors.secondaryContainer
                              : AppColors.primaryContainer,
                          borderRadius: BorderRadius.circular(AppDimensions.radiusPill),
                        ),
                        child: Text(
                          isDoctor ? 'PORTAL DOKTER' : 'PORTAL ORANG TUA',
                          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                color: isDoctor
                                    ? AppColors.onSecondaryContainer
                                    : AppColors.onPrimaryContainer,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.8,
                              ),
                        ),
                      ),
                      const SizedBox(height: AppDimensions.sm),
                      Text(
                        isDoctor
                            ? AppStrings.loginAsDoctor
                            : AppStrings.loginAsParent,
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: AppColors.onSurface,
                            ),
                        textAlign: TextAlign.left,
                      ),
                    ],
                  );
                }),
                const SizedBox(height: AppDimensions.xxl),
                AlleriskTextField(
                  label: AppStrings.email,
                  hint: AppStrings.email,
                  controller: controller.emailController,
                  validator: Validators.validateEmail,
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: Icons.email_rounded,
                ),
                const SizedBox(height: AppDimensions.lg),
                AlleriskTextField(
                  label: AppStrings.password,
                  hint: AppStrings.password,
                  controller: controller.passwordController,
                  validator: Validators.validateRequired,
                  isPassword: true,
                  prefixIcon: Icons.lock_rounded,
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () => Get.toNamed(Routes.FORGOT_PASSWORD),
                    child: Text(
                      AppStrings.forgotPassword,
                      style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: AppDimensions.xl),
                Obx(() => AlleriskButton(
                  text: AppStrings.login,
                  onPressed: controller.login,
                  isLoading: controller.isLoading.value,
                )),
                const SizedBox(height: AppDimensions.xxl),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Ingin ganti peran?',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.onSurfaceVariant,
                          ),
                    ),
                    TextButton(
                      onPressed: () => Get.offNamed(Routes.ROLE_SELECTOR),
                      child: const Text('Pilih Peran'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
