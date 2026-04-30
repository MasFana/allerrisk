import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/constants/app_strings.dart';
import '../../../data/models/assessment_result_model.dart';
import '../../../data/models/child_profile_model.dart';
import 'patient_detail_controller.dart';

class PatientDetailView extends GetView<PatientDetailController> {
  const PatientDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: const Text(AppStrings.patientDetail),
        actions: [
          Obx(() => IconButton(
                icon: controller.isExporting.value
                    ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2))
                    : const Icon(Icons.picture_as_pdf),
                onPressed: controller.isExporting.value ? null : controller.exportPatientReport,
                tooltip: AppStrings.exportPdfTooltip,
              )),
          IconButton(
            icon: const Icon(Icons.article_outlined),
            onPressed: controller.showArticlePicker,
            tooltip: 'Rekomendasikan Artikel',
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return DefaultTabController(
          length: 3,
          child: Column(
            children: [
              _buildPatientHeader(context),
              const TabBar(
                tabs: [
                  Tab(text: AppStrings.assessmentHistory),
                  Tab(text: AppStrings.answerDetail),
                  Tab(text: AppStrings.clinicalNotes),
                ],
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    _buildAssessmentTimeline(),
                    _buildSelectedAssessmentDetail(context),
                    _buildClinicalNotesTab(),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildPatientHeader(BuildContext context) {
    final patient = controller.patient.value;
    final child = patient.child;
    final latest = patient.latestAssessment;
    final Color riskColor = _getRiskColor(latest?.level);

    return Container(
      padding: const EdgeInsets.all(AppDimensions.md),
      color: AppColors.surfaceContainerHighest.withValues(alpha: 0.3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 32,
            backgroundColor: AppColors.primary.withValues(alpha: 0.1),
            child: Text(
              child.name.substring(0, 1).toUpperCase(),
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24, color: AppColors.primary),
            ),
          ),
          const SizedBox(width: AppDimensions.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  child.name,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  '${AppStrings.bornOn}: ${AppFormatters.dateShort(child.dateOfBirth)} (${_calculateAge(child.dateOfBirth)})',
                  style: TextStyle(color: AppColors.onSurface.withValues(alpha: 0.7)),
                ),
                Text(
                  '${child.gender == Gender.male ? AppStrings.male : AppStrings.female} • BB: ${child.weightKg}kg • TB: ${child.heightCm}cm',
                  style: TextStyle(color: AppColors.onSurface.withValues(alpha: 0.7)),
                ),
                const SizedBox(height: 8),
                Text(
                  '${AppStrings.parentLabel}: ${patient.parent.name}',
                  style: TextStyle(fontWeight: FontWeight.w500, color: AppColors.primary),
                ),
              ],
            ),
          ),
          if (latest != null)
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: riskColor.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
              ),
              child: Column(
                children: [
                  Text(
                    latest.score.toStringAsFixed(1),
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: riskColor),
                  ),
                  Text(
                    _getRiskLabel(latest.level),
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10, color: riskColor),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildAssessmentTimeline() {
    if (controller.assessmentHistory.isEmpty) {
      return const Center(child: Text(AppStrings.noAssessmentHistory));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(AppDimensions.md),
      itemCount: controller.assessmentHistory.length,
      itemBuilder: (context, index) {
        final assessment = controller.assessmentHistory[index];
        final isSelected = controller.selectedResult.value?.id == assessment.id;
        final riskColor = _getRiskColor(assessment.level);

        return Container(
          margin: const EdgeInsets.only(bottom: AppDimensions.sm),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary.withValues(alpha: 0.08) : AppColors.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
            boxShadow: AppTheme.ambientShadow,
          ),
          child: Material(
            color: Colors.transparent,
            child: ListTile(
            onTap: () => controller.selectAssessment(assessment),
            leading: Icon(
              Icons.assignment_turned_in,
              color: isSelected ? AppColors.primary : riskColor,
            ),
            title: Text(AppFormatters.dateLong(assessment.assessedAt)),
            subtitle: Text('${AppStrings.score}: ${assessment.score.toStringAsFixed(1)} (${_getRiskLabel(assessment.level)})'),
            trailing: isSelected ? const Icon(Icons.check_circle, color: AppColors.primary) : null,
          ),
        ),
      );
      },
    );
  }

  Widget _buildSelectedAssessmentDetail(BuildContext context) {
    final result = controller.selectedResult.value;
    if (result == null) {
      return const Center(child: Text(AppStrings.selectAssessmentFromHistory));
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppDimensions.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${AppStrings.scoreBreakdown} (${AppFormatters.dateShort(result.assessedAt)})',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: AppDimensions.md),
          _buildScoreBreakdownItem(AppStrings.genetic, result.breakdown.geneticScore, 3.0),
          _buildScoreBreakdownItem(AppStrings.activeSymptoms, result.breakdown.symptomsScore, 4.0),
          _buildScoreBreakdownItem(AppStrings.medicalHistory, result.breakdown.historyScore, 2.0),
          _buildScoreBreakdownItem(AppStrings.environment, result.breakdown.environmentScore, 1.0),
          
          const Divider(height: AppDimensions.xxl),
          
          Text(
            AppStrings.rawAnswers,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: AppDimensions.md),
          // We can display the raw answers if available.
          // In this prototype we might not have full raw answers in the AssessmentResult model,
          // so we just display a placeholder or derive from breakdown.
          Container(
            padding: const EdgeInsets.all(AppDimensions.md),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainer,
              borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
            ),
            child: const Text(AppStrings.rawAnswersPlaceholder),
          ),
        ],
      ),
    );
  }

  Widget _buildScoreBreakdownItem(String label, double score, double maxScore) {
    final percentage = (score / maxScore).clamp(0.0, 1.0);
    return Padding(
      padding: const EdgeInsets.only(bottom: AppDimensions.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
              Text('${score.toStringAsFixed(1)} / $maxScore'),
            ],
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: percentage,
            backgroundColor: AppColors.surfaceContainerHighest,
            color: AppColors.primary,
            minHeight: 8,
            borderRadius: BorderRadius.circular(4),
          ),
        ],
      ),
    );
  }

  Widget _buildClinicalNotesTab() {
    return Column(
      children: [
        Expanded(
          child: Obx(() {
            if (controller.clinicalNotes.isEmpty) {
              return const Center(child: Text(AppStrings.noClinicalNotes));
            }
            return ListView.separated(
              padding: const EdgeInsets.all(AppDimensions.md),
              itemCount: controller.clinicalNotes.length,
              separatorBuilder: (_, _) => const SizedBox(height: AppDimensions.sm),
              itemBuilder: (context, index) {
                final note = controller.clinicalNotes[index];
                return Container(
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainerHighest.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(AppDimensions.md),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              AppFormatters.dateLong(note.createdAt),
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                            ),
                            if (note.assessmentId != null)
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: const Text(AppStrings.relatedAssessment, style: TextStyle(fontSize: 10, color: AppColors.primary)),
                              )
                          ],
                        ),
                        const SizedBox(height: AppDimensions.sm),
                        Text(note.note),
                      ],
                    ),
                  ),
                );
              },
            );
          }),
        ),
        Container(
          padding: const EdgeInsets.all(AppDimensions.md),
          decoration: BoxDecoration(
            color: AppColors.surface,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, -5),
              )
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: TextField(
                  controller: controller.noteController,
                  maxLines: 4,
                  minLines: 1,
                  decoration: const InputDecoration(
                    hintText: AppStrings.addClinicalNoteHint,
                    contentPadding: EdgeInsets.all(AppDimensions.md),
                  ),
                ),
              ),
              const SizedBox(width: AppDimensions.sm),
              Obx(() => IconButton.filled(
                onPressed: controller.isAddingNote.value ? null : controller.addClinicalNote,
                icon: controller.isAddingNote.value
                    ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                    : const Icon(Icons.send),
              )),
            ],
          ),
        ),
      ],
    );
  }

  String _calculateAge(DateTime dob) {
    final now = DateTime.now();
    int years = now.year - dob.year;
    int months = now.month - dob.month;
    if (months < 0) {
      years--;
      months += 12;
    }
    if (years > 0) {
      return '$years thn';
    } else {
      return '$months bln';
    }
  }

  Color _getRiskColor(RiskLevel? level) {
    switch (level) {
      case RiskLevel.low:
        return AppColors.riskLow;
      case RiskLevel.medium:
        return AppColors.riskMedium;
      case RiskLevel.high:
        return AppColors.riskHigh;
      default:
        return AppColors.outline;
    }
  }

  String _getRiskLabel(RiskLevel? level) {
    switch (level) {
      case RiskLevel.low:
        return AppStrings.riskLowLabel;
      case RiskLevel.medium:
        return AppStrings.riskMediumLabel;
      case RiskLevel.high:
        return AppStrings.riskHighLabel;
      default:
        return AppStrings.noRiskLabel;
    }
  }
}
