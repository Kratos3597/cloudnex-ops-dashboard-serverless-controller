import 'package:flutter/material.dart';
import '../widgets/console_tile.dart';

class AzureScreen extends StatefulWidget {
  const AzureScreen({super.key});

  @override
  State<AzureScreen> createState() => _AzureScreenState();
}

class _AzureScreenState extends State<AzureScreen> {
  List<Map<String, dynamic>> services = [
    {"name": "Virtual Machines", "status": "Running", "count": 8},
    {"name": "Storage Accounts", "status": "Healthy", "count": 5},
    {"name": "SQL Databases", "status": "Warning", "count": 3},
    {"name": "App Services", "status": "Running", "count": 4},
  ];

  String subscription = "Production Subscription";

  // Reusing the action menu logic
  void showActionMenu(BuildContext context, String serviceName) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.black.withValues(alpha: 0.95),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("AZURE: $serviceName", style: const TextStyle(color: Colors.cyanAccent, fontSize: 18, fontWeight: FontWeight.bold)),
            const Divider(color: Colors.white24),
            ListTile(
              leading: const Icon(Icons.play_circle, color: Colors.white),
              title: const Text("Start Service", style: TextStyle(color: Colors.white)),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.settings, color: Colors.white),
              title: const Text("Configure Instance", style: TextStyle(color: Colors.white)),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    Stream.periodic(const Duration(seconds: 3)).listen((_) {
      if (!mounted) return;
      setState(() {
        for (var service in services) {
          service["count"]++;
          if (service["count"] > 10) service["count"] = 3;
        }
        services[2]["status"] = services[2]["status"] == "Warning" ? "Running" : "Warning";
      });
    });
  }

  Color getStatusColor(String status) {
    switch (status) {
      case "Running":
      case "Healthy": return Colors.greenAccent;
      case "Warning": return Colors.orangeAccent;
      case "Critical": return Colors.redAccent;
      default: return Colors.cyanAccent;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(8),
      children: [
        // Subscription Header
        Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.4),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.cyanAccent.withValues(alpha: 0.5)),
          ),
          child: Row(
            children: [
              const Icon(Icons.account_tree, color: Colors.cyanAccent, size: 36),
              const SizedBox(width: 15),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("SUBSCRIPTION", style: TextStyle(color: Colors.white70, fontSize: 12)),
                  Text(subscription, style: const TextStyle(color: Colors.cyanAccent, fontSize: 16, fontWeight: FontWeight.bold)),
                ],
              )
            ],
          ),
        ),
        // Service List
        ...services.map((service) => Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: ConsoleTile(
            title: service["name"],
            value: "${service["count"]} Resources | ${service["status"]}",
            icon: Icons.cloud,
            color: getStatusColor(service["status"]),
            onTap: () => showActionMenu(context, service["name"]),
          ),
        )),
      ],
    );
  }
}