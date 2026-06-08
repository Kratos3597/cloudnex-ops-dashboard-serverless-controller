import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'services/dashboard_provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => DashboardProvider()..loadConfig()..refreshDashboard(),
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
      title: 'CloudNex CyberOps',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF020604),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF00FF66),
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
        title: const Text(
          '>> CLOUDNEX_OPS_NODE //',
          style: TextStyle(
            color: Color(0xFF00FF66),
            fontFamily: 'Courier New',
            fontWeight: FontWeight.bold,
            fontSize: 16,
            letterSpacing: 1.0,
            shadows: [Shadow(color: Color(0xFF00FF66), blurRadius: 8)],
          ),
        ),
        backgroundColor: const Color(0xFF050F0A),
        elevation: 0,
        shape: const Border(bottom: BorderSide(color: Color(0xFF00FF66), width: 1.5)),
        actions: [
          IconButton(
            icon: const Icon(Icons.tune, color: Color(0xFF00FF66)),
            onPressed: () => _showSettingsSheet(context),
          ),
          Consumer<DashboardProvider>(
            builder: (context, provider, _) {
              return IconButton(
                icon: provider.isLoading 
                    ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFF00FF66))) 
                    : const Icon(Icons.refresh, color: Color(0xFF00FF66)),
                onPressed: () => provider.refreshDashboard(),
              );
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Opacity(
              opacity: 0.03,
              child: GridPaper(
                color: const Color(0xFF00FF66),
                interval: 30.0,
                divisions: 1,
                subdivisions: 1,
                child: Container(),
              ),
            ),
          ),
          Consumer<DashboardProvider>(
            builder: (context, provider, child) {
              if (provider.isLoading && provider.metrics == null) {
                return const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(color: Color(0xFF00FF66)),
                      SizedBox(height: 16),
                      Text('INGESTING CODESPACE DATA...', style: TextStyle(color: Color(0xFF00FF66), fontFamily: 'Courier New')),
                    ],
                  ),
                );
              }

              if (provider.errorMessage != null && provider.metrics == null) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: const Color(0xFF140505),
                        border: Border.all(color: Colors.redAccent, width: 2),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.terminal, color: Colors.redAccent, size: 40),
                          const SizedBox(height: 12),
                          const Text('CRITICAL_CONN_ERROR', style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold, fontFamily: 'Courier New')),
                          const SizedBox(height: 8),
                          Text(provider.errorMessage!, textAlign: TextAlign.center, style: const TextStyle(color: Colors.red, fontFamily: 'Courier New', fontSize: 12)),
                          const SizedBox(height: 20),
                          OutlinedButton(
                            style: OutlinedButton.styleFrom(side: const BorderSide(color: Colors.redAccent)),
                            onPressed: () => provider.refreshDashboard(),
                            child: const Text('RELOAD NODE_MAP', style: TextStyle(color: Colors.redAccent, fontFamily: 'Courier New')),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }

              return ListView(
                padding: const EdgeInsets.all(16.0),
                children: [
                  const Text('[SYS_STATUS_METRICS]', style: TextStyle(color: Color(0xFF00FF66), fontFamily: 'Courier New', fontWeight: FontWeight.bold, fontSize: 13, shadows: [Shadow(color: Color(0xFF00FF66), blurRadius: 4)])),
                  const SizedBox(height: 12),
                  
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 1.4,
                    children: [
                      _buildCyberCard(
                        title: 'NODE STATUS',
                        value: provider.metrics?.status.toUpperCase() ?? 'OFFLINE',
                        color: provider.metrics?.status == 'healthy' ? const Color(0xFF00FF66) : Colors.amberAccent,
                      ),
                      _buildCyberCard(
                        title: 'TOTAL REQUESTS',
                        value: provider.metrics?.totalRequests.toString() ?? 'E-404',
                        color: const Color(0xFF00E5FF),
                      ),
                      _buildCyberCard(
                        title: 'EDGE CACHE HIT',
                        value: '${((provider.metrics?.cacheHitRate ?? 0) * 100).toStringAsFixed(0)}%',
                        color: const Color(0xFFFF007F),
                      ),
                      _buildCyberCard(
                        title: 'AVG CPU TIME',
                        value: '${provider.metrics?.cpuTimeMs.toStringAsFixed(1) ?? '0'} MS',
                        color: const Color(0xFFCCFF00),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 28),
                  const Text('[SERVERLESS_RAG_LOGSTREAM]', style: TextStyle(color: Color(0xFF00FF66), fontFamily: 'Courier New', fontWeight: FontWeight.bold, fontSize: 13, shadows: [Shadow(color: Color(0xFF00FF66), blurRadius: 4)])),
                  const SizedBox(height: 12),

                  provider.logs.isEmpty
                      ? Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(border: Border.all(color: const Color(0xFF051F10)), color: const Color(0xFF030A05)),
                          child: const Center(child: Text('>> NO DATA STREAM INGESTED', style: TextStyle(color: Color(0xFF00FF66), fontFamily: 'Courier New', fontSize: 12))),
                        )
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: provider.logs.length,
                          itemBuilder: (context, index) {
                            final log = provider.logs[index];
                            return Container(
                              margin: const EdgeInsets.only(bottom: 12),
                              decoration: BoxDecoration(
                                color: const Color(0xFF040A06),
                                border: Border.all(color: const Color(0xFF00FF66), width: 1),
                              ),
                              child: ExpansionTile(
                                iconColor: const Color(0xFF00FF66),
                                collapsedIconColor: const Color(0xFF00FF66), // Fixed syntax typo here
                                title: Text('>> ${log.userQuery}', maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF00FF66), fontFamily: 'Courier New', fontSize: 14)),
                                subtitle: Text('LATENCY: ${log.executionTime}S // TIME: ${log.timestamp.toLocal().toString().substring(11, 16)}', style: const TextStyle(color: Color(0xFF00AA44), fontFamily: 'Courier New', fontSize: 11)),
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(14.0),
                                    child: CrossPlatformCodeBlock(response: log.aiResponse),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCyberCard({required String title, required String value, required Color color}) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF030C07),
        border: Border.all(color: color.withOpacity(0.4), width: 1.5),
        boxShadow: [
          BoxShadow(color: color.withOpacity(0.05), blurRadius: 6, spreadRadius: 1),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: TextStyle(color: color.withOpacity(0.7), fontSize: 10, fontFamily: 'Courier New', fontWeight: FontWeight.bold, letterSpacing: 0.5)),
          Text(
            value,
            style: TextStyle(fontSize: 22, color: color, fontWeight: FontWeight.bold, fontFamily: 'Courier New', shadows: [
              Shadow(color: color.withOpacity(0.6), blurRadius: 6),
            ]),
          ),
        ],
      ),
    );
  }

  void _showSettingsSheet(BuildContext context) {
    final provider = Provider.of<DashboardProvider>(context, listen: false);
    final controller = TextEditingController(text: provider.currentWorkerUrl);

    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF030C07),
      shape: const RoundedRectangleBorder(side: BorderSide(color: Color(0xFF00FF66), width: 1.5), borderRadius: BorderRadius.vertical(top: Radius.circular(0))),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          top: 20,
          left: 20,
          right: 20,
          bottom: MediaQuery.of(context).viewInsets.bottom + 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('// DEFINE_GATEWAY_TARGET', style: TextStyle(color: Color(0xFF00FF66), fontFamily: 'Courier New', fontWeight: FontWeight.bold, fontSize: 12)),
            const SizedBox(height: 16),
            TextField(
              controller: controller,
              style: const TextStyle(color: Color(0xFF00FF66), fontFamily: 'Courier New', fontSize: 13),
              decoration: InputDecoration(
                labelText: 'API ENDPOINT URL',
                labelStyle: const TextStyle(color: Color(0xFF00AA44), fontFamily: 'Courier New'),
                focusedBorder: OutlineInputBorder(borderSide: const BorderSide(color: Color(0xFF00FF66), width: 1.5), borderRadius: BorderRadius.circular(0)),
                enabledBorder: OutlineInputBorder(borderSide: const BorderSide(color: Color(0xFF00AA44)), borderRadius: BorderRadius.circular(0)),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00FF66),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
                ),
                onPressed: () {
                  provider.updateWorkerUrl(controller.text.trim());
                  Navigator.pop(context);
                },
                child: const Text('COMMIT TO ENCLAVE', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontFamily: 'Courier New')),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CrossPlatformCodeBlock extends StatelessWidget {
  final String response;
  const CrossPlatformCodeBlock({required this.response, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF010402),
        border: Border.all(color: const Color(0xFF00AA44), width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('OUT_RESPONSE_STREAM:', style: TextStyle(color: Color(0xFF00AA44), fontFamily: 'Courier New', fontSize: 11, fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          Text(response, style: const TextStyle(height: 1.4, color: Color(0xFF88FF88), fontFamily: 'Courier New', fontSize: 12)),
        ],
      ),
    );
  }
}