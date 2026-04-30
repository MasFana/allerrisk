# AllerRisk — Prototype Implementation Plan
## Mock Data + Local Persistence (No API, GetX + GetStorage)

**Scope:** Full MVP prototype. Zero network calls. Swap-ready for real API.

---

## 1. Architecture Strategy

The prototype uses a **Repository Pattern** where each repository has two implementations:
- `MockXRepository` — used now, fake data + simulated latency
- `RemoteXRepository` — wired in later, same interface

Controllers **only talk to the repository interface**, so switching to real API is a one-line change in the binding.

```
Controller → IAssessmentRepository (abstract)
                ├── MockAssessmentRepository   ← prototype uses this
                └── RemoteAssessmentRepository ← Phase 2
```

**Persistence strategy:** All write operations (`saveAssessment`, `saveChild`, etc.) go through `StorageService` which wraps `GetStorage`. On first launch, `StorageService` seeds mock data if the store is empty.

---

## 2. Complete File Plan

```
lib/
├── app/
│   ├── core/
│   │   └── services/
│   │       └── storage_service.dart       ← GetStorage wrapper + seed logic
│   │
│   ├── data/
│   │   ├── models/
│   │   │   ├── user_model.dart
│   │   │   ├── child_profile_model.dart
│   │   │   ├── assessment_payload_model.dart
│   │   │   ├── assessment_result_model.dart
│   │   │   ├── article_model.dart
│   │   │   ├── patient_model.dart
│   │   │   ├── clinical_note_model.dart
│   │   │   └── notification_model.dart
│   │   │
│   │   ├── mock/
│   │   │   ├── mock_seed_data.dart        ← ALL static fake data lives here
│   │   │   └── mock_saw_engine.dart       ← SAW algorithm (pure Dart, no API)
│   │   │
│   │   └── repositories/
│   │       ├── interfaces/
│   │       │   ├── i_auth_repository.dart
│   │       │   ├── i_assessment_repository.dart
│   │       │   ├── i_article_repository.dart
│   │       │   ├── i_child_repository.dart
│   │       │   └── i_patient_repository.dart
│   │       └── mock/
│   │           ├── mock_auth_repository.dart
│   │           ├── mock_assessment_repository.dart
│   │           ├── mock_article_repository.dart
│   │           ├── mock_child_repository.dart
│   │           └── mock_patient_repository.dart
```

---

## 3. StorageService

```dart
// lib/app/core/services/storage_service.dart

import 'dart:convert';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../data/mock/mock_seed_data.dart';

/// All GetStorage keys in one place — avoids magic strings everywhere.
abstract class StorageKeys {
  static const String token         = 'token';
  static const String currentUser   = 'current_user';
  static const String role          = 'role';
  static const String activeChildId = 'active_child_id';
  static const String hasSeenOnboarding = 'has_seen_onboarding';
  static const String isDarkMode    = 'is_dark_mode';

  // Collections (stored as JSON-encoded List)
  static const String users         = 'users';
  static const String children      = 'children';
  static const String assessments   = 'assessments';
  static const String articles      = 'articles';
  static const String clinicalNotes = 'clinical_notes';
  static const String notifications = 'notifications';
}

class StorageService extends GetxService {
  late final GetStorage _box;

  Future<StorageService> init() async {
    await GetStorage.init('allerisk_db');
    _box = GetStorage('allerisk_db');
    await _seedIfEmpty();
    return this;
  }

  // ─── Primitives ──────────────────────────────────────────────

  T? read<T>(String key) => _box.read<T>(key);
  Future<void> write(String key, dynamic value) => _box.write(key, value);
  Future<void> remove(String key) => _box.remove(key);
  bool hasData(String key) => _box.hasData(key);

  // ─── Collection helpers ──────────────────────────────────────

  /// Reads a JSON-encoded list and returns decoded maps.
  List<Map<String, dynamic>> readList(String key) {
    final raw = _box.read<String>(key);
    if (raw == null) return [];
    final decoded = json.decode(raw) as List<dynamic>;
    return decoded.cast<Map<String, dynamic>>();
  }

  /// Writes a list of maps as a JSON-encoded string.
  Future<void> writeList(String key, List<Map<String, dynamic>> items) {
    return _box.write(key, json.encode(items));
  }

  /// Finds a single item in a collection by field value.
  Map<String, dynamic>? findOne(String key, String field, dynamic value) {
    return readList(key).firstWhereOrNull((e) => e[field] == value);
  }

  /// Upserts (insert or update by id) an item in a collection.
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

  /// Removes an item from a collection by id.
  Future<void> deleteOne(String key, String id) async {
    final list = readList(key);
    list.removeWhere((e) => e['id'] == id);
    await writeList(key, list);
  }

  // ─── Session helpers ─────────────────────────────────────────

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
  }

  Future<void> clearSession() async {
    await remove(StorageKeys.token);
    await remove(StorageKeys.currentUser);
    await remove(StorageKeys.role);
    await remove(StorageKeys.activeChildId);
  }

  // ─── Seed ────────────────────────────────────────────────────

  /// Seeds mock data only on first launch (collections don't exist yet).
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
  }

  /// ⚠️ Dev-only: wipe and re-seed all data.
  Future<void> resetToSeedData() async {
    await _box.erase();
    await _seedIfEmpty();
  }
}
```

---

## 4. Complete Data Models

```dart
// lib/app/data/models/user_model.dart

enum UserRole { parent, doctor }

class UserModel {
  final String id;
  final String name;
  final String email;
  final String password; // plaintext for prototype — hash in production
  final UserRole role;
  final String? avatarUrl;
  final bool isVerified;
  final String? strNumber;    // Doctor only
  final String? specialty;    // Doctor only
  final String? clinicName;   // Doctor only
  final DateTime createdAt;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.role,
    this.avatarUrl,
    this.isVerified = true,
    this.strNumber,
    this.specialty,
    this.clinicName,
    required this.createdAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json['id'],
        name: json['name'],
        email: json['email'],
        password: json['password'],
        role: UserRole.values.byName(json['role']),
        avatarUrl: json['avatar_url'],
        isVerified: json['is_verified'] ?? true,
        strNumber: json['str_number'],
        specialty: json['specialty'],
        clinicName: json['clinic_name'],
        createdAt: DateTime.parse(json['created_at']),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'password': password,
        'role': role.name,
        'avatar_url': avatarUrl,
        'is_verified': isVerified,
        'str_number': strNumber,
        'specialty': specialty,
        'clinic_name': clinicName,
        'created_at': createdAt.toIso8601String(),
      };

  UserModel copyWith({
    String? name,
    String? avatarUrl,
    String? clinicName,
  }) =>
      UserModel(
        id: id,
        name: name ?? this.name,
        email: email,
        password: password,
        role: role,
        avatarUrl: avatarUrl ?? this.avatarUrl,
        isVerified: isVerified,
        strNumber: strNumber,
        specialty: specialty,
        clinicName: clinicName ?? this.clinicName,
        createdAt: createdAt,
      );
}
```

```dart
// lib/app/data/models/child_profile_model.dart

enum Gender { male, female }

class ChildProfile {
  final String id;
  final String parentId;
  final String name;
  final DateTime dateOfBirth;
  final Gender gender;
  final double? weightKg;
  final double? heightCm;
  final String? photoUrl;
  final String? notes;
  final DateTime createdAt;

  const ChildProfile({
    required this.id,
    required this.parentId,
    required this.name,
    required this.dateOfBirth,
    required this.gender,
    this.weightKg,
    this.heightCm,
    this.photoUrl,
    this.notes,
    required this.createdAt,
  });

  // ─── Computed ────────────────────────────────────────────────

  int get ageInMonths {
    final now = DateTime.now();
    return (now.year - dateOfBirth.year) * 12 +
        (now.month - dateOfBirth.month);
  }

  String get ageDisplay {
    final months = ageInMonths;
    if (months < 12) return '$months bulan';
    final years = months ~/ 12;
    final rem = months % 12;
    return rem == 0 ? '$years tahun' : '$years tahun $rem bulan';
  }

  factory ChildProfile.fromJson(Map<String, dynamic> json) => ChildProfile(
        id: json['id'],
        parentId: json['parent_id'],
        name: json['name'],
        dateOfBirth: DateTime.parse(json['date_of_birth']),
        gender: Gender.values.byName(json['gender']),
        weightKg: (json['weight_kg'] as num?)?.toDouble(),
        heightCm: (json['height_cm'] as num?)?.toDouble(),
        photoUrl: json['photo_url'],
        notes: json['notes'],
        createdAt: DateTime.parse(json['created_at']),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'parent_id': parentId,
        'name': name,
        'date_of_birth': dateOfBirth.toIso8601String(),
        'gender': gender.name,
        'weight_kg': weightKg,
        'height_cm': heightCm,
        'photo_url': photoUrl,
        'notes': notes,
        'created_at': createdAt.toIso8601String(),
      };

  ChildProfile copyWith({
    String? name,
    DateTime? dateOfBirth,
    Gender? gender,
    double? weightKg,
    double? heightCm,
    String? photoUrl,
    String? notes,
  }) =>
      ChildProfile(
        id: id,
        parentId: parentId,
        name: name ?? this.name,
        dateOfBirth: dateOfBirth ?? this.dateOfBirth,
        gender: gender ?? this.gender,
        weightKg: weightKg ?? this.weightKg,
        heightCm: heightCm ?? this.heightCm,
        photoUrl: photoUrl ?? this.photoUrl,
        notes: notes ?? this.notes,
        createdAt: createdAt,
      );
}
```

