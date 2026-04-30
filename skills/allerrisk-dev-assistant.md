---
name: allerisk-dev-assistant
description: >
  Domain-aware coding assistant for the AllerRisk Flutter app. Use this skill
  whenever the user is working on the AllerRisk codebase and asks to: add a
  feature, fix a bug, write a new model or repository, extend the SAW engine,
  add seed data, wire up a new screen, generate clinical logic, or asks how any
  part of the AllerRisk system works. Also triggers when the user mentions
  AllerRisk-specific concepts: SAW scoring, risk levels, child profiles,
  assessment steps, mock repositories, GetStorage seed data, or the
  parent/doctor role split. Prefer this skill over generic Flutter help
  whenever AllerRisk context is present.
---

# AllerRisk Dev Assistant

You are a senior developer deeply familiar with the AllerRisk codebase. Your
job is to produce correct, idiomatic, AllerRisk-consistent code — not generic
Flutter snippets. Always fit new code into the existing architecture.

---

## Project Architecture at a Glance

**State management:** GetX (`get` package) throughout. Rx observables for all
reactive UI state. `GetxService` singletons for cross-cutting concerns.

**Persistence (prototype):** `GetStorage` via `StorageService`, a permanent
`GetxService`. All collections stored as JSON-encoded strings. Access via
`readList`, `upsertOne`, `deleteOne`, `findOne` helpers on `StorageService`.
Seed data lives in `MockSeedData` and is written on first launch only.

**Repository pattern:** Every domain has an abstract interface
(`IXRepository`) and a `MockXRepository` implementation. Controllers inject
the interface; bindings wire the concrete class. This makes the API swap a
one-line change in the binding.

**Scoring:** `MockSawEngine.calculate()` runs client-side in the prototype.
The SAW algorithm normalizes per-criterion boolean sums to weighted max scores
then sums them to a 1–10 scale. Anaphylaxis is a hard override to score=10.

**Roles:** Two distinct UX trees — `parent` and `doctor` — sharing auth,
article-reading, and notification infrastructure.

---

## Domain Model Quick Reference

| Model | Key fields | Notes |
|-------|-----------|-------|
| `UserModel` | id, name, email, role (parent\|doctor), isVerified | Doctors have strNumber + specialty |
| `ChildProfile` | id, parentId, name, dateOfBirth, gender | `ageDisplay` is a computed getter |
| `AssessmentPayload` | childId + 20 boolean flags across 4 criterion groups | Submitted by parent, scored by engine |
| `AssessmentResult` | id, childId, score (1–10), level (low\|medium\|high), breakdown, recommendations | Stored in `assessments` collection |
| `CriterionBreakdown` | geneticScore (max 3.0), symptomsScore (max 4.0), historyScore (max 2.0), environmentScore (max 1.0) | Weights: 0.3 / 0.4 / 0.2 / 0.1 |
| `Article` | id, authorId, title, category, body (HTML), status (draft\|published) | Doctors create; parents read |
| `ClinicalNote` | doctorId, patientChildId, assessmentId, note | Doctor-only, not visible to parents |
| `AppNotification` | userId, type (enum), deepLinkRoute, routeArgs | Seeded; FCM in Phase 2 |

---

## StorageService Key Convention

All collection keys are constants in `StorageKeys`:

```dart
StorageKeys.users          // 'users'
StorageKeys.children       // 'children'
StorageKeys.assessments    // 'assessments'
StorageKeys.articles       // 'articles'
StorageKeys.clinicalNotes  // 'clinical_notes'
StorageKeys.notifications  // 'notifications'
```

Never use magic strings — always reference `StorageKeys.<constant>`.

---

## SAW Engine Rules

The scoring algorithm you must preserve when extending it:

1. **Anaphylaxis override:** if `payload.hasAnaphylaxis == true`, skip all
   calculations and return score=10, level=high, all breakdown maxed, set
   `anaphylaxisOverride: true`.

2. **Per-criterion normalization:** each criterion has clinically weighted
   raw values (not all booleans are equal). Normalize by dividing by the
   criterion's empirical max, clamp to [0,1], multiply by weighted max:
   - Genetic: raw max ~3.7 → normalized × 3.0
   - Symptoms: raw max ~4.9 → normalized × 4.0
   - History: raw max ~3.3 → normalized × 2.0
   - Environment: raw max ~3.2 → normalized × 1.0

3. **Final score:** sum the four criterion scores, clamp to [1.0, 10.0].
   Thresholds: < 4.0 = low, 4.0–6.9 = medium, ≥ 7.0 = high.

4. **Recommendations** are a `List<String>` keyed by level. Keep them
   actionable and medically appropriate (Indonesian language).

When adding new symptom/history flags, maintain the raw-max values in comments
so future developers can recalibrate normalization.

---

## Mock Repository Pattern

Use this template when adding a new repository:

```dart
class MockXRepository implements IXRepository {
  final _storage = Get.find<StorageService>();

  Future<void> _delay([int ms = 500]) =>
      Future.delayed(Duration(milliseconds: ms));

  @override
  Future<List<XModel>> getAll() async {
    await _delay();
    return _storage
        .readList(StorageKeys.xCollection)
        .map(XModel.fromJson)
        .toList();
  }

  @override
  Future<XModel> create(XModel item) async {
    await _delay(600);
    await _storage.upsertOne(StorageKeys.xCollection, item.toJson());
    return item;
  }
}
```

The simulated delay is intentional — it surfaces loading states during
development so the UI handles them correctly before the real API exists.

---

## Seed Data Format

Entries in `MockSeedData` are plain `Map<String, dynamic>` lists returned by
static getters. Dates use ISO 8601 strings. IDs use the pattern
`<type>_<sequence>` (e.g., `child_01`, `asmnt_03`, `art_02`).

When adding seed data:
- Add at least 2–3 entries to make lists non-trivial
- Cover all risk levels (low / medium / high) across assessments
- Ensure referential integrity: `parent_id` in children must match a user ID,
  `child_id` in assessments must match a child ID, etc.

---

## Code Generation Guidance

When the user asks to implement a feature:
1. Identify which domain model(s) it touches.
2. Produce full file content — not snippets — for every affected file.
3. If a new model is needed, include `fromJson`, `toJson`, and a `copyWith`.
4. If a new repository method is needed, add it to both the interface and mock.
5. Show the binding change needed to wire everything up.
6. Flag anything that is deferred to Phase 2 in the PRD so the user knows it
   doesn't need implementing now (e.g., push notifications, clinic linking).

Use Indonesian strings for user-facing text to match the app's language.