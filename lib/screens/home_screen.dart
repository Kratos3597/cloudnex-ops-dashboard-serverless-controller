import 'package:flutter/material.dart';
import '../theme/cyberpunk_theme.dart';
import '../widgets/matrix_rain.dart';
import '../widgets/app_header.dart';
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

  // 🔥 HACK MODE INTENSITY (0 = normal, 1 = full hack)
  double _hackMode = 0.0;

  late AnimationController _glowController;
  late Animation<double> _glowAnimation;

  final List<Widget> _screens = const [
    DashboardScreen(),
    VeeamScreen(),
    AzureScreen(),
    EntraScreen(),
    IntuneScreen(),
    ADScreen(),
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
    {"label": "/dashboard", "icon": Icons.dashboard},
    {"label": "/veeam", "icon": Icons.storage},
    {"label": "/azure", "icon": Icons.cloud},
    {"label": "/entra", "icon": Icons.verified_user},
    {"label": "/intune", "icon": Icons.devices},
    {"label": "/directory", "icon": Icons.account_tree},
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

  void _setHackMode(bool active) {
    setState(() {
      _hackMode = active ? 1.0 : 0.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 700;

    return GestureDetector(
      onTapDown: (_) => _setHackMode(true),
      onTapUp: (_) => _setHackMode(false),
      onTapCancel: () => _setHackMode(false),

      child: Stack(
        children: [
          // 🌌 MATRIX BACKGROUND (reacts to hack mode)
          Positioned.fill(
            child: Opacity(
              opacity: 0.12 + (_hackMode * 0.2),
              child: MatrixRain(
                progress: 0.5 + (_hackMode * 2.5),
                depth: 0.3 + (_hackMode * 0.5),
              ),
            ),
          ),

          // 💚 HACK MODE GREEN OVERLAY
          Positioned.fill(
            child: IgnorePointer(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                color: Colors.green.withValues(alpha: _hackMode * 0.06),
              ),
            ),
          ),

          // 📱 MAIN UI
          isMobile ? _buildMobileLayout() : _buildDesktopLayout(),
        ],
      ),
    );
  }

  // =========================
  // 📱 MOBILE
  // =========================
  Widget _buildMobileLayout() {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Column(
          children: [
            AppHeader(title: _titles[_currentIndex]),

            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: _screens[_currentIndex],
              ),
            ),
          ],
        ),
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFF05070C),
        selectedItemColor: CyberpunkTheme.neonBlue,
        unselectedItemColor: CyberpunkTheme.textMuted,
        onTap: (index) => setState(() => _currentIndex = index),
        items: List.generate(_navItems.length, (index) {
          final item = _navItems[index];
          final isActive = index == _currentIndex;

          return BottomNavigationBarItem(
            icon: AnimatedScale(
              scale: isActive ? 1.2 : 1.0,
              duration: const Duration(milliseconds: 200),
              child: Icon(
                item["icon"],
                shadows: isActive
                    ? [
                        const Shadow(
                          color: CyberpunkTheme.neonBlue,
                          blurRadius: 12,
                        )
                      ]
                    : [],
              ),
            ),
            label: item["label"].replaceAll("/", ""),
          );
        }),
      ),
    );
  }

  // =========================
  // 💻 DESKTOP
  // =========================
  Widget _buildDesktopLayout() {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Row(
        children: [
          // 🧭 SIDEBAR
          Container(
            width: 220,
            color: CyberpunkTheme.bgCard,
            child: Column(
              children: [
                const SizedBox(height: 20),

                // 💡 GLOW LOGO (reacts to hack mode)
                AnimatedBuilder(
                  animation: _glowAnimation,
                  builder: (_, __) {
                    return Text(
                      "_CLOUDNEX",
                      style: TextStyle(
                        fontFamily: 'FiraCode',
                        fontSize: 18,
                        color: CyberpunkTheme.textLight,
                        shadows: [
                          Shadow(
                            color: CyberpunkTheme.neonBlue.withValues(
                              alpha: _glowAnimation.value + _hackMode,
                            ),
                            blurRadius: 20 + (_hackMode * 30),
                          ),
                        ],
                      ),
                    );
                  },
                ),

                const SizedBox(height: 30),

                ...List.generate(_navItems.length, (index) {
                  final item = _navItems[index];

                  return _navItem(
                    icon: item["icon"],
                    label: item["label"],
                    isActive: index == _currentIndex,
                    onTap: () => setState(() => _currentIndex = index),
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
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: _screens[_currentIndex],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // =========================
  // 📌 NAV ITEM
  // =========================
  Widget _navItem({
    required IconData icon,
    required String label,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    bool isHovering = false;

    return StatefulBuilder(
      builder: (context, setHover) {
        return MouseRegion(
          onEnter: (_) => setHover(() => isHovering = true),
          onExit: (_) => setHover(() => isHovering = false),
          child: GestureDetector(
            onTap: onTap,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(
                  horizontal: 16, vertical: 14),
              transform:
                  Matrix4.translationValues(0, isHovering ? -3 : 0, 0),
              color: isActive
                  ? CyberpunkTheme.neonBlue.withValues(alpha: 0.1)
                  : Colors.transparent,
              child: Row(
                children: [
                  Icon(
                    icon,
                    color: (isActive || isHovering)
                        ? CyberpunkTheme.neonBlue
                        : CyberpunkTheme.textMuted,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    label,
                    style: TextStyle(
                      fontFamily: 'FiraCode',
                      color: (isActive || isHovering)
                          ? CyberpunkTheme.neonBlue
                          : CyberpunkTheme.textMuted,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}