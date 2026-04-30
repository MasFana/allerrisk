import 'package:get/get.dart';
import 'patient_detail_controller.dart';

class PatientDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PatientDetailController>(() => PatientDetailController());
  }
}
