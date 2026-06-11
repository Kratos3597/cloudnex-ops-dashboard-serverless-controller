import 'package:flutter/material.dart';
import '../theme/cyberpunk_theme.dart';
import '../widgets/terminal_shell.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // The body is where the Stack goes
      body: Stack(
        children: [
          // 1. Background Layer (drawn first)
          CyberpunkTheme.backgroundLayer(), 
          
          // 2. Terminal Shell (drawn on top)
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: TerminalShell(
                child: Text(
                  "SYSTEM INITIALIZED\nWelcome, Mohammed Sheik.", 
                  style: TextStyle(color: CyberpunkTheme.textLight)
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class IntuneScreen extends StatefulWidget {
  const IntuneScreen({super.key});

  @override
  State<IntuneScreen> createState() => _IntuneScreenState();
}

class _IntuneScreenState extends State<IntuneScreen> {
  List<Map<String, dynamic>> devices = [
    {"name": "DESKTOP-01", "os": "Windows"},
    {"name": "Galaxy S21", "os": "Android"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          CyberpunkTheme.backgroundLayer(),
          SafeArea(
            child: ListView(
              children: devices.map((d) {
                return ListTile(
                  title: Text(d["name"],
                      style: const TextStyle(color: Colors.white)),
                  subtitle: Text(d["os"]),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}