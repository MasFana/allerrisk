# AllerRisk — Frontend PRD (Flutter + GetX)
**Version:** 2.0 | **Status:** Detailed Specification | **Platform:** Flutter (iOS & Android)

---

## 1. Gap Analysis: What Was Missing

The original PRD had good backend logic but left the frontend severely underspecified. Below are the identified gaps filled in this document:

| Gap | Resolution |
|-----|-----------|
| No auth screens (Login, Register, Forgot Password) | Added as full module |
| No Splash / Onboarding flow | Added with role persistence logic |
| No Child Profile CRUD | Added `ChildProfileModule` with multi-child support |
| No Assessment History | Added under Parent Beranda |
| No Notification system | Added `NotificationModule` (in-app + push) |
| No Settings / Account screens | Added per-role settings |
| No Doctor auth/onboarding | Added Doctor registration with credential verification state |
| No PDF export screen | Added `ResultShareScreen` with export CTA |
| No GetX folder structure | Full directory tree specified below |
| No data models defined | Full Dart model specs in Section 5 |
| No routing map | Named routes + binding injection map in Section 6 |
| No API contract (frontend view) | Request/response shapes per endpoint in Section 7 |
| Article Editor (Doctor) underspecified | Full rich text + image upload spec |

---

## 2. Flutter GetX Folder Structure

```
lib/
├── main.dart
├── app/
│   ├── app.dart                        # MaterialApp + GetMaterialApp root
│   │
│   ├── core/
│   │   ├── theme/
│   │   │   ├── app_theme.dart          # ThemeData light + dark
│   │   │   ├── app_colors.dart         # Color constants
│   │   │   ├── app_typography.dart     # TextTheme definitions
│   │   │   └── app_dimensions.dart     # spacing, radius, breakpoints
│   │   ├── utils/
│   │   │   ├── validators.dart         # Form field validators (pure fns)
│   │   │   ├── formatters.dart         # Date, number formatters
│   │   │   ├── extensions.dart         # Dart extensions (String, DateTime)
│   │   │   └── logger.dart             # Structured debug logger
│   │   ├── constants/
│   │   │   ├── api_constants.dart      # Base URL, endpoint paths
│   │   │   ├── storage_keys.dart       # GetStorage key constants
│   │   │   └── app_strings.dart        # Localization-ready string keys
│   │   └── widgets/                    # Shared/reusable widgets
│   │       ├── allerisk_button.dart
│   │       ├── allerisk_text_field.dart
│   │       ├── risk_meter_widget.dart  # Animated gauge (Rendah/Sedang/Tinggi)
│   │       ├── loading_overlay.dart
│   │       ├── error_snackbar.dart
│   │       ├── article_card.dart
│   │       └── child_avatar_widget.dart
│   │
│   ├── data/
│   │   ├── models/
│   │   │   ├── user_model.dart
│   │   │   ├── child_profile_model.dart
│   │   │   ├── assessment_model.dart
│   │   │   ├── assessment_result_model.dart
│   │   │   ├── article_model.dart
│   │   │   ├── patient_model.dart
│   │   │   └── notification_model.dart
│   │   ├── providers/
│   │   │   ├── auth_provider.dart      # HTTP calls: /auth/*
│   │   │   ├── assessment_provider.dart
│   │   │   ├── article_provider.dart
│   │   │   ├── patient_provider.dart
│   │   │   └── profile_provider.dart
│   │   └── repositories/
│   │       ├── auth_repository.dart    # Bridges provider ↔ controller
│   │       ├── assessment_repository.dart
│   │       ├── article_repository.dart
│   │       └── patient_repository.dart
│   │
│   ├── services/
│   │   ├── auth_service.dart           # GetxService, JWT + session state
│   │   ├── storage_service.dart        # GetStorage wrapper
│   │   ├── notification_service.dart   # FCM integration
│   │   └── pdf_service.dart            # PDF generation (pdf package)
│   │
│   ├── routes/
│   │   ├── app_routes.dart             # Named route constants
│   │   └── app_pages.dart              # GetPage list with bindings
│   │
│   └── modules/
│       │
│       ├── splash/
│       │   ├── splash_binding.dart
│       │   ├── splash_controller.dart
│       │   └── splash_view.dart
│       │
│       ├── onboarding/
│       │   ├── onboarding_binding.dart
│       │   ├── onboarding_controller.dart
│       │   └── onboarding_view.dart
│       │
│       ├── role_selector/
│       │   ├── role_selector_binding.dart
│       │   ├── role_selector_controller.dart
│       │   └── role_selector_view.dart
│       │
│       ├── auth/
│       │   ├── login/
│       │   │   ├── login_binding.dart
│       │   │   ├── login_controller.dart
│       │   │   └── login_view.dart
│       │   ├── register/
│       │   │   ├── register_binding.dart
│       │   │   ├── register_controller.dart
│       │   │   └── register_view.dart
│       │   └── forgot_password/
│       │       ├── forgot_password_binding.dart
│       │       ├── forgot_password_controller.dart
│       │       └── forgot_password_view.dart
│       │
│       ├── parent/
│       │   ├── home/                        # Beranda
│       │   │   ├── home_binding.dart
│       │   │   ├── home_controller.dart
│       │   │   └── home_view.dart
│       │   ├── child_profile/               # CRUD anak
│       │   │   ├── child_profile_binding.dart
│       │   │   ├── child_profile_controller.dart
│       │   │   ├── child_profile_list_view.dart
│       │   │   └── child_profile_form_view.dart
│       │   ├── assessment/
│       │   │   ├── assessment_binding.dart
│       │   │   ├── assessment_controller.dart
│       │   │   ├── assessment_view.dart     # Host PageView
│       │   │   └── steps/
│       │   │       ├── step_genetics_view.dart
│       │   │       ├── step_symptoms_view.dart
│       │   │       ├── step_history_view.dart
│       │   │       └── step_environment_view.dart
│       │   ├── assessment_result/
│       │   │   ├── result_binding.dart
│       │   │   ├── result_controller.dart
│       │   │   ├── result_view.dart
│       │   │   └── result_share_view.dart   # PDF export / share
│       │   ├── assessment_history/
│       │   │   ├── history_binding.dart
│       │   │   ├── history_controller.dart
│       │   │   └── history_view.dart
│       │   ├── article/
│       │   │   ├── article_list_binding.dart
│       │   │   ├── article_list_controller.dart
│       │   │   ├── article_list_view.dart
│       │   │   ├── article_detail_binding.dart
│       │   │   ├── article_detail_controller.dart
│       │   │   └── article_detail_view.dart
│       │   └── settings/
│       │       ├── settings_binding.dart
│       │       ├── settings_controller.dart
│       │       └── settings_view.dart
│       │
│       └── doctor/
│           ├── dashboard/
│           │   ├── dashboard_binding.dart
│           │   ├── dashboard_controller.dart
│           │   └── dashboard_view.dart
│           ├── patients/
│           │   ├── patient_list_binding.dart
│           │   ├── patient_list_controller.dart
│           │   ├── patient_list_view.dart
│           │   ├── patient_detail_binding.dart
│           │   ├── patient_detail_controller.dart
│           │   └── patient_detail_view.dart
│           ├── article/
│           │   ├── article_list_binding.dart
│           │   ├── article_list_controller.dart
│           │   ├── article_list_view.dart
│           │   ├── article_editor_binding.dart
│           │   ├── article_editor_controller.dart
│           │   └── article_editor_view.dart
│           └── settings/
│               ├── settings_binding.dart
│               ├── settings_controller.dart
│               └── settings_view.dart
```

