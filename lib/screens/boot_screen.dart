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
  double opacity = 1.0;
  double progress = 0;

  double scale = 1.0;
  double blur = 0.0;

  late AnimationController _glowController;
  late Animation<double> _glowAnimation;

  int statusIndex = 0;
  String currentStatus = "Mapping infrastructure configurations...";

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

    // ✅ Status updater (synced with system feel)
    Timer.periodic(const Duration(milliseconds: 500), (timer) {
      if (!mounted) return;

      setState(() {
        if (statusIndex < statusTexts.length - 1) {
          statusIndex++;
          currentStatus = statusTexts[statusIndex];
        } else {
          timer.cancel();
        }
      });
    });

    startBoot();
  }

  Future<void> startBoot() async {
    for (int i = 0; i <= 100; i++) {
      await Future.delayed(const Duration(milliseconds: 26)); // ✅ matches web timing

      if (!mounted) return;

      setState(() {
        progress = i / 100;
      });
    }

    await Future.delayed(const Duration(milliseconds: 300));

    // ✅ Cinematic shutdown (zoom + blur + fade)
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
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    double titleSize = size.width * 0.12; // ✅ bigger text
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
                // ✅ MATRIX (SYNCED + STRONG)
                Opacity(
                  opacity: 0.5,
                  child: MatrixRain(progress: progress),
                ),

                // ✅ LIGHT OVERLAY (keeps matrix visible)
                Container(
                  color: Colors.black.withValues(alpha: 0.35),
                ),

                // ✅ CENTER TERMINAL STYLE UI
                Center(
                  child: Container(
                    width: size.width > 400 ? 400 : size.width * 0.85,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(220, 5, 7, 12),
                      border: Border.all(color: Colors.greenAccent),
                      borderRadius: BorderRadius.circular(4),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.greenAccent.withValues(alpha: 0.2),
                          blurRadius: 25,
                        )
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ✅ TERMINAL HEADER
                        const Text(
                          "> INITIALIZING CORE_BOOT_LOG...",
                          style: TextStyle(
                            color: Colors.greenAccent,
                            fontFamily: 'monospace',
                            fontSize: 12,
                          ),
                        ),

                        const SizedBox(height: 8),

                        // ✅ STATUS TEXT
                        Text(
                          currentStatus,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                          ),
                        ),

                        const SizedBox(height: 16),

                        // ✅ CLOUDNEX LOGO TEXT
                        AnimatedBuilder(
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
                                    blurRadius: 35,
                                  ),
                                ],
                              ),
                            );
                          },
                        ),

                        const SizedBox(height: 6),

                        Text(
                          "CONTROL PLATFORM",
                          style: TextStyle(
                            color: Colors.white38,
                            fontSize: subTitleSize,
                            letterSpacing: 3,
                          ),
                        ),

                        const SizedBox(height: 20),

                        // ✅ PROGRESS BAR
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

                        // ✅ FOOTER STATUS
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            const Text(
                              "DECRYPTION_STAGE",
                              style: TextStyle(
                                  color: Colors.cyanAccent, fontSize: 11),
                            ),
                            const SizedBox(width: 4),
                            Container(
                              width: 6,
                              height: 12,
                              color: Colors.greenAccent,
                            )
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