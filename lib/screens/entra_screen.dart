import 'package:flutter/material.dart';
import '../widgets/console_tile.dart';

class EntraScreen extends StatefulWidget {
  const EntraScreen({super.key});

  @override
  State<EntraScreen> createState() => _EntraScreenState();
}

class _EntraScreenState extends State<EntraScreen> {
  List<Map<String, dynamic>> users = [
    {"name": "Alice Admin", "role": "Admin", "status": "Enabled"},
    {"name": "Bob User", "role": "User", "status": "Enabled"},
    {"name": "Charlie Guest", "role": "Guest", "status": "Disabled"},
    {"name": "David IT", "role": "Admin", "status": "Enabled"},
  ];

  String searchQuery = "";

  void showActionMenu(BuildContext context, Map<String, dynamic> user) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.black.withValues(alpha: 0.95),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("IDENTITY: ${user['name']}", style: const TextStyle(color: Colors.cyanAccent, fontSize: 18, fontWeight: FontWeight.bold)),
            const Divider(color: Colors.white24),
            ListTile(
              leading: const Icon(Icons.security, color: Colors.white),
              title: const Text("View Audit Logs", style: TextStyle(color: Colors.white)),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: Icon(user['status'] == "Enabled" ? Icons.block : Icons.check_circle, color: Colors.white),
              title: Text(user['status'] == "Enabled" ? "Disable Account" : "Enable Account", style: const TextStyle(color: Colors.white)),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }

  Color getRoleColor(String role) {
    switch (role) {
      case "Admin": return Colors.redAccent;
      case "User": return Colors.greenAccent;
      case "Guest": return Colors.orangeAccent;
      default: return Colors.cyanAccent;
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredUsers = users
        .where((u) => u["name"].toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            style: const TextStyle(color: Colors.white),
            onChanged: (v) => setState(() => searchQuery = v),
            decoration: InputDecoration(
              hintText: "Search Entra ID users...",
              hintStyle: const TextStyle(color: Colors.white38),
              prefixIcon: const Icon(Icons.search, color: Colors.cyanAccent),
              filled: true,
              fillColor: Colors.black.withValues(alpha: 0.4),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: filteredUsers.length,
            itemBuilder: (_, i) {
              final user = filteredUsers[i];
              return Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: ConsoleTile(
                  title: user["name"],
                  value: "Role: ${user["role"]} | Status: ${user["status"]}",
                  icon: Icons.person_pin,
                  color: getRoleColor(user["role"]),
                  onTap: () => showActionMenu(context, user),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}