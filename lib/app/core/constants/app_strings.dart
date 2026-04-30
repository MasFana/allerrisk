/// All user-facing strings in Bahasa Indonesia.
/// Keys follow snake_case. Localization-ready: swap values per locale.
abstract class AppStrings {
  // ── App ───────────────────────────────────────────────────────
  static const String appName = 'AllerRisk';
  static const String appTagline = 'Deteksi Dini, Lindungi Si Kecil';

  // ── General ───────────────────────────────────────────────────
  static const String save = 'Simpan';
  static const String cancel = 'Batal';
  static const String confirm = 'Konfirmasi';
  static const String delete = 'Hapus';
  static const String edit = 'Ubah';
  static const String close = 'Tutup';
  static const String back = 'Kembali';
  static const String next = 'Selanjutnya';
  static const String done = 'Selesai';
  static const String retry = 'Coba Lagi';
  static const String seeAll = 'Lihat Semua';
  static const String loading = 'Memuat...';
  static const String or = 'atau';
  static const String yes = 'Ya';
  static const String no = 'Tidak';

  // ── Onboarding ────────────────────────────────────────────────
  static const String skip = 'Lewati';
  static const String getStarted = 'Mulai';
  static const String onboardingTitle1 = 'Kenali Risiko Sejak Dini';
  static const String onboardingDesc1 =
      'Alergi anak bisa dicegah jika dideteksi lebih awal.';
  static const String onboardingTitle2 = 'Berbasis Standar Medis';
  static const String onboardingDesc2 =
      'Kuesioner ISAAC & NICE yang digunakan dokter spesialis.';
  static const String onboardingTitle3 = 'Rekomendasi Instan';
  static const String onboardingDesc3 =
      'Dapatkan stratifikasi risiko dan langkah nyata dalam menit.';

  // ── Role Selector ─────────────────────────────────────────────
  static const String selectRole = 'Saya adalah';
  static const String roleParent = 'Orang Tua';
  static const String roleParentSubtitle = 'Pantau risiko alergi anak Anda';
  static const String roleDoctor = 'Dokter';
  static const String roleDoctorSubtitle =
      'Kelola pasien dan publikasi edukasi';
  static const String continueButton = 'Lanjutkan';

  // ── Auth ──────────────────────────────────────────────────────
  static const String login = 'Masuk';
  static const String register = 'Daftar';
  static const String email = 'Email';
  static const String password = 'Kata Sandi';
  static const String confirmPassword = 'Konfirmasi Kata Sandi';
  static const String forgotPassword = 'Lupa kata sandi?';
  static const String noAccount = 'Belum punya akun?';
  static const String haveAccount = 'Sudah punya akun?';
  static const String signInWithGoogle = 'Masuk dengan Google';
  static const String fullName = 'Nama Lengkap';
  static const String agreeToTerms = 'Setuju dengan Syarat & Ketentuan';
  static const String strNumber = 'Nomor STR';
  static const String specialty = 'Spesialisasi';
  static const String clinicHospital = 'Rumah Sakit / Klinik (opsional)';
  static const String loginAsParent = 'Masuk sebagai Orang Tua';
  static const String loginAsDoctor = 'Masuk sebagai Dokter';
  static const String forgotPasswordTitle = 'Reset Kata Sandi';
  static const String sendResetLink = 'Kirim Tautan Reset';
  static const String verificationPending =
      'Akun Anda sedang dalam proses verifikasi';
  static const String verificationPendingDesc =
      'Tim kami akan memverifikasi nomor STR Anda dalam 1-2 hari kerja.';

  // ── Home ─────────────────────────────────────────────────────
  static const String greeting = 'Halo,';
  static const String addChild = '+ Tambah Anak';
  static const String lastAssessment = 'Asesmen Terakhir';
  static const String startFirstAssessment = 'Mulai Asesmen Pertama';
  static const String reassess = 'Asesmen Ulang';
  static const String assessmentHistory = 'Riwayat Asesmen';
  static const String educationArticles = 'Artikel Edukasi';
  static const String noAssessmentYet = 'Belum ada asesmen untuk anak ini';

  // ── Child Profile ─────────────────────────────────────────────
  static const String childName = 'Nama Anak';
  static const String dateOfBirth = 'Tanggal Lahir';
  static const String gender = 'Jenis Kelamin';
  static const String male = 'Laki-laki';
  static const String female = 'Perempuan';
  static const String weight = 'Berat Badan (kg)';
  static const String height = 'Tinggi Badan (cm)';
  static const String notes = 'Catatan tambahan (opsional)';
  static const String childPhoto = 'Foto Anak (opsional)';
  static const String deleteChildConfirm = 'Hapus profil anak ini?';
  static const String myChildren = 'Anak Saya';
  static const String addChildProfile = 'Tambah Profil Anak';
  static const String editChildProfile = 'Edit Profil Anak';