---

## 3. Named Routes Map

```dart
// app_routes.dart
abstract class Routes {
  static const SPLASH           = '/';
  static const ONBOARDING       = '/onboarding';
  static const ROLE_SELECTOR    = '/role-selector';

  // Auth (shared, role passed as argument)
  static const LOGIN            = '/login';
  static const REGISTER         = '/register';
  static const FORGOT_PASSWORD  = '/forgot-password';

  // Parent
  static const PARENT_HOME      = '/parent/home';
  static const CHILD_LIST       = '/parent/children';
  static const CHILD_FORM       = '/parent/children/form';
  static const ASSESSMENT       = '/parent/assessment';
  static const ASSESSMENT_RESULT= '/parent/assessment/result';
  static const ASSESSMENT_HISTORY='/parent/assessment/history';
  static const PARENT_ARTICLES  = '/parent/articles';
  static const PARENT_ARTICLE_DETAIL = '/parent/articles/:id';
  static const PARENT_SETTINGS  = '/parent/settings';

  // Doctor
  static const DOCTOR_DASHBOARD = '/doctor/dashboard';
  static const PATIENT_LIST     = '/doctor/patients';
  static const PATIENT_DETAIL   = '/doctor/patients/:id';
  static const DOCTOR_ARTICLES  = '/doctor/articles';
  static const ARTICLE_EDITOR   = '/doctor/articles/editor';
  static const DOCTOR_SETTINGS  = '/doctor/settings';
}
```

**Navigation logic in `SplashController`:**
```
StorageService.hasSeenOnboarding?
  → No  → ONBOARDING
  → Yes → AuthService.isLoggedIn?
            → No  → ROLE_SELECTOR
            → Yes → AuthService.role == 'parent'
                      → PARENT_HOME
                      → DOCTOR_DASHBOARD
```

---

## 4. Screen-by-Screen Specification

---

### 4.1 Splash Screen

**Purpose:** Cold-start init. Initialize services, check token validity.

**Controller:** `SplashController extends GetxController`
- `onInit()`: calls `StorageService.init()`, `AuthService.validateToken()`
- Navigates after 1.5s minimum display (UX grace period)

**UI:**
- App logo centered, animated (scale + fade in)
- Brand tagline: *"Deteksi Dini, Lindungi Si Kecil"*
- No user interaction

---

### 4.2 Onboarding Screen

**Purpose:** First-time value proposition. Shown once, persisted via `GetStorage`.

**Controller:** `OnboardingController`
- `RxInt currentPage = 0.obs`
- `void skipOnboarding()` → sets flag, navigates to ROLE_SELECTOR
- `void nextPage()` / `void onPageChanged(int)`

**UI:** `PageView` with 3 slides + dot indicator + Skip/Next/Mulai button

| Slide | Ilustrasi | Judul | Deskripsi |
|-------|-----------|-------|-----------|
| 1 | Anak bermain | "Kenali Risiko Sejak Dini" | Alergi anak bisa dicegah jika dideteksi lebih awal. |
| 2 | Dokter & form | "Berbasis Standar Medis" | Kuesioner ISAAC & NICE yang digunakan dokter spesialis. |
| 3 | Hasil & grafik | "Rekomendasi Instan" | Dapatkan stratifikasi risiko dan langkah nyata dalam menit. |

