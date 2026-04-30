import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../theme/app_colors.dart';
import '../theme/app_dimensions.dart';

class AppSnackbar {
  static void showError({required String title, required String message}) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: AppColors.errorContainer,
      colorText: AppColors.onErrorContainer,
      icon: const Icon(Icons.error_outline, color: AppColors.error),
      margin: const EdgeInsets.all(AppDimensions.md),
      borderRadius: AppDimensions.radiusMd,
      duration: const Duration(seconds: 4),
    );
  }

  static void showSuccess({required String title, required String message}) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: AppColors.riskLowContainer,
      colorText: AppColors.onPrimaryContainer,
      icon: const Icon(Icons.check_circle_outline, color: AppColors.riskLow),
      margin: const EdgeInsets.all(AppDimensions.md),
      borderRadius: AppDimensions.radiusMd,
      duration: const Duration(seconds: 3),
    );
  }

  static void showWarning({required String title, required String message}) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: AppColors.riskMediumContainer,
      colorText: AppColors.onTertiaryContainer,
      icon: const Icon(
        Icons.warning_amber_rounded,
        color: AppColors.riskMedium,
      ),
      margin: const EdgeInsets.all(AppDimensions.md),
      borderRadius: AppDimensions.radiusMd,
      duration: const Duration(seconds: 4),
    );
  }
}
