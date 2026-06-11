/// The contract that all data services (Fake or Real) must follow.
abstract class IDataService {
  /// Stream to provide real-time dashboard metrics
  Stream<Map<String, dynamic>> getDashboardData();

  /// Stream to provide operational alert logs
  Stream<String> getAlerts();
}