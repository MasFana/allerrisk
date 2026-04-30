import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimensions.dart';
import '../../core/constants/app_strings.dart';
import '../../core/widgets/allerisk_button.dart';
import '../../data/models/user_model.dart';
import 'role_selector_controller.dart';

class RoleSelectorView extends GetView<RoleSelectorController> {
  const RoleSelectorView({super.key});

  static const String _logoAssetPath = 'assets/logo/AllerRisk.svg';

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      // Menggunakan warna primary tema Anda
      backgroundColor: AppColors.primary,
      body: Column(
        children: [
          // --- BAGIAN ATAS: LOGO ---
          Expanded(
            flex: 1, // Mengambil 1/3 bagian layar
            child: SafeArea(
              bottom: false,
              child: Center(
                child: SvgPicture.asset(
                  _logoAssetPath,
                  width: 200,
                  placeholderBuilder: (context) => const Center(
                    child: CircularProgressIndicator(color: AppColors.onPrimary),
                  ),
                ),
              ),
            ),
          ),

          // --- BAGIAN BAWAH: KONTEN PILIHAN PERAN ---
          Expanded(
            flex: 2, // Mengambil 2/3 bagian layar
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(32),
                ),
              ),
              child: SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.all(AppDimensions.xl),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: AppDimensions.sm),
                      Text(
                        'Saya adalah...',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppColors.onSurface,
                            ),
                        textAlign: TextAlign.left,
                      ),
                      const SizedBox(height: AppDimensions.xs),
                      Text(
                        'Pilih peran untuk melanjutkan',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppColors.onSurfaceVariant,
                            ),
                        textAlign: TextAlign.left,
                      ),
                      const SizedBox(height: AppDimensions.xl),

                      // --- KARTU ORANG TUA ---
                      Obx(
                        () => _buildRoleCard(
                          context,
                          title: AppStrings.roleParent,
                          subtitle: 'Pantau risiko alergi anak Anda',
                          icon: Icons.person_outline_rounded,
                          iconBgColor: AppColors.primaryContainer,
                          iconColor: AppColors.onPrimaryContainer,
                          isSelected: controller.selectedRole.value == UserRole.parent,
                          onTap: () => controller.selectRole(UserRole.parent),
                        ),
                      ),
                      const SizedBox(height: AppDimensions.lg),

                      // --- KARTU DOKTER ---
                      Obx(
                        () => _buildRoleCard(
                          context,
                          title: AppStrings.roleDoctor,
                          subtitle: 'Kelola pasien dan kurasi artikel medis',
                          icon: Icons.medical_services_outlined,
                          iconBgColor: AppColors.secondaryContainer,
                          iconColor: AppColors.onSecondaryContainer,
                          isSelected: controller.selectedRole.value == UserRole.doctor,
                          onTap: () => controller.selectRole(UserRole.doctor),
                        ),
                      ),
                      
                      const Spacer(),

                      // --- TOMBOL MULAI ---
                      Obx(
                        () => AlleriskButton(
                          text: 'MULAI',
                          onPressed: controller.selectedRole.value != null
                              ? controller.continueToLogin
                              : null,
                        ),
                      ),
                      const SizedBox(height: AppDimensions.md),

                      // --- TEKS PERSETUJUAN ---
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: AppDimensions.xs),
                        child: Text(
                          'Dengan melanjutkan, Anda menyetujui Ketentuan Layanan dan\nKebijakan Privasi AllerSense dalam perlindungan data medis.',
                          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                color: AppColors.onSurfaceVariant,
                                height: 1.5,
                              ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRoleCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color iconBgColor,
    required Color iconColor,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    // Rule 1: No hard borders — use background shift for selected state
    final bg = isSelected
        ? AppColors.primary.withValues(alpha: 0.08)
        : Theme.of(context).brightness == Brightness.dark
            ? AppColors.surfaceContainerLowDark
            : AppColors.surfaceContainerLow;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(AppDimensions.radiusXl),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(AppDimensions.radiusXl),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.lg,
              vertical: AppDimensions.md + 4,
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(AppDimensions.md),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.primaryContainer
                        : iconBgColor,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon,
                    color: isSelected ? AppColors.onPrimaryContainer : iconColor,
                    size: 26,
                  ),
                ),
                const SizedBox(width: AppDimensions.lg),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: isSelected
                                  ? AppColors.primary
                                  : Theme.of(context).colorScheme.onSurface,
                            ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColors.onSurfaceVariant,
                            ),
                      ),
                    ],
                  ),
                ),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: isSelected
                      ? Icon(
                          Icons.check_circle_rounded,
                          color: AppColors.primary,
                          size: 22,
                          key: const ValueKey('check'),
                        )
                      : Icon(
                          Icons.chevron_right_rounded,
                          color: Theme.of(context).colorScheme.outlineVariant,
                          size: 28,
                          key: const ValueKey('chevron'),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}