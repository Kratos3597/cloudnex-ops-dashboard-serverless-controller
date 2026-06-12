import 'package:flutter/material.dart';
import 'sparkline_painter.dart'; // Ensure you have this file created

class ConsoleTile extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  final List<double>? sparklineData; // Optional performance trend

  const ConsoleTile({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    required this.onTap,
    this.sparklineData,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.4),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withValues(alpha: 0.5), width: 1),
        ),
        child: Column(
          children: [
            // Row for Icon and Text
            Row(
              children: [
                Icon(icon, size: 28, color: color),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(title, style: TextStyle(color: color.withValues(alpha: 0.8), fontSize: 12)),
                    Text(value, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                  ],
                ),
              ],
            ),
            
            // Render Sparkline if data exists
            if (sparklineData != null) ...[
              const SizedBox(height: 8),
              SizedBox(
                height: 20,
                width: double.infinity,
                child: CustomPaint(
                  painter: SparklinePainter(data: sparklineData!, color: color),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}