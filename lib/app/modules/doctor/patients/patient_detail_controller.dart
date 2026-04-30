import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/repositories/interfaces/i_patient_repository.dart';
import '../../../data/models/patient_model.dart';
import '../../../data/models/assessment_result_model.dart';
import '../../../data/models/clinical_note_model.dart';
import '../../../data/models/article_model.dart';
import '../../../data/repositories/interfaces/i_article_repository.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/services/pdf_service.dart';
import '../../../core/services/notification_service.dart';
import '../../../core/constants/app_strings.dart';

class PatientDetailController extends GetxController {
  final IPatientRepository _patientRepository = Get.find<IPatientRepository>();
  final IArticleRepository _articleRepository = Get.find<IArticleRepository>();
  final AuthService _authService = Get.find<AuthService>();
  final PdfService _pdfService = Get.find<PdfService>();
  final NotificationService _notificationService = Get.find<NotificationService>();

  late final Rx<Patient> patient;
  final RxList<AssessmentResult> assessmentHistory = <AssessmentResult>[].obs;
  final Rx<AssessmentResult?> selectedResult = Rx<AssessmentResult?>(null);
  final RxList<ClinicalNote> clinicalNotes = <ClinicalNote>[].obs;
  
  final RxBool isLoading = true.obs;
  final RxBool isAddingNote = false.obs;
  final RxBool isExporting = false.obs;

  final TextEditingController noteController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args is Patient) {
      patient = Rx<Patient>(args);
      assessmentHistory.value = patient.value.pastAssessments;
      if (assessmentHistory.isNotEmpty) {
        selectedResult.value = assessmentHistory.first;
      }
      loadNotes();
    } else {
      Get.back();
      Get.snackbar('Error', 'Data pasien tidak valid');
    }
  }

  Future<void> loadNotes() async {
    isLoading.value = true;
    try {
      final notes = await _patientRepository.getNotesForPatient(patient.value.child.id);
      clinicalNotes.value = notes;
    } catch (e) {
      Get.snackbar('Error', 'Gagal memuat catatan klinis');
    } finally {
      isLoading.value = false;
    }
  }

  void selectAssessment(AssessmentResult result) {
    selectedResult.value = result;
  }

  Future<void> addClinicalNote() async {
    final note = noteController.text.trim();
    if (note.isEmpty) return;

    isAddingNote.value = true;
    try {
      final doctorId = _authService.currentUser.value?.id ?? '';
      final doctorName = _authService.currentUser.value?.name ?? 'Dokter';
      
      final newNote = await _patientRepository.addClinicalNote(
        doctorId: doctorId,
        doctorName: doctorName,
        childId: patient.value.child.id,
        assessmentId: selectedResult.value?.id,
        note: note,
      );
      
      clinicalNotes.insert(0, newNote);
      noteController.clear();
      Get.snackbar('Sukses', 'Catatan klinis berhasil ditambahkan');
    } catch (e) {
      Get.snackbar('Error', 'Gagal menambahkan catatan');
    } finally {
      isAddingNote.value = false;
    }
  }

  Future<void> exportPatientReport() async {
    isExporting.value = true;
    try {
      await _pdfService.generatePatientReport(patient.value, clinicalNotes);
    } catch (e) {
      Get.snackbar('Error', 'Gagal membuat laporan PDF');
    } finally {
      isExporting.value = false;
    }
  }

  Future<void> showArticlePicker() async {
    final doctorId = _authService.currentUser.value?.id ?? '';
    if (doctorId.isEmpty) return;

    Get.dialog(
      const Center(child: CircularProgressIndicator()),
      barrierDismissible: false,
    );

    try {
      final articles = await _articleRepository.getArticlesByAuthor(doctorId);
      Get.back(); // close loading

      if (articles.isEmpty) {
        Get.snackbar('Info', 'Anda belum memiliki artikel untuk direkomendasikan.');
        return;
      }

      await Get.bottomSheet(
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(Get.context!).colorScheme.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(AppStrings.selectArticle, style: Theme.of(Get.context!).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: articles.length,
                  itemBuilder: (context, index) {
                    final article = articles[index];
                    return ListTile(
                      leading: const Icon(Icons.article),
                      title: Text(article.title),
                      subtitle: Text(article.category.label),
                      onTap: () {
                        Get.back(); // close bottom sheet
                        recommendArticle(article.id);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      );
    } catch (e) {
      Get.back(); // close loading
      Get.snackbar('Error', 'Gagal memuat daftar artikel');
    }
  }

  void recommendArticle(String articleId) {
    _notificationService.showInAppNotification(
      title: 'Artikel Direkomendasikan',
      body: 'Dr. ${_authService.currentUser.value?.name ?? 'Dokter'} merekomendasikan artikel untuk Anda baca.',
      payload: '/parent/articles/detail?id=$articleId',
    );
    Get.snackbar('Sukses', 'Artikel berhasil direkomendasikan ke orang tua');
  }

  @override
  void onClose() {
    noteController.dispose();
    super.onClose();
  }
}
