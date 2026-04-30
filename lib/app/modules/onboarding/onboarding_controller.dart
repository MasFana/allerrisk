import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/constants/app_strings.dart';
import '../../core/services/storage_service.dart';
import '../../routes/app_routes.dart';

class OnboardingController extends GetxController {
  final StorageService _storage = Get.find<StorageService>();
  final PageController pageController = PageController();
  final RxInt currentIndex = 0.obs;

  final List<Map<String, String>> slides = [
    {
      'title': AppStrings.onboardingTitle1,
      'description': AppStrings.onboardingDesc1,
      'icon': 'health_and_safety_rounded',
    },
    {
      'title': AppStrings.onboardingTitle2,
      'description': AppStrings.onboardingDesc2,
      'icon': 'analytics_rounded',
    },
    {
      'title': AppStrings.onboardingTitle3,
      'description': AppStrings.onboardingDesc3,
      'icon': 'connect_without_contact_rounded',
    },
  ];

  void onPageChanged(int index) {
    currentIndex.value = index;
  }

  void completeOnboarding() async {
    await _storage.write(StorageKeys.hasSeenOnboarding, true);
    Get.offAllNamed(Routes.ROLE_SELECTOR);
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}
