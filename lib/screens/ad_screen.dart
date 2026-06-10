import 'package:flutter/material.dart';
import '../theme/cyberpunk_theme.dart';


class ADScreen extends StatefulWidget {
  const ADScreen({super.key});

  @override
  State<ADScreen> createState() => _ADScreenState();
}

class _ADScreenState extends State<ADScreen> {
  List<Map<String, dynamic>> users = [
    {"name": "Alice Admin", "group": "IT Admins", "status": "Active"},
    {"name": "Bob User", "group": "Employees", "status": "Active"},
    {"name": "Charlie Guest", "group": "Guests", "status": "Disabled"},
  ];

  String searchQuery = "";

  @override
  Widget build(BuildContext context) {
    final filteredUsers = users
        .where((u) =>
            u["name"].toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          CyberpunkTheme.backgroundLayer(),
          SafeArea(
            child: Column(
              children: [
                TextField(
                  style: const TextStyle(color: Colors.white),
                  onChanged: (v) => setState(() => searchQuery = v),
                  decoration: const InputDecoration(
                    hintText: "Search users...",
                    hintStyle: TextStyle(color: Colors.white38),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: filteredUsers.length,
                    itemBuilder: (_, i) {
                      final user = filteredUsers[i];
                      return ListTile(
                        title: Text(user["name"],
                            style: const TextStyle(color: Colors.white)),
                        subtitle: Text(user["group"]),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}