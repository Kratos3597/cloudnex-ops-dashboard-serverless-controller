import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'services/dashboard_provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => DashboardProvider()..loadConfig(),
      child: const CloudNexApp(),
    ),
  );
}

class CloudNexApp extends StatelessWidget {
  const CloudNexApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CloudNex',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFF090D16),
        fontFamily: 'Courier New',
      ),
      home: const BootScreen(),
    );
  }
}

///////////////////////////////////////////////////////////
/// BOOT SCREEN
///////////////////////////////////////////////////////////

class BootScreen extends StatefulWidget {
  const BootScreen({super.key});

  @override
  State<BootScreen> createState() => _BootScreenState();
}

class _BootScreenState extends State<BootScreen> {
  final logs = <String>[];
  int index = 0;

  final messages = [
    "Initializing CloudNex...",
    "Loading API modules...",
    "Securing connection...",
    "Injecting telemetry...",
    "System ready ✅"
  ];

  @override
  void initState() {
    super.initState();
    _run();
  }

  void _run() {
    if (index < messages.length) {
      setState(() => logs.add(messages[index++]));
      Future.delayed(const Duration(milliseconds: 400), _run);
    } else {
      Future.delayed(const Duration(milliseconds: 500), () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const Dashboard()),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF05070C),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: logs
              .map((e) => Text(
                    e,
                    style: const TextStyle(
                        color: Color(0xFF00F0FF), fontSize: 12),
                  ))
              .toList(),
        ),
      ),
    );
  }
}

///////////////////////////////////////////////////////////
/// MAIN DASHBOARD
///////////////////////////////////////////////////////////

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int currentIndex = 0;

  final pages = const [
    M365Screen(),
    EntraScreen(),
    IntuneScreen(),
    AzureScreen(),
  ];

  final titles = ["M365", "Entra", "Intune", "Azure"];

  void click() {
    SystemSound.play(SystemSoundType.click);
    HapticFeedback.lightImpact();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("CloudNex ${titles[currentIndex]}"),
        backgroundColor: const Color(0xFF111827),
      ),
      body: pages[currentIndex],

      // ✅ MOBILE FRIENDLY NAV
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (i) {
          click();
          setState(() => currentIndex = i);
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "M365"),
          BottomNavigationBarItem(icon: Icon(Icons.security), label: "Entra"),
          BottomNavigationBarItem(icon: Icon(Icons.devices), label: "Intune"),
          BottomNavigationBarItem(icon: Icon(Icons.cloud), label: "Azure"),
        ],
      ),
    );
  }
}

///////////////////////////////////////////////////////////
/// SHARED CARD
///////////////////////////////////////////////////////////

Widget cyberCard(String title, String value) {
  return Container(
    margin: const EdgeInsets.all(10),
    padding: const EdgeInsets.all(16),

    // ✅ FIXED (no color conflict)
    decoration: BoxDecoration(
      color: const Color(0xFF111827),
      borderRadius: BorderRadius.circular(8),
      border: Border.all(color: Colors.grey.shade800),
    ),

    child: Row(
      children: [
        Text(title,
            style: const TextStyle(color: Colors.white70, fontSize: 14)),
        const Spacer(),
        Text(
          value,
          style: const TextStyle(
              color: Colors.greenAccent, fontWeight: FontWeight.bold),
        ),
      ],
    ),
  );
}

///////////////////////////////////////////////////////////
/// M365
///////////////////////////////////////////////////////////

class M365Screen extends StatelessWidget {
  const M365Screen({super.key});

  @override
  Widget build(BuildContext context) {
    final data = context.watch<DashboardProvider>().tenantMetrics;

    return ListView(
      children: [
        cyberCard("Users", data["entraId"]["users"].toString()),
        cyberCard("Groups", data["entraId"]["groups"].toString()),
      ],
    );
  }
}

///////////////////////////////////////////////////////////
/// ENTRA
///////////////////////////////////////////////////////////

class EntraScreen extends StatelessWidget {
  const EntraScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final data = context.watch<DashboardProvider>().tenantMetrics;

    return ListView(
      children: [
        cyberCard("Risky Users", data["entraId"]["riskyUsers"].toString()),
        cyberCard("Apps", data["entraId"]["appRegistrations"].toString()),
      ],
    );
  }
}

///////////////////////////////////////////////////////////
/// INTUNE
///////////////////////////////////////////////////////////

class IntuneScreen extends StatelessWidget {
  const IntuneScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final data = context.watch<DashboardProvider>().tenantMetrics;

    return ListView(
      children: [
        cyberCard("Devices", data["intune"]["totalDevices"].toString()),
        cyberCard(
            "Compliant", data["intune"]["compliantDevices"].toString()),
      ],
    );
  }
}

///////////////////////////////////////////////////////////
/// AZURE
///////////////////////////////////////////////////////////

class AzureScreen extends StatelessWidget {
  const AzureScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final data = context.watch<DashboardProvider>().tenantMetrics;

    return ListView(
      children: [
        cyberCard("VMs", data["azure"]["activeVMs"].toString()),
        cyberCard("Billing", data["azure"]["monthlyBurn"].toString()),
      ],
    );
  }
}