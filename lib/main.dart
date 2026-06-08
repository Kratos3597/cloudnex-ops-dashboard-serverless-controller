import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'services/dashboard_provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => DashboardProvider()..refreshDashboard(),
      child: const GitOpsControllerApp(),
    ),
  );
}

class GitOpsControllerApp extends StatelessWidget {
  const GitOpsControllerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CloudNex GitOps',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF0F0F11),
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.teal,
          brightness: Brightness.dark,
        ),
      ),
      home: const DashboardShell(),
    );
  }
}

class DashboardShell extends StatelessWidget {
  const DashboardShell({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CloudNex Ops Node', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        backgroundColor: const Color(0xFF16161A),
        elevation: 0,
        actions: [
          Consumer<DashboardProvider>(
            builder: (context, provider, _) {
              return IconButton(
                icon: provider.isLoading 
                    ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)) 
                    : const Icon(Icons.refresh),
                onPressed: () => provider.refreshDashboard(),
              );
            },
          ),
        ],
      ),
      body: Consumer<DashboardProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading && provider.metrics == null) {
            return const Center(child: CircularProgressIndicator(color: Colors.teal));
          }

          if (provider.errorMessage != null && provider.metrics == null) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.cloud_off, color: Colors.redAccent, size: 48),
                    const SizedBox(height: 16),
                    Text(provider.errorMessage!, textAlign: TextAlign.center, style: const TextStyle(color: Colors.grey)),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () => provider.refreshDashboard(),
                      child: const Text('Retry Connection'),
                    ),
                  ],
                ),
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () => provider.refreshDashboard(),
            child: ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                const Text('SYSTEM METRICS', style: TextStyle(color: Colors.teal, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
                const SizedBox(height: 12),
                
                // Metrics Summary Grid
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1.4,
                  children: [
                    _buildMetricCard(
                      title: 'Node Status',
                      value: provider.metrics?.status.toUpperCase() ?? 'OFFLINE',
                      icon: Icons.gpp_good,
                      color: provider.metrics?.status == 'healthy' ? Colors.greenAccent : Colors.amberAccent,
                    ),
                    _buildMetricCard(
                      title: 'Total Requests',
                      value: provider.metrics?.totalRequests.toString() ?? '0',
                      icon: Icons.analytics,
                      color: Colors.blueAccent,
                    ),
                    _buildMetricCard(
                      title: 'Edge Cache Hit',
                      value: '${((provider.metrics?.cacheHitRate ?? 0) * 100).toStringAsFixed(0)}%',
                      icon: Icons.bolt,
                      color: Colors.orangeAccent,
                    ),
                    _buildMetricCard(
                      title: 'Avg CPU Time',
                      value: '${provider.metrics?.cpuTimeMs.toStringAsFixed(1) ?? '0'} ms',
                      icon: Icons.speed,
                      color: Colors.purpleAccent,
                    ),
                  ],
                ),
                
                const SizedBox(height: 28),
                const Text('SERVERLESS RAG CHAT LOGS', style: TextStyle(color: Colors.teal, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
                const SizedBox(height: 12),

                // Asynchronous Chat Logs Stream List
                provider.logs.isEmpty
                    ? const Padding(
                        padding: EdgeInsets.symmetric(vertical: 32),
                        child: Center(child: Text('No ingestion logs available.', style: TextStyle(color: Colors.grey))),
                      )
                    : ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: provider.logs.length,
                        itemBuilder: (context, index) {
                          final log = provider.logs[index];
                          return Card(
                            margin: const EdgeInsets.only(bottom: 12),
                            color: const Color(0xFF16161A),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            child: ExpansionTile(
                              leading: const Icon(Icons.psychology, color: Colors.tealAccent),
                              title: Text(log.userQuery, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w600)),
                              subtitle: Text('Lat: ${log.executionTime}s • ${log.timestamp.toLocal().toString().substring(11, 16)}', style: const TextStyle(color: Colors.grey, fontSize: 12)),
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text('AI RAG Response:', style: TextStyle(color: Colors.teal, fontWeight: FontWeight.bold, fontSize: 12)),
                                      const SizedBox(height: 6),
                                      Text(log.aiResponse, style: const TextStyle(height: 1.4, color: Color(0xFFE0E0E6))),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildMetricCard({required String title, required String value, required IconData icon, required Color color}) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: RepublicBoxDecoration.clean(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: const TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.w500)),
              Icon(icon, color: color, size: 18),
            ],
          ),
          Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, letterSpacing: 0.5)),
        ],
      ),
    );
  }
}

// Custom decoration module for high-end look
class RepublicBoxDecoration {
  static BoxDecoration clean() {
    return BoxDecoration(
      color: const Color(0xFF16161A),
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: const Color(0xFF24242A), width: 1),
    );
  }
}