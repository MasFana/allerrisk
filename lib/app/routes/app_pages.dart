import 'package:get/get.dart';
import 'app_routes.dart';

import '../modules/splash/splash_binding.dart';
import '../modules/splash/splash_view.dart';

import '../modules/onboarding/onboarding_binding.dart';
import '../modules/onboarding/onboarding_view.dart';

import '../modules/role_selector/role_selector_binding.dart';
import '../modules/role_selector/role_selector_view.dart';

import '../modules/auth/login/login_binding.dart';
import '../modules/auth/login/login_view.dart';

import '../modules/auth/register/register_binding.dart';
import '../modules/auth/register/register_view.dart';

import '../modules/auth/forgot_password/forgot_password_binding.dart';
import '../modules/auth/forgot_password/forgot_password_view.dart';

// ── Parent Shell (hosts the 4 main tabs) ──────────────────────────────────
import '../modules/parent/shell/parent_shell_binding.dart';
import '../modules/parent/shell/parent_shell_view.dart';


import '../modules/parent/child_profile/child_profile_binding.dart';
import '../modules/parent/child_profile/child_profile_list_view.dart';
import '../modules/parent/child_profile/child_profile_form_view.dart';

import '../modules/parent/assessment/assessment_binding.dart';
import '../modules/parent/assessment/assessment_view.dart';

import '../modules/parent/assessment_result/result_binding.dart';
import '../modules/parent/assessment_result/result_view.dart';

import '../modules/parent/assessment_history/history_binding.dart';
import '../modules/parent/assessment_history/history_view.dart';

import '../modules/parent/article/article_list_binding.dart' as parent_articles;
import '../modules/parent/article/article_list_view.dart' as parent_articles;
import '../modules/parent/article/article_detail_binding.dart';
import '../modules/parent/article/article_detail_view.dart';

import '../modules/parent/settings/settings_binding.dart' as parent_settings;
import '../modules/parent/settings/settings_view.dart' as parent_settings;

import '../modules/doctor/shell/doctor_shell_binding.dart';
import '../modules/doctor/shell/doctor_shell_view.dart';

import '../modules/doctor/dashboard/dashboard_binding.dart';
import '../modules/doctor/dashboard/dashboard_view.dart';

import '../modules/doctor/patients/patient_list_binding.dart';
import '../modules/doctor/patients/patient_list_view.dart';
import '../modules/doctor/patients/patient_detail_binding.dart';
import '../modules/doctor/patients/patient_detail_view.dart';

import '../modules/doctor/article/article_list_binding.dart' as doctor_articles;
import '../modules/doctor/article/article_list_view.dart' as doctor_articles;
import '../modules/doctor/article/article_editor_binding.dart';
import '../modules/doctor/article/article_editor_view.dart';

import '../modules/doctor/settings/settings_binding.dart' as doctor_settings;
import '../modules/doctor/settings/settings_view.dart' as doctor_settings;

abstract class AppPages {
  static final routes = <GetPage>[
    GetPage(
      name: Routes.SPLASH,
      page: () => const SplashView(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: Routes.ONBOARDING,
      page: () => const OnboardingView(),
      binding: OnboardingBinding(),
    ),
    GetPage(
      name: Routes.ROLE_SELECTOR,
      page: () => const RoleSelectorView(),
      binding: RoleSelectorBinding(),
    ),
    GetPage(
      name: Routes.LOGIN,
      page: () => const LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: Routes.REGISTER,
      page: () => const RegisterView(),
      binding: RegisterBinding(),
    ),
    GetPage(
      name: Routes.FORGOT_PASSWORD,
      page: () => const ForgotPasswordView(),
      binding: ForgotPasswordBinding(),
    ),
    GetPage(
      name: Routes.PARENT_HOME,
      page: () => const ParentShellView(),
      binding: ParentShellBinding(),
    ),
    GetPage(
      name: Routes.CHILD_LIST,
      page: () => const ChildProfileListView(),
      binding: ChildProfileBinding(),
    ),
    GetPage(
      name: Routes.CHILD_FORM,
      page: () => const ChildProfileFormView(),
      binding: ChildProfileBinding(),
    ),
    GetPage(
      name: Routes.ASSESSMENT,
      page: () => const AssessmentView(),
      binding: AssessmentBinding(),
    ),
    GetPage(
      name: Routes.ASSESSMENT_RESULT,
      page: () => const ResultView(),
      binding: ResultBinding(),
    ),
    GetPage(
      name: Routes.ASSESSMENT_HISTORY,
      page: () => const HistoryView(),
      binding: HistoryBinding(),
    ),
    GetPage(
      name: Routes.PARENT_ARTICLES,
      page: () => const parent_articles.ArticleListView(),
      binding: parent_articles.ArticleListBinding(),
    ),
    GetPage(
      name: Routes.PARENT_ARTICLE_DETAIL,
      page: () => const ArticleDetailView(),
      binding: ArticleDetailBinding(),
    ),
    GetPage(
      name: Routes.PARENT_SETTINGS,
      page: () => const parent_settings.SettingsView(),
      binding: parent_settings.SettingsBinding(),
    ),
    GetPage(
      name: Routes.DOCTOR_SHELL,
      page: () => const DoctorShellView(),
      binding: DoctorShellBinding(),
    ),
    GetPage(
      name: Routes.DOCTOR_DASHBOARD,
      page: () => const DashboardView(),
      binding: DashboardBinding(),
    ),
    GetPage(
      name: Routes.PATIENT_LIST,
      page: () => const PatientListView(),
      binding: PatientListBinding(),
    ),
    GetPage(
      name: Routes.PATIENT_DETAIL,
      page: () => const PatientDetailView(),
      binding: PatientDetailBinding(),
    ),
    GetPage(
      name: Routes.DOCTOR_ARTICLES,
      page: () => const doctor_articles.DoctorArticleListView(),
      binding: doctor_articles.ArticleListBinding(),
    ),
    GetPage(
      name: Routes.ARTICLE_EDITOR,
      page: () => const ArticleEditorView(),
      binding: ArticleEditorBinding(),
    ),
    GetPage(
      name: Routes.DOCTOR_SETTINGS,
      page: () => const doctor_settings.DoctorSettingsView(),
      binding: doctor_settings.SettingsBinding(),
    ),
  ];
}
