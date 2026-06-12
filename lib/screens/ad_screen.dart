import 'package:flutter/material.dart';
import '../widgets/console_tile.dart';

class ADScreen extends StatefulWidget {
  const ADScreen({super.key});

  @override
  State<ADScreen> createState() => _ADScreenState();
}

class _ADScreenState extends State<ADScreen> {
  final List<Map<String, dynamic>> users = [
    {"name": "Alice Admin", "group": "IT Admins", "status": "Active"},
    {"name": "Bob User", "group": "Employees", "status": "Active"},
    {"name": "Charlie Guest", "group": "Guests", "status": "Disabled"},
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
            Text("USER: ${user['name']}", style: const TextStyle(color: Colors.cyanAccent, fontSize: 18, fontWeight: FontWeight.bold)),
            const Divider(color: Colors.white24),
            ListTile(
              leading: const Icon(Icons.lock_reset, color: Colors.white),
              title: const Text("Reset Password", style: TextStyle(color: Colors.white)),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: Icon(user['status'] == "Active" ? Icons.block : Icons.check_circle, color: Colors.white),
              title: Text(user['status'] == "Active" ? "Disable Account" : "Enable Account", style: const TextStyle(color: Colors.white)),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
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
              hintText: "Search AD users...",
              hintStyle: const TextStyle(color: Colors.white38),
              prefixIcon: const Icon(Icons.search, color: Colors.white38),
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
                  value: "${user["group"]} | ${user["status"]}",
                  icon: Icons.person,
                  color: user["status"] == "Active" ? Colors.greenAccent : Colors.redAccent,
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