import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/services/storage_service.dart';
import '../../../core/constants/app_strings.dart';

class DoctorSettingsController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();
  final StorageService _storageService = Get.find<StorageService>();

  final RxBool isDarkMode = Get.isDarkMode.obs;
  final RxBool pushNotifications = true.obs;
  final RxBool emailNotifications = true.obs;

  String get doctorName => _authService.currentUser.value?.name ?? 'Dokter';
  String get doctorEmail => _authService.currentUser.value?.email ?? '-';

  @override
  void onInit() {
    super.onInit();
    final storedDarkMode = _storageService.read<bool>(StorageKeys.isDarkMode);
    if (storedDarkMode != null) {
      isDarkMode.value = storedDarkMode;
    }
  }

  void toggleTheme(bool isDark) {
    isDarkMode.value = isDark;
    Get.changeThemeMode(isDark ? ThemeMode.dark : ThemeMode.light);
    _storageService.write(StorageKeys.isDarkMode, isDark);
  }

  void togglePushNotif(bool value) {
    pushNotifications.value = value;
  }

  void toggleEmailNotif(bool value) {
    emailNotifications.value = value;
  }

  void logout() {
    Get.dialog(
      AlertDialog(
        title: const Text(AppStrings.logout),
        content: const Text(AppStrings.logoutConfirm),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text(AppStrings.cancel),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              _authService.logout();
            },
            child: const Text(AppStrings.logout, style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
