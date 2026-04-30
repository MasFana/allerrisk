// ignore_for_file: constant_identifier_names

/// AllerRisk named route constants.
/// PLAN.md §3 + FE_PLAN.md §3
abstract class Routes {
  // ── Pre-auth ─────────────────────────────────────────────────
  static const String SPLASH = '/';
  static const String ONBOARDING = '/onboarding';
  static const String ROLE_SELECTOR = '/role-selector';

  // ── Auth (role passed as Get.arguments) ──────────────────────
  static const String LOGIN = '/login';
  static const String REGISTER = '/register';
  static const String FORGOT_PASSWORD = '/forgot-password';

  // ── Parent ────────────────────────────────────────────────────
  /// Shell entry — hosts the 4-tab bottom nav.
  static const String PARENT_HOME = '/parent';
  static const String PARENT_SHELL = '/parent'; // alias
  static const String CHILD_LIST = '/parent/children';
  static const String CHILD_FORM = '/parent/children/form';
  static const String ASSESSMENT = '/parent/assessment';
  static const String ASSESSMENT_RESULT = '/parent/assessment/result';
  static const String ASSESSMENT_HISTORY = '/parent/assessment/history';
  static const String PARENT_ARTICLES = '/parent/articles';
  static const String PARENT_ARTICLE_DETAIL = '/parent/articles/detail';
  static const String PARENT_SETTINGS = '/parent/settings';

  // ── Doctor ────────────────────────────────────────────────────
  /// Shell entry — hosts the 4-tab bottom nav.
  static const String DOCTOR_SHELL = '/doctor';
  static const String DOCTOR_DASHBOARD = '/doctor/dashboard';
  static const String PATIENT_LIST = '/doctor/patients';
  static const String PATIENT_DETAIL = '/doctor/patients/detail';
  static const String DOCTOR_ARTICLES = '/doctor/articles';
  static const String ARTICLE_EDITOR = '/doctor/articles/editor';
  static const String DOCTOR_SETTINGS = '/doctor/settings';
}
