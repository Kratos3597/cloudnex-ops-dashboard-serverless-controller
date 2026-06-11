import 'package:flutter/material.dart';
import '../widgets/neon_card.dart';
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

  List<String> alerts = [
    "✅ Backup completed successfully",
    "⚠ Device non-compliant detected",
    "✅ Azure services operational",
  ];

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

        if (devices % 5 == 0) {
          backupStatus = "WARNING";
          alerts.insert(0, "⚠ Backup delay detected");
        } else if (devices % 7 == 0) {
          backupStatus = "CRITICAL";
          alerts.insert(0, "❌ Backup failed!");
        } else {
          backupStatus = "OK";
        }
        if (alerts.length > 5) alerts.removeLast();
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
              NeonCard(title: "Backup", value: backupStatus, icon: Icons.storage, color: getStatusColor(backupStatus)),
              const NeonCard(title: "Azure", value: "ONLINE", icon: Icons.cloud, color: Colors.cyanAccent),
              NeonCard(title: "Devices", value: "$devices", icon: Icons.devices, color: Colors.purpleAccent),
              NeonCard(title: "Users", value: "$users", icon: Icons.group, color: Colors.orangeAccent),
            ],
          ),
          alertPanel(),
        ],
      ),
    );
  }
}