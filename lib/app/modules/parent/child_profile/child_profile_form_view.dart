import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/widgets/allerisk_button.dart';
import '../../../core/widgets/allerisk_text_field.dart';
import '../../../data/models/child_profile_model.dart';
import 'child_profile_controller.dart';

class ChildProfileFormView extends GetView<ChildProfileController> {
  const ChildProfileFormView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isEditing = controller.editingChild != null;

    // Local text controllers populated from controller state
    final nameTEC =
        TextEditingController(text: controller.formName);
    final weightTEC = TextEditingController(
        text: controller.formWeight > 0
            ? controller.formWeight.toStringAsFixed(1)
            : '');
    final heightTEC = TextEditingController(
        text: controller.formHeight > 0
            ? controller.formHeight.toStringAsFixed(0)
            : '');
    final notesTEC =
        TextEditingController(text: controller.formNotes);
    final dobController = TextEditingController(
        text: controller.formDob != null
            ? DateFormat('dd MMM yyyy', 'id_ID')
                .format(controller.formDob!)
            : '');

    final selectedGender =
        controller.formGender.obs;

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        title: Text(isEditing ? AppStrings.editChildProfile : AppStrings.addChildProfile),
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.onSurface,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Photo picker ────────────────────────────────────
            Center(
              child: GestureDetector(
                onTap: () async {
                  await controller.pickPhoto();
                },
                child: CircleAvatar(
                  radius: AppDimensions.avatarLg,
                  backgroundColor: AppColors.primaryContainer,
                  child: const Icon(
                    Icons.add_a_photo_rounded,
                    color: AppColors.primary,
                    size: AppDimensions.iconLg,
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppDimensions.lg),
            // ── Name ────────────────────────────────────────────
            AlleriskTextField(
              controller: nameTEC,
              label: AppStrings.childName,
              prefixIcon: Icons.person_outline,
              onChanged: (v) => controller.formName = v,
            ),
            const SizedBox(height: AppDimensions.md),
            // ── Date of Birth ────────────────────────────────────
            AlleriskTextField(
              controller: dobController,
              label: AppStrings.dateOfBirth,
              prefixIcon: Icons.cake_outlined,
              readOnly: true,
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: controller.formDob ??
                      DateTime.now()
                          .subtract(const Duration(days: 365 * 3)),
                  firstDate: DateTime(2010),
                  lastDate: DateTime.now(),
                );
                if (picked != null) {
                  controller.formDob = picked;
                  dobController.text =
                      DateFormat('dd MMM yyyy', 'id_ID').format(picked);
                }
              },
            ),
            const SizedBox(height: AppDimensions.md),
            // ── Gender ───────────────────────────────────────────
            Text(AppStrings.gender,
                style: theme.textTheme.labelLarge
                    ?.copyWith(color: AppColors.onSurfaceVariant)),
            const SizedBox(height: AppDimensions.sm),
            Obx(() => Row(
                  children: Gender.values.map((g) {
                    final selected = selectedGender.value == g;
                    return Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(
                          right: g == Gender.male
                              ? AppDimensions.sm
                              : 0,
                        ),
                        child: ChoiceChip(
                          label: Text(
                              g == Gender.male ? AppStrings.maleIcon : AppStrings.femaleIcon),
                          selected: selected,
                          onSelected: (_) {
                            selectedGender.value = g;
                            controller.formGender = g;
                          },
                          selectedColor: AppColors.primaryContainer,
                          labelStyle: TextStyle(
                            color: selected
                                ? AppColors.primary
                                : AppColors.onSurfaceVariant,
                            fontWeight: selected
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                )),
            const SizedBox(height: AppDimensions.md),
            // ── Weight & Height ──────────────────────────────────
            Row(
              children: [
                Expanded(
                  child: AlleriskTextField(
                    controller: weightTEC,
                    label: AppStrings.weight,
                    prefixIcon: Icons.monitor_weight_outlined,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    onChanged: (v) =>
                        controller.formWeight = double.tryParse(v) ?? 0,
                  ),
                ),
                const SizedBox(width: AppDimensions.md),
                Expanded(
                  child: AlleriskTextField(
                    controller: heightTEC,
                    label: AppStrings.height,
                    prefixIcon: Icons.height_rounded,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    onChanged: (v) =>
                        controller.formHeight = double.tryParse(v) ?? 0,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppDimensions.md),
            // ── Notes ────────────────────────────────────────────
            AlleriskTextField(
              controller: notesTEC,
              label: AppStrings.notes,
              prefixIcon: Icons.notes_rounded,
              maxLines: 3,
              onChanged: (v) => controller.formNotes = v,
            ),
            const SizedBox(height: AppDimensions.xl),
            // ── Save button ──────────────────────────────────────
            Obx(() => AlleriskButton(
                  text: isEditing ? AppStrings.saveChanges : AppStrings.addProfile,
                  isLoading: controller.isSaving.value,
                  onPressed: controller.saveChild,
                )),
            const SizedBox(height: AppDimensions.lg),
          ],
        ),
      ),
    );
  }
}
