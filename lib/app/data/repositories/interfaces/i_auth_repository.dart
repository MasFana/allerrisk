import '../../models/user_model.dart';

abstract class IAuthRepository {
  Future<UserModel> login(String email, String password);
  Future<UserModel> registerParent({
    required String name,
    required String email,
    required String password,
  });
  Future<UserModel> registerDoctor({
    required String name,
    required String email,
    required String password,
    required String strNumber,
    required String specialty,
    String? clinicName,
  });
  Future<void> logout();
  Future<UserModel?> getCurrentUser();
  Future<void> updateProfile(UserModel updatedUser);
}
