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
      home: const BootScreen(), // 👈 boot screen first
    );
  }
}

//
// ✅ BOOT SCREEN (CYBERPUNK TERMINAL)
//
class BootScreen extends StatefulWidget {
  const BootScreen({super.key});

  @override
  State<BootScreen> createState() => _BootScreenState();
}

class _BootScreenState extends State<BootScreen> {
  List<String> logs = [];

  final List<String> steps = [
    "INITIALIZING CLOUDNEX CONTROL...",
    "CONNECTING TO AZURE...",
    "SYNCING DIRECTORY...",
    "ACCESS GRANTED"
  ];

  @override
  void initState() {
    super.initState();
    runBoot();
  }

  void runBoot() async {
    for (var step in steps) {
      await Future.delayed(const Duration(seconds: 1));
      setState(() {
        logs.add(step);
      });
    }

    await Future.delayed(const Duration(seconds: 1));

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const HomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Align(
          alignment: Alignment.topLeft,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: logs
                .map((line) => Text(
                      line,
                      style: const TextStyle(
                        color: Colors.greenAccent,
                        fontSize: 16,
                        fontFamily: 'Courier',
                      ),
                    ))
                .toList(),
          ),
        ),
      ),
    );
  }
}

//
// ✅ MAIN HOME SCREEN
//
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

//
// ✅ DASHBOARD WITH LIVE DATA
//
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int devices = 20;
  int users = 100;

  @override
  void initState() {
    super.initState();

    // 🔥 LIVE DATA simulation
    Stream.periodic(const Duration(seconds: 2)).listen((_) {
      setState(() {
        devices++;
        users += 2;

        if (devices > 40) devices = 20;
        if (users > 150) users = 100;
      });
    });
  }

  Widget buildCard(String title, String value, IconData icon) {
    return Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.cyanAccent),
        boxShadow: [
          BoxShadow(
            color: Colors.cyanAccent.withOpacity(0.4),
            blurRadius: 10,
          )
        ],
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
                  fontWeight: FontWeight.bold,
                ),
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
        buildCard("Devices", "$devices", Icons.devices),
        buildCard("Users", "$users", Icons.group),
      ],
    );
  }
}

//
// ✅ MODULE PLACEHOLDER
//
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
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}