import 'package:get/get.dart';
import '../controllers/trade_config_controller.dart';

class TradeConfigBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TradeConfigController>(
      () => TradeConfigController(),
    );
  }
}
