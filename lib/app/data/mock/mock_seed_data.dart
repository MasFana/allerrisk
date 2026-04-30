class MockSeedData {
  // TODO(real-auth): Replace these seeded demo credentials with backend-driven auth.
  // Demo prototype accounts:
  // - Orang Tua: budi@demo.com / demo1234
  // - Dokter: dokter@demo.com / demo1234
  // ── Users ────────────────────────────────────────────────────
  static List<Map<String, dynamic>> get users => [
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

  // ── Children ─────────────────────────────────────────────────
  static List<Map<String, dynamic>> get children => [
    {
      'id': 'child_01',
      'parent_id': 'usr_parent_01',
      'name': 'Rizky Santoso',
      'date_of_birth': '2021-03-15T00:00:00.000Z',
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
      'date_of_birth': '2023-07-22T00:00:00.000Z',
      'gender': 'female',
      'weight_kg': 10.2,
      'height_cm': 80.0,
      'photo_url': null,
      'notes': null,
      'created_at': '2024-11-01T08:15:00.000Z',
    },
    {
      'id': 'child_03',
      'parent_id': 'usr_parent_02',
      'name': 'Kevin Pratama',
      'date_of_birth': '2020-11-10T00:00:00.000Z',
      'gender': 'male',
      'weight_kg': 18.0,
      'height_cm': 108.0,
      'photo_url': null,
      'notes': 'Riwayat dermatitis atopik sejak usia 6 bulan',
      'created_at': '2024-11-16T09:00:00.000Z',
    },
    {
      'id': 'child_04',
      'parent_id': 'usr_parent_03',
      'name': 'Putri Wijaya',
      'date_of_birth': '2022-05-01T00:00:00.000Z',
      'gender': 'female',
      'weight_kg': 13.0,
      'height_cm': 92.0,
      'photo_url': null,
      'notes': null,
      'created_at': '2024-12-03T07:20:00.000Z',
    },
  ];

  // ── Assessments ──────────────────────────────────────────────
  static List<Map<String, dynamic>> get assessments => [
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

  // ── Articles ─────────────────────────────────────────────────
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

  // ── Clinical Notes ────────────────────────────────────────────
  static List<Map<String, dynamic>> get clinicalNotes => [
    {
      'id': 'note_01',
      'doctor_id': 'usr_doctor_01',
      'doctor_name': 'dr. Amelia Putri, Sp.A',
      'patient_child_id': 'child_01',
      'assessment_id': 'asmnt_01',
      'note':
          'Pasien datang dengan keluhan kulit gatal di lipatan siku dan lutut. Riwayat ibu dengan asma alergi. Sarankan pemeriksaan SPT untuk tungau debu dan susu sapi. Resepkan pelembap ceramide-based 2x/hari.',
      'created_at': '2025-01-12T13:30:00.000Z',
    },
    {
      'id': 'note_02',
      'doctor_id': 'usr_doctor_02',
      'doctor_name': 'dr. Fajar Rahman, Sp.A-KI',
      'patient_child_id': 'child_03',
      'assessment_id': 'asmnt_03',
      'note':
          'Riwayat dermatitis atopik sejak usia 6 bulan, saat ini dalam tatalaksana steroid topikal. Hasil asesmen menunjukkan risiko tinggi dengan komponen genetik dominan (kedua orang tua atopik). Jadwalkan ImmunoCAP untuk panel makanan dan inhalan.',
      'created_at': '2025-01-19T10:15:00.000Z',
    },
  ];

  // ── Notifications ─────────────────────────────────────────────
  static List<Map<String, dynamic>> get notifications => [
    {
      'id': 'notif_01',
      'user_id': 'usr_parent_01',
      'title': 'Saatnya Asesmen Ulang',
      'body':
          'Sudah 6 bulan sejak asesmen terakhir Rizky. Lakukan asesmen ulang untuk memantau perkembangan risiko alergi.',
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
      'body':
          'dr. Amelia telah mempublikasikan artikel baru: "Cara Membuat Rumah Ramah Alergi"',
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
      'body':
          'Hasil asesmen Kevin menunjukkan risiko alergi TINGGI (7.9). Segera konsultasikan ke dokter spesialis.',
      'type': 'highRiskAlert',
      'deep_link_route': '/parent/assessment/result',
      'route_args': {'assessment_id': 'asmnt_03'},
      'is_read': false,
      'created_at': '2025-01-18T11:10:00.000Z',
    },
  ];
}
