class SupportedBrokers {
  final List<String> live;
  final List<String> comingSoon;

  SupportedBrokers({
    required this.live,
    required this.comingSoon,
  });

  factory SupportedBrokers.fromJson(Map<String, dynamic> json) {
    return SupportedBrokers(
      live: List<String>.from(json['live'] ?? []),
      comingSoon: List<String>.from(json['comingSoon'] ?? []),
    );
  }
}

class BrokerFunds {
  final String dhanClientId;
  final double availableBalance;
  final double sodLimit;
  final double collateralAmount;
  final double receivableAmount;
  final double utilizedAmount;
  final double blockedPayoutAmount;
  final double withdrawableBalance;

  BrokerFunds({
    required this.dhanClientId,
    required this.availableBalance,
    required this.sodLimit,
    required this.collateralAmount,
    required this.receivableAmount,
    required this.utilizedAmount,
    required this.blockedPayoutAmount,
    required this.withdrawableBalance,
  });

  factory BrokerFunds.fromJson(Map<String, dynamic> json) {
    return BrokerFunds(
      dhanClientId: json['dhanClientId']?.toString() ?? '',
      availableBalance: double.tryParse(json['availabelBalance']?.toString() ?? '0') ?? 0.0,
      sodLimit: double.tryParse(json['sodLimit']?.toString() ?? '0') ?? 0.0,
      collateralAmount: double.tryParse(json['collateralAmount']?.toString() ?? '0') ?? 0.0,
      receivableAmount: double.tryParse(json['receiveableAmount']?.toString() ?? '0') ?? 0.0,
      utilizedAmount: double.tryParse(json['utilizedAmount']?.toString() ?? '0') ?? 0.0,
      blockedPayoutAmount: double.tryParse(json['blockedPayoutAmount']?.toString() ?? '0') ?? 0.0,
      withdrawableBalance: double.tryParse(json['withdrawableBalance']?.toString() ?? '0') ?? 0.0,
    );
  }
}

class BrokerConnection {
  final String id;
  final String broker;
  final bool isActive;
  final String user;
  final String createdAt;
  final String updatedAt;
  String? clientId;
  double? balance;
  BrokerFunds? funds;

  BrokerConnection({
    required this.id,
    required this.broker,
    required this.isActive,
    required this.user,
    required this.createdAt,
    required this.updatedAt,
    this.clientId,
    this.balance,
    this.funds,
  });

  factory BrokerConnection.fromJson(Map<String, dynamic> json) {
    return BrokerConnection(
      id: json['_id'] ?? json['id'] ?? '',
      broker: json['broker'] ?? '',
      isActive: json['isActive'] ?? true,
      user: json['user'] ?? '',
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
      clientId: json['clientId']?.toString(),
      balance: json['balance'] != null ? double.tryParse(json['balance'].toString()) : null,
    );
  }
}


class RiskLimit {
  final String id;
  final String brokerConnectionId;
  final double dailyLossLimit;
  final double profitTarget;
  final int maxTrades;
  final bool flattenOnBreach;

  RiskLimit({
    required this.id,
    required this.brokerConnectionId,
    required this.dailyLossLimit,
    required this.profitTarget,
    required this.maxTrades,
    required this.flattenOnBreach,
  });

  factory RiskLimit.fromJson(Map<String, dynamic> json) {
    return RiskLimit(
      id: json['_id'] ?? json['id'] ?? '',
      brokerConnectionId: json['brokerConnectionId'] ?? '',
      dailyLossLimit: double.tryParse(json['dailyLossLimit']?.toString() ?? '0') ?? 0.0,
      profitTarget: double.tryParse(json['profitTarget']?.toString() ?? '0') ?? 0.0,
      maxTrades: json['maxTrades'] ?? 0,
      flattenOnBreach: json['flattenOnBreach'] ?? false,
    );
  }
}

class AuditLogItem {
  final String id;
  final String timestamp;
  final String action;
  final String details;

  AuditLogItem({
    required this.id,
    required this.timestamp,
    required this.action,
    required this.details,
  });

  factory AuditLogItem.fromJson(Map<String, dynamic> json) {
    return AuditLogItem(
      id: json['_id'] ?? json['id'] ?? '',
      timestamp: json['timestamp'] ?? '',
      action: json['action'] ?? '',
      details: json['details'] ?? '',
    );
  }
}

