import 'package:uuid/uuid.dart';
import '../models/assessment_payload_model.dart';
import '../models/assessment_result_model.dart';

/// SAW (Simple Additive Weighting) Mock Engine for Allergy Risk.
/// Represents backend risk stratification logic.
abstract class MockSawEngine {
  // ── SAW Weights (Sum = 1.0) ──────────────────────────────────
  static const double _wGenetic = 0.30;
  static const double _wSymptoms = 0.40;
  static const double _wHistory = 0.20;
  static const double _wEnvironment = 0.10;

  // ── Max Scores per Criterion ─────────────────────────────────
  // Based on number of boolean flags per category in payload
  static const double _maxGenetic = 4.0;
  static const double _maxSymptoms = 5.0; // Excludes anaphylaxis
  static const double _maxHistory = 5.0;
  static const double _maxEnvironment = 5.0;

  /// Calculates risk from payload and returns a full result model.
  static AssessmentResult calculate({
    required String parentId,
    required AssessmentPayload payload,
  }) {
    // 1. Immediate Override Check
    if (payload.hasAnaphylaxis) {
      return AssessmentResult(
        id: const Uuid().v4(),
        childId: payload.childId,
        parentId: parentId,
        score: 10.0,
        level: RiskLevel.high,
        anaphylaxisOverride: true,
        breakdown: const CriterionBreakdown(
          geneticScore: 3.0,
          symptomsScore: 4.0,
          historyScore: 2.0,
          environmentScore: 1.0,
        ),
        payload: payload,
        recommendations: _getAnaphylaxisRecommendations(),
        assessedAt: DateTime.now(),
      );
    }

    // 2. Tally raw scores (1 point per 'true' flag)
    double rawGen = 0;
    if (payload.motherHasAtopy) rawGen++;
    if (payload.fatherHasAtopy) rawGen++;
    if (payload.siblingHasAtopy) rawGen++;
    if (payload.grandparentHasAtopy) rawGen++;

    double rawSym = 0;
    if (payload.hasUrticaria) rawSym++;
    if (payload.hasGiReaction) rawSym++;
    if (payload.hasRhinitis) rawSym++;
    if (payload.hasWheeze) rawSym++;
    if (payload.hasConjunctivitis) rawSym++;

    double rawHis = 0;
    if (payload.hasDermatitis) rawHis++;
    if (payload.hasChronicDrySkin) rawHis++;
    if (payload.hadHospitalization) rawHis++;
    if (payload.hasAntihistamineHistory) rawHis++;
    if (payload.hasRecurrentOtitis) rawHis++;

    double rawEnv = 0;
    if (payload.smokingHousehold) rawEnv++;
    if (payload.hasPets) rawEnv++;
    if (payload.highDustEnv) rawEnv++;
    if (payload.nearPollution) rawEnv++;
    if (payload.hasCarpetOrPlush) rawEnv++;

    // 3. Normalize (X / Max)
    final normGen = rawGen / _maxGenetic;
    final normSym = rawSym / _maxSymptoms;
    final normHis = rawHis / _maxHistory;
    final normEnv = rawEnv / _maxEnvironment;

    // 4. Apply Weights (Result 0.0 - 1.0)
    final weightedGen = normGen * _wGenetic;
    final weightedSym = normSym * _wSymptoms;
    final weightedHis = normHis * _wHistory;
    final weightedEnv = normEnv * _wEnvironment;

    final totalScoreNormalized =
        weightedGen + weightedSym + weightedHis + weightedEnv;

    // 5. Scale to 10.0
    final finalScore = totalScoreNormalized * 10.0;

    // 6. Stratify
    RiskLevel level;
    if (finalScore < 3.5) {
      level = RiskLevel.low;
    } else if (finalScore < 7.0) {
      level = RiskLevel.medium;
    } else {
      level = RiskLevel.high;
    }

    // 7. Generate result
    return AssessmentResult(
      id: const Uuid().v4(),
      childId: payload.childId,
      parentId: parentId,
      score: finalScore,
      level: level,
      anaphylaxisOverride: false,
      breakdown: CriterionBreakdown(
        geneticScore: weightedGen * 10,
        symptomsScore: weightedSym * 10,
        historyScore: weightedHis * 10,
        environmentScore: weightedEnv * 10,
      ),
      payload: payload,
      recommendations: _getRecommendations(level, payload),
      assessedAt: DateTime.now(),
    );
  }

  // ── Contextual Recommendations ───────────────────────────────

  static List<String> _getAnaphylaxisRecommendations() {
    return [
      'Gejala anafilaksis terdeteksi. Ini adalah kondisi darurat medis.',
      'Segera bawa anak ke IGD terdekat atau hubungi 119.',
      'Jangan tinggalkan anak sendirian.',
      'Catat semua makanan, minuman, atau obat yang dikonsumsi 2 jam terakhir.',
    ];
  }

  static List<String> _getRecommendations(
    RiskLevel level,
    AssessmentPayload payload,
  ) {
    final List<String> recs = [];

    switch (level) {
      case RiskLevel.low:
        recs.add('Risiko alergi anak Anda saat ini tergolong rendah.');
        recs.add('Pertahankan pola makan bergizi seimbang.');
        if (payload.smokingHousehold) {
          recs.add('Sangat disarankan untuk menghindari asap rokok di rumah.');
        }
        recs.add(
          'Lakukan asesmen ulang dalam 6 bulan atau jika muncul gejala baru.',
        );
        break;
      case RiskLevel.medium:
        recs.add('Anak Anda memiliki beberapa faktor risiko alergi aktif.');
        recs.add(
          'Jadwalkan konsultasi rutin dengan dokter anak dalam 2 minggu ke depan.',
        );
        if (payload.hasDermatitis || payload.hasChronicDrySkin) {
          recs.add('Gunakan pelembap kulit secara rutin sehabis mandi.');
        }
        if (payload.highDustEnv || payload.hasCarpetOrPlush) {
          recs.add('Tingkatkan frekuensi pembersihan area tidur anak.');
        }
        break;
      case RiskLevel.high:
        recs.add('Analisis SAW menunjukkan risiko alergi TINGGI.');
        recs.add(
          'Segera jadwalkan konsultasi dengan Dokter Spesialis Anak (Sp.A).',
        );
        recs.add('Bawa hasil asesmen ini sebagai referensi awal untuk dokter.');
        if (payload.hasUrticaria || payload.hasWheeze) {
          recs.add('Jangan memberikan obat antihistamin tanpa anjuran dokter.');
        }
        recs.add('Tanyakan mengenai uji alergi (Skin Prick Test / IgE).');
        break;
    }

    return recs;
  }
}
