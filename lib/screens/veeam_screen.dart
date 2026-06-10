import 'package:flutter/material.dart';
import '../theme/cyberpunk_theme.dart';

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
      case "OK":
        return Colors.greenAccent;
      case "RUNNING":
        return Colors.orangeAccent;
      case "FAILED":
        return Colors.redAccent;
      default:
        return Colors.cyanAccent;
    }
  }

  Widget buildJobCard(Map<String, dynamic> job) {
    Color color = getStatusColor(job["status"]);

    return Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: color),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.6), // ✅ fixed
            blurRadius: 12,
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🔥 Job header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                job["name"],
                style: TextStyle(
                  color: color,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                job["status"],
                style: TextStyle(color: color),
              ),
            ],
          ),

          const SizedBox(height: 10),

          // 🔥 Progress
          LinearProgressIndicator(
            value: job["progress"] / 100,
            color: color,
            backgroundColor: Colors.white10,
          ),

          const SizedBox(height: 8),

          Text(
            "${job["progress"]}%",
            style: const TextStyle(color: Colors.white70),
          ),

          const SizedBox(height: 10),

          // 🔥 Buttons
          Row(
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.cyanAccent,
                  foregroundColor: Colors.black,
                ),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Restoring ${job["name"]}..."),
                    ),
                  );
                },
                child: const Text("Restore"),
              ),

              const SizedBox(width: 10),

              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                ),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Stopping ${job["name"]}..."),
                    ),
                  );
                },
                child: const Text("Stop"),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent, // ✅ important
      body: Stack(
        children: [
          CyberpunkTheme.backgroundLayer(), // ✅ global background

          SafeArea(
            child: ListView(
              children: [
                ...jobs.map((job) => buildJobCard(job)), // ✅ fixed
              ],
            ),
          ),
        ],
      ),
    );
  }
}