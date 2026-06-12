import 'package:flutter/material.dart';
import '../widgets/console_tile.dart';

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
            job["progress"] += 5;
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

  // Reuse the Action Menu logic (Ideally move this to a mixin or helper)
  void showActionMenu(BuildContext context, String jobName) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.black.withValues(alpha: 0.95),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("JOB: $jobName", style: const TextStyle(color: Colors.cyanAccent, fontSize: 18, fontWeight: FontWeight.bold)),
            const Divider(color: Colors.white24),
            ListTile(
              leading: const Icon(Icons.play_arrow, color: Colors.white), 
              title: const Text("Retry Job", style: TextStyle(color: Colors.white)),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.stop_circle, color: Colors.white), 
              title: const Text("Abort Task", style: TextStyle(color: Colors.white)),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.description, color: Colors.white), 
              title: const Text("View Full Logs", style: TextStyle(color: Colors.white)),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: jobs.length,
      itemBuilder: (context, index) {
        final job = jobs[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: ConsoleTile(
            title: job["name"],
            value: "${job["status"]} (${job["progress"]}%)",
            icon: Icons.backup,
            color: getStatusColor(job["status"]),
            onTap: () => showActionMenu(context, job["name"]),
          ),
        );
      },
    );
  }
}