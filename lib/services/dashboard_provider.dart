import 'package:flutter/material.dart';
import 'api_service.dart';
import 'storage_service.dart';
import '../models/chat_log_model.dart';
import '../models/node_metrics_model.dart';

class DashboardProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  final StorageService _storageService = StorageService();

  NodeMetrics? _metrics;
  List<ChatLog> _logs = [];
  bool _isLoading = false;
  String? _errorMessage;
  String _currentWorkerUrl = '';

  NodeMetrics? get metrics => _metrics;
  List<ChatLog> get logs => _logs;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String get currentWorkerUrl => _currentWorkerUrl;

  /// Load the saved URL configuration from the hardware vault on initialization
  Future<void> loadConfig() async {
    final url = await _storageService.getWorkerUrl();
    _currentWorkerUrl = url ?? 'https://portfolio-chat-bridge.Kratos3597.workers.dev';
    notifyListeners();
  }

  /// Save a new target endpoint securely and trigger an immediate cluster update
  Future<void> updateWorkerUrl(String newUrl) async {
    await _storageService.saveWorkerUrl(newUrl);
    _currentWorkerUrl = newUrl;
    notifyListeners();
    await refreshDashboard();
  }

  /// Trigger a live refresh from your Cloudflare Worker endpoint
  Future<void> refreshDashboard() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final results = await Future.wait([
        _apiService.fetchNodeMetrics(),
        _apiService.fetchChatLogs(),
      ]);

      _metrics = results[0] as NodeMetrics;
      _logs = results[1] as List<ChatLog>;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}