  // ── Assessment ───────────────────────────────────────────────
  static const String assessmentTitle = 'Asesmen Risiko Alergi';
  static const String stepOf = 'dari';
  static const String step1Title = 'Riwayat Genetik / Keluarga';
  static const String step2Title = 'Gejala Aktif Anak';
  static const String step3Title = 'Riwayat Penyakit Anak';
  static const String step4Title = 'Faktor Lingkungan';
  static const String calculateRisk = 'Hitung Risiko';
  static const String discardAssessment =
      'Batalkan asesmen ini? Data yang dimasukkan akan hilang.';
  static const String anaphylaxisWarning =
      '⚠️ Gejala ini memerlukan perhatian medis segera. '
      'Anda tetap dapat melanjutkan asesmen.';
  static const String symptomInstruction =
      'Pilih gejala yang pernah atau sering dialami anak dalam 3 bulan terakhir.';

  // ── Assessment Result ─────────────────────────────────────────
  static const String riskResult = 'Hasil Risiko';
  static const String scoreBreakdown = 'Rincian Skor';
  static const String recommendations = 'Rekomendasi';
  static const String saveExportPdf = 'Simpan & Ekspor PDF';
  static const String shareResult = 'Bagikan Hasil';
  static const String backToHome = 'Kembali ke Beranda';
  static const String pdfDisclaimer =
      'Hasil ini bukan diagnosis medis. Konsultasikan dengan tenaga kesehatan.';
  static const String anaphylaxisEmergency =
      '⚠️ Gejala anafilaksis terdeteksi. Ini kondisi darurat medis.';
  static const String seekSpecialistCta = 'Cari Dokter Spesialis Anak Terdekat';

  // ── Risk Levels ───────────────────────────────────────────────
  static const String riskLow = 'Risiko Rendah';
  static const String riskMedium = 'Risiko Sedang';
  static const String riskHigh = 'Risiko Tinggi';

  // ── Articles ─────────────────────────────────────────────────
  static const String allArticles = 'Semua Artikel';
  static const String searchArticles = 'Cari artikel...';
  static const String writeNewArticle = 'Tulis Artikel Baru';
  static const String saveDraft = 'Simpan Draft';
  static const String publish = 'Publikasikan';
  static const String unpublish = 'Batalkan Publikasi';
  static const String unsavedChanges = 'Simpan draft sebelum keluar?';
  static const String readMinutes = 'menit baca';

  // ── Categories ───────────────────────────────────────────────
  static const String catAll = 'Semua';
  static const String catFoodAllergy = 'Alergi Makanan';
  static const String catAsthma = 'Asma';
  static const String catEczema = 'Eksim';
  static const String catEnvironment = 'Lingkungan';
  static const String catParentingTips = 'Tips Orang Tua';
  static const String catGeneral = 'Umum';

  // ── Doctor ────────────────────────────────────────────────────
  static const String doctorDashboard = 'Dashboard';
  static const String totalPatients = 'Total Pasien';
  static const String newPatientsWeek = 'Pasien Baru (7 hari)';
  static const String highRiskPatients = 'Risiko Tinggi';
  static const String articlesPublished = 'Artikel Dipublikasikan';
  static const String highRiskPriorityList = 'Pasien Risiko Tinggi';
  static const String seeAllPatients = 'Lihat Semua Pasien';
  static const String clinicalNotes = 'Catatan Klinis';
  static const String addNote = 'Tambah Catatan';
  static const String exportPatientReport = 'Ekspor Laporan Pasien';
  static const String recommendArticle = 'Rekomendasikan Artikel';
  static const String strVerified = 'STR Terverifikasi ✓';

  // ── Settings ─────────────────────────────────────────────────
  static const String settings = 'Pengaturan';
  static const String account = 'Akun';
  static const String notifications = 'Notifikasi';
  static const String appearance = 'Tampilan';
  static const String privacySecurity = 'Privasi & Keamanan';
  static const String about = 'Tentang Aplikasi';
  static const String darkMode = 'Mode Gelap';
  static const String deleteAccount = 'Hapus Akun';
  static const String logout = 'Keluar';
  static const String logoutConfirm = 'Yakin ingin keluar?';
  static const String appVersion = 'Versi Aplikasi';

  // ── Navigation Labels ─────────────────────────────────────────
  static const String navHome = 'Beranda';
  static const String navAssessment = 'Asesmen';
  static const String navArticles = 'Artikel';
  static const String navProfile = 'Profil';
  static const String navDashboard = 'Dashboard';
  static const String navPatients = 'Pasien';

  // ── Errors ────────────────────────────────────────────────────
  static const String errorGeneral = 'Terjadi kesalahan. Silakan coba lagi.';
  static const String errorNetwork =
      'Tidak dapat terhubung. Periksa koneksi internet Anda.';
  static const String errorInvalidCredentials = 'Email atau password salah.';
  static const String errorEmailExists = 'Email sudah terdaftar.';
  static const String errorNotFound = 'Data tidak ditemukan.';
  static const String fieldRequired = 'Kolom ini wajib diisi.';
  static const String invalidEmail = 'Format email tidak valid.';
  static const String passwordTooShort = 'Kata sandi minimal 8 karakter.';
  static const String passwordMismatch = 'Kata sandi tidak cocok.';
  static const String invalidStr = 'Nomor STR harus 11 digit.';