---

### 4.3 Role Selector Screen

**Purpose:** User explicitly picks their role before registration/login. Role is stored in `GetStorage` and passed as argument to auth screens.

**Controller:** `RoleSelectorController`
- `Rx<UserRole?> selectedRole = Rx(null)`
- `void selectRole(UserRole role)` → updates obs, enables CTA

**UI:**
- Two large cards (side-by-side or stacked):
  - **Orang Tua** — icon: family/child, subtitle: *"Pantau risiko alergi anak Anda"*
  - **Dokter** — icon: stethoscope, subtitle: *"Kelola pasien dan publikasi edukasi"*
- Selected card gets highlighted border + check badge
- CTA: "Lanjutkan" → `Get.toNamed(Routes.LOGIN, arguments: selectedRole.value)`
- Below CTA: "Sudah punya akun? Masuk" link

**Data passed forward:** `UserRole` enum (`parent` | `doctor`)

---

### 4.4 Login Screen

**Purpose:** Authenticate existing user. Role-aware (UI heading changes, doctor gets extra "Nomor STR" hint).

**Controller:** `LoginController`
```dart
final emailController = TextEditingController();
final passwordController = TextEditingController();
RxBool isLoading = false.obs;
RxBool obscurePassword = true.obs;
late UserRole role; // injected via Get.arguments

Future<void> login() async { ... }
Future<void> signInWithGoogle() async { ... }
```

**UI Components:**
- Role-aware header text (e.g., *"Masuk sebagai Orang Tua"*)
- Email TextField + Password TextField (with show/hide toggle)
- "Lupa kata sandi?" link → `Routes.FORGOT_PASSWORD`
- Primary CTA: "Masuk" (disables during loading)
- Divider "atau"
- Google Sign-In button (Apple on iOS via `sign_in_with_apple`)
- Footer: "Belum punya akun? Daftar" → `Routes.REGISTER` with same role arg

**Validation:** Email format + password min 8 chars, shown inline (not via dialog).

**Error Handling:** `GetSnackbar` for wrong credentials, network error.

---

### 4.5 Register Screen

**Purpose:** New account creation. Two variants based on role.

**Controller:** `RegisterController`
```dart
// Common fields
RxString name, email, password, confirmPassword;
Rx<UserRole> role;

// Doctor-only
RxString strNumber;  // Surat Tanda Registrasi dokter
RxString specialty;

Future<void> register() async { ... }
```

**UI:** Single scrollable form with conditional section for doctor fields.

**Fields (Parent):**
- Nama Lengkap
- Email
- Password + Konfirmasi Password
- Checkbox: Setuju dengan Syarat & Ketentuan

**Additional Fields (Doctor):**
- Nomor STR (Surat Tanda Registrasi)
- Spesialisasi (Dropdown: SpA, SpKK, Umum, dll)
- Rumah Sakit / Klinik (optional)

**Post-registration flow:**
- Parent → Email verification prompt → `Routes.PARENT_HOME`
- Doctor → "Akun dalam verifikasi" intermediate screen (admin reviews STR before full access)

---

### 4.6 Forgot Password Screen

Standard email input → OTP/link via email → reset form. Three-step view managed by a `RxInt step = 0.obs` in `ForgotPasswordController`. No separate routes needed; handled in-screen.

---

### 4.7 Parent: Beranda (Home)

**Purpose:** Hub screen. Shows active child context, last assessment, quick access CTA.

**Controller:** `ParentHomeController`
```dart
// Reactive state
Rx<ChildProfile?> activeChild;
RxList<AssessmentResult> recentAssessments;
RxList<Article> featuredArticles;
RxBool isLoading = false.obs;

void onInit() → loadDashboard()
void switchActiveChild(String childId)
void startNewAssessment()
```

**UI Sections (top to bottom):**

**Header:**
- Greeting: "Halo, [NamaOrtu] 👋"
- Notification bell icon (badge count if unread)

**Active Child Switcher:**
- Horizontal scrollable chips showing child names + age
- "+ Tambah Anak" chip at end
- Selected child shows full card: photo/avatar, name, DOB, last risk level badge

**Risk Summary Card (per active child):**
- Last assessment date
- Risk gauge (mini version of `RiskMeterWidget`)
- Score (e.g., 6.2 / 10) + level label (Sedang)
- CTA: "Asesmen Ulang" or "Mulai Asesmen Pertama" if none exists

**Assessment History Strip:**
- Last 3 results as small horizontal cards (date + score + color-coded level)
- "Lihat Semua" link → `Routes.ASSESSMENT_HISTORY`

**Artikel Edukasi:**
- 2 featured article cards (thumbnail + title + category tag)
- "Lihat Semua Artikel" → `Routes.PARENT_ARTICLES`

**Bottom Navigation Bar:** Beranda | Asesmen | Artikel | Profil

---

### 4.8 Child Profile Management

**Child List View (`child_profile_list_view.dart`):**
- List of child cards (name, age, last risk level)
- FAB: "+ Tambah Anak"
- Swipe-to-delete with confirmation dialog
- Tap to edit → `Routes.CHILD_FORM` with child as argument

