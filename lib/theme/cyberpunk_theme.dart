import 'package:flutter/material.dart';

class CyberpunkTheme {
  static ThemeData get theme {
    return ThemeData(
      brightness: Brightness.dark,

      scaffoldBackgroundColor: const Color(0xFF05050A),

      primaryColor: Colors.cyanAccent,

      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.black,
        elevation: 0,
      ),

      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Colors.black,
        selectedItemColor: Colors.cyanAccent,
        unselectedItemColor: Colors.white38,
      ),

      textTheme: const TextTheme(
        bodyMedium: TextStyle(color: Colors.white70),
      ),

      cardTheme: CardThemeData(
        color: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
      ),
    );
  }

  // ✅ GLOBAL CYBERPUNK BACKGROUND (NEW 🔥)
  static Widget backgroundLayer() {
    return Container(
      decoration: const BoxDecoration(
        gradient: RadialGradient(
          radius: 1.2,
          colors: [
            Color(0x1100FFFF), // neon glow
            Color(0xFF05050A), // dark outer
          ],
        ),
      ),
    );
  }

  // ✅ NEON CARD STYLE
  static BoxDecoration neonBox(Color color) {
    return BoxDecoration(
      color: Colors.black,
      borderRadius: BorderRadius.circular(18),
      border: Border.all(color: color),
      boxShadow: [
        BoxShadow(
          color: color.withValues(alpha: 0.6), // ✅ updated
          blurRadius: 15,
          spreadRadius: 1,
        ),
      ],
    );
  }
}