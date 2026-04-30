import 'package:get/get.dart';


class DoctorShellController extends GetxController {
  final RxInt currentIndex = 0.obs;

  void switchTab(int index) {
    currentIndex.value = index;
  }
}
