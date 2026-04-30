import 'package:get/get.dart';

import '../data/repositories/interfaces/i_article_repository.dart';
import '../data/repositories/interfaces/i_assessment_repository.dart';
import '../data/repositories/interfaces/i_auth_repository.dart';
import '../data/repositories/interfaces/i_child_repository.dart';
import '../data/repositories/interfaces/i_patient_repository.dart';
import '../data/repositories/mock/mock_article_repository.dart';
import '../data/repositories/mock/mock_assessment_repository.dart';
import '../data/repositories/mock/mock_auth_repository.dart';
import '../data/repositories/mock/mock_child_repository.dart';
import '../data/repositories/mock/mock_patient_repository.dart';

class AppBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<IAuthRepository>(() => MockAuthRepository(), fenix: true);
    Get.lazyPut<IChildRepository>(() => MockChildRepository(), fenix: true);
    Get.lazyPut<IAssessmentRepository>(
      () => MockAssessmentRepository(),
      fenix: true,
    );
    Get.lazyPut<IArticleRepository>(() => MockArticleRepository(), fenix: true);
    Get.lazyPut<IPatientRepository>(() => MockPatientRepository(), fenix: true);
  }
}
