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
  double opacity = 1.0;
  double progress = 0;

  late AnimationController _glowController;
  late Animation<double> _glowAnimation;

  double logoScale = 0.8;
  double logoOpacity = 0.0;

  @override
  void initState() {
    super.initState();

    // ✅ Glow animation
    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _glowAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
    );

    // ✅ Logo fade + scale animation
    Future.delayed(const Duration(milliseconds: 200), () {
      if (!mounted) return;

      setState(() {
        logoScale = 1.0;
        logoOpacity = 1.0;
      });
    });

    startBoot();
  }

  Future<void> startBoot() async {
    for (int i = 0; i <= 100; i++) {
      await Future.delayed(const Duration(milliseconds: 20));

      if (!mounted) return;

      setState(() {
        progress = i / 100;
      });
    }

    await Future.delayed(const Duration(milliseconds: 400));

    setState(() {
      opacity = 0;
    });

    await Future.delayed(const Duration(milliseconds: 600));

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => const HomeScreen(),
        transitionsBuilder: (_, animation, __, child) {
          return FadeTransition(opacity: animation, child: child);
        },
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

    double titleSize = size.width * 0.08;
    double subTitleSize = size.width * 0.03;
    double barWidth = size.width * 0.5;

    return AnimatedOpacity(
      duration: const Duration(milliseconds: 600),
      opacity: opacity,
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            // ✅ Subtle Matrix Background
            const Opacity(
              opacity: 0.08,
              child: MatrixRain(),
            ),

            // ✅ Dark overlay (clean SaaS look)
            Container(
              color: Colors.black.withValues(alpha: 0.85),
            ),

            // ✅ Center content
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // 🔥 LOGO (animated + glow)
                  AnimatedOpacity(
                    duration: const Duration(milliseconds: 800),
                    opacity: logoOpacity,
                    child: AnimatedScale(
                      duration: const Duration(milliseconds: 800),
                      scale: logoScale,
                      curve: Curves.easeOut,
                      child: AnimatedBuilder(
                        animation: _glowAnimation,
                        builder: (_, __) {
                          return Text(
                            "CLOUDNEX",
                            style: TextStyle(
                              color: Colors.cyanAccent,
                              fontSize: titleSize,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 4,
                              shadows: [
                                Shadow(
                                  color: Colors.cyanAccent.withValues(
                                      alpha: _glowAnimation.value),
                                  blurRadius: 25,
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ),

                  SizedBox(height: size.height * 0.01),

                  // ✅ Subtitle
                  Text(
                    "CONTROL PLATFORM",
                    style: TextStyle(
                      color: Colors.white38,
                      fontSize: subTitleSize,
                      letterSpacing: 3,
                    ),
                  ),

                  SizedBox(height: size.height * 0.06),

                  // ✅ Progress bar
                  Container(
                    width: barWidth,
                    height: 2,
                    decoration: BoxDecoration(
                      color: Colors.white10,
                      borderRadius: BorderRadius.circular(2),
                    ),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        width: barWidth * progress,
                        height: 2,
                        color: Colors.cyanAccent,
                      ),
                    ),
                  ),

                  SizedBox(height: size.height * 0.025),

                  // ✅ Percentage
                  Text(
                    "${(progress * 100).toInt()}%",
                    style: TextStyle(
                      color: Colors.white30,
                      fontSize: subTitleSize,
                      letterSpacing: 1.5,
                    ),
                  ),

                  SizedBox(height: size.height * 0.03),

                  // ✅ Welcome message (fades in later)
                  AnimatedOpacity(
                    duration: const Duration(milliseconds: 800),
                    opacity: progress > 0.8 ? 1 : 0,
                    child: Column(
                      children: const [
                        Text(
                          "Welcome to Cloudnex Dashboard",
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                        ),
                        SizedBox(height: 6),
                        Text(
                          "Engineered by Mohammed Sheik",
                          style: TextStyle(
                            color: Colors.white30,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}