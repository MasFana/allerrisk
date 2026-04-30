class ClinicalNote {
  final String id;
  final String doctorId;
  final String doctorName;
  final String patientChildId;
  final String? assessmentId; // Optional link to specific assessment
  final String note;
  final DateTime createdAt;

  const ClinicalNote({
    required this.id,
    required this.doctorId,
    required this.doctorName,
    required this.patientChildId,
    this.assessmentId,
    required this.note,
    required this.createdAt,
  });

  factory ClinicalNote.fromJson(Map<String, dynamic> json) => ClinicalNote(
    id: json['id'] as String,
    doctorId: json['doctor_id'] as String,
    doctorName: json['doctor_name'] as String,
    patientChildId: json['patient_child_id'] as String,
    assessmentId: json['assessment_id'] as String?,
    note: json['note'] as String,
    createdAt: DateTime.parse(json['created_at'] as String),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'doctor_id': doctorId,
    'doctor_name': doctorName,
    'patient_child_id': patientChildId,
    'assessment_id': assessmentId,
    'note': note,
    'created_at': createdAt.toIso8601String(),
  };
}
