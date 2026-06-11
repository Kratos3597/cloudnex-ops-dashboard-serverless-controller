import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'home_screen.dart';
import '../widgets/matrix_rain.dart';

class BootScreen extends StatefulWidget {
  const BootScreen({super.key});

  @override
  State<BootScreen> createState() => _BootScreenState();
}

class _BootScreenState extends State<BootScreen>
    with TickerProviderStateMixin {
  double progress = 0;
  List<String> logs = [];

  late AnimationController _glowController;
  late Animation<double> _glow;

  final List<String> bootSequence = [
    "[SYSTEM] Initializing CloudNex Core...",
    "[SYSTEM] Mapping infrastructure topology...",
    "[SYSTEM] Loading PowerShell modules...",
    "[SYSTEM] Validating Active Directory structures...",
    "[SYSTEM] Establishing secure cloud routes...",
    "[SYSTEM] Multi-sector environment parameters mapped.",
    "[ROOT] CONTROL GRANTED."
  ];

  @override
  void initState() {
    super.initState();

    _glowController =
        AnimationController(vsync: this, duration: const Duration(seconds: 2))
          ..repeat(reverse: true);

    _glow = Tween<double>(begin: 0.5, end: 1).animate(_glowController);

    runBootSequence();
  }

  Future<void> runBootSequence() async {
    for (int i = 0; i < bootSequence.length; i++) {
      await Future.delayed(const Duration(milliseconds: 600));

      if (!mounted) return;

      setState(() {
        logs.add(bootSequence[i]);
        progress = (i + 1) / bootSequence.length;
      });
    }

    await Future.delayed(const Duration(milliseconds: 700));

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => const HomeScreen(),
        transitionsBuilder: (_, animation, __, child) =>
            FadeTransition(opacity: animation, child: child),
      ),
    );
  }

  @override
  void dispose() {
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Stack(
        children: [
          // ✅ MATRIX BACKGROUND
          Opacity(
            opacity: 0.25,
            child: MatrixRain(progress: progress, depth: 0.3),
          ),
          Opacity(
            opacity: 0.6,
            child: MatrixRain(progress: progress, depth: 1.0),
          ),

          // ✅ SCANLINES
          IgnorePointer(
            child: Opacity(
              opacity: 0.06,
              child: CustomPaint(
                size: Size.infinite,
                painter: ScanlinePainter(),
              ),
            ),
          ),

          // ✅ MAIN TERMINAL UI
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40),

                const Text(
                  "CLOUDNEX CORE // BOOT SEQUENCE",
                  style: TextStyle(
                    color: Color(0xFF39FF14),
                    fontFamily: 'monospace',
                    fontSize: 13,
                  ),
                ),

                const SizedBox(height: 12),

                // ✅ SCROLLING LOGS
                Expanded(
                  child: ListView.builder(
                    itemCount: logs.length,
                    itemBuilder: (_, i) {
                      return Text(
                        "${logs[i]} _",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          height: 1.4,
                        ),
                      );
                    },
                  ),
                ),

                // ✅ CENTER LOGO
                AnimatedBuilder(
                  animation: _glow,
                  builder: (_, __) {
                    return Center(
                      child: Text(
                        "CLOUDNEX",
                        style: TextStyle(
                          color: Colors.cyanAccent,
                          fontSize: size.width * 0.12,
                          letterSpacing: 6,
                          shadows: [
                            Shadow(
                              color: Colors.cyanAccent.withValues(
                                  alpha: _glow.value),
                              blurRadius: 40,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 16),

                // ✅ YOUR BRANDING BLOCK
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "CloudNex Ops Control System",
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: size.width * 0.035,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Designed, Engineered & Operated by Mohammed Sheik",
                      style: TextStyle(
                        color: const Color(0xFF39FF14)
                            .withValues(alpha: 0.7),
                        fontSize: size.width * 0.028,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // ✅ PROGRESS BAR
                Container(
                  width: double.infinity,
                  height: 2,
                  color: Colors.white10,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      width: size.width * progress,
                      height: 2,
                      color: Colors.cyanAccent,
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                // ✅ DECRYPTION STAGE
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: const [
                    Text(
                      "DECRYPTION_STAGE",
                      style: TextStyle(
                        color: Colors.cyanAccent,
                        fontSize: 11,
                      ),
                    ),
                    SizedBox(width: 4),
                    SizedBox(
                      width: 6,
                      height: 12,
                      child: ColoredBox(
                        color: Color(0xFF39FF14),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ✅ SCANLINES
class ScanlinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()..color = Colors.white.withValues(alpha: 0.05);

    for (double y = 0; y < size.height; y += 4) {
      canvas.drawRect(Rect.fromLTWH(0, y, size.width, 1), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}