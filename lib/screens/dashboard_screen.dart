import 'package:flutter/material.dart';

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

    // 🔥 Live data simulation
    Stream.periodic(const Duration(seconds: 2)).listen((_) {
      setState(() {
        devices++;
        users += 2;

        if (devices > 40) devices = 20;
        if (users > 150) users = 100;

        // Random status change simulation
        if (devices % 5 == 0) {
          backupStatus = "WARNING";
          alerts.insert(0, "⚠ Backup delay detected");
        } else if (devices % 7 == 0) {
          backupStatus = "CRITICAL";
          alerts.insert(0, "❌ Backup failed!");
        } else {
          backupStatus = "OK";
        }

        if (alerts.length > 5) {
          alerts.removeLast();
        }
      });
    });
  }

  Color getStatusColor(String status) {
    switch (status) {
      case "OK":
        return Colors.greenAccent;
      case "WARNING":
        return Colors.orangeAccent;
      case "CRITICAL":
        return Colors.redAccent;
      default:
        return Colors.cyanAccent;
    }
  }

  Widget neonCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: color.withOpacity(0.7)),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.6),
            blurRadius: 15,
          )
        ],
      ),
      child: Row(
        children: [
          Icon(icon, size: 36, color: color),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: TextStyle(color: color.withOpacity(0.8))),
              Text(
                value,
                style: TextStyle(
                  fontSize: 20,
                  color: color,
                  fontWeight: FontWeight.bold,
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget alertPanel() {
    return Container(
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.redAccent),
        boxShadow: [
          BoxShadow(
            color: Colors.redAccent.withOpacity(0.6),
            blurRadius: 15,
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "SYSTEM ALERTS",
            style: TextStyle(
              color: Colors.redAccent,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 10),
          ...alerts.map((alert) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Text(
                  alert,
                  style: const TextStyle(color: Colors.white70),
                ),
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
          // 🔥 GRID LAYOUT
          Padding(
            padding: const EdgeInsets.all(10),
            child: GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                neonCard("Backup", backupStatus, Icons.storage,
                    getStatusColor(backupStatus)),
                neonCard("Azure", "ONLINE", Icons.cloud, Colors.cyanAccent),
                neonCard("Devices", "$devices", Icons.devices,
                    Colors.purpleAccent),
                neonCard("Users", "$users", Icons.group,
                    Colors.orangeAccent),
              ],
            ),
          ),

          // 🔥 ALERT PANEL
          alertPanel(),
        ],
      ),
    );
  }
}