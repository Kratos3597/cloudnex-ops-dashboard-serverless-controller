import 'package:flutter/material.dart';

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
    {"name": "David Support", "group": "IT Support", "status": "Active"},
  ];

  List<String> groups = ["IT Admins", "Employees", "Guests", "IT Support"];

  String searchQuery = "";

  @override
  void initState() {
    super.initState();

    // 🔥 simulate activity
    Stream.periodic(const Duration(seconds: 4)).listen((_) {
      setState(() {
        users.shuffle();
      });
    });
  }

  Color getStatusColor(String status) {
    return status == "Active"
        ? Colors.greenAccent
        : Colors.redAccent;
  }

  Color getGroupColor(String group) {
    switch (group) {
      case "IT Admins":
        return Colors.redAccent;
      case "IT Support":
        return Colors.orangeAccent;
      case "Employees":
        return Colors.greenAccent;
      case "Guests":
        return Colors.purpleAccent;
      default:
        return Colors.cyanAccent;
    }
  }

  void addUser() {
    setState(() {
      users.add({
        "name": "New User ${users.length}",
        "group": groups[users.length % groups.length],
        "status": "Active"
      });
    });
  }

  void removeUser(int index) {
    setState(() {
      users.removeAt(index);
    });
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
              hintText: "Search directory...",
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
              Color statusColor = getStatusColor(user["status"]);
              Color groupColor = getGroupColor(user["group"]);

              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: groupColor),
                  boxShadow: [
                    BoxShadow(
                      color: groupColor.withOpacity(0.6),
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Icon(Icons.account_circle,
                        color: groupColor, size: 32),
                    const SizedBox(width: 12),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user["name"],
                          style: TextStyle(
                            color: groupColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          "Group: ${user["group"]}",
                          style: const TextStyle(color: Colors.white70),
                        ),
                        Text(
                          "Status: ${user["status"]}",
                          style: TextStyle(color: statusColor),
                        ),
                      ],
                    ),

                    const Spacer(),

                    // ACTIONS
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.group_add,
                              color: Colors.cyanAccent),
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                    "Adding ${user["name"]} to new group..."),
                              ),
                            );
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete,
                              color: Colors.redAccent),
                          onPressed: () {
                            removeUser(index);
                          },
                        ),
                      ],
                    )
                  ],
                ),
              );
            },
          ),
        ),

        // ➕ ADD USER BUTTON
        Padding(
          padding: const EdgeInsets.all(10),
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.cyanAccent,
              foregroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(
                  horizontal: 20, vertical: 12),
            ),
            onPressed: addUser,
            icon: const Icon(Icons.person_add),
            label: const Text("Add User"),
          ),
        ),
      ],
    );
  }
}