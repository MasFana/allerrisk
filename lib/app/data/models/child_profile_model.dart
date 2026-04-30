import '../../core/utils/validators.dart';
import '../../core/utils/extensions.dart';

enum Gender { male, female }

class ChildProfile {
  final String id;
  final String parentId;
  final String name;
  final DateTime dateOfBirth;
  final Gender gender;
  final double weightKg;
  final double heightCm;
  final String? photoUrl;
  final String? notes;
  final DateTime createdAt;

  const ChildProfile({
    required this.id,
    required this.parentId,
    required this.name,
    required this.dateOfBirth,
    required this.gender,
    required this.weightKg,
    required this.heightCm,
    this.photoUrl,
    this.notes,
    required this.createdAt,
  });

  // Computed properties
  int get ageInMonths => dateOfBirth.ageInMonths;
  String get ageDisplay => Formatters.ageDisplay(dateOfBirth);

  factory ChildProfile.fromJson(Map<String, dynamic> json) => ChildProfile(
    id: json['id'] as String,
    parentId: json['parent_id'] as String,
    name: json['name'] as String,
    dateOfBirth: DateTime.parse(json['date_of_birth'] as String),
    gender: Gender.values.byName(json['gender'] as String),
    weightKg: (json['weight_kg'] as num).toDouble(),
    heightCm: (json['height_cm'] as num).toDouble(),
    photoUrl: json['photo_url'] as String?,
    notes: json['notes'] as String?,
    createdAt: DateTime.parse(json['created_at'] as String),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'parent_id': parentId,
    'name': name,
    'date_of_birth': dateOfBirth.toIso8601String(),
    'gender': gender.name,
    'weight_kg': weightKg,
    'height_cm': heightCm,
    'photo_url': photoUrl,
    'notes': notes,
    'created_at': createdAt.toIso8601String(),
  };
}
