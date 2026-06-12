import 'package:flutter/material.dart';

class VeeamScreen extends StatefulWidget {
  const VeeamScreen({super.key});

  @override
  State<VeeamScreen> createState() => _VeeamScreenState();
}

class _VeeamScreenState extends State<VeeamScreen> {
  List<Map<String, dynamic>> jobs = [
    {"name": "Daily Backup", "status": "OK", "progress": 100},
    {"name": "Weekly Backup", "status": "RUNNING", "progress": 60},
    {"name": "SQL Server Backup", "status": "FAILED", "progress": 30},
  ];

  @override
  void initState() {
    super.initState();
    Stream.periodic(const Duration(seconds: 2)).listen((_) {
      if (!mounted) return;
      setState(() {
        for (var job in jobs) {
          if (job["status"] == "RUNNING") {
            job["progress"] += 10;
            if (job["progress"] >= 100) {
              job["progress"] = 100;
              job["status"] = "OK";
            }
          }
        }
      });
    });
  }

  Color getStatusColor(String status) {
    switch (status) {
      case "OK": return Colors.greenAccent;
      case "RUNNING": return Colors.orangeAccent;
      case "FAILED": return Colors.redAccent;
      default: return Colors.cyanAccent;
    }
  }

  Widget buildJobCard(Map<String, dynamic> job) {
    Color color = getStatusColor(job["status"]);
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: color.withValues(alpha: 0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(job["name"], style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 16)),
              Text(job["status"], style: TextStyle(color: color)),
            ],
          ),
          const SizedBox(height: 10),
          LinearProgressIndicator(value: job["progress"] / 100, color: color, backgroundColor: Colors.white10),
          const SizedBox(height: 8),
          Text("${job["progress"]}%", style: const TextStyle(color: Colors.white70)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Only return the list structure, no Scaffold or Stack here!
    return ListView(
      children: [
        ...jobs.map((job) => buildJobCard(job)),
      ],
    );
  }
}