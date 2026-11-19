import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:killswitch/components/snack_bar_view.dart';
import '../../../data/models/api_models.dart';
import '../../../data/repositories/trade_repository.dart';

class DashboardController extends GetxController {
  final _tradeRepo = TradeRepository();

  final isLoading = false.obs;

  final connectedBrokers = <BrokerConnection>[].obs;
  final activeLimits = <RiskLimit>[].obs;
  final todaySession = Rxn<TradingSession>();
  final supportedBrokers = Rxn<SupportedBrokers>();

  BrokerConnection? get activeBroker => connectedBrokers.firstOrNull;
  RiskLimit? get activeLimit => activeLimits.firstOrNull;

  @override
  void onInit() {
    super.onInit();
    refreshData();
  }

  Future<void> refreshData() async {
    isLoading.value = true;
    try {
      final brokersList = await _tradeRepo.fetchUserBrokers();
      connectedBrokers.value = brokersList;

      final limitsList = await _tradeRepo.fetchRiskLimits();
      activeLimits.value = limitsList;

      final session = await _tradeRepo.fetchTodaySession();
      todaySession.value = session;

      try {
        final supported = await _tradeRepo.fetchSupportedBrokers();
        supportedBrokers.value = supported;
      } catch (e) {
        debugPrint('Error fetching supported brokers in dashboard: $e');
      }
    } catch (e) {
      debugPrint('Error fetching dashboard data: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void triggerManualKill() async {
    final broker = activeBroker;
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
          icon: Icons.power_settings_new_rounded);
      await refreshData();
    } catch (e) {
      SnackBarUiView.showError(
          message: 'Unable to activate Kill Switch.');
    } finally {
      isLoading.value = false;
    }
  }

  void requestReactivation() async {
    final session = todaySession.value;
    if (session == null) return;

    isLoading.value = true;
    try {
      await _tradeRepo.reactivateSession(session.id);
      SnackBarUiView.showSuccess(
          message: 'Your request has been submitted to risk admin.',
          icon: Icons.refresh_rounded);
      await refreshData();
    } catch (e) {
      SnackBarUiView.showError(
          message: 'Unable to submit reactivation request.');
    } finally {
      isLoading.value = false;
    }
  }
}
