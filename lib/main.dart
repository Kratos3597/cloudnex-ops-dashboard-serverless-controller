import 'package:flutter/material.dart';
import 'screens/boot_screen.dart';

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
      theme: ThemeData.dark(),
      home: const BootScreen(),
    );
  }
}
