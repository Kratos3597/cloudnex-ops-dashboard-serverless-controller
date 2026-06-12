import 'package:flutter/material.dart';

class IntuneScreen extends StatefulWidget {
  const IntuneScreen({super.key});

  @override
  State<IntuneScreen> createState() => _IntuneScreenState();
}

class _IntuneScreenState extends State<IntuneScreen> {
  final List<Map<String, dynamic>> devices = [
    {"name": "DESKTOP-01", "os": "Windows"},
    {"name": "Galaxy S21", "os": "Android"},
  ];

  @override
  Widget build(BuildContext context) {
    // Returning only the content structure ensures it sits correctly 
    // inside the TerminalShell managed by the HomeScreen
    return ListView.builder(
      itemCount: devices.length,
      itemBuilder: (context, index) {
        final d = devices[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.purpleAccent.withValues(alpha: 0.3)),
          ),
          child: ListTile(
            leading: Icon(
              d["os"] == "Windows" ? Icons.window : Icons.android,
              color: Colors.purpleAccent,
            ),
            title: Text(d["name"], style: const TextStyle(color: Colors.white)),
            subtitle: Text("OS: ${d["os"]}", style: const TextStyle(color: Colors.white70)),
          ),
        );
      },
    );
  }
}