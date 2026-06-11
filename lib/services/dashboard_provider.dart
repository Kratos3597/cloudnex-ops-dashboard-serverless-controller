import 'package:flutter/material.dart';
import '../services/fake_data_service.dart';
import '../services/api_service.dart';
import '../services/storage_service.dart';

class DashboardProvider with ChangeNotifier {
  // Services
  final FakeDataService _fakeService = FakeDataService();
  final ApiService _apiService = ApiService();
  final StorageService _storageService = StorageService();

  // State Variables
  bool _isLoading = false;
  String _activeConsole = 'M365';
  Map<String, dynamic> tenantMetrics = {};
  List<Map<String, dynamic>> infrastructureLogs = [];

  // Getters
  bool get isLoading => _isLoading;
  String get activeConsole => _activeConsole;

  DashboardProvider() {
    _initializeProvider();
  }

  Future<void> _initializeProvider() async {
    // 1. Initialize High-Fidelity Dummy Data
    _generateHighFidelityDummyData();

    // 2. Load persisted URL from StorageService
    String? savedUrl = await _storageService.getWorkerUrl();
    debugPrint("System Node URL: ${savedUrl ?? 'Using Default'}");

    // 3. Start reactive streams
    _startDataStreams();
  }

  void _generateHighFidelityDummyData() {
    tenantMetrics = {
      "tenantName": "CloudNex Enterprise Solutions",
      "tenantId": "c0a80101-7b3c-44af-8123-dc101337afaa",
      "serverSpace": {"usedTB": 42.8, "totalTB": 64.0, "status": "Healthy"},
      "backupServers": {"total": 12, "successful": 11, "failed": 1},
      "entraId": {"users": 1245, "syncStatus": "In Sync"},
      "intune": {"compliantDevices": 1102, "totalDevices": 1116},
      "veeam": {"successRate": 99.2, "repoStatus": "Immutable"},
      "azure": {"activeVMs": 8, "monthlyBurn": "R 14,250"},
      "devices": 20,
      "users": 100,
      "backupStatus": "INITIALIZING..."
    };
    notifyListeners();
  }

  void _startDataStreams() {
    // Reactive Metrics Stream
    _fakeService.getDashboardData().listen((data) {
      tenantMetrics.addAll({
        "devices": data['devices'],
        "users": data['users'],
        "backupStatus": data['backupStatus'],
      });
      notifyListeners();
    });

    // Reactive Log Stream (FIXED: Using DateTime instead of TimeOfDay)
    _fakeService.getAlerts().listen((alert) {
      final now = DateTime.now();
      final timeString = "${now.hour}:${now.minute.toString().padLeft(2, '0')}";

      infrastructureLogs.insert(0, {
        "event": alert,
        "timestamp": timeString,
        "status": "Info"
      });
      
      if (infrastructureLogs.length > 5) infrastructureLogs.removeLast();
      notifyListeners();
    });
  }

  Future<void> refreshRealTimeMetrics() async {
    _isLoading = true;
    notifyListeners();
    try {
      // Integration with your ApiService
      final liveMetrics = await _apiService.fetchNodeMetrics();
      debugPrint("Real-time sync successful: ${liveMetrics.runtimeType}");
    } catch (e) {
      debugPrint("Live Sync Error: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void changeConsole(String consoleId) {
    _activeConsole = consoleId;
    notifyListeners();
  }
}