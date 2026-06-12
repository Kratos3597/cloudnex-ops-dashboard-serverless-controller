import 'package:flutter/material.dart';

class TerminalShell extends StatelessWidget {
  final Widget child;

  const TerminalShell({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      // 1. Make the container transparent
      decoration: BoxDecoration(
        color: Colors.transparent, 
        border: Border.all(color: Colors.transparent),
        borderRadius: BorderRadius.circular(8.0),
      ),
      // 2. Wrap in a Column to hold the content, 
      // but we removed the header Row entirely.
      child: Column(
        children: [
          // Content Area - Expanded keeps your layout integrity
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
}