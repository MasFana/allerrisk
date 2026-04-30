import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/services/storage_service.dart';

class SettingsController extends GetxController {
  final AuthService _auth = Get.find<AuthService>();
  final StorageService _storage = Get.find<StorageService>();

  final RxBool isDarkMode = false.obs;

  @override
  void onInit() {
    super.onInit();
    isDarkMode.value = _storage.read<bool>(StorageKeys.isDarkMode) ?? false;
  }

  String get userName => _auth.currentUser.value?.name ?? 'Pengguna';
  String get userEmail => _auth.currentUser.value?.email ?? '';

  void toggleTheme(bool value) {
    isDarkMode.value = value;
    _storage.write(StorageKeys.isDarkMode, value);
    Get.changeThemeMode(value ? ThemeMode.dark : ThemeMode.light);
  }

  Future<void> logout() async {
    await _auth.logout();
  }
}
