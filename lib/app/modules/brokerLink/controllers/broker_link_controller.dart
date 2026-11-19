import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:killswitch/components/snack_bar_view.dart';
import '../../../data/repositories/trade_repository.dart';
import '../../../data/models/api_models.dart';
import '../../dashboard/controllers/dashboard_controller.dart';

class BrokerLinkController extends GetxController {
  final _tradeRepo = TradeRepository();

  final apiKeyController = TextEditingController();
  final clientIdController = TextEditingController();

  final selectedBroker = 'dhan'.obs;
  final isLoading = false.obs;
  final isFetching = false.obs;
  final errorMessage = ''.obs;

  final connectedBrokers = <BrokerConnection>[].obs;
  final supportedBrokers = Rxn<SupportedBrokers>();

  @override
  void onInit() {
    super.onInit();
    fetchConnectedBrokers();
    fetchSupportedBrokers();
  }

  void fetchSupportedBrokers() async {
    try {
      final result = await _tradeRepo.fetchSupportedBrokers();
      supportedBrokers.value = result;
      if (result.live.isNotEmpty && !result.live.contains(selectedBroker.value)) {
        selectedBroker.value = result.live.first;
      }
    } catch (e) {
      debugPrint('Error fetching supported brokers: $e');
    }
  }

  void fetchConnectedBrokers() async {
    isFetching.value = true;
    try {
      final list = await _tradeRepo.fetchUserBrokers();
      connectedBrokers.value = list;
    } catch (e) {
      debugPrint('Error fetching connected brokers: $e');
    } finally {
      isFetching.value = false;
    }
  }

  void disconnectBroker(String id) async {
    isLoading.value = true;
    try {
      await _tradeRepo.deleteBroker(id);
      SnackBarUiView.showWarning(
        message: 'Successfully disconnected broker.',
        icon: Icons.link_off_rounded,
      );
      fetchConnectedBrokers();
      if (Get.isRegistered<DashboardController>()) {
        Get.find<DashboardController>().refreshData();
      }
    } catch (e) {
      SnackBarUiView.showError(
        message: 'Failed to disconnect broker.',
      );
    } finally {
      isLoading.value = false;
    }
  }

  void connectBroker() async {
    final broker = selectedBroker.value;
    final apiKey = apiKeyController.text.trim();
    final clientId = clientIdController.text.trim();

    if (apiKey.isEmpty || clientId.isEmpty) {
      errorMessage.value = 'Please enter API Key and Client ID';
      return;
    }

    isLoading.value = true;
    errorMessage.value = '';

    try {
      await _tradeRepo.connectBroker(broker, apiKey, clientId);
      
      apiKeyController.clear();
      clientIdController.clear();
      fetchConnectedBrokers();
      
      SnackBarUiView.showSuccess(
        message: 'Successfully linked $broker account.',
        icon: Icons.link_rounded,
      );

      if (Get.isRegistered<DashboardController>()) {
        Get.find<DashboardController>().refreshData();
      }
    } on DioException catch (e) {
      if (e.response != null && e.response?.data != null) {
        final errData = e.response?.data;
        if (errData is Map && errData['message'] != null) {
          errorMessage.value = errData['message'];
        } else {
          errorMessage.value = 'Failed to link broker. Please check credentials.';
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
    apiKeyController.dispose();
    clientIdController.dispose();
    super.onClose();
  }
}