```dart
// lib/app/data/models/assessment_payload_model.dart

/// The form data submitted by the parent before scoring.
class AssessmentPayload {
  final String childId;

  // Step 1 — Genetic / Family History (weight: 0.3, max raw: 4 points → normalized to 3.0)
  final bool motherHasAtopy;
  final bool fatherHasAtopy;
  final bool siblingHasAtopy;
  final bool grandparentHasAtopy;

  // Step 2 — Active Symptoms (weight: 0.4, max raw: 6 points → normalized to 4.0)
  final bool hasAnaphylaxis;       // Override trigger: forces score = 10
  final bool hasUrticaria;
  final bool hasGIReaction;
  final bool hasRhinitis;
  final bool hasWheeze;
  final bool hasConjunctivitis;

  // Step 3 — Disease History (weight: 0.2, max raw: 5 points → normalized to 2.0)
  final bool hasDermatitis;
  final bool hasChronicDrySkin;
  final bool hadHospitalization;
  final bool hasAntihistamineHistory;
  final bool hasRecurrentOtitis;

  // Step 4 — Environment (weight: 0.1, max raw: 5 points → normalized to 1.0)
  final bool smokingHousehold;
  final bool hasPets;
  final bool highDustEnv;
  final bool nearPollution;
  final bool hasCarpetOrPlush;

  const AssessmentPayload({
    required this.childId,
    this.motherHasAtopy = false,
    this.fatherHasAtopy = false,
    this.siblingHasAtopy = false,
    this.grandparentHasAtopy = false,
    this.hasAnaphylaxis = false,
    this.hasUrticaria = false,
    this.hasGIReaction = false,
    this.hasRhinitis = false,
    this.hasWheeze = false,
    this.hasConjunctivitis = false,
    this.hasDermatitis = false,
    this.hasChronicDrySkin = false,
    this.hadHospitalization = false,
    this.hasAntihistamineHistory = false,
    this.hasRecurrentOtitis = false,
    this.smokingHousehold = false,
    this.hasPets = false,
    this.highDustEnv = false,
    this.nearPollution = false,
    this.hasCarpetOrPlush = false,
  });

  Map<String, dynamic> toJson() => {
        'child_id': childId,
        'mother_has_atopy': motherHasAtopy,
        'father_has_atopy': fatherHasAtopy,
        'sibling_has_atopy': siblingHasAtopy,
        'grandparent_has_atopy': grandparentHasAtopy,
        'has_anaphylaxis': hasAnaphylaxis,
        'has_urticaria': hasUrticaria,
        'has_gi_reaction': hasGIReaction,
        'has_rhinitis': hasRhinitis,
        'has_wheeze': hasWheeze,
        'has_conjunctivitis': hasConjunctivitis,
        'has_dermatitis': hasDermatitis,
        'has_chronic_dry_skin': hasChronicDrySkin,
        'had_hospitalization': hadHospitalization,
        'has_antihistamine_history': hasAntihistamineHistory,
        'has_recurrent_otitis': hasRecurrentOtitis,
        'smoking_household': smokingHousehold,
        'has_pets': hasPets,
        'high_dust_env': highDustEnv,
        'near_pollution': nearPollution,
        'has_carpet_or_plush': hasCarpetOrPlush,
      };
}
```

```dart
// lib/app/data/models/assessment_result_model.dart

enum RiskLevel { low, medium, high }

extension RiskLevelDisplay on RiskLevel {
  String get label {
    switch (this) {
      case RiskLevel.low:    return 'Risiko Rendah';
      case RiskLevel.medium: return 'Risiko Sedang';
      case RiskLevel.high:   return 'Risiko Tinggi';
    }
  }
}

class CriterionBreakdown {
  final double geneticScore;      // max 3.0
  final double symptomsScore;     // max 4.0
  final double historyScore;      // max 2.0
  final double environmentScore;  // max 1.0

  const CriterionBreakdown({
    required this.geneticScore,
    required this.symptomsScore,
    required this.historyScore,
    required this.environmentScore,
  });

  double get total =>
      geneticScore + symptomsScore + historyScore + environmentScore;

  factory CriterionBreakdown.fromJson(Map<String, dynamic> json) =>
      CriterionBreakdown(
        geneticScore: (json['genetic_score'] as num).toDouble(),
        symptomsScore: (json['symptoms_score'] as num).toDouble(),
        historyScore: (json['history_score'] as num).toDouble(),
        environmentScore: (json['environment_score'] as num).toDouble(),
      );

  Map<String, dynamic> toJson() => {
        'genetic_score': geneticScore,
        'symptoms_score': symptomsScore,
        'history_score': historyScore,
        'environment_score': environmentScore,
      };
}

class AssessmentResult {
  final String id;
  final String childId;
  final String parentId;
  final double score;
  final RiskLevel level;
  final bool anaphylaxisOverride;
  final CriterionBreakdown breakdown;
  final AssessmentPayload payload;    // stored for doctor's raw-answers view
  final List<String> recommendations;
  final DateTime assessedAt;

  const AssessmentResult({
    required this.id,
    required this.childId,
    required this.parentId,
    required this.score,
    required this.level,
    required this.anaphylaxisOverride,
    required this.breakdown,
    required this.payload,
    required this.recommendations,
    required this.assessedAt,
  });

  factory AssessmentResult.fromJson(Map<String, dynamic> json) =>
      AssessmentResult(
        id: json['id'],
        childId: json['child_id'],
        parentId: json['parent_id'],
        score: (json['score'] as num).toDouble(),
        level: RiskLevel.values.byName(json['level']),
        anaphylaxisOverride: json['anaphylaxis_override'] ?? false,
        breakdown: CriterionBreakdown.fromJson(json['breakdown']),
        payload: AssessmentPayload.fromJson(json['payload']),
        recommendations: List<String>.from(json['recommendations']),
        assessedAt: DateTime.parse(json['assessed_at']),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'child_id': childId,
        'parent_id': parentId,
        'score': score,
        'level': level.name,
        'anaphylaxis_override': anaphylaxisOverride,
        'breakdown': breakdown.toJson(),
        'payload': payload.toJson(),
        'recommendations': recommendations,
        'assessed_at': assessedAt.toIso8601String(),
      };
}
```

