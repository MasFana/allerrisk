---
name: flutter-getx-scaffolding
description: >
  Generate complete Flutter + GetX module scaffolds from a feature name or
  description. Use this skill whenever the user asks to scaffold, generate,
  create, or stub out a new Flutter screen, module, feature, or page — even if
  they just say things like "add a settings screen", "make a new module for X",
  or "create the GetX files for Y". Also triggers when the user asks about
  GetX folder structure, bindings, controller boilerplate, or named route
  registration. Always prefer this skill over writing Flutter/GetX code from
  scratch.
---

# Flutter + GetX Module Scaffolding

Generate production-ready module scaffolds following the AllerRisk project
conventions. Every module is a self-contained triplet (or more) of files that
keeps concerns cleanly separated and makes swapping implementations easy.

---

## Canonical Folder Convention

All modules live under `lib/app/modules/<role>/<feature>/` where role is one of:
`parent`, `doctor`, or shared (no role prefix for auth/onboarding/splash).

```
lib/app/modules/<role>/<feature>/
├── <feature>_binding.dart      # Dependency wiring (always present)
├── <feature>_controller.dart   # Business logic + reactive state
└── <feature>_view.dart         # UI (can split into list/form/detail views)
```

When a feature has multiple views (e.g., list + form, or a multi-step flow),
create one controller and one binding, but multiple view files:
`<feature>_list_view.dart`, `<feature>_form_view.dart`, etc.

---

## File Templates

### Binding

Bindings wire repositories to controllers. Always use `lazyPut` so objects are
only created when first accessed. The binding is also where you swap
`MockXRepository` for `RemoteXRepository` in production — controllers never
need to change.

```dart
// <feature>_binding.dart
import 'package:get/get.dart';
import '../../../data/repositories/interfaces/i_<domain>_repository.dart';
import '../../../data/repositories/mock/mock_<domain>_repository.dart';
import '<feature>_controller.dart';

class <Feature>Binding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<I<Domain>Repository>(() => Mock<Domain>Repository());
    Get.lazyPut<<Feature>Controller>(
      () => <Feature>Controller(repository: Get.find()),
    );
  }
}
```

### Controller

Controllers extend `GetxController`. All mutable UI state is declared as `Rx`
observables. Use `ever()` / `debounce()` workers in `onInit` for reactive side
effects. Inject repositories via constructor so they're testable.

```dart
// <feature>_controller.dart
import 'package:get/get.dart';
import '../../../data/repositories/interfaces/i_<domain>_repository.dart';

class <Feature>Controller extends GetxController {
  final I<Domain>Repository _repository;

  <Feature>Controller({required I<Domain>Repository repository})
      : _repository = repository;

  // ── State ────────────────────────────────────────────────────
  final RxBool isLoading = false.obs;
  // Add feature-specific Rx fields here

  // ── Lifecycle ────────────────────────────────────────────────
  @override
  void onInit() {
    super.onInit();
    _load();
  }

  // ── Methods ──────────────────────────────────────────────────
  Future<void> _load() async {
    isLoading.value = true;
    try {
      // TODO: call repository and update state
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
```

### View

Views are `StatelessWidget`. Wrap reactive sections in `Obx`. Access the
controller via `Get.find<FeatureController>()` (or declare a local getter).
Never put business logic in views.

```dart
// <feature>_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '<feature>_controller.dart';

class <Feature>View extends StatelessWidget {
  const <Feature>View({super.key});

  <Feature>Controller get _c => Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('<Feature Title>')),
      body: Obx(() {
        if (_c.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        return const Placeholder(); // Replace with actual UI
      }),
    );
  }
}
```

---

## Named Route Registration

After scaffolding a module, add its route to two files:

**`lib/app/routes/app_routes.dart`** — add the constant:
```dart
static const <FEATURE> = '/<role>/<feature>';
```

**`lib/app/routes/app_pages.dart`** — add a `GetPage` entry:
```dart
GetPage(
  name: Routes.<FEATURE>,
  page: () => const <Feature>View(),
  binding: <Feature>Binding(),
),
```

---

## Multi-Step Forms (PageView pattern)

When scaffolding assessment-style multi-step flows, use a single controller
that owns all step data and drives a `PageController`. Views for individual
steps go in a `steps/` subfolder:

```
assessment/
├── assessment_binding.dart
├── assessment_controller.dart
├── assessment_view.dart          # hosts PageView
└── steps/
    ├── step_one_view.dart
    └── step_two_view.dart
```

The controller exposes:
```dart
final PageController pageController = PageController();
final RxInt currentStep = 0.obs;
void nextStep() { ... }
void previousStep() { ... }
bool get canProceed { ... }  // per-step validation
```

---

## Output Instructions

When generating a scaffold, produce the full file content for each file — not
just snippets. Use proper Dart formatting. Fill in any Rx fields and methods
that are clearly implied by the feature name or description. If the feature
interacts with an existing domain (e.g., ChildProfile, Article), import and
use the correct model class.

Include a short summary at the end listing:
1. Files created
2. Route constant + GetPage entry to add
3. Any imports that need to be added elsewhere