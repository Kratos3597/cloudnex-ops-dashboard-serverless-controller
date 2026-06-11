import 'package:flutter/material.dart';
import '../theme/cyberpunk_theme.dart';

class TerminalShell extends StatelessWidget {
  final Widget child;

  const TerminalShell({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: CyberpunkTheme.bgCard,
        border: Border.all(color: CyberpunkTheme.border),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        children: [
          // Header Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: CyberpunkTheme.border)),
            ),
            child: Row(
              children: [
                _dot(const Color(0xFFFF5F56)), // Exit
                const SizedBox(width: 6),
                _dot(const Color(0xFFFFBD2E)), // Minimize
                const SizedBox(width: 6),
                _dot(const Color(0xFF27C93F)), // Maximize
              ],
            ),
          ),
          // Content Area - Expanded prevents overflow
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: child,
            ),
          ),
        ],
      ),
    );
  }

  Widget _dot(Color color) => CircleAvatar(radius: 5, backgroundColor: color);
}