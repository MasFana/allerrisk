import 'dart:convert';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../data/mock/mock_seed_data.dart';
import '../utils/logger.dart';

/// All GetStorage key strings — no magic strings elsewhere in the project.
abstract class StorageKeys {
  static const String token = 'token';
  static const String currentUser = 'current_user';
  static const String role = 'role';
  static const String activeChildId = 'active_child_id';
  static const String hasSeenOnboarding = 'has_seen_onboarding';
  static const String isDarkMode = 'is_dark_mode';

  // Collections stored as JSON-encoded List<Map>
  static const String users = 'users';
  static const String children = 'children';
  static const String assessments = 'assessments';
  static const String articles = 'articles';
  static const String clinicalNotes = 'clinical_notes';
  static const String notifications = 'notifications';
}

/// Local persistence service backed by GetStorage.
///
/// All collections are stored as JSON-encoded `List<Map<String, dynamic>>`.
/// On first launch, seeds mock data so the app is immediately demoable.
class StorageService extends GetxService {
  static const _boxName = 'allerisk_db';
  late final GetStorage _box;

  Future<StorageService> init() async {
    await GetStorage.init(_boxName);
    _box = GetStorage(_boxName);
    await _seedIfEmpty();
    AppLogger.service.i('StorageService ready');
    return this;
  }

  // ── Primitives ───────────────────────────────────────────────

  T? read<T>(String key) => _box.read<T>(key);
  Future<void> write(String key, dynamic value) => _box.write(key, value);
  Future<void> remove(String key) => _box.remove(key);
  bool hasData(String key) => _box.hasData(key);

  // ── Collection Helpers ───────────────────────────────────────

  /// Reads and decodes a JSON-encoded List.
  List<Map<String, dynamic>> readList(String key) {
    final raw = _box.read<String>(key);
    if (raw == null) return [];
    try {
      final decoded = json.decode(raw) as List<dynamic>;
      return decoded.cast<Map<String, dynamic>>();
    } catch (e) {
      AppLogger.service.e('readList decode error for key=$key', error: e);
      return [];
    }
  }

  /// Encodes and writes a List of maps.
  Future<void> writeList(String key, List<Map<String, dynamic>> items) =>
      _box.write(key, json.encode(items));

  /// Finds a single item in a collection by [field] == [value].
  Map<String, dynamic>? findOne(String key, String field, dynamic value) =>
      readList(key).firstWhereOrNull((e) => e[field] == value);

  /// Upserts an item by its 'id' field.
  Future<void> upsertOne(String key, Map<String, dynamic> item) async {
    final list = readList(key);
    final idx = list.indexWhere((e) => e['id'] == item['id']);
    if (idx == -1) {
      list.add(item);
    } else {
      list[idx] = item;
    }
    await writeList(key, list);
  }

  /// Removes an item from a collection by its id value.
  Future<void> deleteOne(String key, String id) async {
    final list = readList(key);
    list.removeWhere((e) => e['id'] == id);
    await writeList(key, list);
  }

  // ── Session Helpers ──────────────────────────────────────────

  bool get isLoggedIn => hasData(StorageKeys.token);
  String get activeRole => read<String>(StorageKeys.role) ?? 'parent';

  Future<void> saveSession({
    required String token,
    required Map<String, dynamic> user,
    required String role,
  }) async {
    await write(StorageKeys.token, token);
    await write(StorageKeys.currentUser, json.encode(user));
    await write(StorageKeys.role, role);
    AppLogger.service.i('Session saved: role=$role');
  }

  Future<void> clearSession() async {
    await remove(StorageKeys.token);
    await remove(StorageKeys.currentUser);
    await remove(StorageKeys.role);
    await remove(StorageKeys.activeChildId);
    AppLogger.service.i('Session cleared');
  }

  // ── Seed ─────────────────────────────────────────────────────

  Future<void> _seedIfEmpty() async {
    if (!hasData(StorageKeys.users)) {
      await writeList(StorageKeys.users, MockSeedData.users);
    }
    if (!hasData(StorageKeys.children)) {
      await writeList(StorageKeys.children, MockSeedData.children);
    }
    if (!hasData(StorageKeys.assessments)) {
      await writeList(StorageKeys.assessments, MockSeedData.assessments);
    }
    if (!hasData(StorageKeys.articles)) {
      await writeList(StorageKeys.articles, MockSeedData.articles);
    }
    if (!hasData(StorageKeys.clinicalNotes)) {
      await writeList(StorageKeys.clinicalNotes, MockSeedData.clinicalNotes);
    }
    if (!hasData(StorageKeys.notifications)) {
      await writeList(StorageKeys.notifications, MockSeedData.notifications);
    }
    AppLogger.service.d('Seed data verified');
  }

  /// ⚠️ Dev-only: wipe everything and re-seed. Accessible via 5-tap on version.
  Future<void> resetToSeedData() async {
    await _box.erase();
    await _seedIfEmpty();
    AppLogger.service.w('Data reset to seed');
  }
}