```dart
// lib/app/data/models/article_model.dart

enum ArticleStatus { draft, published }
enum ArticleCategory {
  foodAllergy,
  asthma,
  eczema,
  environment,
  parentingTips,
  general,
}

extension ArticleCategoryDisplay on ArticleCategory {
  String get label {
    const labels = {
      ArticleCategory.foodAllergy:   'Alergi Makanan',
      ArticleCategory.asthma:        'Asma',
      ArticleCategory.eczema:        'Eksim',
      ArticleCategory.environment:   'Lingkungan',
      ArticleCategory.parentingTips: 'Tips Orang Tua',
      ArticleCategory.general:       'Umum',
    };
    return labels[this]!;
  }
}

class Article {
  final String id;
  final String authorId;
  final String authorName;
  final String authorSpecialty;
  final String? authorAvatarUrl;
  final String title;
  final ArticleCategory category;
  final List<String> tags;
  final String coverImageUrl;
  final String body;              // HTML string
  final ArticleStatus status;
  final int readTimeMinutes;
  final DateTime createdAt;
  final DateTime? publishedAt;

  const Article({
    required this.id,
    required this.authorId,
    required this.authorName,
    required this.authorSpecialty,
    this.authorAvatarUrl,
    required this.title,
    required this.category,
    required this.tags,
    required this.coverImageUrl,
    required this.body,
    required this.status,
    required this.readTimeMinutes,
    required this.createdAt,
    this.publishedAt,
  });

  factory Article.fromJson(Map<String, dynamic> json) => Article(
        id: json['id'],
        authorId: json['author_id'],
        authorName: json['author_name'],
        authorSpecialty: json['author_specialty'],
        authorAvatarUrl: json['author_avatar_url'],
        title: json['title'],
        category: ArticleCategory.values.byName(json['category']),
        tags: List<String>.from(json['tags']),
        coverImageUrl: json['cover_image_url'],
        body: json['body'],
        status: ArticleStatus.values.byName(json['status']),
        readTimeMinutes: json['read_time_minutes'],
        createdAt: DateTime.parse(json['created_at']),
        publishedAt: json['published_at'] != null
            ? DateTime.parse(json['published_at'])
            : null,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'author_id': authorId,
        'author_name': authorName,
        'author_specialty': authorSpecialty,
        'author_avatar_url': authorAvatarUrl,
        'title': title,
        'category': category.name,
        'tags': tags,
        'cover_image_url': coverImageUrl,
        'body': body,
        'status': status.name,
        'read_time_minutes': readTimeMinutes,
        'created_at': createdAt.toIso8601String(),
        'published_at': publishedAt?.toIso8601String(),
      };

  Article copyWith({
    String? title,
    ArticleCategory? category,
    List<String>? tags,
    String? coverImageUrl,
    String? body,
    ArticleStatus? status,
    int? readTimeMinutes,
    DateTime? publishedAt,
  }) =>
      Article(
        id: id,
        authorId: authorId,
        authorName: authorName,
        authorSpecialty: authorSpecialty,
        authorAvatarUrl: authorAvatarUrl,
        title: title ?? this.title,
        category: category ?? this.category,
        tags: tags ?? this.tags,
        coverImageUrl: coverImageUrl ?? this.coverImageUrl,
        body: body ?? this.body,
        status: status ?? this.status,
        readTimeMinutes: readTimeMinutes ?? this.readTimeMinutes,
        createdAt: createdAt,
        publishedAt: publishedAt ?? this.publishedAt,
      );
}
```

```dart
// lib/app/data/models/clinical_note_model.dart

class ClinicalNote {
  final String id;
  final String doctorId;
  final String doctorName;
  final String patientChildId;
  final String assessmentId;
  final String note;
  final DateTime createdAt;

  const ClinicalNote({
    required this.id,
    required this.doctorId,
    required this.doctorName,
    required this.patientChildId,
    required this.assessmentId,
    required this.note,
    required this.createdAt,
  });

  factory ClinicalNote.fromJson(Map<String, dynamic> json) => ClinicalNote(
        id: json['id'],
        doctorId: json['doctor_id'],
        doctorName: json['doctor_name'],
        patientChildId: json['patient_child_id'],
        assessmentId: json['assessment_id'],
        note: json['note'],
        createdAt: DateTime.parse(json['created_at']),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'doctor_id': doctorId,
        'doctor_name': doctorName,
        'patient_child_id': patientChildId,
        'assessment_id': assessmentId,
        'note': note,
        'created_at': createdAt.toIso8601String(),
      };
}
```

```dart
// lib/app/data/models/notification_model.dart

enum NotificationType {
  assessmentReminder,
  highRiskAlert,
  newArticle,
  doctorNote,
  systemAnnouncement,
}

class AppNotification {
  final String id;
  final String userId;
  final String title;
  final String body;
  final NotificationType type;
  final String? deepLinkRoute;
  final Map<String, String>? routeArgs;
  bool isRead;
  final DateTime createdAt;

  AppNotification({
    required this.id,
    required this.userId,
    required this.title,
    required this.body,
    required this.type,
    this.deepLinkRoute,
    this.routeArgs,
    required this.isRead,
    required this.createdAt,
  });

  factory AppNotification.fromJson(Map<String, dynamic> json) =>
      AppNotification(
        id: json['id'],
        userId: json['user_id'],
        title: json['title'],
        body: json['body'],
        type: NotificationType.values.byName(json['type']),
        deepLinkRoute: json['deep_link_route'],
        routeArgs: json['route_args'] != null
            ? Map<String, String>.from(json['route_args'])
            : null,
        isRead: json['is_read'] ?? false,
        createdAt: DateTime.parse(json['created_at']),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'user_id': userId,
        'title': title,
        'body': body,
        'type': type.name,
        'deep_link_route': deepLinkRoute,
        'route_args': routeArgs,
        'is_read': isRead,
        'created_at': createdAt.toIso8601String(),
      };
}
```

---

## 5. SAW Engine (Pure Dart — No API Needed)

