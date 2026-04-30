import 'dart:ui' as dart_ui;
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../theme/app_colors.dart';
import '../theme/app_dimensions.dart';

import '../../modules/doctor/shell/doctor_shell_controller.dart';

/// Glassmorphism bottom navigation bar for the Doctor module.
/// Rule 4: BackdropFilter + semi-transparent surface, no standard NavigationBar.
class DoctorNavBar extends StatelessWidget {
  final int currentIndex;

  const DoctorNavBar({super.key, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(AppDimensions.radiusXl),
        topRight: Radius.circular(AppDimensions.radiusXl),
      ),
      child: BackdropFilter(
        filter: dart_ui.ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.surface.withValues(alpha: 0.80),
            border: Border(
              top: BorderSide(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.05),
              ),
            ),
          ),
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
                    icon: Icons.dashboard_outlined,
                    activeIcon: Icons.dashboard_rounded,
                    label: 'Dashboard',
                    isActive: currentIndex == 0,
                    onTap: () {
                      if (currentIndex != 0) {
                        Get.find<DoctorShellController>().switchTab(0);
                      }
                    },
                  ),
                  _NavItem(
                    icon: Icons.people_outline,
                    activeIcon: Icons.people_rounded,
                    label: 'Pasien',
                    isActive: currentIndex == 1,
                    onTap: () {
                      if (currentIndex != 1) {
                        Get.find<DoctorShellController>().switchTab(1);
                      }
                    },
                  ),
                  _NavItem(
                    icon: Icons.article_outlined,
                    activeIcon: Icons.article_rounded,
                    label: 'Artikel',
                    isActive: currentIndex == 2,
                    onTap: () {
                      if (currentIndex != 2) {
                        Get.find<DoctorShellController>().switchTab(2);
                      }
                    },
                  ),
                  _NavItem(
                    icon: Icons.person_outline_rounded,
                    activeIcon: Icons.person_rounded,
                    label: 'Profil',
                    isActive: currentIndex == 3,
                    onTap: () {
                      if (currentIndex != 3) {
                        Get.find<DoctorShellController>().switchTab(3);
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

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
              transitionBuilder: (child, anim) =>
                  ScaleTransition(scale: anim, child: child),
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
