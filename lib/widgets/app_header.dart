import 'package:flutter/material.dart';

class AppHeader extends StatelessWidget {
  final String title;

  const AppHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    double titleSize = size.width * 0.035;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: const BoxDecoration(
        color: Colors.black,
      ),
      child: Row(
        children: [
          // ✅ LOGO WITH GLOW
          Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.cyanAccent.withValues(alpha: 0.4),
                  blurRadius: 12,
                ),
              ],
            ),
            child: TweenAnimationBuilder(
              tween: Tween(begin: 0.9, end: 1.0),
              duration: const Duration(milliseconds: 700),
              curve: Curves.easeOut,
              builder: (context, value, child) {
                return Transform.scale(
                  scale: value,
                  child: child,
                );
              },
              child: Image.asset(
                'assets/images/logo.jpg',
                height: 36,
              ),
            ),
          ),

          const SizedBox(width: 12),

          // ✅ PAGE TITLE (dynamic)
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                color: Colors.white70,
                fontSize: titleSize,
                letterSpacing: 1.2,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}