```dart
// lib/app/data/mock/mock_saw_engine.dart

import '../models/assessment_payload_model.dart';
import '../models/assessment_result_model.dart';

/// Implements the Simple Additive Weighting algorithm from the PRD.
/// Pure Dart — identical logic will run on HonoJS in production.
/// Each criterion normalizes raw boolean-sum scores to their weighted max.
class MockSawEngine {
  static const _geneticWeight     = 0.3;
  static const _symptomsWeight    = 0.4;
  static const _historyWeight     = 0.2;
  static const _environmentWeight = 0.1;

  static AssessmentResult calculate({
    required String resultId,
    required String parentId,
    required AssessmentPayload payload,
  }) {
    // ── Override: Anaphylaxis detected ─────────────────────────
    if (payload.hasAnaphylaxis) {
      return _buildResult(
        id: resultId,
        parentId: parentId,
        payload: payload,
        score: 10.0,
        level: RiskLevel.high,
        breakdown: const CriterionBreakdown(
          geneticScore: 3.0,
          symptomsScore: 4.0,
          historyScore: 2.0,
          environmentScore: 1.0,
        ),
        anaphylaxisOverride: true,
      );
    }

    // ── Step 1: Genetic (4 boolean flags, max raw = 4) ──────────
    // Weighted per clinical significance, not equally.
    final geneticRaw =
        (payload.motherHasAtopy ? 1.2 : 0.0) +
        (payload.fatherHasAtopy ? 1.2 : 0.0) +
        (payload.siblingHasAtopy ? 0.8 : 0.0) +
        (payload.grandparentHasAtopy ? 0.5 : 0.0); // max ~3.7
    final geneticNormalized = (geneticRaw / 3.7).clamp(0.0, 1.0);
    final geneticScore = double.parse(
      (geneticNormalized * 3.0 * _geneticWeight / _geneticWeight)
          .toStringAsFixed(2),
    ); // max 3.0

    // ── Step 2: Active Symptoms (6 flags, excl. anaphylaxis) ────
    final symptomsRaw =
        (payload.hasUrticaria     ? 1.5 : 0.0) +
        (payload.hasGIReaction    ? 1.2 : 0.0) +
        (payload.hasWheeze        ? 1.0 : 0.0) +
        (payload.hasRhinitis      ? 0.7 : 0.0) +
        (payload.hasConjunctivitis? 0.5 : 0.0); // max ~4.9
    final symptomsNormalized = (symptomsRaw / 4.9).clamp(0.0, 1.0);
    final symptomsScore = double.parse(
      (symptomsNormalized * 4.0).toStringAsFixed(2),
    ); // max 4.0

    // ── Step 3: Disease History (5 flags) ────────────────────────
    final historyRaw =
        (payload.hasDermatitis            ? 1.0 : 0.0) +
        (payload.hasChronicDrySkin        ? 0.8 : 0.0) +
        (payload.hadHospitalization       ? 0.7 : 0.0) +
        (payload.hasAntihistamineHistory  ? 0.5 : 0.0) +
        (payload.hasRecurrentOtitis       ? 0.3 : 0.0); // max ~3.3
    final historyNormalized = (historyRaw / 3.3).clamp(0.0, 1.0);
    final historyScore = double.parse(
      (historyNormalized * 2.0).toStringAsFixed(2),
    ); // max 2.0

    // ── Step 4: Environment (5 flags) ────────────────────────────
    final environmentRaw =
        (payload.smokingHousehold  ? 1.0 : 0.0) +
        (payload.hasPets           ? 0.7 : 0.0) +
        (payload.highDustEnv       ? 0.7 : 0.0) +
        (payload.nearPollution     ? 0.5 : 0.0) +
        (payload.hasCarpetOrPlush  ? 0.3 : 0.0); // max ~3.2
    final environmentNormalized = (environmentRaw / 3.2).clamp(0.0, 1.0);
    final environmentScore = double.parse(
      (environmentNormalized * 1.0).toStringAsFixed(2),
    ); // max 1.0

    // ── Final SAW Score ──────────────────────────────────────────
    final totalScore = double.parse(
      (geneticScore + symptomsScore + historyScore + environmentScore)
          .clamp(1.0, 10.0)
          .toStringAsFixed(1),
    );

    final level = totalScore >= 7.0
        ? RiskLevel.high
        : totalScore >= 4.0
            ? RiskLevel.medium
            : RiskLevel.low;

    return _buildResult(
      id: resultId,
      parentId: parentId,
      payload: payload,
      score: totalScore,
      level: level,
      breakdown: CriterionBreakdown(
        geneticScore: geneticScore,
        symptomsScore: symptomsScore,
        historyScore: historyScore,
        environmentScore: environmentScore,
      ),
      anaphylaxisOverride: false,
    );
  }

  static List<String> _recommendations(RiskLevel level, bool override) {
    if (override) {
      return [
        'Gejala anafilaksis terdeteksi. Ini adalah kondisi darurat medis.',
        'Segera bawa anak ke IGD atau hubungi 119.',
        'Jangan tinggalkan anak sendirian.',
        'Catat semua makanan/paparan yang terjadi sebelum gejala muncul.',
      ];
    }
    switch (level) {
      case RiskLevel.low:
        return [
          'Risiko alergi anak Anda saat ini tergolong rendah.',
          'Pertahankan lingkungan rumah yang bersih dan bebas debu.',
          'Hindari paparan asap rokok di sekitar anak.',
          'Perkenalkan makanan baru secara bertahap dan catat reaksinya.',
          'Lakukan asesmen ulang dalam 6 bulan atau jika ada gejala baru.',
        ];
      case RiskLevel.medium:
        return [
          'Anak Anda memiliki beberapa faktor risiko alergi.',
          'Jadwalkan konsultasi ke dokter atau Puskesmas dalam waktu dekat.',
          'Bawa hasil asesmen ini saat berkonsultasi.',
          'Hindari makanan pemicu yang sudah teridentifikasi.',
          'Kurangi paparan alergen lingkungan (debu, bulu hewan).',
          'Pantau gejala dan catat dalam jurnal harian.',
        ];
      case RiskLevel.high:
        return [
          'Anak Anda memiliki risiko alergi yang tinggi.',
          'Segera konsultasikan ke Dokter Spesialis Anak (Sp.A) atau Sp.A-Alergi Imunologi.',
          'Jangan tunda pemeriksaan meskipun gejala tampak ringan saat ini.',
          'Bawa hasil asesmen ini lengkap ke dokter.',
          'Catat semua gejala, kapan terjadi, dan apa yang didahului.',
          'Tanyakan kepada dokter tentang uji alergi (SPT atau ImmunoCAP).',
        ];
    }
  }

  static AssessmentResult _buildResult({
    required String id,
    required String parentId,
    required AssessmentPayload payload,
    required double score,
    required RiskLevel level,
    required CriterionBreakdown breakdown,
    required bool anaphylaxisOverride,
  }) =>
      AssessmentResult(
        id: id,
        childId: payload.childId,
        parentId: parentId,
        score: score,
        level: level,
        anaphylaxisOverride: anaphylaxisOverride,
        breakdown: breakdown,
        payload: payload,
        recommendations: _recommendations(level, anaphylaxisOverride),
        assessedAt: DateTime.now(),
      );
}
```

---

## 6. Mock Seed Data

