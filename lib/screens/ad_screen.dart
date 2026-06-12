import 'package:flutter/material.dart';

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

  @override
  Widget build(BuildContext context) {
    final filteredUsers = users
        .where((u) => u["name"].toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();

    return Column(
      children: [
        // 🔍 SEARCH BAR
        Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: TextField(
            style: const TextStyle(color: Colors.white),
            onChanged: (v) => setState(() => searchQuery = v),
            decoration: InputDecoration(
              hintText: "Search users...",
              hintStyle: const TextStyle(color: Colors.white38),
              filled: true,
              fillColor: Colors.black.withValues(alpha: 0.4),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),

        // 📋 LIST
        Expanded(
          child: ListView.builder(
            itemCount: filteredUsers.length,
            itemBuilder: (_, i) {
              final user = filteredUsers[i];

              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Colors.greenAccent.withValues(alpha: 0.2),
                  ),
                ),
                child: ListTile(
                  title: Text(
                    user["name"],
                    style: const TextStyle(color: Colors.white),
                  ),
                  subtitle: Text(
                    user["group"],
                    style: const TextStyle(color: Colors.white70),
                  ),
                  trailing: Text(
                    user["status"],
                    style: TextStyle(
                      color: user["status"] == "Active"
                          ? Colors.greenAccent
                          : Colors.redAccent,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}