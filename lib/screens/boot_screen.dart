import 'package:flutter/material.dart';importimport 'home_screen.dart';

class BootScreen extends StatefulWidget {
  const BootScreen({super.key});

  @override
  State<BootScreen> createState() => _BootScreenState();
}

class _BootScreenState extends State<BootScreen> {
  final List<String> _steps = [
    "INITIALIZING CLOUDNEX CONTROL...",
    "CONNECTING TO AZURE...",
    "SYNCING DIRECTORY...",
    "LOADING SECURITY MODULES...",
    "ACCESS GRANTED"
  ];

  List<String> _visibleLogs = [];

  @override
  void initState() {
    super.initState();
    _startBootSequence();
  }

  Future<void> _startBootSequence() async {
    for (String step in _steps) {
      await Future.delayed(const Duration(milliseconds: 900));

      if (!mounted) return;

      setState(() {
        _visibleLogs.add(step);
      });
    }

    // Final delay before moving to main app
    await Future.delayed(const Duration(milliseconds: 800));

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const HomeScreen()),
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
            children: _visibleLogs.map((line) {
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