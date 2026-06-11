import 'dart:async';
import 'dart:math';

class FakeDataService {
  static final Random _random = Random();

  /// Stream for live, high-fidelity infrastructure metrics
  Stream<Map<String, dynamic>> getDashboardData() async* {
    while (true) {
      await Future.delayed(const Duration(seconds: 2));

      // Simulate dynamic infrastructure values
      int devices = 1100 + _random.nextInt(20);
      int users = 1240 + _random.nextInt(10);
      double backupRate = 99.0 + (_random.nextDouble() * 0.9);

      yield {
        "tenantName": "CloudNex Enterprise Solutions",
        "devices": devices,
        "users": users,
        "backupStatus": _getStatus(),
        "veeam": {
          "successRate": double.parse(backupRate.toStringAsFixed(1)),
          "repoStatus": "Immutable"
        },
        "azure": {
          "activeVMs": 8,
          "monthlyBurn": "R 14,250"
        }
      };
    }
  }

  static String _getStatus() {
    List<String> statuses = ["OK", "WARNING", "CRITICAL"];
    return statuses[_random.nextInt(statuses.length)];
  }

  /// Fake alert generator for the infrastructure log stream
  Stream<String> getAlerts() async* {
    List<String> alerts = [
      "✅ Backup completed successfully",
      "⚠ Device non-compliant detected",
      "❌ Backup failed on server 03",
      "✅ Azure synced",
      "⚠ High CPU usage detected",
      "🔒 Entra ID Identity Protection Alert",
      "⚙ Hyper-V Cluster Node Storage Allocation"
    ];

    while (true) {
      await Future.delayed(const Duration(seconds: 5));
      yield alerts[_random.nextInt(alerts.length)];
    }
  }
}