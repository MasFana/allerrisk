import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/services/auth_service.dart';
import '../../../data/models/assessment_payload_model.dart';
import '../../../data/repositories/interfaces/i_assessment_repository.dart';
import '../shell/parent_shell_controller.dart';

/// Represents a single yes/no question in the questionnaire.
class AssessmentQuestion {
  final String key;
  final String label;
  final String? hint;

  const AssessmentQuestion({
    required this.key,
    required this.label,
    this.hint,
  });
}

/// Groups of questions matching the 4 assessment criterion categories.
class AssessmentStep {
  final String title;
  final String subtitle;
  final IconData icon;
  final List<AssessmentQuestion> questions;

  const AssessmentStep({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.questions,
  });
}

class AssessmentController extends GetxController {
  final IAssessmentRepository _repo = Get.find<IAssessmentRepository>();
  final AuthService _auth = Get.find<AuthService>();

  // ── Multi-step form state ─────────────────────────────────────
  final RxInt currentStep = 0.obs;
  final RxBool isSubmitting = false.obs;

  /// Map of questionKey → boolean answer
  final RxMap<String, bool> answers = <String, bool>{}.obs;

  // ── Steps definition ──────────────────────────────────────────

  final List<AssessmentStep> steps = [
    AssessmentStep(
      title: 'Riwayat Genetik',
      subtitle: 'Apakah ada anggota keluarga yang memiliki riwayat alergi?',
      icon: Icons.family_restroom_rounded,
      questions: [
        AssessmentQuestion(
          key: 'motherHasAtopy',
          label: 'Ibu memiliki riwayat atopi (alergi, asma, eksim)',
        ),
        AssessmentQuestion(
          key: 'fatherHasAtopy',
          label: 'Ayah memiliki riwayat atopi',
        ),
        AssessmentQuestion(
          key: 'siblingHasAtopy',
          label: 'Saudara kandung memiliki riwayat atopi',
        ),
        AssessmentQuestion(
          key: 'grandparentHasAtopy',
          label: 'Kakek/nenek memiliki riwayat atopi',
        ),
      ],
    ),
    AssessmentStep(
      title: 'Gejala Aktif',
      subtitle: 'Gejala yang sedang atau pernah dialami anak.',
      icon: Icons.monitor_heart_rounded,
      questions: [
        AssessmentQuestion(
          key: 'hasAnaphylaxis',
          label: 'Pernah mengalami anafilaksis',
          hint: 'Reaksi alergi berat dan cepat — darurat medis',
        ),
        AssessmentQuestion(
          key: 'hasUrticaria',
          label: 'Sering muncul biduran (urtikaria)',
        ),
        AssessmentQuestion(
          key: 'hasGiReaction',
          label: 'Reaksi saluran cerna (mual, muntah, diare) setelah makan',
        ),
        AssessmentQuestion(
          key: 'hasRhinitis',
          label: 'Hidung berair / bersin-bersin (rinitis alergi)',
        ),
        AssessmentQuestion(
          key: 'hasWheeze',
          label: 'Mengi (wheezing) atau sesak napas',
        ),
        AssessmentQuestion(
          key: 'hasConjunctivitis',
          label: 'Mata merah dan gatal (konjungtivitis alergi)',
        ),
      ],
    ),
    AssessmentStep(
      title: 'Riwayat Medis Anak',
      subtitle: 'Kondisi dan riwayat kesehatan anak sebelumnya.',
      icon: Icons.medical_information_rounded,
      questions: [
        AssessmentQuestion(
          key: 'hasDermatitis',
          label: 'Didiagnosis dermatitis atopik (eksim)',
        ),
        AssessmentQuestion(
          key: 'hasChronicDrySkin',
          label: 'Kulit kering kronis yang tidak membaik',
        ),
        AssessmentQuestion(
          key: 'hadHospitalization',
          label: 'Pernah dirawat di RS akibat reaksi alergi',
        ),
        AssessmentQuestion(
          key: 'hasAntihistamineHistory',
          label: 'Sering menggunakan antihistamin',
        ),
        AssessmentQuestion(
          key: 'hasRecurrentOtitis',
          label: 'Sering mengalami infeksi telinga (otitis)',
        ),
      ],
    ),
    AssessmentStep(
      title: 'Faktor Lingkungan',
      subtitle: 'Kondisi di sekitar tempat tinggal anak.',
      icon: Icons.home_rounded,
      questions: [
        AssessmentQuestion(
          key: 'smokingHousehold',
          label: 'Ada anggota keluarga yang merokok di dalam rumah',
        ),
        AssessmentQuestion(
          key: 'hasPets',
          label: 'Memelihara hewan berbulu di dalam rumah',
        ),
        AssessmentQuestion(
          key: 'highDustEnv',
          label: 'Lingkungan berdebu tinggi / sering terpapar debu',
        ),
        AssessmentQuestion(
          key: 'nearPollution',
          label: 'Tinggal dekat jalan raya padat / area industri',
        ),
        AssessmentQuestion(
          key: 'hasCarpetOrPlush',
          label: 'Ada karpet tebal atau mainan boneka berbulu di kamar anak',
        ),
      ],
    ),
  ];

