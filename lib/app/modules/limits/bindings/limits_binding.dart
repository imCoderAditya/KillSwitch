import 'package:get/get.dart';
import '../controllers/limits_controller.dart';

class LimitsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LimitsController>(
      () => LimitsController(),
    );
  }
}
