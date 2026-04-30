---
name: prd-to-implementation
description: >
  Convert a product requirements document (PRD) into a complete prototype
  implementation plan. Use this skill when the user provides or references a
  PRD, feature spec, or product design document and wants to turn it into
  actionable code architecture — including folder structure, data models,
  repository interfaces, mock implementations, seed data, and algorithm logic.
  Also triggers when the user says things like "generate the implementation for
  this spec", "turn this PRD into code", "scaffold the backend for this
  design", "create a prototype from this document", or "what files do I need to
  build X". Prefer this skill over ad-hoc planning whenever a structured spec
  document is present.
---

# PRD → Implementation Plan

Turn a product requirements document into a complete, runnable prototype
architecture. The output is not just a plan — it's ready-to-use Dart/Flutter
code organized into clear sections that a developer can drop straight into
their project.

---

## Output Structure

Always produce the implementation plan in this order. Skip sections only if
the PRD genuinely has no content for them.

### 1. Architecture Strategy
- State management choice (justified by PRD complexity)
- Persistence strategy (local mock vs. remote API — prefer mock-first with
  swap-ready interfaces for prototypes)
- Repository pattern decision (interface + mock implementation)
- Key design decisions made, and why

### 2. Folder Structure
Show the complete `lib/` directory tree. Every file should be named.
Use the pattern:
```
lib/
├── main.dart
├── app/
│   ├── core/           # theme, utils, constants, shared widgets
│   ├── data/           # models, providers, repositories, mock data
│   ├── services/       # GetxService singletons
│   ├── routes/         # named routes + GetPage list
│   └── modules/        # per-role feature modules
│       ├── <role>/
│       │   └── <feature>/
│       │       ├── <feature>_binding.dart
│       │       ├── <feature>_controller.dart
│       │       └── <feature>_view.dart
```

### 3. Data Models
For each entity in the PRD, produce a complete Dart class with:
- All fields (typed correctly)
- `const` constructor
- `factory fromJson(Map<String, dynamic> json)`
- `Map<String, dynamic> toJson()`
- `copyWith(...)` for mutable models
- Computed getters if the PRD implies derived data (e.g., age from DOB)
- Enums for fixed-value fields, with display extensions

### 4. StorageService / Persistence Layer
Produce the full `StorageService` class including:
- `GetStorage` initialization
- Collection helpers: `readList`, `writeList`, `upsertOne`, `deleteOne`, `findOne`
- Session helpers: `saveSession`, `clearSession`, `isLoggedIn`
- Seed-on-first-launch logic calling `_seedIfEmpty()`
- A `StorageKeys` abstract class with all key constants

### 5. Scoring / Algorithm Logic (if present)
If the PRD specifies a scoring or decision algorithm (SAW, weighted sum,
decision tree, etc.):
- Implement it as a pure Dart class with zero side effects
- Comment each step with its PRD reference
- Explain weight rationale in code comments
- Handle overrides and edge cases explicitly
- Include a `_buildResult` helper that assembles the full result object

### 6. Repository Interfaces
For each domain, produce:
```dart
abstract class IXRepository {
  Future<List<X>> getAll();
  Future<X> getById(String id);
  Future<X> create(X item);
  Future<X> update(X item);
  Future<void> delete(String id);
  // ...plus domain-specific operations
}
```
Only include methods the PRD actually requires. Don't pad with CRUD that won't be used.

### 7. Mock Repository Implementations
For each interface, produce a `MockXRepository` that:
- Reads/writes from `StorageService` collections
- Uses `Future.delayed(500ms)` to simulate latency
- Applies sorting (most recent first for time-series data)
- Handles filtering (by parentId, category, status, etc.)
- Throws descriptive `Exception` strings on not-found

### 8. Mock Seed Data
Produce `MockSeedData` as a class of static getters returning
`List<Map<String, dynamic>>`. Seed data must:
- Have 3–5 entries per collection (enough for non-trivial lists)
- Use ISO 8601 date strings
- Use predictable ID patterns: `<type>_<sequence>` (e.g., `child_01`)
- Cover different states/variants (e.g., all risk levels, draft and published)
- Maintain referential integrity (foreign key values must actually exist)
- Include a "Quick-Start Credentials" table at the end listing demo accounts

### 9. Dependency Injection Bindings
Show the binding for each module and a note on how to swap mock → remote:
```dart
// Before (prototype):
Get.lazyPut<IXRepository>(() => MockXRepository());

// After (production):
Get.lazyPut<IXRepository>(() => RemoteXRepository(provider: Get.find()));
```

### 10. main.dart + App Bootstrap
Show the `main()` function with services initialized in dependency order, and
the `GetMaterialApp` root with routes and theme.

### 11. Package Dependencies
List only the packages actually needed. For each, one line explaining why.

### 12. Phase Allocation
Produce a table mapping every feature in the PRD to Phase 1 (MVP), Phase 2,
or Phase 3. Use PRD priorities and complexity to decide. Phase 1 must be
a coherent, demoable product on its own.

---

## Reading the PRD

Before generating any code, scan the PRD for:
- **Entities**: nouns that persist (users, children, results, articles…)
- **Actions**: verbs that imply API calls (submit, fetch, publish, delete…)
- **Roles**: user types with different permissions or UX flows
- **Algorithms**: scoring formulas, classification rules, overrides
- **States**: status fields (draft/published, low/medium/high, verified/pending)
- **Relationships**: which entities reference others (child belongs to parent)

Map these to models, repository methods, and seed entries before writing code.

---

## Quality Bar

A good implementation plan output:
- Compiles without errors if copy-pasted into a fresh Flutter project
- Has no magic strings (all constants are named)
- Has no placeholder comments that a developer would have to figure out
- Seed data is realistic enough to use in a demo without embarrassment
- Every module in the PRD's MVP phase has a binding, controller, and view stub

If the PRD is incomplete or ambiguous, flag the gaps explicitly (e.g.,
"PRD does not specify how doctors are linked to patients — defaulting to
admin-assigned for Phase 1, flagging for Phase 2").