```dart
// lib/app/data/mock/mock_seed_data.dart
// All dates are relative to a reference point so seed data stays
// "recent" regardless of when the app is first run.

class MockSeedData {

  // ─── Users ────────────────────────────────────────────────────

  static List<Map<String, dynamic>> get users => [
    // ── Parent accounts ──
    {
      'id': 'usr_parent_01',
      'name': 'Budi Santoso',
      'email': 'budi@demo.com',
      'password': 'demo1234',
      'role': 'parent',
      'avatar_url': null,
      'is_verified': true,
      'str_number': null,
      'specialty': null,
      'clinic_name': null,
      'created_at': '2024-11-01T08:00:00.000Z',
    },
    {
      'id': 'usr_parent_02',
      'name': 'Sari Dewi',
      'email': 'sari@demo.com',
      'password': 'demo1234',
      'role': 'parent',
      'avatar_url': null,
      'is_verified': true,
      'str_number': null,
      'specialty': null,
      'clinic_name': null,
      'created_at': '2024-11-15T09:30:00.000Z',
    },
    {
      'id': 'usr_parent_03',
      'name': 'Hendra Wijaya',
      'email': 'hendra@demo.com',
      'password': 'demo1234',
      'role': 'parent',
      'avatar_url': null,
      'is_verified': true,
      'str_number': null,
      'specialty': null,
      'clinic_name': null,
      'created_at': '2024-12-03T07:15:00.000Z',
    },

    // ── Doctor accounts ──
    {
      'id': 'usr_doctor_01',
      'name': 'dr. Amelia Putri, Sp.A',
      'email': 'dokter@demo.com',
      'password': 'demo1234',
      'role': 'doctor',
      'avatar_url': null,
      'is_verified': true,
      'str_number': '12345678901',
      'specialty': 'Dokter Spesialis Anak',
      'clinic_name': 'RSUD Dr. Soetomo Surabaya',
      'created_at': '2024-10-20T10:00:00.000Z',
    },
    {
      'id': 'usr_doctor_02',
      'name': 'dr. Fajar Rahman, Sp.A-KI',
      'email': 'dokter2@demo.com',
      'password': 'demo1234',
      'role': 'doctor',
      'avatar_url': null,
      'is_verified': true,
      'str_number': '98765432100',
      'specialty': 'Sp.A - Alergi & Imunologi',
      'clinic_name': 'Klinik Alergi Anak Surabaya',
      'created_at': '2024-10-25T11:00:00.000Z',
    },
  ];

  // ─── Children ─────────────────────────────────────────────────

  static List<Map<String, dynamic>> get children => [
    // Budi's children
    {
      'id': 'child_01',
      'parent_id': 'usr_parent_01',
      'name': 'Rizky Santoso',
      'date_of_birth': '2021-03-15T00:00:00.000Z',  // ~4 tahun
      'gender': 'male',
      'weight_kg': 16.5,
      'height_cm': 102.0,
      'photo_url': null,
      'notes': 'Lahir prematur 36 minggu',
      'created_at': '2024-11-01T08:10:00.000Z',
    },
    {
      'id': 'child_02',
      'parent_id': 'usr_parent_01',
      'name': 'Nayla Santoso',
      'date_of_birth': '2023-07-22T00:00:00.000Z',  // ~1.5 tahun
      'gender': 'female',
      'weight_kg': 10.2,
      'height_cm': 80.0,
      'photo_url': null,
      'notes': null,
      'created_at': '2024-11-01T08:15:00.000Z',
    },
    // Sari's child
    {
      'id': 'child_03',
      'parent_id': 'usr_parent_02',
      'name': 'Kevin Pratama',
      'date_of_birth': '2020-11-10T00:00:00.000Z',  // ~4.5 tahun
      'gender': 'male',
      'weight_kg': 18.0,
      'height_cm': 108.0,
      'photo_url': null,
      'notes': 'Riwayat dermatitis atopik sejak usia 6 bulan',
      'created_at': '2024-11-16T09:00:00.000Z',
    },
    // Hendra's child
    {
      'id': 'child_04',
      'parent_id': 'usr_parent_03',
      'name': 'Putri Wijaya',
      'date_of_birth': '2022-05-01T00:00:00.000Z',  // ~3 tahun
      'gender': 'female',
      'weight_kg': 13.0,
      'height_cm': 92.0,
      'photo_url': null,
      'notes': null,
      'created_at': '2024-12-03T07:20:00.000Z',
    },
  ];

  // ─── Assessments ──────────────────────────────────────────────
  // Each entry is a stored AssessmentResult (already scored).

  static List<Map<String, dynamic>> get assessments => [
    // child_01 — Rizky — Sedang (4.8)
    {
      'id': 'asmnt_01',
      'child_id': 'child_01',
      'parent_id': 'usr_parent_01',
      'score': 4.8,
      'level': 'medium',
      'anaphylaxis_override': false,
      'breakdown': {
        'genetic_score': 2.1,
        'symptoms_score': 1.7,
        'history_score': 0.8,
        'environment_score': 0.2,
      },
      'payload': {
        'child_id': 'child_01',
        'mother_has_atopy': true,
        'father_has_atopy': false,
        'sibling_has_atopy': false,
        'grandparent_has_atopy': true,
        'has_anaphylaxis': false,
        'has_urticaria': true,
        'has_gi_reaction': false,
        'has_rhinitis': false,
        'has_wheeze': false,
        'has_conjunctivitis': false,
        'has_dermatitis': false,
        'has_chronic_dry_skin': true,
        'had_hospitalization': false,
        'has_antihistamine_history': false,
        'has_recurrent_otitis': false,
        'smoking_household': false,
        'has_pets': false,
        'high_dust_env': true,
        'near_pollution': false,
        'has_carpet_or_plush': false,
      },
      'recommendations': [
        'Anak Anda memiliki beberapa faktor risiko alergi.',
        'Jadwalkan konsultasi ke dokter atau Puskesmas dalam waktu dekat.',
        'Bawa hasil asesmen ini saat berkonsultasi.',
        'Hindari makanan pemicu yang sudah teridentifikasi.',
        'Kurangi paparan alergen lingkungan (debu, bulu hewan).',
        'Pantau gejala dan catat dalam jurnal harian.',
      ],
      'assessed_at': '2025-01-10T14:22:00.000Z',
    },

    // child_01 — Rizky — earlier assessment — Rendah (2.5)
    {
      'id': 'asmnt_02',
      'child_id': 'child_01',
      'parent_id': 'usr_parent_01',
      'score': 2.5,
      'level': 'low',
      'anaphylaxis_override': false,
      'breakdown': {
        'genetic_score': 1.2,
        'symptoms_score': 0.8,
        'history_score': 0.3,
        'environment_score': 0.2,
      },
      'payload': {
        'child_id': 'child_01',
        'mother_has_atopy': true,
        'father_has_atopy': false,
        'sibling_has_atopy': false,
        'grandparent_has_atopy': false,
        'has_anaphylaxis': false,
        'has_urticaria': false,
        'has_gi_reaction': false,
        'has_rhinitis': false,
        'has_wheeze': false,
        'has_conjunctivitis': false,
        'has_dermatitis': false,
        'has_chronic_dry_skin': false,
        'had_hospitalization': false,
        'has_antihistamine_history': false,
        'has_recurrent_otitis': false,
        'smoking_household': false,
        'has_pets': false,
        'high_dust_env': true,
        'near_pollution': false,
        'has_carpet_or_plush': false,
      },
      'recommendations': [
        'Risiko alergi anak Anda saat ini tergolong rendah.',
        'Pertahankan lingkungan rumah yang bersih dan bebas debu.',
        'Hindari paparan asap rokok di sekitar anak.',
        'Lakukan asesmen ulang dalam 6 bulan atau jika ada gejala baru.',
      ],
      'assessed_at': '2024-07-05T09:00:00.000Z',
    },

    // child_03 — Kevin — Tinggi (7.9) — has dermatitis history
    {
      'id': 'asmnt_03',
      'child_id': 'child_03',
      'parent_id': 'usr_parent_02',
      'score': 7.9,
      'level': 'high',
      'anaphylaxis_override': false,
      'breakdown': {
        'genetic_score': 2.7,
        'symptoms_score': 3.1,
        'history_score': 1.8,
        'environment_score': 0.3,
      },
      'payload': {
        'child_id': 'child_03',
        'mother_has_atopy': true,
        'father_has_atopy': true,
        'sibling_has_atopy': false,
        'grandparent_has_atopy': true,
        'has_anaphylaxis': false,
        'has_urticaria': true,
        'has_gi_reaction': true,
        'has_rhinitis': true,
        'has_wheeze': false,
        'has_conjunctivitis': false,
        'has_dermatitis': true,
        'has_chronic_dry_skin': true,
        'had_hospitalization': false,
        'has_antihistamine_history': true,
        'has_recurrent_otitis': false,
        'smoking_household': false,
        'has_pets': false,
        'high_dust_env': true,
        'near_pollution': false,
        'has_carpet_or_plush': false,
      },
      'recommendations': [
        'Anak Anda memiliki risiko alergi yang tinggi.',
        'Segera konsultasikan ke Dokter Spesialis Anak (Sp.A).',
        'Jangan tunda pemeriksaan meskipun gejala tampak ringan saat ini.',
        'Catat semua gejala, kapan terjadi, dan apa yang mendahuluinya.',
        'Tanyakan kepada dokter tentang uji alergi (SPT atau ImmunoCAP).',
      ],
      'assessed_at': '2025-01-18T11:05:00.000Z',
    },

    // child_04 — Putri — Anafilaksis override
    {
      'id': 'asmnt_04',
      'child_id': 'child_04',
      'parent_id': 'usr_parent_03',
      'score': 10.0,
      'level': 'high',
      'anaphylaxis_override': true,
      'breakdown': {
        'genetic_score': 3.0,
        'symptoms_score': 4.0,
        'history_score': 2.0,
        'environment_score': 1.0,
      },
      'payload': {
        'child_id': 'child_04',
        'mother_has_atopy': false,
        'father_has_atopy': false,
        'sibling_has_atopy': false,
        'grandparent_has_atopy': false,
        'has_anaphylaxis': true,
        'has_urticaria': true,
        'has_gi_reaction': true,
        'has_rhinitis': false,
        'has_wheeze': true,
        'has_conjunctivitis': false,
        'has_dermatitis': false,
        'has_chronic_dry_skin': false,
        'had_hospitalization': false,
        'has_antihistamine_history': false,
        'has_recurrent_otitis': false,
        'smoking_household': false,
        'has_pets': false,
        'high_dust_env': false,
        'near_pollution': false,
        'has_carpet_or_plush': false,
      },
      'recommendations': [
        'Gejala anafilaksis terdeteksi. Ini adalah kondisi darurat medis.',
        'Segera bawa anak ke IGD atau hubungi 119.',
        'Jangan tinggalkan anak sendirian.',
        'Catat semua makanan/paparan yang terjadi sebelum gejala muncul.',
      ],
      'assessed_at': '2025-01-20T08:45:00.000Z',
    },
  ];

  // ─── Articles ─────────────────────────────────────────────────

  static List<Map<String, dynamic>> get articles => [
    {
      'id': 'art_01',
      'author_id': 'usr_doctor_01',
      'author_name': 'dr. Amelia Putri, Sp.A',
      'author_specialty': 'Dokter Spesialis Anak',
      'author_avatar_url': null,
      'title': 'Mengenal Atopic March: Dari Eksim ke Asma',
      'category': 'eczema',
      'tags': ['atopic march', 'eksim', 'asma', 'alergi anak'],
      'cover_image_url': 'https://picsum.photos/seed/art01/800/400',
      'body': '''<h2>Apa itu Atopic March?</h2>
<p>Atopic March adalah perjalanan alami penyakit atopik yang dimulai sejak bayi. Kondisi ini menggambarkan bagaimana dermatitis atopik (eksim) pada bayi dapat berkembang menjadi asma dan rinitis alergi saat anak tumbuh.</p>
<h2>Tahapan Atopic March</h2>
<p>Pada usia 0–2 tahun, manifestasi pertama biasanya berupa dermatitis atopik — kulit kering, gatal, dan meradang. Pada usia 2–6 tahun, alergi makanan sering muncul bersamaan atau setelah eksim. Memasuki usia sekolah, asma dan rinitis alergi menjadi lebih dominan.</p>
<h2>Pentingnya Deteksi Dini</h2>
<p>Intervensi dini, terutama pelembap intensif pada bayi berisiko tinggi, terbukti dapat memotong rantai Atopic March. Inilah mengapa penilaian risiko sejak dini sangat penting.</p>''',
      'status': 'published',
      'read_time_minutes': 4,
      'created_at': '2024-12-10T10:00:00.000Z',
      'published_at': '2024-12-11T08:00:00.000Z',
    },
    {
      'id': 'art_02',
      'author_id': 'usr_doctor_02',
      'author_name': 'dr. Fajar Rahman, Sp.A-KI',
      'author_specialty': 'Sp.A - Alergi & Imunologi',
      'author_avatar_url': null,
      'title': '7 Alergen Makanan Utama pada Anak yang Perlu Diwaspadai',
      'category': 'foodAllergy',
      'tags': ['alergi makanan', 'susu sapi', 'telur', 'kacang'],
      'cover_image_url': 'https://picsum.photos/seed/art02/800/400',
      'body': '''<h2>Kenali 7 Alergen Makanan Utama</h2>
<p>Berdasarkan data epidemiologi, tujuh kelompok makanan bertanggung jawab atas lebih dari 90% reaksi alergi makanan pada anak:</p>
<ol>
<li><strong>Susu sapi</strong> — Alergen paling umum pada bayi di bawah 1 tahun</li>
<li><strong>Telur</strong> — Terutama protein putih telur (albumin)</li>
<li><strong>Kacang tanah</strong> — Berisiko anafilaksis</li>
<li><strong>Kacang pohon</strong> — Walnut, almond, mete</li>
<li><strong>Ikan</strong> — Reaksi silang antar spesies mungkin terjadi</li>
<li><strong>Makanan laut</strong> — Udang, kepiting, cumi</li>
<li><strong>Gandum</strong> — Terkait celiac disease dan WDEIA</li>
</ol>
<h2>Kapan Harus ke Dokter?</h2>
<p>Segera ke IGD jika anak mengalami sesak napas, bengkak bibir/lidah/tenggorokan, atau pingsan setelah makan. Untuk reaksi ringan seperti ruam atau gatal terlokalisir, konsultasi ke dokter dalam 24 jam.</p>''',
      'status': 'published',
      'read_time_minutes': 5,
      'created_at': '2024-12-20T11:00:00.000Z',
      'published_at': '2024-12-21T08:00:00.000Z',
    },
    {
      'id': 'art_03',
      'author_id': 'usr_doctor_01',
      'author_name': 'dr. Amelia Putri, Sp.A',
      'author_specialty': 'Dokter Spesialis Anak',
      'author_avatar_url': null,
      'title': 'Cara Membuat Rumah Ramah Alergi untuk Buah Hati',
      'category': 'environment',
      'tags': ['lingkungan', 'debu', 'hewan peliharaan', 'pencegahan'],
      'cover_image_url': 'https://picsum.photos/seed/art03/800/400',
      'body': '''<h2>Lingkungan Dalam Ruangan sebagai Pemicu Alergi</h2>
<p>Tungau debu rumah (Dermatophagoides pteronyssinus) adalah alergen inhalan paling umum di Indonesia. Konsentrasi tungau debu paling tinggi ditemukan di kasur, bantal, sofa berlapis kain, dan karpet.</p>
<h2>Langkah Praktis Mengurangi Alergen</h2>
<p><strong>Kasur dan Bantal:</strong> Gunakan penutup anti-alergi (allergen-proof covers). Cuci seprai dengan air panas (>60°C) setiap minggu.</p>
<p><strong>Karpet:</strong> Pertimbangkan mengganti karpet dengan lantai keras. Jika tetap menggunakan karpet, vacuum dengan filter HEPA dua kali seminggu.</p>
<p><strong>Hewan Peliharaan:</strong> Alergen hewan (bulu, air liur, sel kulit mati) dapat bertahan di udara selama 6 bulan. Jauhkan hewan dari kamar tidur anak.</p>''',
      'status': 'published',
      'read_time_minutes': 6,
      'created_at': '2025-01-05T09:00:00.000Z',
      'published_at': '2025-01-06T08:00:00.000Z',
    },
    {
      'id': 'art_04',
      'author_id': 'usr_doctor_02',
      'author_name': 'dr. Fajar Rahman, Sp.A-KI',
      'author_specialty': 'Sp.A - Alergi & Imunologi',
      'author_avatar_url': null,
      'title': 'Memahami Hasil Uji Alergi: SPT vs IgE Spesifik',
      'category': 'general',
      'tags': ['skin prick test', 'IgE', 'diagnosis', 'uji alergi'],
      'cover_image_url': 'https://picsum.photos/seed/art04/800/400',
      'body': '''<h2>Dua Jenis Uji Alergi yang Umum</h2>
<p>Banyak orang tua bingung memilih antara Skin Prick Test (SPT) dan pemeriksaan IgE spesifik darah. Keduanya valid, namun memiliki kelebihan dan keterbatasan berbeda.</p>
<h2>Skin Prick Test (SPT)</h2>
<p>SPT adalah standar emas untuk diagnosis alergi IgE-mediated. Alergen ditetes di kulit lengan bawah lalu ditusuk dengan lanset kecil. Hasil positif (bentol >3mm) muncul dalam 15–20 menit. Kelebihan: cepat, murah, bisa menguji banyak alergen sekaligus. Keterbatasan: perlu penghentian antihistamin 5–7 hari sebelumnya; tidak bisa dilakukan saat eksim aktif berat.</p>
<h2>IgE Spesifik (ImmunoCAP)</h2>
<p>Pemeriksaan darah yang mengukur kadar antibodi IgE terhadap alergen tertentu. Tidak memerlukan penghentian obat, aman untuk anak dengan dermatitis berat. Kelemahannya: lebih mahal dan hasil baru tersedia 1–3 hari kemudian.</p>''',
      'status': 'published',
      'read_time_minutes': 7,
      'created_at': '2025-01-12T10:00:00.000Z',
      'published_at': '2025-01-13T08:00:00.000Z',
    },
    // Draft article (only visible to doctors)
    {
      'id': 'art_05',
      'author_id': 'usr_doctor_01',
      'author_name': 'dr. Amelia Putri, Sp.A',
      'author_specialty': 'Dokter Spesialis Anak',
      'author_avatar_url': null,
      'title': 'Imunoterapi Alergi pada Anak: Kapan dan Untuk Siapa?',
      'category': 'general',
      'tags': ['imunoterapi', 'AIT', 'sublingual', 'subcutaneous'],
      'cover_image_url': 'https://picsum.photos/seed/art05/800/400',
      'body': '<p>Draft artikel sedang dalam penulisan...</p>',
      'status': 'draft',
      'read_time_minutes': 8,
      'created_at': '2025-01-22T15:00:00.000Z',
      'published_at': null,
    },
  ];

  // ─── Clinical Notes ───────────────────────────────────────────

  static List<Map<String, dynamic>> get clinicalNotes => [
    {
      'id': 'note_01',
      'doctor_id': 'usr_doctor_01',
      'doctor_name': 'dr. Amelia Putri, Sp.A',
      'patient_child_id': 'child_01',
      'assessment_id': 'asmnt_01',
      'note': 'Pasien datang dengan keluhan kulit gatal di lipatan siku dan lutut. Riwayat ibu dengan asma alergi. Sarankan pemeriksaan SPT untuk tungau debu dan susu sapi. Resepkan pelembap ceramide-based 2x/hari.',
      'created_at': '2025-01-12T13:30:00.000Z',
    },
    {
      'id': 'note_02',
      'doctor_id': 'usr_doctor_02',
      'doctor_name': 'dr. Fajar Rahman, Sp.A-KI',
      'patient_child_id': 'child_03',
      'assessment_id': 'asmnt_03',
      'note': 'Riwayat dermatitis atopik sejak usia 6 bulan, saat ini dalam tatalaksana steroid topikal. Hasil asesmen menunjukkan risiko tinggi dengan komponen genetik dominan (kedua orang tua atopik). Jadwalkan ImmunoCAP untuk panel makanan dan inhalan.',
      'created_at': '2025-01-19T10:15:00.000Z',
    },
  ];

  // ─── Notifications ────────────────────────────────────────────

  static List<Map<String, dynamic>> get notifications => [
    {
      'id': 'notif_01',
      'user_id': 'usr_parent_01',
      'title': 'Saatnya Asesmen Ulang',
      'body': 'Sudah 6 bulan sejak asesmen terakhir Rizky. Lakukan asesmen ulang untuk memantau perkembangan risiko alergi.',
      'type': 'assessmentReminder',
      'deep_link_route': '/parent/assessment',
      'route_args': {'child_id': 'child_01'},
      'is_read': false,
      'created_at': '2025-01-20T08:00:00.000Z',
    },
    {
      'id': 'notif_02',
      'user_id': 'usr_parent_01',
      'title': 'Artikel Baru Untuk Anda',
      'body': 'dr. Amelia telah mempublikasikan artikel baru: "Cara Membuat Rumah Ramah Alergi"',
      'type': 'newArticle',
      'deep_link_route': '/parent/articles/art_03',
      'route_args': null,
      'is_read': true,
      'created_at': '2025-01-06T09:00:00.000Z',
    },
    {
      'id': 'notif_03',
      'user_id': 'usr_parent_02',
      'title': '⚠️ Risiko Tinggi Terdeteksi',
      'body': 'Hasil asesmen Kevin menunjukkan risiko alergi TINGGI (7.9). Segera konsultasikan ke dokter spesialis.',
      'type': 'highRiskAlert',
      'deep_link_route': '/parent/assessment/result',
      'route_args': {'assessment_id': 'asmnt_03'},
      'is_read': false,
      'created_at': '2025-01-18T11:10:00.000Z',
    },
  ];
}
```

