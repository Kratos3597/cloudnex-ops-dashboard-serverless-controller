import 'package:flutter/material.dart';
import 'api_service.dart';
import '../models/chat_log_model.dart';
import '../models/node_metrics_model.dart';

class DashboardProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();

  NodeMetrics? _metrics;
  List<ChatLog> _logs = [];
  bool _isLoading = false;
  String? _errorMessage;

  NodeMetrics? get metrics => _metrics;
  List<ChatLog> get logs => _logs;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  /// Trigger a live refresh from your Cloudflare Worker endpoint
  Future<void> refreshDashboard() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Run both API requests in parallel for maximum enterprise performance
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
      notifyListeners(); // This instantly re-renders the mobile screen with new data
    }
  }
}