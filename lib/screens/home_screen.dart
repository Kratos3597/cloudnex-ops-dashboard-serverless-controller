import 'package:flutter/material.dart';
import '../widgets/matrix_rain.dart';
import '../widgets/app_header.dart';
import '../widgets/cyber_fx_layer.dart';

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
  double _hackMode = 0.0;

  final List<Widget> _screens = [
    const DashboardScreen(),
    const VeeamScreen(),
    const AzureScreen(),
    const EntraScreen(),
    const IntuneScreen(),
    const ADScreen(),
  ];

  final List<String> _titles = const [
    "Dashboard",
    "Veeam Backup",
    "Azure",
    "Entra ID",
    "Intune",
    "Active Directory",
  ];

  void _onTabChanged(int index) {
    setState(() {
      _currentIndex = index;
      _hackMode = 0.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabChanged,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.black,
        selectedItemColor: Colors.cyanAccent,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: "Dash"),
          BottomNavigationBarItem(icon: Icon(Icons.storage), label: "Veeam"),
          BottomNavigationBarItem(icon: Icon(Icons.cloud), label: "Azure"),
          BottomNavigationBarItem(icon: Icon(Icons.verified_user), label: "Entra"),
          BottomNavigationBarItem(icon: Icon(Icons.devices), label: "Intune"),
          BottomNavigationBarItem(icon: Icon(Icons.account_tree), label: "AD"),
        ],
      ),

      body: Stack(
        children: [

          // 🌌 MATRIX BACKGROUND
          Positioned.fill(
            child: MatrixRain(
              progress: 0.6 + (_hackMode * 1.5),
              depth: 0.4,
            ),
          ),

          // 🌑 DARK OVERLAY
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.65),
            ),
          ),

          // ⚡ FX LAYER
          Positioned.fill(
            child: CyberFxLayer(intensity: 1.0 + _hackMode),
          ),

          // 📱 MAIN CONTENT
          Column(
            children: [
              AppHeader(title: _titles[_currentIndex]),

              Expanded(
                child: _screens[_currentIndex],
              ),
            ],
          ),
        ],
      ),
    );
  }
}