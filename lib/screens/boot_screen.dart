import 'package:flutter/material.dart';
import 'home_screen.dart';
import '../widgets/matrix_rain.dart';

class BootScreen extends StatefulWidget {
  const BootScreen({super.key});

  @override
  State<BootScreen> createState() => _BootScreenState();
}

class _BootScreenState extends State<BootScreen> {
  List<String> logs = [];
  double opacity = 1.0;

  final List<String> steps = [
    "INITIALIZING CORE...",
    "LOADING POWER MODULES...",
    "CONNECTING TO AZURE...",
    "SYNCING DIRECTORY...",
    "STABILIZING NETWORK...",
    "ACCESS GRANTED"
  ];

  @override
  void initState() {
    super.initState();
    startBoot();
  }

  Future<void> startBoot() async {
    for (var step in steps) {
      await Future.delayed(const Duration(milliseconds: 700));

      if (!mounted) return;

      setState(() {
        logs.add(step);
      });
    }

    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      opacity = 0;
    });

    await Future.delayed(const Duration(milliseconds: 800));

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
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 800),
      opacity: opacity,
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            const MatrixRain(), // ✅ matrix background

            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const SizedBox(height: 40),

                    // 🔥 TITLE
                    const Text(
                      "CLOUDNEX CONTROL",
                      style: TextStyle(
                        color: Colors.cyanAccent,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                      ),
                    ),

                    const SizedBox(height: 20),

                    // 🔥 CENTERED TERMINAL
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ...logs.map((line) {
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 4),
                              child: Row(
                                children: [
                                  const Text(
                                    "> ",
                                    style: TextStyle(
                                      color: Colors.greenAccent,
                                      fontFamily: 'FiraCode',
                                      fontSize: 14,
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      line,
                                      style: const TextStyle(
                                        color: Colors.greenAccent,
                                        fontFamily: 'FiraCode',
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),

                          const SizedBox(height: 10),

                          // 🔥 CURSOR
                          const Text(
                            "_",
                            style: TextStyle(
                              color: Colors.greenAccent,
                              fontFamily: 'FiraCode',
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}