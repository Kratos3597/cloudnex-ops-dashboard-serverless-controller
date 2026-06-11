import 'package:flutter/material.dart';

class CyberpunkTheme {
  // Brand Colors
  static const Color neonBlue = Color(0xFF00F0FF);
  static const Color neonGreen = Color(0xFF39FF14);
  static const Color bgDark = Color(0xFF05050A);
  static const Color bgCard = Color(0xFF0B0F1A);
  static const Color textMuted = Color(0xFF9CA3AF);
  static const Color textLight = Colors.white;
  static const Color border = Color(0xFF1F2937);

  // Theme configuration
  static ThemeData get theme => ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: bgDark,
        primaryColor: neonBlue,
        fontFamily: 'Courier',
      );

  // Background gradient layer
  static Widget backgroundLayer() {
    return Container(
      decoration: const BoxDecoration(
        gradient: RadialGradient(
          radius: 1.2,
          colors: [Color(0x1100FFFF), bgDark],
        ),
      ),
    );
  }
}