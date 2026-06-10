import 'package:flutter/material.dart';

class CyberpunkTheme {
  // ✅ COLORS
  static const Color neonBlue = Color(0xFF00F0FF);
  static const Color neonGreen = Color(0xFF39FF14);

  static const Color bgDark = Color(0xFF05050A);
  static const Color bgCard = Color(0xFF0B0F1A);
  static const Color textMuted = Color(0xFF9CA3AF);
  static const Color textLight = Color(0xFFE5E7EB);

  // ✅ THEME
  static ThemeData get theme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: bgDark,
      primaryColor: neonBlue,

      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.black,
        elevation: 0,
      ),

      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Colors.black,
        selectedItemColor: neonBlue,
        unselectedItemColor: Colors.white38,
      ),

      textTheme: const TextTheme(
        bodyMedium: TextStyle(color: Colors.white70),
      ),

      cardTheme: CardThemeData(
        color: bgCard,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(18)),
        ),
      ),
    );
  }

  // ✅ BACKGROUND LAYER
  static Widget backgroundLayer() {
    return Container(
      decoration: const BoxDecoration(
        gradient: RadialGradient(
          radius: 1.2,
          colors: [
            Color(0x1100FFFF),
            bgDark,
          ],
        ),
      ),
    );
  }

  // ✅ NEON CARD STYLE
  static BoxDecoration neonBox(Color color) {
    return BoxDecoration(
      color: bgCard,
      borderRadius: BorderRadius.circular(18),
      border: Border.all(color: color),
      boxShadow: [
        BoxShadow(
          color: color.withOpacity(0.6),
          blurRadius: 15,
          spreadRadius: 1,
        ),
      ],
    );
  }
}