import 'package:get/get.dart';
import '../controllers/broker_link_controller.dart';

class BrokerLinkBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BrokerLinkController>(
      () => BrokerLinkController(),
    );
  }
}
