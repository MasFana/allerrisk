import 'dart:ui' as dart_ui;
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/widgets/allerisk_button.dart';

import '../../../data/models/assessment_result_model.dart';
import '../../../routes/app_routes.dart';
import '../assessment/assessment_view.dart';
import '../article/article_list_view.dart';
import '../home/home_view.dart';
import '../assessment_history/history_view.dart';
import '../assessment_result/embedded_result_view.dart';
import '../settings/settings_view.dart';
import 'parent_shell_controller.dart';

class ParentShellView extends GetView<ParentShellController> {
  const ParentShellView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: Obx(
        () => IndexedStack(
          index: controller.currentIndex.value,
          children: [
            const HomeView(),
            const AssessmentView(),
            Obx(() => controller.showResultDetail.value ? const EmbeddedResultView() : const HistoryView()),
            const ArticleListView(),
            const SettingsView(),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNav(context),
    );
  }

  Widget _buildBottomNav(BuildContext context) {
    return Obx(() {
      final idx = controller.currentIndex.value;
      return ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(AppDimensions.radiusXl),
          topRight: Radius.circular(AppDimensions.radiusXl),
        ),
        child: BackdropFilter(
          filter: dart_ui.ImageFilter.blur(sigmaX: 16, sigmaY: 16),
          child: Container(
            color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.82),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.md,
                  vertical: AppDimensions.sm,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _NavItem(
                      icon: Icons.home_outlined,
                      activeIcon: Icons.home_rounded,
                      label: 'Beranda',
                      isActive: idx == 0,
                      onTap: () => controller.switchTab(0),
                    ),
                    _NavItem(
                      icon: Icons.assessment_outlined,
                      activeIcon: Icons.assessment_rounded,
                      label: 'Assessment',
                      isActive: idx == 1,
                      onTap: () => controller.switchTab(1),
                    ),
                    _NavItem(
                      icon: Icons.check_circle_outline_rounded,
                      activeIcon: Icons.check_circle_rounded,
                      label: 'Hasil',
                      isActive: idx == 2,
                      onTap: () => controller.switchTab(2),
                    ),
                    _NavItem(
                      icon: Icons.menu_book_outlined,
                      activeIcon: Icons.menu_book_rounded,
                      label: 'Artikel',
                      isActive: idx == 3,
                      onTap: () => controller.switchTab(3),
                    ),
                    _NavItem(
                      icon: Icons.person_outline,
                      activeIcon: Icons.person_rounded,
                      label: 'Profil',
                      isActive: idx == 4,
                      onTap: () => controller.switchTab(4),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}


// ── Bottom Nav Item ────────────────────────────────────────────────────────────

class _NavItem extends StatelessWidget {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = isActive ? AppColors.primary : AppColors.onSurfaceVariant;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.md,
          vertical: AppDimensions.xs,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: Icon(
                isActive ? activeIcon : icon,
                color: color,
                size: 24,
                key: ValueKey(isActive),
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: isActive ? FontWeight.w700 : FontWeight.w400,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

