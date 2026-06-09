import 'package:flutter/material.dart';
import 'home({super.key});import 'home_screen.dart';

  @override
  State<BootScreen> createState() => _BootScreenState();
}

class _BootScreenState extends State<BootScreen> {
  final List<String> steps = [
    "INITIALIZING CLOUDNEX CONTROL...",
    "CONNECTING TO AZURE...",
    "SYNCING DIRECTORY...",
    "LOADING SECURITY MODULES...",
    "ACCESS GRANTED"
  ];

  List<String> logs = [];

  @override
  void initState() {
    super.initState();
    runBootSequence();
  }

  Future<void> runBootSequence() async {
    for (var step in steps) {
      await Future.delayed(const Duration(milliseconds: 900));

      if (!mounted) return;

      setState(() {
        logs.add(step);
      });
    }

    await Future.delayed(const Duration(milliseconds: 800));

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const HomeScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Align(
          alignment: Alignment.topLeft,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: logs.map((line) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Text(
                  line,
                  style: const TextStyle(
                    color: Colors.greenAccent,
                    fontSize: 16,
                    fontFamily: 'Courier',
                    letterSpacing: 1.2,
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}


class BootScreen extends StatefulWidget {