class ChatLog {
  final String id;
  final String userQuery;
  final String aiResponse;
  final DateTime timestamp;
  final double executionTime;

  ChatLog({
    required this.id,
    required this.userQuery,
    required this.aiResponse,
    required this.timestamp,
    required this.executionTime,
  });

  factory ChatLog.fromJson(Map<String, dynamic> json) {
    return ChatLog(
      id: json['id'] as String,
      userQuery: json['user_query'] as String,
      aiResponse: json['ai_response'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      executionTime: (json['execution_time'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_query': userQuery,
      'ai_response': aiResponse,
      'timestamp': timestamp.toIso8601String(),
      'execution_time': executionTime,
    };
  }
}