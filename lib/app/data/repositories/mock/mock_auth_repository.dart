import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

import '../interfaces/i_auth_repository.dart';
import '../../models/user_model.dart';
import '../../../core/services/storage_service.dart';
import '../../../core/services/auth_service.dart';

class MockAuthRepository implements IAuthRepository {
  StorageService get _storage => Get.find<StorageService>();
  AuthService get _auth => Get.find<AuthService>();

  Future<void> _delay() => Future.delayed(const Duration(milliseconds: 800));

  @override
  Future<UserModel> login(String email, String password) async {
    await _delay();

    final userMap = _storage.findOne(StorageKeys.users, 'email', email);
    if (userMap == null || userMap['password'] != password) {
      throw Exception('Email atau password salah.');
    }

    final user = UserModel.fromJson(userMap);
    final mockJwt = 'mock_jwt_${const Uuid().v4()}';

    await _storage.saveSession(
      token: mockJwt,
      user: user.toJson(),
      role: user.role.name,
    );
    _auth.onLoginSuccess(user, mockJwt);

    return user;
  }

  @override
  Future<UserModel> registerParent({
    required String name,
    required String email,
    required String password,
  }) async {
    await _delay();

    if (_storage.findOne(StorageKeys.users, 'email', email) != null) {
      throw Exception('Email sudah terdaftar. Silakan gunakan email lain.');
    }

    final user = UserModel(
      id: 'usr_parent_${const Uuid().v4().substring(0, 8)}',
      name: name,
      email: email,
      role: UserRole.parent,
      createdAt: DateTime.now(),
      isVerified: true, // Auto-verified for parent
    );

    final rawData = user.toJson();
    rawData['password'] = password;
    await _storage.upsertOne(StorageKeys.users, rawData);

    // Auto-login after register
    final mockJwt = 'mock_jwt_${const Uuid().v4()}';
    await _storage.saveSession(
      token: mockJwt,
      user: user.toJson(),
      role: user.role.name,
    );
    _auth.onLoginSuccess(user, mockJwt);

    return user;
  }

  @override
  Future<UserModel> registerDoctor({
    required String name,
    required String email,
    required String password,
    required String strNumber,
    required String specialty,
    String? clinicName,
  }) async {
    await _delay();

    if (_storage.findOne(StorageKeys.users, 'email', email) != null) {
      throw Exception('Email sudah terdaftar. Silakan gunakan email lain.');
    }

    final user = UserModel(
      id: 'usr_doctor_${const Uuid().v4().substring(0, 8)}',
      name: name,
      email: email,
      role: UserRole.doctor,
      strNumber: strNumber,
      specialty: specialty,
      clinicName: clinicName,
      createdAt: DateTime.now(),
      isVerified: false, // Doctors need verification
    );

    final rawData = user.toJson();
    rawData['password'] = password;
    await _storage.upsertOne(StorageKeys.users, rawData);

    // Auto-login
    final mockJwt = 'mock_jwt_${const Uuid().v4()}';
    await _storage.saveSession(
      token: mockJwt,
      user: user.toJson(),
      role: user.role.name,
    );
    _auth.onLoginSuccess(user, mockJwt);

    return user;
  }

  @override
  Future<void> logout() async {
    await _delay();
    await _auth.logout();
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    await _delay();
    return _auth.currentUser.value;
  }

  @override
  Future<void> updateProfile(UserModel updatedUser) async {
    await _delay();

    final existingUserMap = _storage.findOne(
      StorageKeys.users,
      'id',
      updatedUser.id,
    );
    if (existingUserMap == null) return;

    final updatedMap = updatedUser.toJson();
    // Preserve local-only password
    updatedMap['password'] = existingUserMap['password'];

    await _storage.upsertOne(StorageKeys.users, updatedMap);
    _auth.updateCurrentUser(updatedUser);
  }
}
