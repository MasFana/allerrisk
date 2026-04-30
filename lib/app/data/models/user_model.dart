// lib/app/data/models/user_model.dart

enum UserRole { parent, doctor }

class UserModel {
  final String id;
  final String name;
  final String email;
  final UserRole role;

  // Shared
  final String? avatarUrl;
  final bool isVerified;
  final DateTime createdAt;

  // Doctor specifics (null if parent)
  final String? strNumber;
  final String? specialty;
  final String? clinicName;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.avatarUrl,
    this.isVerified = false,
    required this.createdAt,
    this.strNumber,
    this.specialty,
    this.clinicName,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    id: json['id'] as String,
    name: json['name'] as String,
    email: json['email'] as String,
    role: UserRole.values.byName(json['role'] as String),
    avatarUrl: json['avatar_url'] as String?,
    isVerified: json['is_verified'] as bool? ?? false,
    createdAt: DateTime.parse(json['created_at'] as String),
    strNumber: json['str_number'] as String?,
    specialty: json['specialty'] as String?,
    clinicName: json['clinic_name'] as String?,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'email': email,
    'role': role.name,
    'avatar_url': avatarUrl,
    'is_verified': isVerified,
    'created_at': createdAt.toIso8601String(),
    'str_number': strNumber,
    'specialty': specialty,
    'clinic_name': clinicName,
  };

  UserModel copyWith({String? name, String? avatarUrl}) {
    return UserModel(
      id: id,
      name: name ?? this.name,
      email: email,
      role: role,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      isVerified: isVerified,
      createdAt: createdAt,
      strNumber: strNumber,
      specialty: specialty,
      clinicName: clinicName,
    );
  }
}
