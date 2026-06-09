import 'package:flutter/material.dart';
import 'dashboard_screen.dart';
import 'veeam_screen.dart';
import 'azure_screen.dart';
import 'entra_screen.dart';
import 'intune_screen.dart';
import 'ad_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    DashboardScreen(),
    VeeamScreen(),
    AzureScreen(),
    EntraScreen(),
    IntuneScreen(),
    ADScreen(),
  ];

  final List<String> _titles = [
    "Dashboard",
    "Veeam Backup",
    "Azure",
    "Entra ID",
    "Intune",
    "Active Directory"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_currentIndex]),
        backgroundColor: Colors.black,
      ),

      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: _screens[_currentIndex],
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.black,
        selectedItemColor: Colors.cyanAccent,
        unselectedItemColor: Colors.white38,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
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