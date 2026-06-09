import 'package:flutter/material.dart';

void main() {
  runApp(const CloudnexApp());
}

class CloudnexApp extends StatelessWidget {
  const CloudnexApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cloudnex Control',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF05050A),
        primaryColor: Colors.cyanAccent,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int index = 0;

  final List<Widget> screens = const [
    DashboardScreen(),
    ModuleScreen(title: "Veeam Backup"),
    ModuleScreen(title: "Azure"),
    ModuleScreen(title: "Entra ID"),
    ModuleScreen(title: "Intune"),
    ModuleScreen(title: "Active Directory"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cloudnex Control"),
        backgroundColor: Colors.black,
      ),
      body: screens[index],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: index,
        backgroundColor: Colors.black,
        selectedItemColor: Colors.cyanAccent,
        unselectedItemColor: Colors.white38,
        onTap: (i) {
          setState(() {
            index = i;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.storage), label: "Veeam"),
          BottomNavigationBarItem(icon: Icon(Icons.cloud), label: "Azure"),
          BottomNavigationBarItem(icon: Icon(Icons.security), label: "Entra"),
          BottomNavigationBarItem(icon: Icon(Icons.devices), label: "Intune"),
          BottomNavigationBarItem(icon: Icon(Icons.group), label: "AD"),
        ],
      ),
    );
  }
}

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  Widget buildCard(String title, String value, IconData icon) {
    return Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.cyanAccent),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.cyanAccent, size: 40),
          const SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(color: Colors.white70)),
              Text(
                value,
                style: const TextStyle(
                    color: Colors.cyanAccent,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
            ],
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        buildCard("Backup Status", "OK", Icons.check_circle),
        buildCard("Azure Status", "ONLINE", Icons.cloud),
        buildCard("Devices", "28", Icons.devices),
        buildCard("Users", "112", Icons.group),
      ],
    );
  }
}

class ModuleScreen extends StatelessWidget {
  final String title;

  const ModuleScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "$title Module",
        style: const TextStyle(
            color: Colors.cyanAccent,
            fontSize: 22,
            fontWeight: FontWeight.bold),
      ),
    );
  }
}