  // ── Additional Settings ──────────────────────────────────────
  static const String language = 'Bahasa';
  static const String indonesia = 'Indonesia';
  static const String privacyPolicy = 'Kebijakan Privasi';
  static const String helpSupport = 'Bantuan & Dukungan';

  // ── Additional Articles ──────────────────────────────────────
  static const String noArticlesFound = 'Tidak ada artikel ditemukan.';
  static const String noArticlesYet = 'Belum ada artikel';
  static const String shareMedicalKnowledge = 'Bagikan pengetahuan medis Anda\ndengan menulis artikel pertama.';
  static const String myArticles = 'Artikel Saya';
  static const String writeArticle = 'Tulis Artikel';
  static const String deleteArticleTitle = 'Hapus Artikel';
  static const String deleteArticleConfirm = 'Apakah Anda yakin ingin menghapus artikel ini?';
  static const String category = 'Kategori';
  static const String articleTitle = 'Judul Artikel';
  static const String titleRequired = 'Judul tidak boleh kosong';
  static const String imageUrlOptional = 'URL Gambar (Opsional)';
  static const String articleContent = 'Konten Artikel';
  static const String articleContentHint = 'Tulis isi artikel di sini (mendukung HTML)...';
  static const String contentRequired = 'Konten tidak boleh kosong';
  static const String deleteArticle = 'Hapus';

  // ── Additional Child Profile ─────────────────────────────────
  static const String saveChanges = 'Simpan Perubahan';
  static const String addProfile = 'Tambah Profil';
  static const String maleIcon = '♂ Laki-laki';
  static const String femaleIcon = '♀ Perempuan';
  static const String childProfile = 'Profil Anak';
  static const String noChildProfile = 'Belum Ada Profil Anak';
  static const String addProfileInstruction = 'Tekan tombol di bawah untuk menambahkan profil anak Anda.';
  static const String deleteProfileConfirmTitle = 'Hapus Profil?';
  static const String deleteProfileConfirmDesc = 'Profil ini beserta semua riwayat asesmen akan dihapus.';

  // ── Additional Doctor / Patient Detail ───────────────────────
  static const String patientDetail = 'Detail Pasien';
  static const String exportPdfTooltip = 'Ekspor PDF';
  static const String answerDetail = 'Detail Jawaban';
  static const String bornOn = 'Lahir';
  static const String parentLabel = 'Orang Tua';
  static const String parentShort = 'Ortu';
  static const String noAssessmentHistory = 'Belum ada riwayat asesmen.';
  static const String score = 'Skor';
  static const String selectAssessmentFromHistory = 'Pilih asesmen dari tab riwayat.';
  static const String genetic = 'Genetik';
  static const String activeSymptoms = 'Gejala Aktif';
  static const String medicalHistory = 'Riwayat Penyakit';
  static const String environment = 'Lingkungan';
  static const String rawAnswers = 'Jawaban Mentah (Raw Answers)';
  static const String rawAnswersPlaceholder = 'Di lingkungan produksi, jawaban kuesioner lengkap orang tua akan ditampilkan di sini untuk anamnesis mendalam.';
  static const String noClinicalNotes = 'Belum ada catatan klinis.';
  static const String relatedAssessment = 'Asesmen Terkait';
  static const String addClinicalNoteHint = 'Tambah catatan klinis (internal)...';

  static const String patientList = 'Daftar Pasien';
  static const String searchPatientHint = 'Cari nama pasien atau orang tua...';
  static const String sortRecent = 'Terbaru';
  static const String sortScoreHigh = 'Skor Tertinggi';
  static const String sortScoreLow = 'Skor Terendah';
  static const String sortNameAsc = 'Nama (A-Z)';
  static const String noPatientsFound = 'Tidak ada pasien ditemukan';
  static const String clearFilter = 'Hapus Filter';
  static const String yearsShort = 'thn';
  static const String monthsShort = 'bln';
  static const String riskLowLabel = 'RENDAH';
  static const String riskMediumLabel = 'SEDANG';
  static const String riskHighLabel = 'TINGGI';
  static const String noRiskLabel = 'TIDAK ADA';

  // ── Additional Doctor Settings & Editor ──────────────────────
  static const String doctorProfile = 'Profil Dokter';
  static const String pushNotifications = 'Notifikasi Push';
  static const String pushNotificationsDesc = 'Pasien baru & pesan sistem';
  static const String weeklyReportEmail = 'Email Laporan mingguan';
  static const String weeklyReportEmailDesc = 'Ringkasan aktivitas pasien';
  static const String termsAndConditions = 'Syarat & Ketentuan';
  static const String selectArticle = 'Pilih Artikel';
  static const String unsavedChangesDesc = 'Anda memiliki perubahan yang belum disimpan.';
  static const String exitWithoutSaving = 'Keluar Tanpa Menyimpan';
}
