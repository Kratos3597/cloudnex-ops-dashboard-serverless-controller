import 'package:flutter/material.dart';
import '../widgets/matrix_rain.dart';
import '../widgets/cyber_fx_layer.dart';
import '../theme/cyberpunk_theme.dart';
import '../widgets/terminal_shell.dart';

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
  final double _hackMode = 0.0;

  final List<Widget> _screens = const [
    DashboardScreen(),
    VeeamScreen(),
    AzureScreen(),
    EntraScreen(),
    IntuneScreen(),
    ADScreen(),
  ];

  void _onTabChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.transparent,
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          canvasColor: Colors.transparent,
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: _onTabChanged,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.transparent,
          elevation: 0,
          selectedItemColor: CyberpunkTheme.neonBlue,
          unselectedItemColor: CyberpunkTheme.textMuted,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: "Dash"),
            BottomNavigationBarItem(icon: Icon(Icons.storage), label: "Veeam"),
            BottomNavigationBarItem(icon: Icon(Icons.cloud), label: "Azure"),
            BottomNavigationBarItem(icon: Icon(Icons.verified_user), label: "Entra"),
            BottomNavigationBarItem(icon: Icon(Icons.devices), label: "Intune"),
            BottomNavigationBarItem(icon: Icon(Icons.account_tree), label: "AD"),
          ],
        ),
      ),
      body: Stack(
        children: [
          // 1. Theme Background
          CyberpunkTheme.backgroundLayer(),

          // 2. 🌌 MATRIX BACKGROUND
          Positioned.fill(
            child: MatrixRain(
              progress: 0.6 + (_hackMode * 1.5),
              depth: 0.4,
            ),
          ),

          // 3. 🌑 DARK OVERLAY
          Positioned.fill(
            child: Container(
              color: Colors.black.withValues(alpha: 0.65),
            ),
          ),

          // 4. ⚡ FX LAYER
          Positioned.fill(
            child: CyberFxLayer(intensity: 1.0 + _hackMode),
          ),

          // 5. 📱 MAIN CONTENT SHELL
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: TerminalShell(
                child: _screens[_currentIndex],
              ),
            ),
          ),
        ],
      ),
    );
  }
}