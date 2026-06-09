import 'dart:async';
import 'dart:math';

class FakeDataService {
  static final Random _random = Random();

  /// Stream for live dashboard data
  Stream<Map<String, dynamic>> getDashboardData() async* {
    int devices = 20;
    int users = 100;

    while (true) {
      await Future.delayed(const Duration(seconds: 2));

      devices += _random.nextInt(3);
      users += _random.nextInt(5);

      if (devices > 40) devices = 20;
      if (users > 150) users = 100;

      yield {
        "devices": devices,
        "users": users,
        "backupStatus": _getStatus(),
      };
    }
  }

  static String _getStatus() {
    List<String> statuses = ["OK", "WARNING", "CRITICAL"];
    return statuses[_random.nextInt(statuses.length)];
  }

  /// Fake alert generator
  Stream<String> getAlerts() async* {
    List<String> alerts = [
      "✅ Backup completed successfully",
      "⚠ Device non-compliant detected",
      "❌ Backup failed on server 03",
      "✅ Azure synced",
      "⚠ High CPU usage detected"
    ];

    while (true) {
      await Future.delayed(const Duration(seconds: 4));
      yield alerts[_random.nextInt(alerts.length)];
    }
  }
}