import 'package:get/get.dart';
import '../../../data/repositories/interfaces/i_patient_repository.dart';
import '../../../data/repositories/interfaces/i_article_repository.dart';
import '../../../data/models/patient_model.dart';
import '../../../data/models/article_model.dart';
import '../../../data/models/assessment_result_model.dart';
import '../../../core/services/auth_service.dart';

class DashboardController extends GetxController {
  final IPatientRepository _patientRepository = Get.find<IPatientRepository>();
  final IArticleRepository _articleRepository = Get.find<IArticleRepository>();
  final AuthService _authService = Get.find<AuthService>();

  final RxBool isLoading = true.obs;
  final RxInt totalPatients = 0.obs;
  final RxInt newPatientsThisWeek = 0.obs;
  final RxList<Patient> recentHighRiskPatients = <Patient>[].obs;
  final RxList<Article> myArticles = <Article>[].obs;
  
  // { 'low': 12, 'medium': 8, 'high': 5 }
  final RxMap<String, int> riskDistribution = <String, int>{
    'low': 0,
    'medium': 0,
    'high': 0,
  }.obs;

  String get doctorName => _authService.currentUser.value?.name ?? 'Dokter';

  @override
  void onInit() {
    super.onInit();
    loadDashboard();
  }

  Future<void> loadDashboard() async {
    isLoading.value = true;
    try {
      final doctorId = _authService.currentUser.value?.id ?? '';
      
      // Load patients and articles in parallel
      final results = await Future.wait([
        _patientRepository.getPatientsForDoctor(doctorId),
        _articleRepository.getArticlesByAuthor(doctorId),
      ]);

      final allPatients = results[0] as List<Patient>;
      final articles = results[1] as List<Article>;

      totalPatients.value = allPatients.length;

      // Calculate new patients this week (patients whose latest assessment is within 7 days)
      final now = DateTime.now();
      newPatientsThisWeek.value = allPatients.where((p) {
        if (p.latestAssessment == null) return false;
        return now.difference(p.latestAssessment!.assessedAt).inDays <= 7;
      }).length;

      // Filter high risk patients (top 5 recent)
      final highRisk = allPatients.where((p) => p.latestAssessment?.level == RiskLevel.high).toList();
      highRisk.sort((a, b) => (b.latestAssessment?.assessedAt ?? DateTime(1970))
          .compareTo(a.latestAssessment?.assessedAt ?? DateTime(1970)));
      recentHighRiskPatients.value = highRisk.take(5).toList();

      // Calculate risk distribution
      int low = 0, med = 0, high = 0;
      for (final p in allPatients) {
        switch (p.latestAssessment?.level) {
          case RiskLevel.low:
            low++;
            break;
          case RiskLevel.medium:
            med++;
            break;
          case RiskLevel.high:
            high++;
            break;
          default:
            break;
        }
      }
      riskDistribution.value = {
        'low': low,
        'medium': med,
        'high': high,
      };

      // Set articles (take top 2 recent)
      articles.sort((a, b) => (b.publishedAt ?? b.createdAt).compareTo(a.publishedAt ?? a.createdAt));
      myArticles.value = articles.take(2).toList();
      
    } catch (e) {
      Get.snackbar('Error', 'Gagal memuat data dashboard: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
