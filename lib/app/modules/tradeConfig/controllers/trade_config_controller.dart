import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:killswitch/components/snack_bar_view.dart';
import '../../../data/models/api_models.dart';
import '../../../data/repositories/trade_repository.dart';
import '../../dashboard/controllers/dashboard_controller.dart';

class TradeConfigController extends GetxController {
  final _tradeRepo = TradeRepository();

  final isLoading = false.obs;
  final activeLimits = <RiskLimit>[].obs;
  final isEditing = false.obs;
  final errorMessage = ''.obs;

  // Form controllers
  final lossLimitController = TextEditingController();
  final profitTargetController = TextEditingController();
  final maxTradesController = TextEditingController();
  final flattenOnBreach = true.obs;

  RiskLimit? get activeLimit => activeLimits.firstOrNull;

  @override
  void onInit() {
    super.onInit();
    fetchRiskLimits();
  }

  @override
  void onClose() {
    lossLimitController.dispose();
    profitTargetController.dispose();
    maxTradesController.dispose();
    super.onClose();
  }

  Future<void> fetchRiskLimits() async {
    isLoading.value = true;
    try {
      final list = await _tradeRepo.fetchRiskLimits();
      activeLimits.value = list;
    } catch (e) {
      debugPrint('Error fetching risk limits in trade config: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void toggleEditMode(bool edit) {
    isEditing.value = edit;
    errorMessage.value = '';
    if (edit) {
      final limit = activeLimit;
      if (limit != null) {
        lossLimitController.text = limit.dailyLossLimit.abs().toStringAsFixed(0);
        profitTargetController.text = limit.profitTarget.toStringAsFixed(0);
        maxTradesController.text = limit.maxTrades.toString();
        flattenOnBreach.value = limit.flattenOnBreach;
      } else {
        lossLimitController.clear();
        profitTargetController.clear();
        maxTradesController.clear();
        flattenOnBreach.value = true;
      }
    }
  }

  Future<void> saveLimits() async {
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

      await fetchRiskLimits();
      Get.find<DashboardController>().refreshData();
      isEditing.value = false;
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

  Future<void> deactivateLimit() async {
    final limit = activeLimit;
    if (limit == null) return;

    isLoading.value = true;
    try {
      await _tradeRepo.deleteRiskLimit(limit.id);
      SnackBarUiView.showWarning(
        message: 'Daily risk controls have been deactivated.',
        icon: Icons.shield_outlined,
      );
      await fetchRiskLimits();
      Get.find<DashboardController>().refreshData();
    } catch (e) {
      SnackBarUiView.showError(
        message: 'Unable to deactivate risk limits.',
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> triggerEmergencyKill() async {
    if (!Get.isRegistered<DashboardController>()) {
      SnackBarUiView.showError(
          message: 'Dashboard controller not found.');
      return;
    }

    final broker = Get.find<DashboardController>().activeBroker;
    if (broker == null) {
      SnackBarUiView.showWarning(
          message: 'Please connect a broker account first.',
          icon: Icons.account_balance_outlined);
      return;
    }

    isLoading.value = true;
    try {
      final message = await _tradeRepo.triggerManualKill(broker.id);
      SnackBarUiView.showWarning(
        message: message,
        icon: Icons.power_settings_new_rounded,
      );
      await fetchRiskLimits();
      Get.find<DashboardController>().refreshData();
    } catch (e) {
      SnackBarUiView.showError(
        message: 'Unable to trigger manual kill switch.',
      );
    } finally {
      isLoading.value = false;
    }
  }
}
