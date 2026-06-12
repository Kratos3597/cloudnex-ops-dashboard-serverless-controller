import 'package:flutter/material.dart';

class SparklinePainter extends CustomPainter {
  final List<double> data;
  final Color color;

  SparklinePainter({required this.data, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    if (data.length < 2) return;
    
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    final path = Path();
    double dx = size.width / (data.length - 1);
    
    for (int i = 0; i < data.length; i++) {
      double x = i * dx;
      double y = size.height - (data[i] * size.height); // Normalize 0.0-1.0
      if (i == 0) path.moveTo(x, y);
      else path.lineTo(x, y);
    }
    
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant SparklinePainter oldDelegate) => true;
}