**Child Form View (`child_profile_form_view.dart`):**
- Mode: Create | Edit (detected via null check on argument)
- Fields:
  - Foto Anak (optional, camera/gallery picker)
  - Nama Anak (required)
  - Tanggal Lahir (DatePicker, required) — auto-calculates age display
  - Jenis Kelamin (Radio: Laki-laki / Perempuan)
  - Berat Badan (kg, decimal)
  - Tinggi Badan (cm)
  - Catatan tambahan (optional, max 200 chars)

**Controller:** `ChildProfileController`
```dart
Rx<ChildProfile?> editingChild;  // null = create mode
RxList<ChildProfile> children;

Future<void> saveChild() async { ... }
Future<void> deleteChild(String id) async { ... }
void selectActiveChild(String id) // updates AuthService.activeChildId
```

---

### 4.9 Parent: Assessment (Multi-step Form)

**Architecture:** Single `AssessmentView` hosts a `PageView` (non-swipeable, controlled programmatically). One `AssessmentController` owns all step data.

**Controller:** `AssessmentController`
```dart
final PageController pageController = PageController();
RxInt currentStep = 0.obs;  // 0-3
RxDouble stepProgress = 0.0.obs; // for progress bar

// Step 1 - Genetika
RxBool motherHasAtopy = false.obs;
RxBool fatherHasAtopy = false.obs;
RxBool siblingHasAtopy = false.obs;
RxInt geneticScore = 0.obs; // computed from above

// Step 2 - Gejala Aktif (CRITICAL: anafilaksis triggers override)
RxBool hasAnaphylaxis = false.obs;  // → override to HIGH immediately
RxBool hasUrticaria = false.obs;
RxBool hasVomitingAfterFood = false.obs;
RxBool hasRhinitisSymptoms = false.obs;
RxBool hasWheeze = false.obs;

// Step 3 - Riwayat Penyakit
RxBool hasDermatitis = false.obs;
RxBool hasEczema = false.obs;
RxBool hasPreviousFoodReaction = false.obs;

// Step 4 - Faktor Lingkungan
RxBool smokingHousehold = false.obs;
RxBool hasPets = false.obs;
RxBool highDustEnvironment = false.obs;
RxBool nearPollution = false.obs;

void nextStep()
void previousStep()
bool get canProceed  // per-step validation
Future<void> submitAssessment()  // POST to API
```

**Override Logic (FR 3.3):** When `hasAnaphylaxis` toggles to `true`, show inline warning banner: *"⚠️ Gejala ini memerlukan perhatian medis segera. Anda tetap dapat melanjutkan asesmen."*. Backend handles the override, but UI must NOT skip remaining steps — user still completes them for data completeness.

**Header (persistent across all steps):**
- Back arrow (with discard confirmation dialog)
- "Asesmen Risiko Alergi" title
- Step progress bar: `LinearProgressIndicator(value: (currentStep+1)/4)`
- Step label: "Langkah 1 dari 4"

**Step 1 — Riwayat Genetik / Keluarga:**

| Field | Type | Bobot Kontribusi |
|-------|------|-----------------|
| Ibu memiliki alergi/asma/eksim | Toggle | +1.0 |
| Ayah memiliki alergi/asma/eksim | Toggle | +1.0 |
| Saudara kandung memiliki alergi | Toggle | +0.5 |
| Nenek/Kakek (paternal/maternal) pernah didiagnosis atopi | Toggle | +0.5 |

UI: Each item as a labeled card with toggle switch. Short explanatory subtitle per item (e.g., "Atopi: asma, rinitis alergi, eksim, atau alergi makanan"). Running score indicator (optional, design choice).

**Step 2 — Gejala Aktif Anak:**

| Field | Type | Note |
|-------|------|------|
| Sesak napas/anafilaksis setelah makan | Toggle (RED) | Triggers override banner |
| Ruam/gatal-gatal < 1 jam setelah makan | Toggle | |
| Muntah/diare < 1 jam setelah makan | Toggle | |
| Bersin/hidung gatal/meler (bukan flu) | Toggle | |
| Mengi/bunyi ngik saat bernapas | Toggle | |
| Mata merah/gatal setelah paparan | Toggle | |

UI: Anafilaksis item styled distinctively (warning color border, icon). Instruction text: *"Pilih gejala yang pernah atau sering dialami anak dalam 3 bulan terakhir."*

**Step 3 — Riwayat Penyakit Anak:**

| Field | Type |
|-------|------|
| Pernah didiagnosis Dermatitis Atopik / Eksim | Toggle |
| Kulit kering dan gatal persisten sejak bayi | Toggle |
| Pernah rawat inap karena reaksi alergi | Toggle |
| Pernah diberikan antihistamin oleh dokter | Toggle |
| Memiliki riwayat infeksi telinga berulang | Toggle |

**Step 4 — Faktor Lingkungan:**

| Field | Type |
|-------|------|
| Ada anggota keluarga yang merokok di rumah | Toggle |
| Memelihara hewan berbulu (anjing/kucing) | Toggle |
| Lingkungan berdebu / jarang dibersihkan | Toggle |
| Dekat jalan raya / area polusi tinggi | Toggle |
| Menggunakan karpet / boneka bulu di kamar anak | Toggle |

**Step 4 Footer:** "Hitung Risiko" CTA button (replaces "Selanjutnya"). Shows loading state while awaiting API response. On success → navigate to `Routes.ASSESSMENT_RESULT` passing `AssessmentResult` as argument.

---

### 4.10 Parent: Assessment Result

