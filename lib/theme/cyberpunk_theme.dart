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

  // ✅ reusable neon box
  static BoxDecoration neonBox(Color color) {
    return BoxDecoration(
      color: Colors.black,
      borderRadius: BorderRadius.circular(18),
      border: Border.all(color: color),
      boxShadow: [
        BoxShadow(
          color: color.withOpacity(0.6),
          blurRadius: 15,
        ),
      ],
    );
  }
}