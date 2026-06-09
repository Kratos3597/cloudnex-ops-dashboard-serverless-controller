import 'package:flutter/material.dart';

class DashboardProvider with ChangeNotifier {
  bool _isLoading = false;
  String _currentWorkerUrl = 'https://portfolio-chat-bridge.sheikwin10.workers.dev';
  String _activeConsole = 'M365'; // Default starting view state

  // Public Getters explicitly tracking UI demands
  bool get isLoading => _isLoading;
  String get currentWorkerUrl => _currentWorkerUrl;
  String get activeConsole => _activeConsole;

  // Multi-Tenant Infrastructure Map State Variables
  Map<String, dynamic> tenantMetrics = {};
  List<Map<String, dynamic>> infrastructureLogs = [];

  void changeConsole(String consoleId) {
    _activeConsole = consoleId;
    notifyListeners();
  }

  Future<void> loadConfig() async {
    _generateHighFidelityDummyData();
    notifyListeners();
  }

  void _generateHighFidelityDummyData() {
    // High-fidelity Microsoft 365, Azure, Entra, and Veeam monitoring structures
    tenantMetrics = {
      "tenantName": "CloudNex Enterprise Solutions",
      "tenantId": "c0a80101-7b3c-44af-8123-dc101337afaa",
      "serverSpace": {"usedTB": 42.8, "totalTB": 64.0, "status": "Healthy"},
      "backupServers": {"total": 12, "successful": 11, "failed": 1, "lastSync": "Just now"},
      "securityScore": {"current": 84, "target": 95, "mfaEnabled": "98%"},
      "entraId": {"users": 1245, "groups": 88, "syncStatus": "In Sync", "riskyUsers": 0, "appRegistrations": 14},
      "intune": {"compliantDevices": 1102, "nonCompliant": 14, "totalDevices": 1116, "windows": 942, "iOS": 120, "android": 54},
      "veeam": {"sobrCapacity": 84.5, "successRate": 99.2, "repoStatus": "Immutable"},
      "azure": {"activeVMs": 8, "vnetStatus": "Connected", "monthlyBurn": "R 14,250"}
    };

    infrastructureLogs = [
      {
        "category": "Intune",
        "event": "Device Configuration Profile Enforcement",
        "details": "Pushed BitLocker Encryption policy to 14 newly enrolled Windows 11 Endpoints.",
        "status": "Success",
        "timestamp": "10:14 AM"
      },
      {
        "category": "Backup",
        "event": "Veeam Replication Job: VM-PROD-SQL01",
        "details": "Synthetic full backup completed. 1.2 TB processed. Target storage repository: On-Premise SAN.",
        "status": "Success",
        "timestamp": "09:30 AM"
      },
      {
        "category": "Security",
        "event": "Entra ID Identity Protection Alert",
        "details": "Unfamiliar sign-in properties detected for user admin@cloudnex.co.za. Risk mitigated via conditional access MFA challenge.",
        "status": "Warning",
        "timestamp": "08:45 AM"
      },
      {
        "category": "Infrastructure",
        "event": "Hyper-V Cluster Node Storage Allocation",
        "details": "Provisioned 500GB VHDX for automated dev environment sandbox pipeline.",
        "status": "Success",
        "timestamp": "07:12 AM"
      }
    ];
  }

  Future<void> updateWorkerUrl(String newUrl) async {
    _currentWorkerUrl = newUrl;
    notifyListeners();
    await refreshDashboard();
  }

  Future<void> refreshDashboard() async {
    _isLoading = true;
    notifyListeners();

    // Minor cloud network emulation delay
    await Future.delayed(const Duration(milliseconds: 400));
    _generateHighFidelityDummyData();

    _isLoading = false;
    notifyListeners();
  }
}