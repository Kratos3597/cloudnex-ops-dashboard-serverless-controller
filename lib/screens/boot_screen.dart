import 'dart:async';
import 'dart:math';
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
  double opacity = 1.0;
  double progress = 0;

  double scale = 1.0;
  double blur = 0.0;

  late AnimationController _glowController;
  late Animation<double> _glowAnimation;

  int statusIndex = 0;

  // ✅ TYPING EFFECT STATE
  String displayedText = "";
  String fullText = "Mapping infrastructure configurations...";
  int typingIndex = 0;
  Timer? typingTimer;

  final List<String> statusTexts = [
    "Mapping infrastructure configurations...",
    "Loading PowerShell script assemblies...",
    "Validating Active Directory trees...",
    "Stabilizing cloud cluster routing matrix...",
    "ACCESS GRANTED. Handshake complete."
  ];

  @override
  void initState() {
    super.initState();

    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _glowAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
    );

    // ✅ Start first typing
    startTyping(statusTexts[0]);

    // ✅ Status update with typing
    Timer.periodic(const Duration(milliseconds: 500), (timer) {
      if (!mounted) return;

      if (statusIndex < statusTexts.length - 1) {
        statusIndex++;
        startTyping(statusTexts[statusIndex]);
      } else {
        timer.cancel();
      }
    });

    startBoot();
  }

  void startTyping(String newText) {
    typingTimer?.cancel();

    fullText = newText;
    typingIndex = 0;
    displayedText = "";

    typingTimer =
        Timer.periodic(const Duration(milliseconds: 15), (timer) {
      if (!mounted) return;

      setState(() {
        if (typingIndex < fullText.length) {
          displayedText += fullText[typingIndex];
          typingIndex++;
        } else {
          timer.cancel();
        }
      });
    });
  }

  Future<void> startBoot() async {
    for (int i = 0; i <= 100; i++) {
      await Future.delayed(const Duration(milliseconds: 26));

      if (!mounted) return;

      setState(() {
        progress = i / 100;
      });
    }

    await Future.delayed(const Duration(milliseconds: 300));

    setState(() {
      opacity = 0;
      scale = 1.08;
      blur = 20;
    });

    await Future.delayed(const Duration(milliseconds: 900));

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
    typingTimer?.cancel();
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    double titleSize = size.width * 0.12;
    double subTitleSize = size.width * 0.045;
    double barWidth = size.width * 0.6;

    return AnimatedOpacity(
      duration: const Duration(milliseconds: 900),
      opacity: opacity,
      child: AnimatedScale(
        scale: scale,
        duration: const Duration(milliseconds: 900),
        child: ImageFiltered(
          imageFilter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
          child: Scaffold(
            backgroundColor: Colors.black,
            body: Stack(
              children: [
                // ✅ BACK MATRIX
                Opacity(
                  opacity: 0.25,
                  child: MatrixRain(progress: progress, depth: 0.3),
                ),

                // ✅ FRONT MATRIX
                Opacity(
                  opacity: 0.6,
                  child: MatrixRain(progress: progress, depth: 1.0),
                ),

                // ✅ CRT SCANLINES 🔥
                IgnorePointer(
                  child: Opacity(
                    opacity: 0.08,
                    child: CustomPaint(
                      size: Size.infinite,
                      painter: ScanlinePainter(),
                    ),
                  ),
                ),

                // ✅ Overlay
                Container(
                  color: Colors.black.withValues(alpha: 0.25),
                ),

                // ✅ TERMINAL UI
                Center(
                  child: Container(
                    width: size.width > 400 ? 400 : size.width * 0.85,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(220, 5, 7, 12),
                      border: Border.all(color: const Color(0xFF39FF14)),
                      borderRadius: BorderRadius.circular(4),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF39FF14)
                              .withValues(alpha: 0.2),
                          blurRadius: 25,
                        )
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "> INITIALIZING CORE_BOOT_LOG...",
                          style: TextStyle(
                            color: Color(0xFF39FF14),
                            fontFamily: 'monospace',
                            fontSize: 12,
                          ),
                        ),

                        const SizedBox(height: 8),

                        // ✅ TYPING + FLICKER 🔥
                        AnimatedOpacity(
                          duration: const Duration(milliseconds: 100),
                          opacity:
                              Random().nextDouble() > 0.1 ? 1 : 0.5,
                          child: Text(
                            displayedText,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                            ),
                          ),
                        ),

                        const SizedBox(height: 16),

                        // ✅ GLITCH EFFECT (subtle)
                        AnimatedBuilder(
                          animation: _glowAnimation,
                          builder: (_, __) {
                            return Transform.translate(
                              offset: Offset(
                                Random().nextDouble() * 1.2,
                                Random().nextDouble() * 1.2,
                              ),
                              child: Text(
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
                                      blurRadius: 35,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),

                        const SizedBox(height: 6),

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "CloudNex Ops Control System",
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: subTitleSize,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "Designed, Engineered & Operated by Mohammed Sheik",
                              style: TextStyle(
                                color: const Color(0xFF39FF14)
                                    .withValues(alpha: 0.7),
                                fontSize: subTitleSize * 0.8,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),

                        Container(
                          width: barWidth,
                          height: 2,
                          color: Colors.white10,
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Container(
                              width: barWidth * progress,
                              height: 2,
                              color: Colors.cyanAccent,
                            ),
                          ),
                        ),

                        const SizedBox(height: 10),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: const [
                            Text(
                              "DECRYPTION_STAGE",
                              style: TextStyle(
                                  color: Colors.cyanAccent, fontSize: 11),
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
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ✅ CRT SCANLINES
class ScanlinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()..color = Colors.white.withValues(alpha: 0.05);

    for (double y = 0; y < size.height; y += 4) {
      canvas.drawRect(
        Rect.fromLTWH(0, y, size.width, 1),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}