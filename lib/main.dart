import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'services/dashboard_provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    ChangeNotifierProvider(
      create: (_) => DashboardProvider()..loadConfig(),
      child: const M365AdminCenterApp(),
    ),
  );
}

class M365AdminCenterApp extends StatelessWidget {
  const M365AdminCenterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CloudNex Enterprise Cyber Management Ecosystem',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFF090D16),
        fontFamily: 'Courier New',
      ),
      home: const AdminCenterShell(),
    );
  }
}

// 🛡️ STABLE ARCHITECTURE: Prevents assertion errors by enforcing decoration-only styling
class TerminalBox extends StatelessWidget {
  final Widget child;
  final BoxDecoration? decoration;
  final EdgeInsetsGeometry? padding;

  const TerminalBox({
    super.key,
    required this.child,
    this.decoration,
    this.padding,
  });

  @override
  Widget build(BuildContext context) => Container(
    padding: padding ?? const EdgeInsets.all(16),
    decoration: decoration ?? BoxDecoration(
      color: const Color(0xFF111827).withOpacity(0.95),
      border: Border.all(color: const Color(0xFF1F2937), width: 1.0),
    ),
    child: child,
  );
}

class AdminCenterShell extends StatefulWidget {
  const AdminCenterShell({super.key});
  @override
  State<AdminCenterShell> createState() => _AdminCenterShellState();
}

class _AdminCenterShellState extends State<AdminCenterShell> {
  String _consoleOutput = "PS C:\\> SYSTEM_READY // AWAITING OPERATOR INPUT";
  
  void _playTerminalChime() {
    SystemSound.play(SystemSoundType.click);
    HapticFeedback.heavyImpact();
  }

  void _executeTask(String task) {
    _playTerminalChime();
    setState(() => _consoleOutput = "PS C:\\> [RUNNING] $task.ps1 // PROCESSING_THREAD...");
    Future.delayed(const Duration(seconds: 2), () {
      setState(() => _consoleOutput = "PS C:\\> [SUCCESS] $task finalized // LOG_ID: ${math.Random().nextInt(9999)}");
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<DashboardProvider>(context);
    final metrics = provider.tenantMetrics;

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            const Positioned.fill(child: MatrixRainCanvas()),
            Positioned.fill(child: CustomPaint(painter: CyberScanlinePainter())),
            Column(
              children: [
                _buildNavBar(provider),
                Expanded(
                  child: Row(
                    children: [
                      _buildSidebar(provider),
                      Expanded(
                        child: ListView(
                          padding: const EdgeInsets.all(24),
                          children: [
                            _buildInfrastructureStats(metrics),
                            const SizedBox(height: 24),
                            _buildOperationsGrid(),
                            const SizedBox(height: 24),
                            TerminalBox(
                              child: Text(_consoleOutput, style: const TextStyle(color: Color(0xFF39FF14), fontFamily: 'monospace')),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavBar(DashboardProvider provider) => Container(
    padding: const EdgeInsets.all(16),
    decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Color(0xFF1F2937)))),
    child: Row(children: [
      const Text("CLOUDNEX // OPS CORE", style: TextStyle(color: Color(0xFF00F0FF), fontFamily: 'monospace', fontWeight: FontWeight.bold)),
      const Spacer(),
      IconButton(icon: const Icon(Icons.refresh, color: Colors.white, size: 16), onPressed: () => provider.refreshDashboard()),
    ]),
  );

  Widget _buildSidebar() => Container(
    width: 60,
    decoration: const BoxDecoration(border: Border(right: BorderSide(color: Color(0xFF1F2937)))),
    child: Column(children: ["M365", "ID", "MDM", "VEEAM", "AZR"].map((t) => Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Text(t, style: const TextStyle(color: Colors.grey, fontSize: 10, fontFamily: 'monospace')),
    )).toList()),
  );

  Widget _buildInfrastructureStats(Map<String, dynamic> metrics) => GridView.count(
    crossAxisCount: 4,
    shrinkWrap: true,
    childAspectRatio: 2.0,
    mainAxisSpacing: 16,
    crossAxisSpacing: 16,
    children: [
      _buildStatCard("Compute Nodes", "42"),
      _buildStatCard("Active Backups", "12"),
      _buildStatCard("Security Score", "98%"),
      _buildStatCard("Tenant Health", "OK"),
    ],
  );

  Widget _buildOperationsGrid() => GridView.count(
    crossAxisCount: 3,
    shrinkWrap: true,
    mainAxisSpacing: 16,
    crossAxisSpacing: 16,
    childAspectRatio: 2.5,
    children: [
      _buildTaskButton("Provision Identity", () => _executeTask("identity_provisioning")),
      _buildTaskButton("Snapshot Verify", () => _executeTask("veeam_snapshot")),
      _buildTaskButton("Compliance Audit", () => _executeTask("intune_audit")),
    ],
  );

  Widget _buildStatCard(String t, String v) => TerminalBox(child: Column(children: [
    Text(t, style: const TextStyle(color: Colors.grey, fontSize: 9, fontFamily: 'monospace')),
    Text(v, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
  ]));

  Widget _buildTaskButton(String label, VoidCallback onTap) => InkWell(
    onTap: onTap,
    child: TerminalBox(child: Center(child: Text(label, style: const TextStyle(color: Color(0xFF00F0FF), fontFamily: 'monospace')))),
  );
}

// Matrix Engine
class MatrixRainCanvas extends StatelessWidget {
  const MatrixRainCanvas({super.key});
  @override
  Widget build(BuildContext context) => Container(color: const Color(0xFF090D16).withOpacity(0.95));
}

class CyberScanlinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.black.withOpacity(0.15)..strokeWidth = 1.0;
    for (double y = 0; y < size.height; y += 4) canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}