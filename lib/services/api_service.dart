import 'dart:convert';
import 'package:http/http.dart' as http;
import 'storage_service.dart';
import '../models/node_metrics_model.dart';
import '../models/chat_log_model.dart';

class ApiService {
  final StorageService _storageService = StorageService();
  final String _fallbackUrl = 'https://portfolio-chat-bridge.sheikwin10.workers.dev';

  /// 1. Dynamic Routing: Always fetches the URL from secure storage first
  Future<String> _getEffectiveBaseUrl() async {
    final configuredUrl = await _storageService.getWorkerUrl();
    return (configuredUrl != null && configuredUrl.isNotEmpty) 
        ? configuredUrl 
        : _fallbackUrl;
  }

  /// 2. Production Metrics Fetcher
  Future<NodeMetrics> fetchNodeMetrics() async {
    final baseUrl = await _getEffectiveBaseUrl();
    try {
      final response = await http.get(Uri.parse('$baseUrl/api/metrics'))
          .timeout(const Duration(seconds: 8));

      if (response.statusCode == 200) {
        return NodeMetrics.fromJson(json.decode(response.body));
      } else {
        throw Exception('Worker Error: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Node Unreachable: Ensure Worker is deployed at $baseUrl. Details: $e');
    }
  }

  /// 3. Secure Log Ingestion
  Future<List<ChatLog>> fetchChatLogs() async {
    final baseUrl = await _getEffectiveBaseUrl();
    final response = await http.get(Uri.parse('$baseUrl/api/logs'))
        .timeout(const Duration(seconds: 10));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((jsonItem) => ChatLog.fromJson(jsonItem)).toList();
    } else {
      throw Exception('Database connector failure.');
    }
  }
}