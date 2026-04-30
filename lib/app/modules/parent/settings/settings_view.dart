import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/constants/app_strings.dart';
import 'settings_controller.dart';

class SettingsView extends GetView<SettingsController> {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.settings), centerTitle: true),
      body: ListView(
        padding: const EdgeInsets.all(AppDimensions.lg),
        children: [
          // Profile Section
          Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: isDark
                    ? AppColors.surfaceContainerHighDark
                    : AppColors.primaryContainer,
                child: const Icon(
                  Icons.person,
                  color: AppColors.primary,
                  size: 32,
                ),
              ),
              const SizedBox(width: AppDimensions.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      controller.userName,
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      controller.userEmail,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: isDark
                            ? AppColors.onSurfaceVariantDark
                            : AppColors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.xl),

          Text(
            'PREFERENSI',
            style: theme.textTheme.labelMedium?.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppDimensions.md),

          Container(
            margin: EdgeInsets.zero,
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerLowest,
              borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
              boxShadow: AppTheme.ambientShadow,
            ),
            child: Material(
              color: Colors.transparent,
              child: Column(
              children: [

                ListTile(
                  leading: const Icon(Icons.notifications_outlined),
                  title: const Text(AppStrings.notifications),
                  subtitle: const Text('Atur pengingat asesmen'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    Get.snackbar('Info', 'Fitur notifikasi akan segera hadir');
                  },
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.language),
                  title: const Text(AppStrings.language),
                  subtitle: const Text(AppStrings.indonesia),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    Get.snackbar(
                      'Info',
                      'Hanya bahasa Indonesia yang didukung saat ini',
                    );
                  },
                ),
              ],
            ),
          ),
          ),

          const SizedBox(height: AppDimensions.xl),
          Text(
            'LAINNYA',
            style: theme.textTheme.labelMedium?.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppDimensions.md),

          Container(
            margin: EdgeInsets.zero,
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerLowest,
              borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
              boxShadow: AppTheme.ambientShadow,
            ),
            child: Material(
              color: Colors.transparent,
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.privacy_tip_outlined),
                    title: const Text(AppStrings.privacyPolicy),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {},
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.help_outline),
                    title: const Text(AppStrings.helpSupport),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {},
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.info_outline),
                    title: const Text(AppStrings.about),
                    trailing: const Text(
                      'v1.0.0',
                      style: TextStyle(color: Colors.grey),
                    ),
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: AppDimensions.xxl),

          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {
                Get.dialog(
                  AlertDialog(
                    title: const Text(AppStrings.logout),
                    content: const Text(AppStrings.logoutConfirm),
                    actions: [
                      TextButton(
                        onPressed: () => Get.back(),
                        child: const Text(AppStrings.cancel),
                      ),
                      TextButton(
                        onPressed: () {
                          Get.back();
                          controller.logout();
                        },
                        child: const Text(
                          AppStrings.logout,
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                );
              },
              icon: const Icon(Icons.logout, color: AppColors.error),
              label: const Text(
                AppStrings.logout,
                style: TextStyle(color: AppColors.error),
              ),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: AppDimensions.md),
                side: const BorderSide(color: AppColors.error),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
                ),
              ),
            ),
          ),
          const SizedBox(height: AppDimensions.xxl),
        ],
      ),
    );
  }
}
