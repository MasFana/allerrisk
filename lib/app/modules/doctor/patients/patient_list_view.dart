import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/constants/app_strings.dart';
import '../../../routes/app_routes.dart';
import '../../../data/models/patient_model.dart';
import '../../../data/models/assessment_result_model.dart';
import 'patient_list_controller.dart';

class PatientListView extends GetView<PatientListController> {
  const PatientListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: const Text(AppStrings.patientList),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(110),
          child: Column(
            children: [
              _buildSearchBar(),
              _buildFiltersAndSort(),
            ],
          ),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.patients.isEmpty) {
          return _buildEmptyState(context);
        }

        return RefreshIndicator(
          onRefresh: controller.loadPatients,
          child: ListView.separated(
            padding: const EdgeInsets.all(AppDimensions.md),
            itemCount: controller.patients.length,
            separatorBuilder: (_, _) => const SizedBox(height: AppDimensions.sm),
            itemBuilder: (context, index) {
              return _buildPatientCard(context, controller.patients[index]);
            },
          ),
        );
      }),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.md, vertical: AppDimensions.sm),
      child: TextField(
        onChanged: controller.searchPatients,
        decoration: InputDecoration(
          hintText: AppStrings.searchPatientHint,
          prefixIcon: const Icon(Icons.search),
          filled: true,
          fillColor: AppColors.surfaceContainer,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 0),
        ),
      ),
    );
  }

  Widget _buildFiltersAndSort() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.md, vertical: AppDimensions.xs),
      child: Row(
        children: [
          _buildFilterChip('Semua', 'all'),
          const SizedBox(width: AppDimensions.sm),
          _buildFilterChip('Tinggi', 'high', color: AppColors.riskHigh),
          const SizedBox(width: AppDimensions.sm),
          _buildFilterChip('Sedang', 'medium', color: AppColors.riskMedium),
          const SizedBox(width: AppDimensions.sm),
          _buildFilterChip('Rendah', 'low', color: AppColors.riskLow),
          const SizedBox(width: AppDimensions.md),
          _buildSortDropdown(),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, String value, {Color? color}) {
    return Obx(() {
      final isSelected = controller.filterRisk.value == value;
      return ChoiceChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (selected) {
          if (selected) controller.applyFilter(value);
        },
        selectedColor: (color ?? AppColors.primary).withValues(alpha: 0.2),
        labelStyle: TextStyle(
          color: isSelected ? (color ?? AppColors.primary) : null,
          fontWeight: isSelected ? FontWeight.bold : null,
        ),
      );
    });
  }

  Widget _buildSortDropdown() {
    return Obx(() {
      return Container(
        height: 32,
        padding: const EdgeInsets.symmetric(horizontal: AppDimensions.sm),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerHigh,
          borderRadius: BorderRadius.circular(AppDimensions.radiusPill),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: controller.sortBy.value,
            icon: const Icon(Icons.arrow_drop_down, size: 20),
            style: const TextStyle(fontSize: 13, color: AppColors.onSurface),
            onChanged: (String? newValue) {
              if (newValue != null) controller.applySort(newValue);
            },
            items: const [
              DropdownMenuItem(value: 'recent', child: Text(AppStrings.sortRecent)),
              DropdownMenuItem(value: 'score_high', child: Text(AppStrings.sortScoreHigh)),
              DropdownMenuItem(value: 'score_low', child: Text(AppStrings.sortScoreLow)),
              DropdownMenuItem(value: 'name', child: Text(AppStrings.sortNameAsc)),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.people_outline, size: 64, color: AppColors.outline),
          const SizedBox(height: AppDimensions.md),
          Text(
            AppStrings.noPatientsFound,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          if (controller.searchQuery.value.isNotEmpty || controller.filterRisk.value != 'all')
            TextButton(
              onPressed: () {
                controller.searchQuery.value = '';
                controller.filterRisk.value = 'all';
              },
              child: const Text(AppStrings.clearFilter),
            ),
        ],
      ),
    );
  }

  Widget _buildPatientCard(BuildContext context, Patient patient) {
    final latest = patient.latestAssessment;
    final Color riskColor = _getRiskColor(latest?.level);

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        boxShadow: AppTheme.ambientShadow,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        onTap: () => Get.toNamed(Routes.PATIENT_DETAIL, arguments: patient),
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.md),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                child: Text(
                  patient.child.name.substring(0, 1).toUpperCase(),
                  style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary),
                ),
              ),
              const SizedBox(width: AppDimensions.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${patient.child.name} (${_calculateAge(patient.child.dateOfBirth)})',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${AppStrings.parentShort}: ${patient.parent.name}',
                      style: TextStyle(fontSize: 13, color: AppColors.onSurface.withValues(alpha: 0.7)),
                    ),
                    const SizedBox(height: 8),
                    if (latest != null)
                      Row(
                        children: [
                          Icon(Icons.calendar_today, size: 12, color: AppColors.onSurface.withValues(alpha: 0.5)),
                          const SizedBox(width: 4),
                          Text(
                            AppFormatters.dateShort(latest.assessedAt),
                            style: TextStyle(fontSize: 12, color: AppColors.onSurface.withValues(alpha: 0.7)),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: riskColor.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(AppDimensions.radiusPill),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          latest?.score.toStringAsFixed(1) ?? '-',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: riskColor,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(width: 4),
                        _buildTrendArrow(patient),
                      ],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _getRiskLabel(latest?.level),
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: riskColor,
                    ),
                  ),
                ],
              ),
            ],
        ),
      ),
      ),
      ),
    );
  }

  Widget _buildTrendArrow(Patient patient) {
    if (patient.pastAssessments.length < 2) {
      return const SizedBox(width: 12, height: 12);
    }
    
    // As pastAssessments are sorted newest first, index 0 is latest, index 1 is previous
    final latestScore = patient.pastAssessments[0].score;
    final previousScore = patient.pastAssessments[1].score;
    
    IconData icon;
    Color color;

    if (latestScore > previousScore) {
      icon = Icons.arrow_upward;
      color = AppColors.error; // Risk going up is bad
    } else if (latestScore < previousScore) {
      icon = Icons.arrow_downward;
      color = AppColors.success; // Risk going down is good
    } else {
      icon = Icons.arrow_forward;
      color = AppColors.onSurface.withValues(alpha: 0.5); // No change
    }

    return Icon(icon, size: 12, color: color);
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
      return '$years ${AppStrings.yearsShort}';
    } else {
      return '$months ${AppStrings.monthsShort}';
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
