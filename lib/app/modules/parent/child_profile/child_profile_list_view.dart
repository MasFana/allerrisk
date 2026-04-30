import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/widgets/child_avatar_widget.dart';
import '../../../data/models/child_profile_model.dart';
import 'child_profile_controller.dart';

class ChildProfileListView extends GetView<ChildProfileController> {
  const ChildProfileListView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        title: const Text(AppStrings.childProfile),
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.onSurface,
        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => controller.goToForm(),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.onPrimary,
        icon: const Icon(Icons.add),
        label: const Text(AppStrings.addChild),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          );
        }
        if (controller.children.isEmpty) {
          return _buildEmpty(context, theme);
        }
        return RefreshIndicator(
          onRefresh: controller.loadChildren,
          color: AppColors.primary,
          child: ListView.builder(
            padding: const EdgeInsets.fromLTRB(
                AppDimensions.md, AppDimensions.sm,
                AppDimensions.md, AppDimensions.xxxl),
            itemCount: controller.children.length,
            itemBuilder: (_, i) =>
                _buildChildTile(context, controller.children[i], theme),
          ),
        );
      }),
    );
  }

  Widget _buildChildTile(
      BuildContext context, ChildProfile child, ThemeData theme) {
    return Dismissible(
      key: Key(child.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: AppDimensions.lg),
        decoration: BoxDecoration(
          color: AppColors.riskHigh.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        ),
        child: const Icon(Icons.delete_outline, color: AppColors.riskHigh),
      ),
      confirmDismiss: (_) => _confirmDelete(context, child.name),
      onDismissed: (_) => controller.deleteChild(child),
      child: Padding(
        padding: const EdgeInsets.only(bottom: AppDimensions.sm),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
            boxShadow: AppTheme.ambientShadow,
          ),
          child: Material(
            color: Colors.transparent,
            child: ListTile(
            contentPadding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.md,
                vertical: AppDimensions.xs),
            leading: ChildAvatarWidget(
              name: child.name,
              radius: AppDimensions.avatarMd / 2,
              imageUrl: child.photoUrl,
            ),
            title: Text(child.name,
                style: theme.textTheme.titleSmall
                    ?.copyWith(fontWeight: FontWeight.bold)),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(child.ageDisplay,
                    style: theme.textTheme.bodySmall
                        ?.copyWith(color: AppColors.onSurfaceVariant)),
                Text(
                  '${child.gender == Gender.male ? AppStrings.maleIcon : AppStrings.femaleIcon}'
                  ' • ${child.weightKg.toStringAsFixed(1)} kg'
                  ' • ${child.heightCm.toStringAsFixed(0)} cm',
                  style: theme.textTheme.labelSmall
                      ?.copyWith(color: AppColors.onSurfaceVariant),
                ),
              ],
            ),
            trailing: PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert,
                  color: AppColors.onSurfaceVariant),
              onSelected: (val) {
                if (val == 'edit') controller.goToForm(child: child);
                if (val == 'assess') controller.goToAssessment(child.id);
              },
              itemBuilder: (_) => [
                const PopupMenuItem(
                  value: 'assess',
                  child: ListTile(
                    leading: Icon(Icons.assessment_rounded),
                    title: Text(AppStrings.navAssessment),
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
                const PopupMenuItem(
                  value: 'edit',
                  child: ListTile(
                    leading: Icon(Icons.edit_outlined),
                    title: Text(AppStrings.editChildProfile),
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ],
            ),
          ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmpty(BuildContext context, ThemeData theme) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.child_care_rounded,
                size: 72, color: AppColors.primary),
            const SizedBox(height: AppDimensions.lg),
            Text(AppStrings.noChildProfile,
                style: theme.textTheme.titleMedium
                    ?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: AppDimensions.sm),
            Text(AppStrings.addProfileInstruction,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium
                    ?.copyWith(color: AppColors.onSurfaceVariant)),
          ],
        ),
      ),
    );
  }

  Future<bool> _confirmDelete(BuildContext context, String name) async {
    return await showDialog<bool>(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text(AppStrings.deleteProfileConfirmTitle),
            content: const Text(AppStrings.deleteProfileConfirmDesc),
            actions: [
              TextButton(
                onPressed: () => Get.back(result: false),
                child: const Text(AppStrings.cancel),
              ),
              TextButton(
                onPressed: () => Get.back(result: true),
                style: TextButton.styleFrom(
                    foregroundColor: AppColors.riskHigh),
                child: const Text(AppStrings.delete),
              ),
            ],
          ),
        ) ??
        false;
  }
}
