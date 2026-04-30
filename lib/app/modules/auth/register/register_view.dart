import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/widgets/allerisk_text_field.dart';
import '../../../core/widgets/allerisk_button.dart';
import '../../../core/utils/validators.dart';
import '../../../data/models/user_model.dart';
import 'register_controller.dart';

class RegisterView extends GetView<RegisterController> {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text(AppStrings.register),
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
                Obx(() => Text(
                  controller.selectedRole.value == UserRole.doctor
                      ? 'Daftar sebagai Dokter'
                      : 'Daftar sebagai Orang Tua',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.onSurface,
                      ),
                  textAlign: TextAlign.center,
                )),
                const SizedBox(height: AppDimensions.sm),
                Text(
                  'Bergabung dengan AllerRisk untuk memulai',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppColors.onSurfaceVariant,
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppDimensions.xxl),
                
                AlleriskTextField(
                  label: AppStrings.fullName,
                  hint: AppStrings.fullName,
                  controller: controller.nameController,
                  validator: (v) => Validators.validateRequired(v, fieldName: AppStrings.fullName),
                  prefixIcon: Icons.person_rounded,
                ),
                const SizedBox(height: AppDimensions.lg),
                
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
                  validator: Validators.validatePassword,
                  isPassword: true,
                  prefixIcon: Icons.lock_rounded,
                ),
                const SizedBox(height: AppDimensions.lg),
                
                AlleriskTextField(
                  label: AppStrings.confirmPassword,
                  hint: AppStrings.confirmPassword,
                  controller: controller.confirmPasswordController,
                  validator: (v) => Validators.validateConfirmPassword(v, controller.passwordController.text),
                  isPassword: true,
                  prefixIcon: Icons.lock_rounded,
                ),
                
                Obx(() => controller.selectedRole.value == UserRole.doctor
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const SizedBox(height: AppDimensions.xl),
                          const Divider(),
                          const SizedBox(height: AppDimensions.xl),
                          Text(
                            'Informasi Profesional',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.onSurface,
                                ),
                          ),
                          const SizedBox(height: AppDimensions.lg),
                          AlleriskTextField(
                            label: AppStrings.strNumber,
                            hint: '11 digit STR',
                            controller: controller.strNumberController,
                            validator: Validators.validateStr,
                            keyboardType: TextInputType.number,
                            prefixIcon: Icons.credit_card_rounded,
                          ),
                          const SizedBox(height: AppDimensions.lg),
                          AlleriskTextField(
                            label: AppStrings.specialty,
                            hint: 'Contoh: Spesialis Anak',
                            controller: controller.specialtyController,
                            validator: (v) => Validators.validateRequired(v, fieldName: AppStrings.specialty),
                            prefixIcon: Icons.local_hospital_rounded,
                          ),
                          const SizedBox(height: AppDimensions.lg),
                          AlleriskTextField(
                            label: AppStrings.clinicHospital,
                            hint: 'Tempat praktik (opsional)',
                            controller: controller.clinicNameController,
                            prefixIcon: Icons.business_rounded,
                          ),
                        ],
                      )
                    : const SizedBox.shrink()),
                    
                const SizedBox(height: AppDimensions.xxl),
                Obx(() => AlleriskButton(
                  text: AppStrings.register,
                  onPressed: controller.register,
                  isLoading: controller.isLoading.value,
                )),
                const SizedBox(height: AppDimensions.xxl),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      AppStrings.haveAccount,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.onSurfaceVariant,
                          ),
                    ),
                    TextButton(
                      onPressed: () => Get.back(),
                      child: Text(
                        AppStrings.login,
                        style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
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
