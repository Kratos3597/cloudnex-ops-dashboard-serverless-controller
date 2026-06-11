import 'package:flutter/material.dart';
import '../widgets/neon_card.dart';
import '../theme/cyberpunk_theme.dart';
import '../widgets/terminal_shell.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // The body is where the Stack goes
      body: Stack(
        children: [
          // 1. Background Layer (drawn first)
          CyberpunkTheme.backgroundLayer(), 
          
          // 2. Terminal Shell (drawn on top)
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: TerminalShell(
                child: Text(
                  "SYSTEM INITIALIZED\nWelcome, Mohammed Sheik.", 
                  style: TextStyle(color: CyberpunkTheme.textLight)
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

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
            color: Colors.redAccent.withValues(alpha: 0.6),
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
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          CyberpunkTheme.backgroundLayer(),

          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: GridView.count(
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        NeonCard(
                          title: "Backup",
                          value: backupStatus,
                          icon: Icons.storage,
                          color: getStatusColor(backupStatus),
                        ),
                        const NeonCard(
                          title: "Azure",
                          value: "ONLINE",
                          icon: Icons.cloud,
                          color: Colors.cyanAccent,
                        ),
                        NeonCard(
                          title: "Devices",
                          value: "$devices",
                          icon: Icons.devices,
                          color: Colors.purpleAccent,
                        ),
                        NeonCard(
                          title: "Users",
                          value: "$users",
                          icon: Icons.group,
                          color: Colors.orangeAccent,
                        ),
                      ],
                    ),
                  ),

                  alertPanel(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}