---

## 7. Repository Interfaces

```dart
// lib/app/data/repositories/interfaces/i_auth_repository.dart
abstract class IAuthRepository {
  Future<UserModel> login(String email, String password);
  Future<UserModel> register({
    required String name,
    required String email,
    required String password,
    required UserRole role,
    String? strNumber,
    String? specialty,
    String? clinicName,
  });
  Future<void> logout();
  Future<UserModel?> getCurrentUser();
  Future<void> updateProfile(UserModel updated);
}

// lib/app/data/repositories/interfaces/i_child_repository.dart
abstract class IChildRepository {
  Future<List<ChildProfile>> getChildrenForParent(String parentId);
  Future<ChildProfile> createChild(ChildProfile child);
  Future<ChildProfile> updateChild(ChildProfile child);
  Future<void> deleteChild(String childId);
}

// lib/app/data/repositories/interfaces/i_assessment_repository.dart
abstract class IAssessmentRepository {
  Future<AssessmentResult> submitAssessment({
    required String parentId,
    required AssessmentPayload payload,
  });
  Future<List<AssessmentResult>> getAssessmentsForChild(String childId);
  Future<AssessmentResult> getAssessmentById(String id);
}

// lib/app/data/repositories/interfaces/i_article_repository.dart
abstract class IArticleRepository {
  Future<List<Article>> getPublishedArticles({
    String? category,
    String? searchQuery,
    int page = 1,
    int limit = 10,
  });
  Future<Article> getArticleById(String id);
  // Doctor-only:
  Future<List<Article>> getArticlesByAuthor(String authorId);
  Future<Article> createArticle(Article article);
  Future<Article> updateArticle(Article article);
  Future<void> deleteArticle(String id);
  Future<Article> publishArticle(String id);
}

// lib/app/data/repositories/interfaces/i_patient_repository.dart
abstract class IPatientRepository {
  Future<List<Map<String, dynamic>>> getAllPatients();  // Doctor view
  Future<Map<String, dynamic>> getPatientDetail({
    required String childId,
    required String parentId,
  });
  Future<ClinicalNote> addClinicalNote(ClinicalNote note);
  Future<List<ClinicalNote>> getNotesForAssessment(String assessmentId);
}
```

