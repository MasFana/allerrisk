import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import '../../core/services/auth_service.dart';
import '../../core/services/storage_service.dart';
import '../../core/utils/logger.dart';
import '../../routes/app_routes.dart';

/// Splash screen controller — checks session state and routes accordingly.
///
/// Navigation decision tree:
///   hasSeenOnboarding?
///     → No  → ONBOARDING
///     → Yes → isLoggedIn?
///               → No  → ROLE_SELECTOR
///               → Yes → role == 'parent' → PARENT_HOME
///                        role == 'doctor' → DOCTOR_DASHBOARD
class SplashController extends GetxController {
  StorageService get _storage => Get.find<StorageService>();
  AuthService get _auth => Get.find<AuthService>();

  @override
  void onReady() {
    super.onReady();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _init();
    });
  }

  Future<void> _init() async {
    try {
      AppLogger.service.i('Splash init started');

      // 1.5s minimum display for brand impression
      await Future.delayed(const Duration(milliseconds: 1500));
      await _auth.validateToken();

      final hasSeenOnboarding =
          _storage.read<bool>(StorageKeys.hasSeenOnboarding) ?? false;
      final targetRoute = !hasSeenOnboarding
          ? Routes.ONBOARDING
          : !_auth.isLoggedIn
          ? Routes.ROLE_SELECTOR
          : _auth.isDoctor
          ? Routes.DOCTOR_SHELL
          : Routes.PARENT_HOME;

      AppLogger.service.i(
        'Splash redirect -> $targetRoute | onboarding=$hasSeenOnboarding | '
        'loggedIn=${_auth.isLoggedIn} | doctor=${_auth.isDoctor}',
      );

      if (Get.currentRoute != targetRoute) {
        await Get.offAllNamed(targetRoute);
      }
    } catch (e, st) {
      AppLogger.service.e('Splash init failed', error: e, stackTrace: st);
      await Get.offAllNamed(Routes.ROLE_SELECTOR);
    }
  }
}
