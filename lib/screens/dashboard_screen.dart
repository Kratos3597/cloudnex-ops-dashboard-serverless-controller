import 'package:flutter/material.dart';
import 'dart:math';
import '../widgets/console_tile.dart'; 
import '../theme/cyberpunk_theme.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int devices = 20;
  int users = 100;
  String backupStatus = "OK";
  
  // Data for sparklines (History of 10 points)
  Map<String, List<double>> telemetry = {
    "Backup": List.generate(10, (index) => Random().nextDouble()),
    "Azure": List.generate(10, (index) => Random().nextDouble()),
    "Server 01": List.generate(10, (index) => Random().nextDouble()),
    "Users": List.generate(10, (index) => Random().nextDouble()),
  };

  List<String> alerts = [
    "✅ Backup completed successfully",
    "⚠ Device non-compliant detected",
    "✅ Azure services operational",
  ];

  void addSystemLog(String message) {
    setState(() {
      String timestamp = DateTime.now().toString().substring(11, 19);
      alerts.insert(0, "[$timestamp] $message");
      if (alerts.length > 6) alerts.removeLast();
    });
  }

  void showActionMenu(BuildContext context, String targetName) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.black.withValues(alpha: 0.9),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("MANAGE: $targetName", style: const TextStyle(color: Colors.cyanAccent, fontSize: 18)),
            const Divider(color: Colors.white24),
            ListTile(
              leading: const Icon(Icons.wifi, color: Colors.white), 
              title: const Text("Ping", style: TextStyle(color: Colors.white)), 
              onTap: () {
                Navigator.pop(context);
                addSystemLog("📡 Pinging $targetName...");
                Future.delayed(const Duration(seconds: 1), () => addSystemLog("✅ $targetName responded (12ms)"));
              }
            ),
            ListTile(
              leading: const Icon(Icons.refresh, color: Colors.white), 
              title: const Text("Restart Service", style: TextStyle(color: Colors.white)), 
              onTap: () {
                Navigator.pop(context);
                addSystemLog("⚠️ Restarting $targetName...");
                Future.delayed(const Duration(seconds: 2), () => addSystemLog("✅ $targetName: Service Restarted."));
              }
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    Stream.periodic(const Duration(seconds: 2)).listen((_) {
      if (!mounted) return;
      setState(() {
        devices++;
        users += 2;
        if (devices > 40) devices = 20;
        if (users > 150) users = 100;

        // Update telemetry data
        for (var key in telemetry.keys) {
          telemetry[key]!.removeAt(0);
          telemetry[key]!.add(Random().nextDouble());
        }

        if (devices % 5 == 0) backupStatus = "WARNING";
        else if (devices % 7 == 0) backupStatus = "CRITICAL";
        else backupStatus = "OK";
      });
    });
  }

  Color getStatusColor(String status) {
    switch (status) {
      case "OK": return Colors.greenAccent;
      case "WARNING": return Colors.orangeAccent;
      case "CRITICAL": return Colors.redAccent;
      default: return CyberpunkTheme.neonBlue;
    }
  }

  Widget alertPanel() {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.redAccent.withValues(alpha: 0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("SYSTEM ALERTS", style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          ...alerts.map((alert) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Text(alert, style: const TextStyle(color: Colors.white70, fontSize: 12)),
              )),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              ConsoleTile(
                title: "Backup", value: backupStatus, icon: Icons.storage, 
                color: getStatusColor(backupStatus), 
                sparklineData: telemetry["Backup"],
                onTap: () => showActionMenu(context, "Backup System")
              ),
              ConsoleTile(
                title: "Azure", value: "ONLINE", icon: Icons.cloud, 
                color: Colors.cyanAccent, 
                sparklineData: telemetry["Azure"],
                onTap: () => showActionMenu(context, "Azure Cloud")
              ),
              ConsoleTile(
                title: "Server 01", value: "ONLINE", icon: Icons.dns, 
                color: Colors.greenAccent, 
                sparklineData: telemetry["Server 01"],
                onTap: () => showActionMenu(context, "Server 01")
              ),
              ConsoleTile(
                title: "Users", value: "$users", icon: Icons.group, 
                color: Colors.orangeAccent, 
                sparklineData: telemetry["Users"],
                onTap: () => showActionMenu(context, "Active Users")
              ),
            ],
          ),
          alertPanel(),
        ],
      ),
    );
  }
}