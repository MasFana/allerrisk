/// Raw assessment data filled out by parent. All boolean.
class AssessmentPayload {
  final String childId;

  // 1. Genetic / Family History
  final bool motherHasAtopy;
  final bool fatherHasAtopy;
  final bool siblingHasAtopy;
  final bool grandparentHasAtopy;

  // 2. Active Symptoms
  final bool hasAnaphylaxis; // Immediate override → HIGH RISK
  final bool hasUrticaria;
  final bool hasGiReaction; // Gastrointestinal (diarrhea, vomiting)
  final bool hasRhinitis;
  final bool hasWheeze;
  final bool hasConjunctivitis;

  // 3. Child Medical History
  final bool hasDermatitis; // Atopic dermatitis early sign
  final bool hasChronicDrySkin;
  final bool hadHospitalization; // Due to allergic reaction
  final bool hasAntihistamineHistory;
  final bool hasRecurrentOtitis;

  // 4. Environment
  final bool smokingHousehold;
  final bool hasPets; // Furry pets indoors
  final bool highDustEnv;
  final bool nearPollution; // High traffic /工业
  final bool hasCarpetOrPlush;

  const AssessmentPayload({
    required this.childId,
    // Gen
    required this.motherHasAtopy,
    required this.fatherHasAtopy,
    required this.siblingHasAtopy,
    required this.grandparentHasAtopy,
    // Sym
    required this.hasAnaphylaxis,
    required this.hasUrticaria,
    required this.hasGiReaction,
    required this.hasRhinitis,
    required this.hasWheeze,
    required this.hasConjunctivitis,
    // His
    required this.hasDermatitis,
    required this.hasChronicDrySkin,
    required this.hadHospitalization,
    required this.hasAntihistamineHistory,
    required this.hasRecurrentOtitis,
    // Env
    required this.smokingHousehold,
    required this.hasPets,
    required this.highDustEnv,
    required this.nearPollution,
    required this.hasCarpetOrPlush,
  });

  factory AssessmentPayload.fromJson(Map<String, dynamic> json) =>
      AssessmentPayload(
        childId: json['child_id'] as String,
        motherHasAtopy: json['mother_has_atopy'] as bool,
        fatherHasAtopy: json['father_has_atopy'] as bool,
        siblingHasAtopy: json['sibling_has_atopy'] as bool,
        grandparentHasAtopy: json['grandparent_has_atopy'] as bool,
        hasAnaphylaxis: json['has_anaphylaxis'] as bool,
        hasUrticaria: json['has_urticaria'] as bool,
        hasGiReaction: json['has_gi_reaction'] as bool,
        hasRhinitis: json['has_rhinitis'] as bool,
        hasWheeze: json['has_wheeze'] as bool,
        hasConjunctivitis: json['has_conjunctivitis'] as bool,
        hasDermatitis: json['has_dermatitis'] as bool,
        hasChronicDrySkin: json['has_chronic_dry_skin'] as bool,
        hadHospitalization: json['had_hospitalization'] as bool,
        hasAntihistamineHistory: json['has_antihistamine_history'] as bool,
        hasRecurrentOtitis: json['has_recurrent_otitis'] as bool,
        smokingHousehold: json['smoking_household'] as bool,
        hasPets: json['has_pets'] as bool,
        highDustEnv: json['high_dust_env'] as bool,
        nearPollution: json['near_pollution'] as bool,
        hasCarpetOrPlush: json['has_carpet_or_plush'] as bool,
      );

  Map<String, dynamic> toJson() => {
    'child_id': childId,
    'mother_has_atopy': motherHasAtopy,
    'father_has_atopy': fatherHasAtopy,
    'sibling_has_atopy': siblingHasAtopy,
    'grandparent_has_atopy': grandparentHasAtopy,
    'has_anaphylaxis': hasAnaphylaxis,
    'has_urticaria': hasUrticaria,
    'has_gi_reaction': hasGiReaction,
    'has_rhinitis': hasRhinitis,
    'has_wheeze': hasWheeze,
    'has_conjunctivitis': hasConjunctivitis,
    'has_dermatitis': hasDermatitis,
    'has_chronic_dry_skin': hasChronicDrySkin,
    'had_hospitalization': hadHospitalization,
    'has_antihistamine_history': hasAntihistamineHistory,
    'has_recurrent_otitis': hasRecurrentOtitis,
    'smoking_household': smokingHousehold,
    'has_pets': hasPets,
    'high_dust_env': highDustEnv,
    'near_pollution': nearPollution,
    'has_carpet_or_plush': hasCarpetOrPlush,
  };
}