---

## 8. Mock Repository Implementations

```dart
// lib/app/data/repositories/mock/mock_auth_repository.dart

import 'dart:async';
import 'package:get/get.dart';
import '../../../core/services/storage_service.dart';
import '../../models/user_model.dart';
import '../interfaces/i_auth_repository.dart';

class MockAuthRepository implements IAuthRepository {
  final _storage = Get.find<StorageService>();

  /// Simulates network latency.
  Future<void> _delay([int ms = 600]) =>
      Future.delayed(Duration(milliseconds: ms));

  @override
  Future<UserModel> login(String email, String password) async {
    await _delay();
    final userJson = _storage.findOne(StorageKeys.users, 'email', email);
    if (userJson == null || userJson['password'] != password) {
      throw Exception('Email atau password salah.');
    }
    final user = UserModel.fromJson(userJson);
    await _storage.saveSession(
      token: 'mock_jwt_${user.id}_${DateTime.now().millisecondsSinceEpoch}',
      user: userJson,
      role: user.role.name,
    );
    return user;
  }

  @override
  Future<UserModel> register({
    required String name,
    required String email,
    required String password,
    required UserRole role,
    String? strNumber,
    String? specialty,
    String? clinicName,
  }) async {
    await _delay(800);
    final existing = _storage.findOne(StorageKeys.users, 'email', email);
    if (existing != null) {
      throw Exception('Email sudah terdaftar.');
    }
    final newUser = UserModel(
      id: 'usr_${DateTime.now().millisecondsSinceEpoch}',
      name: name,
      email: email,
      password: password,
      role: role,
      isVerified: role == UserRole.parent, // Doctors need manual verification
      strNumber: strNumber,
      specialty: specialty,
      clinicName: clinicName,
      createdAt: DateTime.now(),
    );
    await _storage.upsertOne(StorageKeys.users, newUser.toJson());
    if (role == UserRole.parent) {
      await _storage.saveSession(
        token: 'mock_jwt_${newUser.id}',
        user: newUser.toJson(),
        role: role.name,
      );
    }
    return newUser;
  }

  @override
  Future<void> logout() async {
    await _storage.clearSession();
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    import 'dart:convert';
    final raw = _storage.read<String>(StorageKeys.currentUser);
    if (raw == null) return null;
    return UserModel.fromJson(json.decode(raw));
  }

  @override
  Future<void> updateProfile(UserModel updated) async {
    await _delay(400);
    await _storage.upsertOne(StorageKeys.users, updated.toJson());
    await _storage.write(
      StorageKeys.currentUser,
      json.encode(updated.toJson()),
    );
  }
}
```

```dart
// lib/app/data/repositories/mock/mock_child_repository.dart

class MockChildRepository implements IChildRepository {
  final _storage = Get.find<StorageService>();

  Future<void> _delay() => Future.delayed(const Duration(milliseconds: 500));

  @override
  Future<List<ChildProfile>> getChildrenForParent(String parentId) async {
    await _delay();
    return _storage
        .readList(StorageKeys.children)
        .where((e) => e['parent_id'] == parentId)
        .map(ChildProfile.fromJson)
        .toList();
  }

  @override
  Future<ChildProfile> createChild(ChildProfile child) async {
    await _delay();
    await _storage.upsertOne(StorageKeys.children, child.toJson());
    return child;
  }

  @override
  Future<ChildProfile> updateChild(ChildProfile child) async {
    await _delay();
    await _storage.upsertOne(StorageKeys.children, child.toJson());
    return child;
  }

  @override
  Future<void> deleteChild(String childId) async {
    await _delay();
    await _storage.deleteOne(StorageKeys.children, childId);
  }
}
```

```dart
// lib/app/data/repositories/mock/mock_assessment_repository.dart

class MockAssessmentRepository implements IAssessmentRepository {
  final _storage = Get.find<StorageService>();

  Future<void> _delay() => Future.delayed(const Duration(milliseconds: 800));

  @override
  Future<AssessmentResult> submitAssessment({
    required String parentId,
    required AssessmentPayload payload,
  }) async {
    await _delay(); // Simulate SAW computation time

    final resultId = 'asmnt_${DateTime.now().millisecondsSinceEpoch}';
    final result = MockSawEngine.calculate(
      resultId: resultId,
      parentId: parentId,
      payload: payload,
    );

    await _storage.upsertOne(StorageKeys.assessments, result.toJson());
    return result;
  }

  @override
  Future<List<AssessmentResult>> getAssessmentsForChild(String childId) async {
    await _delay();
    final results = _storage
        .readList(StorageKeys.assessments)
        .where((e) => e['child_id'] == childId)
        .map(AssessmentResult.fromJson)
        .toList();

    // Most recent first
    results.sort((a, b) => b.assessedAt.compareTo(a.assessedAt));
    return results;
  }

  @override
  Future<AssessmentResult> getAssessmentById(String id) async {
    await _delay();
    final json = _storage.findOne(StorageKeys.assessments, 'id', id);
    if (json == null) throw Exception('Assessment tidak ditemukan.');
    return AssessmentResult.fromJson(json);
  }
}
```

