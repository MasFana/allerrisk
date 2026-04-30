import 'package:get/get.dart';
import 'doctor_shell_controller.dart';
import '../dashboard/dashboard_controller.dart';
import '../patients/patient_list_controller.dart';
import '../article/article_list_controller.dart' as doctor_articles;
import '../settings/settings_controller.dart' as doctor_settings;

class DoctorShellBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DoctorShellController>(() => DoctorShellController());
    
    // Lazy initialize tab controllers
    Get.lazyPut<DashboardController>(() => DashboardController());
    Get.lazyPut<PatientListController>(() => PatientListController());
    Get.lazyPut<doctor_articles.DoctorArticleListController>(() => doctor_articles.DoctorArticleListController());
    Get.lazyPut<doctor_settings.DoctorSettingsController>(() => doctor_settings.DoctorSettingsController());
  }
}
