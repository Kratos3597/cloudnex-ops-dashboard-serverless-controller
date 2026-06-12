import 'package:flutter/material.dart';
import '../widgets/console_tile.dart';

class IntuneScreen extends StatefulWidget {
  const IntuneScreen({super.key});

  @override
  State<IntuneScreen> createState() => _IntuneScreenState();
}

class _IntuneScreenState extends State<IntuneScreen> {
  final TextEditingController _searchController = TextEditingController();

  final List<Map<String, dynamic>> devices = [
    {
      "name": "DESKTOP-01",
      "os": "Windows",
      "status": "Compliant",
      "lastSync": "2 min ago",
      "health": "Good"
    },
    {
      "name": "Galaxy S21",
      "os": "Android",
      "status": "Non-Compliant",
      "lastSync": "1 hour ago",
      "health": "Risk"
    },
    {
      "name": "LAPTOP-DEV-02",
      "os": "Windows",
      "status": "Compliant",
      "lastSync": "10 min ago",
      "health": "Good"
    },
    {
      "name": "iPhone 13 Pro Max",
      "os": "iOS",
      "status": "Non-Compliant",
      "lastSync": "Yesterday",
      "health": "Critical"
    },
  ];

  String query = "";

  Color statusColor(String status) {
    return status == "Compliant"
        ? Colors.greenAccent
        : Colors.orangeAccent;
  }

  Color healthColor(String health) {
    switch (health) {
      case "Good":
        return Colors.greenAccent;
      case "Risk":
        return Colors.orangeAccent;
      default:
        return Colors.redAccent;
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredDevices = devices.where((d) {
      return d["name"].toLowerCase().contains(query.toLowerCase());
    }).toList();

    return Column(
      children: [
        // 🔍 SEARCH BAR
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: _searchController,
            onChanged: (value) {
              setState(() => query = value);
            },
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: "Search devices...",
              hintStyle: const TextStyle(color: Colors.white38),
              prefixIcon: const Icon(Icons.search, color: Colors.white),
              filled: true,
              fillColor: Colors.black54,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),

        // 📱 DEVICE LIST
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: filteredDevices.length,
            itemBuilder: (context, index) {
              final d = filteredDevices[index];

              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: ConsoleTile(
                  title: d["name"],

                  // clean compact format
                  value: "${d["os"]} • ${d["lastSync"]}",

                  icon: d["os"] == "Windows"
                      ? Icons.window
                      : Icons.android,

                  color: statusColor(d["status"]),

                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      backgroundColor:
                          Colors.black.withValues(alpha: 0.95),
                      builder: (context) => Container(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              d["name"],
                              style: const TextStyle(
                                color: Colors.cyanAccent,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            const SizedBox(height: 10),

                            // 🟢 STATUS PILL
                            Chip(
                              label: Text(d["status"]),
                              backgroundColor: statusColor(d["status"]),
                            ),

                            const SizedBox(height: 8),

                            // 🧠 HEALTH INDICATOR
                            Chip(
                              label: Text("Health: ${d["health"]}"),
                              backgroundColor: healthColor(d["health"]),
                            ),

                            const SizedBox(height: 8),

                            Text(
                              "Last Sync: ${d["lastSync"]}",
                              style: const TextStyle(color: Colors.white70),
                            ),

                            const Divider(color: Colors.white24),

                            ListTile(
                              leading: const Icon(Icons.sync,
                                  color: Colors.white),
                              title: const Text("Sync Policy",
                                  style: TextStyle(color: Colors.white)),
                              onTap: () => Navigator.pop(context),
                            ),

                            ListTile(
                              leading: const Icon(Icons.delete_forever,
                                  color: Colors.redAccent),
                              title: const Text("Remote Wipe",
                                  style: TextStyle(color: Colors.redAccent)),
                              onTap: () => Navigator.pop(context),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}