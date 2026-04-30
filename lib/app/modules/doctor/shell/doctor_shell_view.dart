import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/doctor_nav_bar.dart';
import '../dashboard/dashboard_view.dart';
import '../patients/patient_list_view.dart';
import '../article/article_list_view.dart' as doctor_articles;
import '../settings/settings_view.dart' as doctor_settings;
import 'doctor_shell_controller.dart';

class DoctorShellView extends GetView<DoctorShellController> {
  const DoctorShellView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: Obx(
        () => IndexedStack(
          index: controller.currentIndex.value,
          children: const [
            DashboardView(),
            PatientListView(),
            doctor_articles.DoctorArticleListView(),
            doctor_settings.DoctorSettingsView(),
          ],
        ),
      ),
      bottomNavigationBar: Obx(
        () => DoctorNavBar(
          currentIndex: controller.currentIndex.value,
        ),
      ),
    );
  }
}
