import 'package:flutter/material.dart';
import '../theme/cyberpunk_theme.dart';
import '../widgets/matrix_rain.dart';
import '../widgets/app_header.dart';
import '../widgets/cyber_fx_layer.dart';
import '../widgets/glitch_transition.dart';

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

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {

  int _currentIndex = 0;
  double _hackMode = 0.0;

  late AnimationController _glowController;
  late Animation<double> _glowAnimation;

final List<Widget> _screens = [
  const DashboardScreen(),
  const DashboardScreen(),
  const DashboardScreen(),
  const DashboardScreen(),
  const DashboardScreen(),
  const DashboardScreen(),
];

  final List<String> _titles = const [
    "Dashboard",
    "Veeam Backup",
    "Azure",
    "Entra ID",
    "Intune",
    "Active Directory",
  ];

  final List<Map<String, dynamic>> _navItems = const [
    {"label": "Dashboard", "icon": Icons.dashboard},
    {"label": "Veeam", "icon": Icons.storage},
    {"label": "Azure", "icon": Icons.cloud},
    {"label": "Entra", "icon": Icons.verified_user},
    {"label": "Intune", "icon": Icons.devices},
    {"label": "AD", "icon": Icons.account_tree},
  ];

  @override
  void initState() {
    super.initState();

    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _glowAnimation =
        Tween<double>(begin: 0.4, end: 1.0).animate(_glowController);
  }

  @override
  void dispose() {
    _glowController.dispose();
    super.dispose();
  }

  void _triggerHackMode(int index) {
    setState(() => _hackMode = 1.0);

    Future.delayed(const Duration(milliseconds: 120), () {
      setState(() {
        _currentIndex = index;
        _hackMode = 0.0;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 700;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [

          // 🌌 MATRIX BASE LAYER
          Positioned.fill(
            child: MatrixRain(
              progress: 0.6 + (_hackMode * 1.5),
              depth: 0.4,
            ),
          ),

          // 🌑 DARK LAYER
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.65),
            ),
          ),

          // ⚡ FX LAYER
          Positioned.fill(
            child: CyberFxLayer(intensity: 1.0 + _hackMode),
          ),

          // 💚 HACK FLASH
          Positioned.fill(
            child: IgnorePointer(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 100),
                color: Colors.green.withOpacity(_hackMode * 0.08),
              ),
            ),
          ),

          // 📱 MAIN UI
          isMobile ? _buildMobileLayout() : _buildDesktopLayout(),
        ],
      ),
    );
  }

  // ================= MOBILE =================
  Widget _buildMobileLayout() {
    return Column(
      children: [
        AppHeader(title: _titles[_currentIndex]),

        Expanded(
          child: GlitchTransition(
            active: _hackMode > 0,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: KeyedSubtree(
                key: ValueKey(_currentIndex),
                child: _screens[_currentIndex],
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ================= DESKTOP =================
  Widget _buildDesktopLayout() {
    return Row(
      children: [

        // 🧭 SIDEBAR
        Container(
          width: 220,
          color: Colors.black.withOpacity(0.4),
          child: Column(
            children: [
              const SizedBox(height: 20),

              AnimatedBuilder(
                animation: _glowAnimation,
                builder: (_, __) {
                  return Text(
                    "_CLOUDNEX",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          color: CyberpunkTheme.neonBlue.withOpacity(
                              _glowAnimation.value + _hackMode),
                          blurRadius: 25,
                        ),
                      ],
                    ),
                  );
                },
              ),

              const SizedBox(height: 30),

              ...List.generate(_navItems.length, (index) {
                final item = _navItems[index];
                final isActive = index == _currentIndex;

                return ListTile(
                  leading: Icon(
                    item["icon"],
                    color: isActive
                        ? CyberpunkTheme.neonBlue
                        : CyberpunkTheme.textMuted,
                  ),
                  title: Text(
                    item["label"],
                    style: TextStyle(
                      color: isActive
                          ? CyberpunkTheme.neonBlue
                          : CyberpunkTheme.textMuted,
                    ),
                  ),
                  onTap: () => _triggerHackMode(index),
                );
              }),
            ],
          ),
        ),

        // 📄 CONTENT
        Expanded(
          child: Column(
            children: [
              AppHeader(title: _titles[_currentIndex]),

              Expanded(
                child: GlitchTransition(
                  active: _hackMode > 0,
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: KeyedSubtree(
                      key: ValueKey(_currentIndex),
                      child: _screens[_currentIndex],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}