  // ── Lifecycle ─────────────────────────────────────────────────

  @override
  void onInit() {
    super.onInit();
    _initAnswers();
  }

  void _initAnswers() {
    for (final step in steps) {
      for (final q in step.questions) {
        answers[q.key] = false;
      }
    }
  }

  // ── Helpers ───────────────────────────────────────────────────

  int get totalSteps => steps.length;
  bool get isFirstStep => currentStep.value == 0;
  bool get isLastStep => currentStep.value == steps.length - 1;
  AssessmentStep get currentStepData => steps[currentStep.value];
  double get progress => (currentStep.value + 1) / totalSteps;
  bool get hasActiveChild => _auth.activeChildId.value.isNotEmpty;
  bool get hasAnaphylaxisSelected => answers['hasAnaphylaxis'] ?? false;

  void setAnswer(String key, bool value) => answers[key] = value;

  void nextStep() {
    if (!hasActiveChild) {
      Get.snackbar(
        'Pilih Profil Anak',
        'Silakan pilih profil anak terlebih dahulu di Beranda.',
        snackPosition: SnackPosition.BOTTOM,
      );
      Get.find<ParentShellController>().switchTab(0);
      return;
    }
    if (!isLastStep) currentStep.value++;
  }

  void prevStep() {
    if (!isFirstStep) currentStep.value--;
  }

  /// Called by the AssessmentView back button.
  /// If on step 1, returns to the Beranda tab instead of popping.
  void goBackFromAssessment() {
    if (isFirstStep) {
      Get.find<ParentShellController>().switchTab(0);
    } else {
      prevStep();
    }
  }

  /// Resets all answers and step counter (used when re-entering the tab).
  void resetAssessment() {
    _initAnswers();
    currentStep.value = 0;
  }

  // ── Submission ────────────────────────────────────────────────

  Future<void> submit() async {
    final childId = _auth.activeChildId.value;
    if (childId.isEmpty) {
      Get.snackbar(
        'Pilih Profil Anak',
        'Silakan pilih profil anak terlebih dahulu di Beranda.',
        snackPosition: SnackPosition.BOTTOM,
      );
      Get.find<ParentShellController>().switchTab(0);
      return;
    }

    isSubmitting.value = true;
    try {
      final payload = _buildPayload(childId);
      final result = await _repo.submitAssessment(payload);
      // Store in shell and switch to Hasil tab
      Get.find<ParentShellController>().setResultAndSwitch(result);
      // Reset for next use — slight delay to allow tab transition to complete
      Future.delayed(const Duration(milliseconds: 300), resetAssessment);
    } catch (e) {
      Get.snackbar('Error', 'Gagal mengirim asesmen: $e',
          snackPosition: SnackPosition.BOTTOM);
    } finally {
      isSubmitting.value = false;
    }
  }

  AssessmentPayload _buildPayload(String childId) => AssessmentPayload(
        childId: childId,
        motherHasAtopy: answers['motherHasAtopy'] ?? false,
        fatherHasAtopy: answers['fatherHasAtopy'] ?? false,
        siblingHasAtopy: answers['siblingHasAtopy'] ?? false,
        grandparentHasAtopy: answers['grandparentHasAtopy'] ?? false,
        hasAnaphylaxis: answers['hasAnaphylaxis'] ?? false,
        hasUrticaria: answers['hasUrticaria'] ?? false,
        hasGiReaction: answers['hasGiReaction'] ?? false,
        hasRhinitis: answers['hasRhinitis'] ?? false,
        hasWheeze: answers['hasWheeze'] ?? false,
        hasConjunctivitis: answers['hasConjunctivitis'] ?? false,
        hasDermatitis: answers['hasDermatitis'] ?? false,
        hasChronicDrySkin: answers['hasChronicDrySkin'] ?? false,
        hadHospitalization: answers['hadHospitalization'] ?? false,
        hasAntihistamineHistory: answers['hasAntihistamineHistory'] ?? false,
        hasRecurrentOtitis: answers['hasRecurrentOtitis'] ?? false,
        smokingHousehold: answers['smokingHousehold'] ?? false,
        hasPets: answers['hasPets'] ?? false,
        highDustEnv: answers['highDustEnv'] ?? false,
        nearPollution: answers['nearPollution'] ?? false,
        hasCarpetOrPlush: answers['hasCarpetOrPlush'] ?? false,
      );
}
