import 'assessment_payload_model.dart';
import '../../core/theme/app_colors.dart';
import 'package:flutter/material.dart';

enum RiskLevel { low, medium, high }

extension RiskLevelColors on RiskLevel {
  Color get color {
    switch (this) {
      case RiskLevel.low:
        return AppColors.riskLow;
      case RiskLevel.medium:
        return AppColors.riskMedium;
      case RiskLevel.high:
        return AppColors.riskHigh;
    }
  }

  Color get containerColor {
    switch (this) {
      case RiskLevel.low:
        return AppColors.riskLowContainer;
      case RiskLevel.medium:
        return AppColors.riskMediumContainer;
      case RiskLevel.high:
        return AppColors.riskHighContainer;
    }
  }

  String get label {
    switch (this) {
      case RiskLevel.low:
        return 'Risiko Rendah';
      case RiskLevel.medium:
        return 'Risiko Sedang';
      case RiskLevel.high:
        return 'Risiko Tinggi';
    }
  }
}

class CriterionBreakdown {
  final double geneticScore;
  final double symptomsScore;
  final double historyScore;
  final double environmentScore;

  const CriterionBreakdown({
    required this.geneticScore,
    required this.symptomsScore,
    required this.historyScore,
    required this.environmentScore,
  });

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
  final double score; // 0.0 - 10.0
  final RiskLevel level;
  final bool anaphylaxisOverride;
  final CriterionBreakdown breakdown;
  final AssessmentPayload payload;
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
        id: json['id'] as String,
        childId: json['child_id'] as String,
        parentId: json['parent_id'] as String,
        score: (json['score'] as num).toDouble(),
        level: RiskLevel.values.byName(json['level'] as String),
        anaphylaxisOverride: json['anaphylaxis_override'] as bool,
        breakdown: CriterionBreakdown.fromJson(
          json['breakdown'] as Map<String, dynamic>,
        ),
        payload: AssessmentPayload.fromJson(
          json['payload'] as Map<String, dynamic>,
        ),
        recommendations: (json['recommendations'] as List)
            .map((e) => e as String)
            .toList(),
        assessedAt: DateTime.parse(json['assessed_at'] as String),
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