**Controller:** `ResultController`
```dart
Rx<AssessmentResult> result;  // injected via Get.arguments
RxBool isGeneratingPdf = false.obs;

Future<void> exportPdf() async { ... }
Future<void> shareResult() async { ... }
void bookmarkResult() { ... }
```

**UI Sections:**

**Hero Section:**
- Animated `RiskMeterWidget` (custom gauge, animates from 0 to `result.score` on mount)
  - Arc gauge: green (0-3.9), yellow (4-6.9), red (7-10)
  - Center: large score text (e.g., **7.5**)
  - Below gauge: level badge — pill shape with color (e.g., 🔴 RISIKO TINGGI)
- Child name + assessment date subtitle

**Score Breakdown Card:**
- Expandable section showing per-criterion contribution:
  - Genetik: 2.4 / 3.0
  - Gejala Aktif: 3.2 / 4.0
  - Riwayat Penyakit: 1.4 / 2.0
  - Lingkungan: 0.5 / 1.0
- Bar chart or segmented display per criterion

**Rekomendasi Section:** (content driven by API response)

| Level | Content |
|-------|---------|
| Rendah (1–3.9) | Edukasi pantau mandiri. Checklist lingkungan aman. Kapan perlu ke dokter. |
| Sedang (4–6.9) | Jadwalkan ke Puskesmas/klinik. Daftar pertanyaan untuk dokter. Artikel relevan. |
| Tinggi (7–10) | Warning card merah. CTA: "Cari Dokter Spesialis Anak Terdekat". Emergency triggers. |

**Rekomendasi Tinggi — special UI:**
- Red alert card at top: *"Segera konsultasikan dengan Dokter Spesialis Anak (Sp.A)"*
- If anafilaksis override triggered: *"⚠️ Gejala anafilaksis terdeteksi. Ini kondisi darurat medis."*

**Action Buttons:**
- "Simpan & Ekspor PDF" → calls `pdf_service.dart`, generates formatted PDF
- "Bagikan Hasil" → system share sheet
- "Asesmen Ulang" → back to `Routes.ASSESSMENT`
- "Kembali ke Beranda" → `Routes.PARENT_HOME`

**PDF Content:**
- AllerRisk header + logo
- Child profile summary
- Assessment date
- Score + level
- Criterion breakdown table
- Full recommendation text
- Disclaimer: *"Hasil ini bukan diagnosis medis. Konsultasikan dengan tenaga kesehatan."*

---

### 4.11 Parent: Assessment History

**Controller:** `AssessmentHistoryController`
```dart
Rx<ChildProfile?> selectedChild;
RxList<AssessmentResult> history;
RxString filterLevel = 'all'.obs; // 'all' | 'low' | 'medium' | 'high'

void loadHistory(String childId)
```

**UI:**
- Child switcher tabs at top
- Filter chips: Semua | Rendah | Sedang | Tinggi
- Timeline list: each item shows date, score, level badge, "Lihat Detail" link
- Line chart (optional, stretch): score trend over time using `fl_chart`
- Empty state: illustration + "Belum ada asesmen untuk anak ini"

---

### 4.12 Parent: Article List

**Controller:** `ParentArticleListController`
```dart
RxList<Article> articles;
RxString searchQuery = ''.obs;
RxString selectedCategory = 'all'.obs;
RxBool isLoading = false.obs;

// Debounced search
void onSearchChanged(String q)  // 300ms debounce
void loadArticles()
```

**UI:**
- Search bar (persistent, top)
- Category filter chips (horizontal scroll): Semua | Alergi Makanan | Asma | Eksim | Lingkungan | Tips Orang Tua
- Article grid/list cards:
  - Thumbnail image
  - Category tag
  - Title (max 2 lines)
  - Author name (doctor) + publish date
  - Read time estimate
- Pull-to-refresh
- Pagination (infinite scroll with `ScrollController` + `isLoadingMore.obs`)

---

### 4.13 Parent: Article Detail

**Controller:** `ParentArticleDetailController`
```dart
Rx<Article> article;  // loaded by articleId from Get.parameters['id']
RxBool isBookmarked = false.obs;
RxList<Article> relatedArticles;

void toggleBookmark()
void shareArticle()
```

**UI:**
- Hero image (full-width, `SliverAppBar`)
- Category chip + title
- Author card: doctor avatar, name, specialty, date
- Rich text body (rendered from HTML/Markdown via `flutter_html` or `flutter_markdown`)
- "Artikel Terkait" section (3 cards, horizontal scroll)
- Floating share + bookmark action bar

---

### 4.14 Parent: Settings

**Sections:**
- **Akun:** Nama, Email, foto profil, ganti password
- **Anak:** Shortcut ke Child Profile List
- **Notifikasi:** Toggle push notif, reminder asesmen berkala
- **Tampilan:** Theme toggle (Light/Dark), ukuran teks
- **Privasi & Keamanan:** Link ke kebijakan privasi, hapus akun
- **Tentang Aplikasi:** Versi, lisensi, kontak

---

### 4.15 Doctor: Dashboard

**Purpose:** Operational overview for the doctor.

**Controller:** `DoctorDashboardController`
```dart
RxInt totalPatients = 0.obs;
RxInt newPatientsThisWeek = 0.obs;
RxList<PatientSummary> recentHighRiskPatients;
RxList<Article> myArticles;
RxMap<String, int> riskDistribution;  // {low: 12, medium: 8, high: 5}

void onInit() → loadDashboard()
```

**UI Sections:**

