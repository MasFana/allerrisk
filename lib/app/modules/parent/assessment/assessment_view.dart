import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/widgets/allerisk_button.dart';
import 'assessment_controller.dart';

class AssessmentView extends GetView<AssessmentController> {
  const AssessmentView({super.key});

  static const _weights = ['35%', '30%', '20%', '15%'];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        titleSpacing: 0,
        leading: Obx(
          () => IconButton(
            icon: const Icon(Icons.arrow_back_rounded),
            color: AppColors.primary,
            onPressed: controller.goBackFromAssessment,
            tooltip: controller.isFirstStep ? 'Kembali ke Beranda' : 'Sebelumnya',
          ),
        ),
        title: Text(
          'Asesmen Risiko',
          style: theme.textTheme.titleMedium?.copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: SafeArea(
        child: Obx(() {
          if (controller.isSubmitting.value) {
            return const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(color: AppColors.primary),
                  SizedBox(height: AppDimensions.md),
                  Text('Menghitung risiko alergi...'),
                ],
              ),
            );
          }
  
          if (!controller.hasActiveChild) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(AppDimensions.lg),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(AppDimensions.lg),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainerLowest,
                    borderRadius: BorderRadius.circular(AppDimensions.radiusXl),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(AppDimensions.sm),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceContainerLow,
                          borderRadius:
                              BorderRadius.circular(AppDimensions.radiusMd),
                        ),
                        child: const Icon(
                          Icons.child_care_rounded,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(height: AppDimensions.md),
                      Text(
                        'Pilih profil anak terlebih dahulu',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: AppColors.onSurface,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: AppDimensions.xs),
                      Text(
                        'Asesmen berjalan berdasarkan anak aktif dari beranda agar hasil dan riwayat tetap sinkron.',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: AppColors.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: AppDimensions.md),
                      FilledButton(
                        style: FilledButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: AppColors.onPrimary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AppDimensions.radiusPill),
                          ),
                        ),
                        onPressed: controller.goBackFromAssessment,
                        child: const Text('Kembali ke Beranda'),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
  
          return Column(
            children: [
              _buildProgressHeader(theme),
              Expanded(
                child: ClipRect(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 280),
                    layoutBuilder: (currentChild, previousChildren) {
                      return Stack(
                        alignment: Alignment.topCenter,
                        children: <Widget>[
                          ...previousChildren,
                          ?currentChild,
                        ],
                      );
                    },
                    transitionBuilder: (child, anim) => FadeTransition(
                      opacity: anim,
                      child: SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(0.04, 0),
                          end: Offset.zero,
                        ).animate(anim),
                        child: child,
                      ),
                    ),
                    child: KeyedSubtree(
                      key: ValueKey(controller.currentStep.value),
                      child: _buildStepContent(context, theme),
                    ),
                  ),
                ),
              ),
              _buildNavButtons(theme),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildProgressHeader(ThemeData theme) {
    final step = controller.currentStepData;
    final current = controller.currentStep.value;
    final total = controller.totalSteps;
    
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppDimensions.md,
        AppDimensions.sm,
        AppDimensions.md,
        0,
      ),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppDimensions.md),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerLow,
              borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.info_outline_rounded,
                  color: AppColors.secondary,
                  size: 18,
                ),
                const SizedBox(width: AppDimensions.sm),
                Expanded(
                  child: Text(
                    'Jawab berdasarkan kondisi anak saat ini dan riwayat yang pernah terjadi. Hasil ini membantu skrining awal, bukan diagnosis medis.',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: AppColors.onSurface,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppDimensions.md),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      step.title.toUpperCase(),
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                  Text(
                    'Langkah ${current + 1} dari $total',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppDimensions.xs),
              Row(
                children: List.generate(total, (index) {
                  final filled = index <= current;
                  return Expanded(
                    child: Container(
                      height: 6,
                      margin:
                          EdgeInsets.only(right: index < total - 1 ? 4 : 0),
                      decoration: BoxDecoration(
                        color: filled
                            ? AppColors.primary
                            : AppColors.surfaceContainerHighest,
                        borderRadius:
                            BorderRadius.circular(AppDimensions.radiusPill),
                      ),
                    ),
                  );
                }),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStepContent(BuildContext context, ThemeData theme) {
    final step = controller.currentStepData;
    final stepIdx = controller.currentStep.value;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppDimensions.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      step.title,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppColors.onSurface,
                      ),
                    ),
                    const SizedBox(height: AppDimensions.xs),
                    Text(
                      step.subtitle,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppDimensions.sm),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.sm + 2,
                  vertical: AppDimensions.xs,
                ),
                decoration: BoxDecoration(
                  color: AppColors.tertiaryContainer,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusPill),
                ),
                child: Text(
                  _weights[stepIdx],
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: AppColors.tertiary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          if (controller.currentStep.value == 1 && controller.hasAnaphylaxisSelected) ...[
            const SizedBox(height: AppDimensions.md),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppDimensions.md),
              decoration: BoxDecoration(
                color: AppColors.errorContainer,
                borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.warning_amber_rounded,
                    color: AppColors.error,
                  ),
                  const SizedBox(width: AppDimensions.sm),
                  Expanded(
                    child: Text(
                      'Gejala anafilaksis memerlukan perhatian medis segera. Anda tetap dapat melanjutkan asesmen untuk melengkapi data.',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: AppColors.onErrorContainer,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: AppDimensions.lg),
          ...step.questions.map((q) => _buildQuestionTile(theme, q)),
        ],
      ),
    );
  }

  Widget _buildQuestionTile(ThemeData theme, AssessmentQuestion q) {
    final answer = controller.answers[q.key] ?? false;
    final isCritical = q.key == 'hasAnaphylaxis';
    final bgColor = isCritical && answer
        ? AppColors.errorContainer
        : answer
            ? AppColors.primaryContainer.withValues(alpha: 0.32)
            : AppColors.surfaceContainerLowest;
    final accent = isCritical ? AppColors.error : AppColors.primary;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppDimensions.sm),
      child: Material(
        color: bgColor,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        child: InkWell(
          borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
          onTap: () => controller.setAnswer(q.key, !answer),
          child: Padding(
            padding: const EdgeInsets.all(AppDimensions.md),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: answer ? accent : Colors.transparent,
                    border: Border.all(
                      color: answer
                          ? accent
                          : AppColors.outlineVariant,
                      width: 2,
                    ),
                  ),
                  child: answer
                      ? const Icon(Icons.check, size: 14, color: Colors.white)
                      : null,
                ),
                const SizedBox(width: AppDimensions.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        q.label,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: AppColors.onSurface,
                          fontWeight:
                              answer ? FontWeight.w700 : FontWeight.w500,
                        ),
                      ),
                      if (q.hint != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          q.hint!,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: isCritical
                                ? AppColors.error
                                : AppColors.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavButtons(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.fromLTRB(
        AppDimensions.md,
        AppDimensions.md,
        AppDimensions.md,
        AppDimensions.md,
      ),
      decoration: const BoxDecoration(
        color: AppColors.surfaceContainerLowest,
      ),
      child: Obx(() => Row(
        children: [
          if (!controller.isFirstStep) ...[
            Expanded(
              // Rule 1 + 3: No OutlinedButton border — use AlleriskButton(isOutlined:true)
              child: AlleriskButton(
                text: 'Sebelumnya',
                isOutlined: true,
                onPressed: controller.prevStep,
              ),
            ),
            const SizedBox(width: AppDimensions.sm),
          ],
          Expanded(
            flex: 2,
            child: controller.isLastStep
                // Rule 3: Gradient CTA via AlleriskButton
                ? AlleriskButton(
                    text: 'Hitung Risiko',
                    icon: Icons.send_rounded,
                    onPressed: controller.submit,
                    isLoading: controller.isSubmitting.value,
                  )
                : AlleriskButton(
                    text: 'Selanjutnya',
                    onPressed: controller.nextStep,
                  ),
          ),
        ],
      )),
    );
  }
}

