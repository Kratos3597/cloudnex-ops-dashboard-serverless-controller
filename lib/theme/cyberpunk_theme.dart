import 'package:flutter/material.dart';

class CyberpunkTheme        selectedItemColor: Colors.cyanAccent,class CyberpunkTheme {
        unselectedItemColor: Colors.white38,
      ),

      textTheme: const TextTheme(
        bodyMedium: TextStyle(color: Colors.white70),
      ),

      cardTheme: CardTheme(
        color: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
      ),
    );
  }

  /// Neon Glow Decoration (reusable)
  static BoxDecoration neonBox(Color color) {
    return BoxDecoration(
      color: Colors.black,
      borderRadius: BorderRadius.circular(18),
      border: Border.all(color: color.withOpacity(0.7)),
      boxShadow: [
        BoxShadow(
          color: color.withOpacity(0.6),
          blurRadius: 15,
        )
      ],
    );
  }
}
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