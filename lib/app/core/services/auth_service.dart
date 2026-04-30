import 'dart:convert';
import 'package:get/get.dart';
import '../services/storage_service.dart';
import '../../data/models/user_model.dart';
import '../utils/logger.dart';
import '../../routes/app_routes.dart';

/// Persistent auth state — loaded on app start, survives restarts.
///
/// This is the single source of truth for:
///   - JWT token (mock in prototype)
///   - Current user profile
///   - User role (parent | doctor)
///   - Active child selection (parent only)
class AuthService extends GetxService {
  StorageService get _storage => Get.find<StorageService>();

  // ── Reactive State ───────────────────────────────────────────
  final Rx<UserModel?> currentUser = Rx(null);
  final RxString token = ''.obs;
  final Rx<UserRole?> role = Rx(null);
  final RxString activeChildId = ''.obs;

  // ── Computed ─────────────────────────────────────────────────
  bool get isLoggedIn => token.value.isNotEmpty;
  bool get isParent => role.value == UserRole.parent;
  bool get isDoctor => role.value == UserRole.doctor;

  // ── Lifecycle ────────────────────────────────────────────────

  Future<AuthService> init() async {
    _restoreSession();
    AppLogger.service.i('AuthService ready — loggedIn=$isLoggedIn');
    return this;
  }

  // ── Session restoration ──────────────────────────────────────

  void _restoreSession() {
    token.value = _storage.read<String>(StorageKeys.token) ?? '';
    if (!isLoggedIn) return;

    final roleStr = _storage.read<String>(StorageKeys.role);
    if (roleStr != null) {
      role.value = UserRole.values.byName(roleStr);
    }

    final userRaw = _storage.read<String>(StorageKeys.currentUser);
    if (userRaw != null) {
      try {
        currentUser.value = UserModel.fromJson(
          json.decode(userRaw) as Map<String, dynamic>,
        );
      } catch (e) {
        AppLogger.service.e('Failed to restore user', error: e);
        token.value = '';
      }
    }

    activeChildId.value =
        _storage.read<String>(StorageKeys.activeChildId) ?? '';
  }

  // ── Token validation (mock — always valid in prototype) ───────

  Future<bool> validateToken() async {
    if (!isLoggedIn) return false;
    // In prototype: token is always valid. In production: call /auth/refresh.
    AppLogger.service.d('Token validated (mock)');
    return true;
  }

  // ── Login / Logout handlers (called by MockAuthRepository) ───

  void onLoginSuccess(UserModel user, String jwt) {
    token.value = jwt;
    currentUser.value = user;
    role.value = user.role;
    AppLogger.service.i('Login: ${user.email} (${user.role.name})');
  }

  Future<void> logout() async {
    await _storage.clearSession();
    token.value = '';
    currentUser.value = null;
    role.value = null;
    activeChildId.value = '';
    AppLogger.service.i('Logged out');
    Get.offAllNamed(Routes.ROLE_SELECTOR);
  }

  // ── Active Child ──────────────────────────────────────────────

  Future<void> setActiveChild(String childId) async {
    activeChildId.value = childId;
    await _storage.write(StorageKeys.activeChildId, childId);
  }

  // ── Profile update ────────────────────────────────────────────

  void updateCurrentUser(UserModel updated) {
    currentUser.value = updated;
    _storage.write(StorageKeys.currentUser, json.encode(updated.toJson()));
  }
}
