import 'package:flutter/material.dart';
import '../theme/cyberpunk_theme.dart';

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

  @override
  void initState() {
    super.initState();
    Stream.periodic(const Duration(seconds: 4)).listen((_) {
      if (mounted) {
        setState(() {
          users.shuffle();
        });
      }
    });
  }

  Color getRoleColor(String role) {
    switch (role) {
      case "Admin":
        return Colors.redAccent;
      case "User":
        return Colors.greenAccent;
      case "Guest":
        return Colors.orangeAccent;
      default:
        return Colors.cyanAccent;
    }
  }

  Color getStatusColor(String status) {
    return status == "Enabled"
        ? Colors.greenAccent
        : Colors.redAccent;
  }

  @override
  Widget build(BuildContext context) {
    final filteredUsers = users
        .where((user) =>
            user["name"]
                .toLowerCase()
                .contains(searchQuery.toLowerCase()))
        .toList();

    return Scaffold(
      backgroundColor: Colors.transparent, // ✅ important
      body: Stack(
        children: [
          CyberpunkTheme.backgroundLayer(), // ✅ global background

          SafeArea(
            child: Column(
              children: [
                // 🔍 SEARCH BAR
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: TextField(
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: "Search users...",
                      hintStyle:
                          const TextStyle(color: Colors.white38),
                      prefixIcon: const Icon(Icons.search,
                          color: Colors.cyanAccent),
                      filled: true,
                      fillColor: Colors.black,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    onChanged: (value) =>
                        setState(() => searchQuery = value),
                  ),
                ),

                // 👤 USER LIST
                Expanded(
                  child: ListView.builder(
                    itemCount: filteredUsers.length,
                    itemBuilder: (context, index) {
                      final user = filteredUsers[index];
                      Color roleColor =
                          getRoleColor(user["role"]);
                      Color statusColor =
                          getStatusColor(user["status"]);

                      return Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(color: roleColor),
                          boxShadow: [
                            BoxShadow(
                              color:
                                  roleColor.withValues(alpha: 0.6),
                              blurRadius: 10,
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.person,
                                color: roleColor, size: 32),
                            const SizedBox(width: 12),

                            Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                Text(
                                  user["name"],
                                  style: TextStyle(
                                    color: roleColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  "Role: ${user["role"]}",
                                  style: const TextStyle(
                                      color: Colors.white70),
                                ),
                                Text(
                                  "Status: ${user["status"]}",
                                  style: TextStyle(
                                      color: statusColor),
                                ),
                              ],
                            ),
                          ],
                        ),
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