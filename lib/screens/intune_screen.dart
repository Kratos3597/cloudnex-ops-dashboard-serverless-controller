import 'package:flutter/material.dart';
import '../theme/cyberpunk_theme.dart';

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