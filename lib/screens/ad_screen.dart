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
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            colors: [
              Color(0xFF05050A),
              Colors.black,
            ],
            radius: 1.2,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [

              // 🔍 SEARCH BAR
              Padding(
                padding: const EdgeInsets.all(12),
                child: TextField(
                  style: const TextStyle(color: Colors.white),
                  onChanged: (v) => setState(() => searchQuery = v),
                  decoration: InputDecoration(
                    hintText: "Search users...",
                    hintStyle: const TextStyle(color: Colors.white38),
                    filled: true,
                    fillColor: Colors.black.withOpacity(0.4),
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
                      margin: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.greenAccent.withOpacity(0.3),
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
          ),
        ),
      ),
    );
  }
}