```dart
// lib/app/data/repositories/mock/mock_article_repository.dart

class MockArticleRepository implements IArticleRepository {
  final _storage = Get.find<StorageService>();

  Future<void> _delay() => Future.delayed(const Duration(milliseconds: 500));

  @override
  Future<List<Article>> getPublishedArticles({
    String? category,
    String? searchQuery,
    int page = 1,
    int limit = 10,
  }) async {
    await _delay();
    var articles = _storage
        .readList(StorageKeys.articles)
        .where((e) => e['status'] == 'published')
        .map(Article.fromJson)
        .toList();

    if (category != null && category != 'all') {
      articles = articles.where((a) => a.category.name == category).toList();
    }
    if (searchQuery != null && searchQuery.isNotEmpty) {
      final q = searchQuery.toLowerCase();
      articles = articles
          .where((a) =>
              a.title.toLowerCase().contains(q) ||
              a.tags.any((t) => t.toLowerCase().contains(q)))
          .toList();
    }

    // Sort by publishedAt desc, paginate
    articles.sort((a, b) => (b.publishedAt ?? b.createdAt)
        .compareTo(a.publishedAt ?? a.createdAt));
    final start = (page - 1) * limit;
    return articles.skip(start).take(limit).toList();
  }

  @override
  Future<Article> getArticleById(String id) async {
    await _delay();
    final json = _storage.findOne(StorageKeys.articles, 'id', id);
    if (json == null) throw Exception('Artikel tidak ditemukan.');
    return Article.fromJson(json);
  }

  @override
  Future<List<Article>> getArticlesByAuthor(String authorId) async {
    await _delay();
    return _storage
        .readList(StorageKeys.articles)
        .where((e) => e['author_id'] == authorId)
        .map(Article.fromJson)
        .toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  @override
  Future<Article> createArticle(Article article) async {
    await _delay(600);
    await _storage.upsertOne(StorageKeys.articles, article.toJson());
    return article;
  }

  @override
  Future<Article> updateArticle(Article article) async {
    await _delay(400);
    await _storage.upsertOne(StorageKeys.articles, article.toJson());
    return article;
  }

  @override
  Future<void> deleteArticle(String id) async {
    await _delay();
    await _storage.deleteOne(StorageKeys.articles, id);
  }

  @override
  Future<Article> publishArticle(String id) async {
    await _delay(400);
    final json = _storage.findOne(StorageKeys.articles, 'id', id);
    if (json == null) throw Exception('Artikel tidak ditemukan.');
    json['status'] = 'published';
    json['published_at'] = DateTime.now().toIso8601String();
    await _storage.upsertOne(StorageKeys.articles, json);
    return Article.fromJson(json);
  }
}
```

```dart
// lib/app/data/repositories/mock/mock_patient_repository.dart

class MockPatientRepository implements IPatientRepository {
  final _storage = Get.find<StorageService>();

  Future<void> _delay() => Future.delayed(const Duration(milliseconds: 600));

  @override
  Future<List<Map<String, dynamic>>> getAllPatients() async {
    await _delay();
    final children = _storage.readList(StorageKeys.children);
    final assessments = _storage.readList(StorageKeys.assessments);
    final users = _storage.readList(StorageKeys.users);

    return children.map((child) {
      final parent = users.firstWhereOrNull(
        (u) => u['id'] == child['parent_id'],
      );
      final childAssessments = assessments
          .where((a) => a['child_id'] == child['id'])
          .map(AssessmentResult.fromJson)
          .toList()
        ..sort((a, b) => b.assessedAt.compareTo(a.assessedAt));

      return {
        'child': ChildProfile.fromJson(child),
        'parent': parent != null ? UserModel.fromJson(parent) : null,
        'latest_result':
            childAssessments.isNotEmpty ? childAssessments.first : null,
        'assessment_count': childAssessments.length,
      };
    }).toList();
  }

  @override
  Future<Map<String, dynamic>> getPatientDetail({
    required String childId,
    required String parentId,
  }) async {
    await _delay();
    final childJson = _storage.findOne(StorageKeys.children, 'id', childId);
    final parentJson = _storage.findOne(StorageKeys.users, 'id', parentId);
    final assessments = _storage
        .readList(StorageKeys.assessments)
        .where((a) => a['child_id'] == childId)
        .map(AssessmentResult.fromJson)
        .toList()
      ..sort((a, b) => b.assessedAt.compareTo(a.assessedAt));
    final notes = _storage
        .readList(StorageKeys.clinicalNotes)
        .where((n) => n['patient_child_id'] == childId)
        .map(ClinicalNote.fromJson)
        .toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

    return {
      'child': childJson != null ? ChildProfile.fromJson(childJson) : null,
      'parent': parentJson != null ? UserModel.fromJson(parentJson) : null,
      'assessments': assessments,
      'clinical_notes': notes,
    };
  }

  @override
  Future<ClinicalNote> addClinicalNote(ClinicalNote note) async {
    await _delay(400);
    await _storage.upsertOne(StorageKeys.clinicalNotes, note.toJson());
    return note;
  }

  @override
  Future<List<ClinicalNote>> getNotesForAssessment(
      String assessmentId) async {
    await _delay();
    return _storage
        .readList(StorageKeys.clinicalNotes)
        .where((n) => n['assessment_id'] == assessmentId)
        .map(ClinicalNote.fromJson)
        .toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }
}
```

---

## 9. Dependency Injection (Bindings)

```dart
// lib/app/routes/app_pages.dart — Bindings wire the mock repositories.
// To go live: swap MockXRepository for RemoteXRepository in each Binding.
// Controllers never change.

class AssessmentBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<IAssessmentRepository>(() => MockAssessmentRepository());
    Get.lazyPut(() => AssessmentController());
  }
}

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<IAuthRepository>(() => MockAuthRepository());
    Get.lazyPut(() => LoginController());
  }
}

// etc. for each module...
```

---

## 10. main.dart + Service Initialization

```dart
// lib/main.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'app/core/services/storage_service.dart';
import 'app/core/services/auth_service.dart';
import 'app/routes/app_pages.dart';
import 'app/core/theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Services must be initialized in order.
  await Get.putAsync(() => StorageService().init());
  await Get.putAsync(() => AuthService().init());

  runApp(const AllerRiskApp());
}

class AllerRiskApp extends StatelessWidget {
  const AllerRiskApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'AllerRisk',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,
      initialRoute: Routes.SPLASH,
      getPages: AppPages.routes,
    );
  }
}
```

---

## 11. Migration Path: Mock → Real API

When the backend is ready, the only change per module is in the Binding:

```dart
// Before (prototype):
Get.lazyPut<IAssessmentRepository>(() => MockAssessmentRepository());

// After (production):
Get.lazyPut<IAssessmentRepository>(() => RemoteAssessmentRepository(
  provider: Get.find<AssessmentProvider>(),
));
```

`RemoteAssessmentRepository` implements the same `IAssessmentRepository` interface. Controllers, views, and all business logic remain untouched. The `MockSawEngine` can be deleted — the server runs it instead.

---

## 12. Quick-Start Demo Credentials

| Role | Email | Password |
|------|-------|----------|
| Orang Tua (2 anak) | `budi@demo.com` | `demo1234` |
| Orang Tua (risiko tinggi) | `sari@demo.com` | `demo1234` |
| Dokter Sp.A | `dokter@demo.com` | `demo1234` |
| Dokter Sp.A-KI | `dokter2@demo.com` | `demo1234` |

> Add a dev-only **"Reset Data"** button in Settings (hidden behind a 5-tap tap sequence on the version number) that calls `StorageService.resetToSeedData()`. This is invaluable for demos.