**Header:**
- "Selamat pagi, Dr. [Nama]"
- Verification badge (STR verified ✓)
- Notification bell

**Summary Cards (2x2 grid):**
- Total Pasien
- Pasien Baru (7 hari)
- Risiko Tinggi (perlu tindakan)
- Artikel Dipublikasikan

**Risk Distribution Chart:**
- Pie/donut chart from `fl_chart`
- Color-coded: green / yellow / red

**Pasien Risiko Tinggi (priority list):**
- Up to 5 recent HIGH risk patients
- Each row: child name + parent name + score + date + "Lihat Detail" CTA
- "Lihat Semua Pasien" → `Routes.PATIENT_LIST`

**Artikel Terbaru Saya:**
- Last 2 published articles
- "Tulis Artikel Baru" CTA → `Routes.ARTICLE_EDITOR`

**Bottom Navigation Bar:** Dashboard | Pasien | Artikel | Profil

---

### 4.16 Doctor: Patient List

**Controller:** `PatientListController`
```dart
RxList<Patient> patients;
RxString searchQuery = ''.obs;
RxString filterRisk = 'all'.obs;
RxString sortBy = 'recent'.obs;  // 'recent' | 'score_high' | 'score_low' | 'name'
RxBool isLoading = false.obs;

void searchPatients(String q)
void applyFilter(String risk)
void applySort(String sortOption)
Future<void> loadPatients()
```

**UI:**
- Search bar
- Filter row: chips for risk level + sort dropdown
- Patient list cards:
  - Child name + age
  - Parent name
  - Last assessment date
  - Risk level badge (color-coded)
  - Score badge
  - Trend arrow (↑↓→ compared to previous assessment if available)
- Tap → `Routes.PATIENT_DETAIL`
- Empty/no-match state

**Note on data access:** Doctors see patients who have shared their results (opt-in by parent, or linked via clinic code). This requires a `share_token` or `clinic_code` mechanism — scope for Phase 2. For Phase 1 MVP, doctor sees all assessments submitted through the app (admin-assigned relationship).

---

### 4.17 Doctor: Patient Detail

**Controller:** `PatientDetailController`
```dart
Rx<Patient> patient;  // from Get.arguments
RxList<AssessmentResult> assessmentHistory;
Rx<AssessmentResult?> selectedResult;

void loadPatientData(String patientId)
void selectAssessment(String assessmentId)
Future<void> addClinicalNote(String note)
Future<void> exportPatientReport()
```

**UI Sections:**

**Patient Header:**
- Child: name, DOB, age, gender, weight/height
- Parent: name, contact (if shared)
- Risk trend indicator

**Assessment Timeline:**
- Vertical timeline of all assessments
- Each entry: date, score, level badge
- Tap → expands to show full criterion breakdown

**Selected Assessment Detail:**
- Full criterion breakdown (same as parent result view)
- Raw answers panel (collapsible) — shows what the parent answered per question
- This is the key clinical value: doctor sees structured anamnesis

**Catatan Klinis (Doctor Notes):**
- Text field to add clinical notes per assessment
- Notes are doctor-only, not visible to parent
- List of previous notes with timestamp

**Actions:**
- "Ekspor Laporan Pasien" (PDF with all assessments + notes)
- "Rekomendasikan Artikel" → opens article picker, sends to parent's notification

---

### 4.18 Doctor: Article List (Management)

**UI:** Same as parent article list but with management actions per card:
- Edit (pencil icon) → `Routes.ARTICLE_EDITOR`
- Delete (with confirmation)
- Publish/Unpublish toggle
- Status badge: Draft | Review | Published

**FAB:** "Tulis Artikel Baru"

---

### 4.19 Doctor: Article Editor

**Controller:** `ArticleEditorController`
```dart
Rx<Article?> editingArticle;  // null = create mode
RxString title = ''.obs;
RxString category = ''.obs;
RxString coverImagePath = ''.obs;
RxString body = ''.obs;          // Rich text content (HTML or Markdown)
RxString status = 'draft'.obs;   // 'draft' | 'published'
RxBool isSaving = false.obs;
RxBool hasUnsavedChanges = false.obs;

Future<void> saveDraft()
Future<void> publish()
Future<void> uploadCoverImage()
void onBodyChanged(String content)
```

**UI:**
- Top bar: "← Kembali" | "Simpan Draft" | "Publikasikan"
- Unsaved changes indicator (dot on save button)
- Cover image picker (full width, tap to change)
- Title field (large font, borderless)
- Category selector (chips or dropdown)
- Tags input (free text, comma separated)
- Rich text editor: use `flutter_quill` or `quill_html_editor`
  - Toolbar: Bold, Italic, Underline, Heading, Bullet list, Numbered list, Link, Image insert
- Estimated read time (auto-calculated from word count)
- Character/word count footer

**Leaving guard:** If `hasUnsavedChanges.value` is true, intercept back navigation with a "Simpan draft sebelum keluar?" dialog.

---

### 4.20 Doctor: Settings

Same structure as Parent Settings, with additional:
- **Profil Profesional:** STR number (read-only after verification), Spesialisasi, Klinik/RS
- **Verifikasi:** Badge status, re-submit if rejected

---

## 5. Data Models (Dart)

