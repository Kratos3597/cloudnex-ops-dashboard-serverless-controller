import 'package:flutter/material.dart';
import '../theme/cyberpunk_theme.dart';

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

  @override
  void initState() {
    super.initState();

    Stream.periodic(const Duration(seconds: 3)).listen((_) {
      if (!mounted) return;

      setState(() {
        for (var service in services) {
          service["count"]++;

          if (service["count"] > 10) {
            service["count"] = 3;
          }
        }

        services[2]["status"] =
            services[2]["status"] == "Warning"
                ? "Running"
                : "Warning";
      });
    });
  }

  Color getStatusColor(String status) {
    switch (status) {
      case "Running":
      case "Healthy":
        return Colors.greenAccent;
      case "Warning":
        return Colors.orangeAccent;
      case "Critical":
        return Colors.redAccent;
      default:
        return Colors.cyanAccent;
    }
  }

  Widget buildServiceCard(Map<String, dynamic> service) {
    Color color = getStatusColor(service["status"]);

    return Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: color),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.6),
            blurRadius: 12,
          )
        ],
      ),
      child: Row(
        children: [
          Icon(Icons.cloud, color: color, size: 36),
          const SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                service["name"],
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Text(
                "${service["count"]} resources",
                style: const TextStyle(color: Colors.white70),
              ),
              Text(
                service["status"],
                style: TextStyle(color: color),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget subscriptionHeader() {
    return Container(
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.cyanAccent),
        boxShadow: [
          BoxShadow(
            color: Colors.cyanAccent.withValues(alpha: 0.6),
            blurRadius: 12,
          )
        ],
      ),
      child: Row(
        children: [
          const Icon(Icons.account_tree,
              color: Colors.cyanAccent,
              size: 36),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "SUBSCRIPTION",
                style: TextStyle(color: Colors.white70),
              ),
              Text(
                subscription,
                style: const TextStyle(
                  color: Colors.cyanAccent,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          )
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
            child: ListView(
              children: [
                subscriptionHeader(),

                ...services.map(
                  (service) => buildServiceCard(service),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}