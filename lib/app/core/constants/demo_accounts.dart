import '../../data/models/user_model.dart';

/// TODO(real-auth): Remove hardcoded demo credentials after backend auth is ready.
abstract class DemoAccounts {
  static const String demoPassword = 'demo1234';

  static const String parentEmail = 'budi@demo.com';
  static const String doctorEmail = 'dokter@demo.com';

  static String emailForRole(UserRole? role) {
    return role == UserRole.doctor ? doctorEmail : parentEmail;
  }
}