```dart
// user_model.dart
class UserModel {
  final String id;
  final String name;
  final String email;
  final UserRole role;           // UserRole.parent | UserRole.doctor
  final String? avatarUrl;
  final bool isVerified;         // For doctors: STR verified
  final DateTime createdAt;
}

enum UserRole { parent, doctor }

// child_profile_model.dart
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

  int get ageInMonths => ...
  String get ageDisplay => ...  // "2 tahun 3 bulan"
}

// assessment_model.dart  (the submitted payload)
class AssessmentPayload {
  final String childId;

  // Step 1 - Genetic (max score 3.0 with w=0.3)
  final bool motherHasAtopy;
  final bool fatherHasAtopy;
  final bool siblingHasAtopy;
  final bool grandparentHasAtopy;

  // Step 2 - Active Symptoms (max score 4.0 with w=0.4)
  final bool hasAnaphylaxis;      // Override trigger
  final bool hasUrticaria;
  final bool hasGIReaction;
  final bool hasRhinitis;
  final bool hasWheeze;
  final bool hasConjunctivitis;

  // Step 3 - Disease History (max score 2.0 with w=0.2)
  final bool hasDermatitis;
  final bool hasChronicDrySkin;
  final bool hadHospitalization;
  final bool hasAntihistamineHistory;
  final bool hasRecurrentOtitis;

  // Step 4 - Environment (max score 1.0 with w=0.1)
  final bool smokingHousehold;
  final bool hasPets;
  final bool highDustEnv;
  final bool nearPollution;
  final bool hasCarpetOrPlush;

  Map<String, dynamic> toJson() { ... }
}

// assessment_result_model.dart  (API response)
class AssessmentResult {
  final String id;
  final String childId;
  final double score;             // 1.0 - 10.0
  final RiskLevel level;          // low | medium | high
  final bool anaphylaxisOverride; // true if score was forced to HIGH
  final CriterionBreakdown breakdown;
  final List<String> recommendations;
  final DateTime assessedAt;
}

enum RiskLevel { low, medium, high }

class CriterionBreakdown {
  final double geneticScore;     // max 3.0
  final double symptomsScore;    // max 4.0
  final double historyScore;     // max 2.0
  final double environmentScore; // max 1.0
}

// article_model.dart
class Article {
  final String id;
  final String title;
  final String category;
  final List<String> tags;
  final String coverImageUrl;
  final String body;             // HTML or Markdown
  final String authorId;
  final String authorName;
  final String authorSpecialty;
  final ArticleStatus status;
  final int readTimeMinutes;     // computed serverside
  final DateTime publishedAt;
  final DateTime updatedAt;
}

enum ArticleStatus { draft, review, published }

// patient_model.dart  (Doctor-facing view)
class Patient {
  final ChildProfile child;
  final UserModel parent;
  final List<AssessmentResult> assessmentHistory;
  final AssessmentResult? latestResult;
  final List<ClinicalNote> clinicalNotes;
}

class ClinicalNote {
  final String id;
  final String doctorId;
  final String assessmentId;
  final String note;
  final DateTime createdAt;
}

// notification_model.dart
class AppNotification {
  final String id;
  final String title;
  final String body;
  final NotificationType type;
  final String? deepLinkRoute;
  final Map<String, dynamic>? payload;
  final bool isRead;
  final DateTime createdAt;
}

enum NotificationType {
  assessmentReminder,
  highRiskAlert,
  newArticle,
  doctorNote,
  systemAnnouncement,
}
```

---

## 6. API Contract (Frontend View)

All requests include `Authorization: Bearer <jwt>` header.

```
POST   /api/v1/auth/register
POST   /api/v1/auth/login
POST   /api/v1/auth/google
POST   /api/v1/auth/refresh
POST   /api/v1/auth/forgot-password

GET    /api/v1/children                     → List<ChildProfile>
POST   /api/v1/children                     → ChildProfile
PUT    /api/v1/children/:id                 → ChildProfile
DELETE /api/v1/children/:id                 → 204

POST   /api/v1/assessments                  → AssessmentResult (SAW calc)
GET    /api/v1/assessments?childId=...      → List<AssessmentResult>
GET    /api/v1/assessments/:id              → AssessmentResult
GET    /api/v1/assessments/:id/pdf          → application/pdf blob

GET    /api/v1/articles?category=&search=&page=&limit=
GET    /api/v1/articles/:id                 → Article
POST   /api/v1/articles                     → Article (Doctor only)
PUT    /api/v1/articles/:id                 → Article (Doctor only)
DELETE /api/v1/articles/:id                 → 204 (Doctor only)
POST   /api/v1/articles/:id/publish         → Article

GET    /api/v1/doctor/patients              → List<Patient>
GET    /api/v1/doctor/patients/:id          → Patient
POST   /api/v1/doctor/patients/:id/notes    → ClinicalNote
GET    /api/v1/doctor/dashboard             → DashboardStats

GET    /api/v1/notifications
PATCH  /api/v1/notifications/:id/read
```

---

## 7. GetX Service Layer

### AuthService (GetxService — permanent singleton)
```dart
class AuthService extends GetxService {
  final _storage = Get.find<StorageService>();

  Rx<UserModel?> currentUser = Rx(null);
  RxString token = ''.obs;
  Rx<UserRole?> role = Rx(null);
  RxString? activeChildId;  // Parent only

  bool get isLoggedIn => token.value.isNotEmpty;

  Future<AuthService> init() async {
    // Load persisted session from GetStorage
    token.value = _storage.read(StorageKeys.token) ?? '';
    // ... restore user from storage
    return this;
  }

  Future<void> logout() async { ... }
  Future<bool> validateToken() async { ... }
}
```

