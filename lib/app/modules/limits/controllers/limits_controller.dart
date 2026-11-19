import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:killswitch/components/snack_bar_view.dart';
import '../../../data/repositories/trade_repository.dart';
import '../../dashboard/controllers/dashboard_controller.dart';
import '../../tradeConfig/controllers/trade_config_controller.dart';

class LimitsController extends GetxController {
  final _tradeRepo = TradeRepository();

  final lossLimitController = TextEditingController();
  final profitTargetController = TextEditingController();
  final maxTradesController = TextEditingController();

  final flattenOnBreach = true.obs;
  final isLoading = false.obs;
  final errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    if (Get.isRegistered<DashboardController>()) {
      final activeLimit = Get.find<DashboardController>().activeLimit;
      if (activeLimit != null) {
        lossLimitController.text = activeLimit.dailyLossLimit.abs().toStringAsFixed(0);
        profitTargetController.text = activeLimit.profitTarget.toStringAsFixed(0);
        maxTradesController.text = activeLimit.maxTrades.toString();
        flattenOnBreach.value = activeLimit.flattenOnBreach;
      }
    }
  }

  void saveLimits() async {
    final lossStr = lossLimitController.text.trim();
    final profitStr = profitTargetController.text.trim();
    final maxTradesStr = maxTradesController.text.trim();

    if (lossStr.isEmpty || profitStr.isEmpty || maxTradesStr.isEmpty) {
      errorMessage.value = 'Please fill all limits fields';
      return;
    }

    final double? lossVal = double.tryParse(lossStr);
    final double? profitVal = double.tryParse(profitStr);
    final int? maxTradesVal = int.tryParse(maxTradesStr);

    if (lossVal == null || profitVal == null || maxTradesVal == null) {
      errorMessage.value = 'Please enter valid numbers';
      return;
    }

    final double dailyLossLimit = -lossVal.abs();
    final double profitTarget = profitVal.abs();
    final int maxTrades = maxTradesVal.abs();

    if (!Get.isRegistered<DashboardController>()) {
      errorMessage.value = 'Dashboard session state not found.';
      return;
    }

    final brokerConnection = Get.find<DashboardController>().activeBroker;
    if (brokerConnection == null) {
      errorMessage.value = 'Please connect a broker account first.';
      return;
    }

    isLoading.value = true;
    errorMessage.value = '';

    try {
      await _tradeRepo.saveRiskLimit(
        brokerConnectionId: brokerConnection.id,
        dailyLossLimit: dailyLossLimit,
        profitTarget: profitTarget,
        maxTrades: maxTrades,
        flattenOnBreach: flattenOnBreach.value,
      );

      SnackBarUiView.showSuccess(
        message: 'Your daily risk controls are updated.',
        icon: Icons.shield_rounded,
      );

      Get.find<DashboardController>().refreshData();
      if (Get.isRegistered<TradeConfigController>()) {
        Get.find<TradeConfigController>().fetchRiskLimits();
      }
      Get.back();
    } on DioException catch (e) {
      if (e.response != null && e.response?.data != null) {
        final errData = e.response?.data;
        if (errData is Map && errData['message'] != null) {
          errorMessage.value = errData['message'];
        } else {
          errorMessage.value = 'Failed to save risk limits. Please try again.';
        }
      } else {
        errorMessage.value = 'Network error. Please try again.';
      }
    } catch (e) {
      errorMessage.value = 'An unexpected error occurred.';
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    lossLimitController.dispose();
    profitTargetController.dispose();
    maxTradesController.dispose();
    super.onClose();
  }
}
