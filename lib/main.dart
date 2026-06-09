import 'package:flutter/material.dart';
import 'screens/boot_screen.dart';
import 'theme/cyberpunk_theme.dart'; //

void main() {
  runApp(const CloudnexApp());
}

class CloudnexApp extends StatelessWidget {
  const CloudnexApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cloudnex Control',
      debugShowCheckedModeBanner: false,
      theme: CyberpunkTheme.theme,
      home: const BootScreen(),
      );
  }
}