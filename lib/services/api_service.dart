import 'dart:convert';
import 'package:http/http.dart' as http;
import 'storage_service.dart';
import '../models/chat_log_model.dart';
import '../models/node_metrics_model.dart';

class ApiService {
  final StorageService _storageService = StorageService();
  
  // Pointing directly to your active Cloudflare Worker profile bridge
  final String _fallbackUrl = 'https://portfolio-chat-bridge.sheikwin10.workers.dev';

  /// Helper to get the active URL configuration
  Future<String> _getEffectiveBaseUrl() async {
    final configuredUrl = await _storageService.getWorkerUrl();
    if (configuredUrl != null && configuredUrl.isNotEmpty) {
      return configuredUrl;
    }
    return _fallbackUrl;
  }

  /// Fetches real-time operational health and cache performance metrics from the serverless edge node
  Future<NodeMetrics> fetchNodeMetrics() async {
    try {
      final baseUrl = await _getEffectiveBaseUrl();
      final response = await http.get(Uri.parse('$baseUrl/api/metrics')).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return NodeMetrics.fromJson(data);
      } else {
        throw Exception('Serverless Node responded with code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Connection failed. Verify Cloudflare Worker routing. Details: $e');
    }
  }

  /// Pulls the historical tracking logs from your RAG database to monitor AI conversations
  Future<List<ChatLog>> fetchChatLogs() async {
    try {
      final baseUrl = await _getEffectiveBaseUrl();
      final response = await http.get(Uri.parse('$baseUrl/api/logs')).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((jsonItem) => ChatLog.fromJson(jsonItem)).toList();
      } else {
        throw Exception('RAG Ingestion Database responded with code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Database connector exception: $e');
    }
  }
}