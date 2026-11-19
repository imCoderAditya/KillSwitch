import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:killswitch/components/snack_bar_view.dart';
import '../../../data/models/api_models.dart';
import '../../../data/repositories/trade_repository.dart';

class LogsController extends GetxController {
  final _tradeRepo = TradeRepository();

  final isLoading = false.obs;
  final todaySession = Rxn<TradingSession>();
  final statsSummary = Rxn<SessionStatsSummary>();

  final historicalSessions = <TradingSession>[].obs;
  final sessionsCurrentPage = 1.obs;
  final hasMoreSessions = true.obs;
  final isFetchingSessions = false.obs;
  final isReactivating = false.obs;

  @override
  void onInit() {
    super.onInit();
    refreshData();
  }

  Future<void> refreshData() async {
    isLoading.value = true;
    try {
      // Fetch today's session and stats in parallel
      final results = await Future.wait([
        _tradeRepo.fetchTodaySession(),
        _tradeRepo.fetchStatsSummary(),
      ]);
      todaySession.value = results[0] as TradingSession?;
      final statsData = results[1] as Map<String, dynamic>?;
      if (statsData != null) {
        statsSummary.value = SessionStatsSummary.fromJson(statsData);
      }
      await fetchSessionsHistory(loadMore: false);
    } catch (e) {
      debugPrint('Error refreshing logs data: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchSessionsHistory({bool loadMore = false}) async {
    if (isFetchingSessions.value) return;

    if (!loadMore) {
      sessionsCurrentPage.value = 1;
      historicalSessions.clear();
      hasMoreSessions.value = true;
    }

    if (!hasMoreSessions.value) return;

    isFetchingSessions.value = true;
    try {
      final data = await _tradeRepo.fetchAllSessions(page: sessionsCurrentPage.value);
      if (data != null && data['sessions'] != null) {
        final list = data['sessions'] as List;
        final sessions = list.map((e) => TradingSession.fromJson(e)).toList();
        final totalPages = data['pages'] ?? 1;

        if (sessions.isEmpty || sessionsCurrentPage.value >= totalPages) {
          hasMoreSessions.value = false;
        }
        historicalSessions.addAll(sessions);
        sessionsCurrentPage.value++;
      } else {
        hasMoreSessions.value = false;
      }
    } catch (e) {
      debugPrint('Error fetching session history: $e');
    } finally {
      isFetchingSessions.value = false;
    }
  }

  Future<void> reactivateSession(String sessionId) async {
    if (isReactivating.value) return;
    isReactivating.value = true;
    try {
      await _tradeRepo.reactivateSession(sessionId);
      SnackBarUiView.showSuccess(
        message: 'Trading session has been reactivated successfully.',
        icon: Icons.play_circle_outline_rounded,
        duration: const Duration(seconds: 3),
      );
      await refreshData();
    } catch (e) {
      SnackBarUiView.showError(
        message: e.toString().replaceAll('DioException [bad response]:', '').trim(),
        duration: const Duration(seconds: 3),
      );
    } finally {
      isReactivating.value = false;
    }
  }

  Future<TradingSession?> fetchSessionDetails(String sessionId) async {
    try {
      return await _tradeRepo.fetchSessionById(sessionId);
    } catch (e) {
      debugPrint('Error fetching session details: $e');
      return null;
    }
  }
}
