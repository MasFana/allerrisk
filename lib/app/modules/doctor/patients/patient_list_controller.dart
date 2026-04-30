import 'package:get/get.dart';
import '../../../data/repositories/interfaces/i_patient_repository.dart';
import '../../../data/models/patient_model.dart';
import '../../../data/models/assessment_result_model.dart';
import '../../../core/services/auth_service.dart';

class PatientListController extends GetxController {
  final IPatientRepository _patientRepository = Get.find<IPatientRepository>();
  final AuthService _authService = Get.find<AuthService>();

  final RxList<Patient> _allPatients = <Patient>[].obs;
  final RxList<Patient> patients = <Patient>[].obs;
  
  final RxString searchQuery = ''.obs;
  final RxString filterRisk = 'all'.obs; // 'all' | 'low' | 'medium' | 'high'
  final RxString sortBy = 'recent'.obs; // 'recent' | 'score_high' | 'score_low' | 'name'
  final RxBool isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    
    // Setup debounced search and reactive filtering
    debounce(searchQuery, (_) => _applyFilters(), time: const Duration(milliseconds: 300));
    ever(filterRisk, (_) => _applyFilters());
    ever(sortBy, (_) => _applyFilters());

    loadPatients();
  }

  Future<void> loadPatients() async {
    isLoading.value = true;
    try {
      final doctorId = _authService.currentUser.value?.id ?? '';
      final results = await _patientRepository.getPatientsForDoctor(doctorId);
      _allPatients.value = results;
      _applyFilters();
    } catch (e) {
      Get.snackbar('Error', 'Gagal memuat daftar pasien: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void searchPatients(String query) {
    searchQuery.value = query;
  }

  void applyFilter(String risk) {
    filterRisk.value = risk;
  }

  void applySort(String sortOption) {
    sortBy.value = sortOption;
  }

  void _applyFilters() {
    List<Patient> filtered = List.from(_allPatients);

    // Apply search
    final query = searchQuery.value.trim().toLowerCase();
    if (query.isNotEmpty) {
      filtered = filtered.where((p) {
        final childName = p.child.name.toLowerCase();
        final parentName = p.parent.name.toLowerCase();
        return childName.contains(query) || parentName.contains(query);
      }).toList();
    }

    // Apply filter by risk
    if (filterRisk.value != 'all') {
      filtered = filtered.where((p) {
        if (p.latestAssessment == null) return false;
        switch (filterRisk.value) {
          case 'low':
            return p.latestAssessment!.level == RiskLevel.low;
          case 'medium':
            return p.latestAssessment!.level == RiskLevel.medium;
          case 'high':
            return p.latestAssessment!.level == RiskLevel.high;
          default:
            return true;
        }
      }).toList();
    }

    // Apply sort
    filtered.sort((a, b) {
      switch (sortBy.value) {
        case 'recent':
          final dateA = a.latestAssessment?.assessedAt ?? DateTime(1970);
          final dateB = b.latestAssessment?.assessedAt ?? DateTime(1970);
          return dateB.compareTo(dateA); // Newest first
        case 'score_high':
          final scoreA = a.latestAssessment?.score ?? 0.0;
          final scoreB = b.latestAssessment?.score ?? 0.0;
          return scoreB.compareTo(scoreA); // Highest score first
        case 'score_low':
          final scoreA = a.latestAssessment?.score ?? double.infinity;
          final scoreB = b.latestAssessment?.score ?? double.infinity;
          return scoreA.compareTo(scoreB); // Lowest score first
        case 'name':
          return a.child.name.compareTo(b.child.name); // A-Z
        default:
          return 0;
      }
    });

    patients.value = filtered;
  }
}
