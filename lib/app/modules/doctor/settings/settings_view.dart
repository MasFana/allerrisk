import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/constants/app_strings.dart';
import 'settings_controller.dart';

class DoctorSettingsView extends GetView<DoctorSettingsController> {
  const DoctorSettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: const Text(AppStrings.doctorProfile),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppDimensions.md),
        children: [
          _buildProfileHeader(context),
          const SizedBox(height: AppDimensions.xl),
          _buildSettingsSection(
            title: AppStrings.notifications,
            children: [
              Obx(() => SwitchListTile(
                    title: const Text(AppStrings.pushNotifications),
                    subtitle: const Text(AppStrings.pushNotificationsDesc),
                    value: controller.pushNotifications.value,
                    onChanged: controller.togglePushNotif,
                    activeThumbColor: AppColors.primary,
                  )),
              const Divider(height: 1),
              Obx(() => SwitchListTile(
                    title: const Text(AppStrings.weeklyReportEmail),
                    subtitle: const Text(AppStrings.weeklyReportEmailDesc),
                    value: controller.emailNotifications.value,
                    onChanged: controller.toggleEmailNotif,
                    activeThumbColor: AppColors.primary,
                  )),
            ],
          ),
          const SizedBox(height: AppDimensions.lg),

          _buildSettingsSection(
            title: AppStrings.helpSupport,
            children: [
              ListTile(
                title: const Text(AppStrings.helpSupport),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {},
              ),
              const Divider(height: 1),
              ListTile(
                title: const Text(AppStrings.termsAndConditions),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {},
              ),
              const Divider(height: 1),
              ListTile(
                title: const Text(AppStrings.privacyPolicy),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {},
              ),
              const Divider(height: 1),
              ListTile(
                title: const Text(AppStrings.appVersion),
                trailing: const Text('1.0.0', style: TextStyle(color: Colors.grey)),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.xl),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: controller.logout,
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.error,
                side: const BorderSide(color: AppColors.error),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text(AppStrings.logout, style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
          const SizedBox(height: AppDimensions.xxl),
        ],
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.md),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 36,
            backgroundColor: AppColors.primary,
            child: Text(
              controller.doctorName.substring(0, 1).toUpperCase(),
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ),
          const SizedBox(width: AppDimensions.lg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Dr. ${controller.doctorName}',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  controller.doctorEmail,
                  style: TextStyle(color: AppColors.onSurface.withValues(alpha: 0.7)),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.success.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(AppDimensions.radiusPill),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.verified, size: 14, color: AppColors.success),
                      const SizedBox(width: 4),
                      Text(AppStrings.strVerified, style: TextStyle(color: AppColors.success, fontSize: 11, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsSection({required String title, required List<Widget> children}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8, bottom: 8),
          child: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.primary),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: AppColors.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
            boxShadow: AppTheme.ambientShadow,
          ),
          child: Material(
            color: Colors.transparent,
            child: Column(children: children),
          ),
        ),
      ],
    );
  }
}
