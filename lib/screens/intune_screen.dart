import 'package:flutter/material.dart';

class IntuneScreen extends StatefulWidget {
  const IntuneScreen({super.key});

  @override
  State<IntuneScreen> createState() => _IntuneScreenState();
}

class _IntuneScreenState extends State<IntuneScreen> {
  List<Map<String, dynamic>> devices = [
    {"name": "DESKTOP-01", "os": "Windows", "status": "Compliant", "risk": "Low"},
    {"name": "LAPTOP-22", "os": "Windows", "status": "Non-Compliant", "risk": "High"},
    {"name": "Galaxy S21", "os": "Android", "status": "Compliant", "risk": "Low"},
    {"name": "iPhone 13", "os": "iOS", "status": "Compliant", "risk": "Medium"},
  ];

  @override
  void initState() {
    super.initState();
    // 🔥 simulate live device updates
    Stream.periodic(const Duration(seconds: 3)).listen((_) {
      if (!mounted) return;
      setState(() {
        devices.shuffle();
        for (var device in devices) {
          if (device["status"] == "Non-Compliant") {
            device["status"] = "Compliant";
            device["risk"] = "Low";
          }
        }
      });
    });
  }

  Color getStatusColor(String status) =>
      status == "Compliant" ? Colors.greenAccent : Colors.redAccent;

  Color getRiskColor(String risk) {
    switch (risk) {
      case "Low": return Colors.greenAccent;
      case "Medium": return Colors.orangeAccent;
      case "High": return Colors.redAccent;
      default: return Colors.cyanAccent;
    }
  }

  Icon getDeviceIcon(String os) {
    switch (os) {
      case "Windows": return const Icon(Icons.computer, size: 32);
      case "Android": return const Icon(Icons.android, size: 32);
      case "iOS": return const Icon(Icons.phone_iphone, size: 32);
      default: return const Icon(Icons.devices, size: 32);
    }
  }

  Widget buildDeviceCard(Map<String, dynamic> device) {
    Color statusColor = getStatusColor(device["status"]);
    Color riskColor = getRiskColor(device["risk"]);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: statusColor),
      ),
      child: Row(
        children: [
          IconTheme(data: IconThemeData(color: statusColor), child: getDeviceIcon(device["os"])),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(device["name"], style: TextStyle(color: statusColor, fontWeight: FontWeight.bold, fontSize: 16)),
              Text("OS: ${device["os"]}", style: const TextStyle(color: Colors.white70)),
              Text("Status: ${device["status"]}", style: TextStyle(color: statusColor)),
              Text("Risk: ${device["risk"]}", style: TextStyle(color: riskColor)),
            ],
          ),
          const Spacer(),
          Column(
            children: [
              IconButton(icon: const Icon(Icons.security, color: Colors.cyanAccent), onPressed: () {}),
              IconButton(icon: const Icon(Icons.lock, color: Colors.redAccent), onPressed: () {}),
            ],
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Intune Devices")),
      body: ListView(
        children: devices.map((device) => buildDeviceCard(device)).toList(),
      ),
    );
  }
}