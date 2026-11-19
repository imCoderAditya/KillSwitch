import 'dart:developer';

import 'package:get/get.dart';
import '../baseclient/base_client.dart';
import '../models/api_models.dart';
import '../endpoint/end_point.dart';

class TradeRepository {
  final _client = Get.find<BaseClient>();

  Future<List<BrokerConnection>> fetchUserBrokers() async {
    try {
      final response = await _client.dio.get(EndPoint.brokers);
      final list = response.data['data'] as List?;
      if (list == null) return [];
      final brokers = list.map((e) => BrokerConnection.fromJson(e)).toList();

      for (var b in brokers) {
        try {
          final funds = await fetchBrokerFunds(b.id);
          b.funds = funds;
          b.clientId = funds.dhanClientId;
          b.balance = funds.availableBalance;
        } catch (e) {
          Get.log('Error loading funds for broker ${b.id}: $e');
        }
      }
      return brokers;
    } catch (e) {
      rethrow;
    }
  }

  Future<BrokerConnection> connectBroker(
    String broker,
    String apiKey,
    String clientId,
  ) async {
    try {
      final response = await _client.dio.post(
        EndPoint.brokers,
        data: {
          'broker': broker.toLowerCase(),
          'apiKey': apiKey,
          'clientId': clientId,
        },
      );
      return BrokerConnection.fromJson(response.data['data']);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteBroker(String connectionId) async {
    try {
      await _client.dio.delete(EndPoint.deleteBroker(connectionId));
    } catch (e) {
      rethrow;
    }
  }

  Future<SupportedBrokers> fetchSupportedBrokers() async {
    try {
      final response = await _client.dio.get(EndPoint.supportedBrokers);
      return SupportedBrokers.fromJson(response.data['data']);
    } catch (e) {
      rethrow;
    }
  }

  Future<BrokerFunds> fetchBrokerFunds(String connectionId) async {
    try {
      final response = await _client.dio.get(
        EndPoint.brokerFunds(connectionId),
      );
      return BrokerFunds.fromJson(response.data['data']);
    } catch (e) {
      rethrow;
    }
  }

  Future<List<RiskLimit>> fetchRiskLimits() async {
    try {
      final response = await _client.dio.get(EndPoint.limits);
      final list = response.data['data'] as List?;
      if (list == null) return [];
      return list.map((e) => RiskLimit.fromJson(e)).toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<RiskLimit> saveRiskLimit({
    required String brokerConnectionId,
    required double dailyLossLimit,
    required double profitTarget,
    required int maxTrades,
    required bool flattenOnBreach,
  }) async {
    try {
      final response = await _client.dio.post(
        EndPoint.limits,
        data: {
          'brokerConnectionId': brokerConnectionId,
          'dailyLossLimit': dailyLossLimit,
          'profitTarget': profitTarget,
          'maxTrades': maxTrades,
          'flattenOnBreach': flattenOnBreach,
        },
      );
      return RiskLimit.fromJson(response.data['data']);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteRiskLimit(String limitId) async {
    try {
      await _client.dio.delete(EndPoint.deleteLimit(limitId));
    } catch (e) {
      rethrow;
    }
  }

  Future<String> triggerManualKill(String brokerConnectionId) async {
    log("brokerConnectionId $brokerConnectionId");
    try {
      final response = await _client.dio.post(
        EndPoint.killNow,
        data: {'brokerConnectionId': brokerConnectionId},
      );
      return response.data['message'] ?? 'Manual kill switch triggered immediately';
    } catch (e) {
      rethrow;
    }
  }

  Future<TradingSession?> fetchTodaySession() async {
    try {
      final response = await _client.dio.get(EndPoint.sessionsToday);
      final data = response.data['data'];
      if (data == null) return null;
      return TradingSession.fromJson(data);
    } catch (e) {
      return null;
    }
  }

  Future<void> reactivateSession(String sessionId) async {
    try {
      await _client.dio.post(EndPoint.reactivateSession(sessionId));
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> fetchStatsSummary() async {
    try {
      final response = await _client.dio.get(EndPoint.sessionsStatsSummary);
      return response.data['data'];
    } catch (e) {
      return null;
    }
  }

  Future<UserProfile> fetchUserProfile() async {
    try {
      final response = await _client.dio.get(EndPoint.authMe);
      return UserProfile.fromJson(response.data['data']);
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> googleLogin({
    required String name,
    required String email,
    required String googleId,
    required String profilePicture,
  }) async {
    try {
      final response = await _client.dio.post(
        EndPoint.authGoogle,
        data: {
          'name': name,
          'email': email,
          'googleId': googleId,
          'profilePicture': profilePicture,
        },
      );
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      await _client.dio.patch(
        EndPoint.changePassword,
        data: {'currentPassword': currentPassword, 'newPassword': newPassword},
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> fetchAllSessions({int page = 1}) async {
    try {
      final response = await _client.dio.get(
        EndPoint.sessions,
        queryParameters: {'page': page},
      );
      return response.data['data'];
    } catch (e) {
      return null;
    }
  }

  Future<TradingSession?> fetchSessionById(String id) async {
    try {
      final response = await _client.dio.get(EndPoint.sessionById(id));
      final data = response.data['data'];
      if (data == null) return null;
      return TradingSession.fromJson(data);
    } catch (e) {
      return null;
    }
  }
}
