import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class NotificationService extends GetxService {
  Future<NotificationService> init() async {
    // Initialize push notifications here in the future
    return this;
  }

  void showInAppNotification({
    required String title,
    required String body,
    String? payload,
  }) {
    Get.snackbar(
      title,
      body,
      snackPosition: SnackPosition.TOP,
      backgroundColor: AppColors.surfaceContainerHighest,
      colorText: AppColors.onSurface,
      margin: const EdgeInsets.all(16),
      icon: const Icon(Icons.notifications_active, color: AppColors.primary),
      duration: const Duration(seconds: 4),
      onTap: (_) {
        if (payload != null) {
          Get.toNamed(payload);
        }
      },
    );
  }
}
