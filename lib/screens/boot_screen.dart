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
            const MatrixRain(),

            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 40),

                  const Text(
                    "CLOUDNEX CONTROL",
                    style: TextStyle(
                      color: Colors.cyanAccent,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 20),

                  ...logs.map((line) {
                    return Row(
                      children: [
                        const Text("> ",
                            style: TextStyle(color: Colors.greenAccent)),
                        Expanded(
                          child: Text(
                            line,
                            style: const TextStyle(
                              color: Colors.greenAccent,
                              fontFamily: 'Courier',
                            ),
                          ),
                        ),
                      ],
                    );
                  }),

                  const SizedBox(height: 10),
                  const Text("_",
                      style: TextStyle(color: Colors.greenAccent)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}