### StorageService
Wraps `GetStorage`. All keys defined in `storage_keys.dart` as constants to avoid magic strings.

### NotificationService
Wraps `firebase_messaging`. Handles foreground/background/terminated states. Maps FCM payload `type` to `NotificationType` enum and routes deep links.

---

## 8. Shared Widgets Specification

### `RiskMeterWidget`
Custom painter arc gauge.
```dart
RiskMeterWidget({
  required double score,      // 0.0 - 10.0
  required RiskLevel level,
  double size = 200,
  bool animate = true,        // Tween from 0 to score on mount
})
```
- Uses `AnimationController` + `CustomPainter`
- Arc: 220° sweep, start from bottom-left
- Color zones painted inline: green → yellow → red
- Needle/pointer rotates to score position
- Center text: score value (large) + level label (small)

### `ArticleCard`
```dart
ArticleCard({
  required Article article,
  ArticleCardStyle style = ArticleCardStyle.vertical,
  VoidCallback? onTap,
  bool showAuthor = true,
})
// Styles: vertical (thumbnail top) | horizontal (thumbnail left) | compact
```

### `RiskBadge`
```dart
RiskBadge({ required RiskLevel level })
// Renders: colored pill with icon + localized label
```

---

## 9. State Management Patterns

**Reactive (Obx):** Use for UI that reflects changing state — loading flags, form fields, score values, list updates.

**Non-reactive (GetBuilder):** Use for lighter UI that only needs to rebuild on explicit `update()` calls — settings toggles, article editor save state.

**GetConnect:** Use for HTTP with built-in timeout, retry, and request modifier for JWT header injection:
```dart
class AllerRiskConnect extends GetConnect {
  @override
  void onInit() {
    httpClient.baseUrl = ApiConstants.baseUrl;
    httpClient.addRequestModifier<dynamic>((request) {
      final token = Get.find<AuthService>().token.value;
      if (token.isNotEmpty) {
        request.headers['Authorization'] = 'Bearer $token';
      }
      return request;
    });
    httpClient.addResponseModifier((request, response) {
      if (response.statusCode == 401) {
        Get.find<AuthService>().logout();
      }
      return response;
    });
  }
}
```

**Worker patterns** (in controllers that need reactive side effects):
```dart
// In AssessmentController:
ever(hasAnaphylaxis, (bool val) {
  if (val) _showAnaphylaxisWarning();
});

debounce(searchQuery, (_) => searchArticles(), time: 300.ms);
```

---

## 10. Recommended Packages

| Package | Purpose |
|---------|---------|
| `get` | State, routing, DI |
| `get_storage` | Persistent local storage |
| `dio` or `get_connect` | HTTP client |
| `firebase_core` + `firebase_messaging` | Push notifications |
| `firebase_auth` | Google Sign-In |
| `sign_in_with_apple` | iOS Apple Sign-In |
| `pdf` | PDF generation |
| `share_plus` | System share sheet |
| `image_picker` | Camera / gallery |
| `flutter_quill` | Rich text editor (Doctor) |
| `fl_chart` | Charts (dashboard, history trend) |
| `flutter_html` | Render article HTML body |
| `cached_network_image` | Image caching |
| `intl` | Date/number formatting (Indonesian locale) |
| `logger` | Structured debug logging |
| `flutter_dotenv` | Environment config (base URL, keys) |

---

## 11. Phase Allocation (Updated)

| Feature | Phase 1 MVP | Phase 2 | Phase 3 |
|---------|-------------|---------|---------|
| Splash + Onboarding | ✅ | | |
| Role Selector | ✅ | | |
| Auth (Email + Google) | ✅ | | |
| Child Profile CRUD | ✅ | | |
| Assessment (4 steps) | ✅ | | |
| SAW Engine + Result | ✅ | | |
| PDF Export | ✅ | | |
| Parent Article List/Detail | ✅ | | |
| Doctor Dashboard | ✅ | | |
| Patient List + Detail | ✅ | | |
| Doctor Article Editor | ✅ | | |
| Assessment History + chart | | ✅ | |
| Push Notifications | | ✅ | |
| Doctor Clinical Notes | | ✅ | |
| Apple Sign-In | | ✅ | |
| Dark Mode | | ✅ | |
| Clinic code / patient linking | | ✅ | |
| Doctor-to-parent article recommendation | | | ✅ |
| Offline mode / local cache | | | ✅ |
| Multilingual (EN) | | | ✅ |

---

## 12. Open Design Decisions

1. **Assessment history visibility to doctors:** Phase 1 proposes all results are visible to all doctors. This is a privacy concern. Phase 2 should implement explicit parent opt-in (share token or clinic linkage).

2. **Article moderation:** Current spec has doctors publish directly. Consider an admin review queue to prevent medical misinformation.

3. **Doctor registration verification:** STR verification is manual (admin-side) in the spec. Phase 2 could integrate with KTKI (Konsil Tenaga Kesehatan Indonesia) API if available.

4. **Assessment re-entry:** Should parents be blocked from re-taking the same child's assessment too frequently? Consider a 30-day cooldown with override option to prevent gaming the system.

5. **`flutter_quill` vs `quill_html_editor`:** `flutter_quill` is more mature and offline-capable; `quill_html_editor` uses a WebView which is heavier but renders HTML directly. Given the article body is HTML for frontend rendering, `quill_html_editor` reduces conversion overhead.