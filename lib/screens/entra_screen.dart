import 'package:flutter/material.dart';import 'super.key});

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

    // 🔥 simulate status changes
    Stream.periodic(const Duration(seconds: 4)).listen((_) {
      setState(() {
        users.shuffle(); // makes UI feel dynamic
      });
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
    return status == "Enabled" ? Colors.greenAccent : Colors.redAccent;
  }

  @override
  Widget build(BuildContext context) {
    final filteredUsers = users
        .where((user) =>
            user["name"].toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();

    return Column(
      children: [
        // 🔍 SEARCH BAR
        Padding(
          padding: const EdgeInsets.all(12),
          child: TextField(
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: "Search users...",
              hintStyle: const TextStyle(color: Colors.white38),
              prefixIcon: const Icon(Icons.search, color: Colors.cyanAccent),
              filled: true,
              fillColor: Colors.black,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(color: Colors.cyanAccent),
              ),
            ),
            onChanged: (value) {
              setState(() {
                searchQuery = value;
              });
            },
          ),
        ),

        // 👥 USER LIST
        Expanded(
          child: ListView.builder(
            itemCount: filteredUsers.length,
            itemBuilder: (context, index) {
              final user = filteredUsers[index];
              Color roleColor = getRoleColor(user["role"]);
              Color statusColor = getStatusColor(user["status"]);

              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: roleColor),
                  boxShadow: [
                    BoxShadow(
                      color: roleColor.withOpacity(0.6),
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Icon(Icons.person, color: roleColor, size: 32),
                    const SizedBox(width: 12),

                    // User Info
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user["name"],
                          style: TextStyle(
                            color: roleColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          "Role: ${user["role"]}",
                          style: const TextStyle(color: Colors.white70),
                        ),
                        Text(
                          "Status: ${user["status"]}",
                          style: TextStyle(color: statusColor),
                        ),
                      ],
                    ),

                    const Spacer(),

                    // ACTION BUTTON
                    IconButton(
                      icon: const Icon(Icons.lock_reset,
                          color: Colors.cyanAccent),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content:
                                Text("Reset password for ${user["name"]}"),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class EntraScreen extends StatefulWidget {