import 'package:flutter/material.dart';
import '../widgets/console_tile.dart';

class IntuneScreen extends StatefulWidget {
  const IntuneScreen({super.key});

  @override
  State<IntuneScreen> createState() => _IntuneScreenState();
}

class _IntuneScreenState extends State<IntuneScreen> {
  final List<Map<String, dynamic>> devices = [
    {"name": "DESKTOP-01", "os": "Windows", "status": "Compliant"},
    {"name": "Galaxy S21", "os": "Android", "status": "Non-Compliant"},
  ];

  void showActionMenu(BuildContext context, Map<String, dynamic> device) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.black.withValues(alpha: 0.95),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("DEVICE: ${device['name']}", style: const TextStyle(color: Colors.cyanAccent, fontSize: 18, fontWeight: FontWeight.bold)),
            const Divider(color: Colors.white24),
            ListTile(
              leading: const Icon(Icons.sync, color: Colors.white),
              title: const Text("Sync Policy", style: TextStyle(color: Colors.white)),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.delete_forever, color: Colors.redAccent),
              title: const Text("Remote Wipe", style: TextStyle(color: Colors.redAccent)),
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
      itemCount: devices.length,
      itemBuilder: (context, index) {
        final d = devices[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: ConsoleTile(
            title: d["name"],
            value: "OS: ${d["os"]} | Status: ${d["status"]}",
            icon: d["os"] == "Windows" ? Icons.window : Icons.android,
            color: d["status"] == "Compliant" ? Colors.greenAccent : Colors.orangeAccent,
            onTap: () => showActionMenu(context, d),
          ),
        );
      },
    );
  }
}