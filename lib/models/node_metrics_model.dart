class NodeMetrics {
  final String workerName;
  final String status;
  final int totalRequests;
  final double cpuTimeMs;
  final double cacheHitRate;

  NodeMetrics({
    required this.workerName,
    required this.status,
    required this.totalRequests,
    required this.cpuTimeMs,
    required this.cacheHitRate,
  });

  factory NodeMetrics.fromJson(Map<String, dynamic> json) {
    return NodeMetrics(
      workerName: json['worker_name'] as String,
      status: json['status'] as String,
      totalRequests: json['total_requests'] as int,
      cpuTimeMs: (json['cpu_time_ms'] as num).toDouble(),
      cacheHitRate: (json['cache_hit_rate'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'worker_name': workerName,
      'status': status,
      'total_requests': totalRequests,
      'cpu_time_ms': cpuTimeMs,
      'cache_hit_rate': cacheHitRate,
    };
  }
}