class SessionStatsSummary {
  final double totalPnL;
  final int totalBreaches;
  final int totalSessions;
  final double averagePnL;

  SessionStatsSummary({
    required this.totalPnL,
    required this.totalBreaches,
    required this.totalSessions,
    required this.averagePnL,
  });

  factory SessionStatsSummary.fromJson(Map<String, dynamic> json) {
    return SessionStatsSummary(
      totalPnL: double.tryParse(json['totalPnL']?.toString() ?? '0') ?? 0.0,
      totalBreaches: json['totalBreaches'] ?? 0,
      totalSessions: json['totalSessions'] ?? 0,
      averagePnL: double.tryParse(json['averagePnL']?.toString() ?? '0') ?? 0.0,
    );
  }
}

class TradingSession {
  final String id;
  final String status;
  final double netPnL;
  final int tradesCount;
  final String? breachReason;
  final bool reactivationRequested;
  final int positionsCount;
  final int ordersCount;
  final double lockedProfit;
  final List<AuditLogItem> auditLog;
  final String date;
  final String? brokerName;

  TradingSession({
    required this.id,
    required this.status,
    required this.netPnL,
    required this.tradesCount,
    this.breachReason,
    required this.reactivationRequested,
    required this.positionsCount,
    required this.ordersCount,
    required this.lockedProfit,
    required this.auditLog,
    required this.date,
    this.brokerName,
  });

  factory TradingSession.fromJson(Map<String, dynamic> json) {
    // Determine reactivation requested status
    bool reactivated = false;
    final req = json['reactivationRequest'];
    if (req != null) {
      if (req is bool) {
        reactivated = req;
      } else if (req is Map) {
        reactivated = req['status'] == 'pending' || req['status'] == 'approved';
      }
    }

    var logList = json['auditLog'] as List? ?? [];
    List<AuditLogItem> auditLogs = logList.map((e) => AuditLogItem.fromJson(e)).toList();

    // brokerConnectionId can be null, a string, or a Map with _id and broker
    String? brokerName;
    final brokerConn = json['brokerConnectionId'];
    if (brokerConn is Map) {
      brokerName = brokerConn['broker']?.toString();
    }

    return TradingSession(
      id: json['_id'] ?? json['id'] ?? '',
      status: json['status'] ?? 'ACTIVE',
      netPnL: double.tryParse(json['netPnL']?.toString() ?? json['pnl']?.toString() ?? '0') ?? 0.0,
      tradesCount: json['tradesCount'] ?? 0,
      breachReason: json['breachReason'],
      reactivationRequested: reactivated,
      positionsCount: json['positionsCount'] ?? json['openPositions'] ?? 0,
      ordersCount: json['ordersCount'] ?? json['totalOrders'] ?? json['placedOrders'] ?? 0,
      lockedProfit: double.tryParse(json['lockedProfit']?.toString() ?? json['profitLocked']?.toString() ?? '0') ?? 0.0,
      auditLog: auditLogs,
      date: json['date'] ?? json['createdAt'] ?? '',
      brokerName: brokerName,
    );
  }
}

class UserProfile {
  final String id;
  final String name;
  final String email;
  final String? profilePicture;
  final String createdAt;
  final String updatedAt;
  final List<ProfileBroker> brokers;

  UserProfile({
    required this.id,
    required this.name,
    required this.email,
    this.profilePicture,
    required this.createdAt,
    required this.updatedAt,
    required this.brokers,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    var brokerList = json['brokers'] as List? ?? [];
    return UserProfile(
      id: json['_id'] ?? json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      profilePicture: json['profilePicture'],
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
      brokers: brokerList.map((e) => ProfileBroker.fromJson(e)).toList(),
    );
  }
}

class ProfileBroker {
  final String id;
  final String broker;
  final bool isActive;
  final String status;
  final BrokerFunds? liveFunds;

  ProfileBroker({
    required this.id,
    required this.broker,
    required this.isActive,
    required this.status,
    this.liveFunds,
  });

  factory ProfileBroker.fromJson(Map<String, dynamic> json) {
    return ProfileBroker(
      id: json['_id'] ?? json['id'] ?? '',
      broker: json['broker'] ?? '',
      isActive: json['isActive'] ?? true,
      status: json['status'] ?? 'connected',
      liveFunds: json['liveFunds'] != null ? BrokerFunds.fromJson(json['liveFunds']) : null,
    );
  }
}

