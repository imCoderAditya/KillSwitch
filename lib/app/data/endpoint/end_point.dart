class EndPoint {
  static const String endPoint = 'https://trade-backend-20h6.onrender.com';

  // Auth
  static const String changePassword = '/api/auth/change-password';
  static const String authMe = '/api/auth/me';
  static const String authGoogle = '/api/auth/google';

  // Brokers
  static const String brokers = '/api/brokers';
  static const String supportedBrokers = '/api/brokers/supported';
  static String brokerFunds(String connectionId) =>
      '/api/brokers/$connectionId/funds';
  static String deleteBroker(String connectionId) =>
      '/api/brokers/$connectionId';

  // Limits
  static const String limits = '/api/limits';
  static String deleteLimit(String limitId) => '/api/limits/$limitId';
  static const String killNow = '/api/limits/kill-now';

  // Sessions
  static const String sessions = '/api/sessions';
  static const String sessionsToday = '/api/sessions/today';
  static const String sessionsStatsSummary = '/api/sessions/stats/summary';
  static String reactivateSession(String sessionId) =>
      '/api/sessions/$sessionId/reactivate';
  static String sessionById(String id) => '/api/sessions/$id';
}
