import 'dart:async';
import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';

class MatrixRain extends StatefulWidget {
  final double progress;

  const MatrixRain({super.key, required this.progress});

  @override
  State<MatrixRain> createState() => _MatrixRainState();
}

class _MatrixRainState extends State<MatrixRain> {
  final Random random = Random();
  late Timer timer;

  List<double> drops = [];
  List<int> speeds = [];

  final List<String> chars =
      "010101ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789@#\$%&*+-/<>[]{}".split("");

  double fontSize = 9; // ✅ DENSE MATRIX (IMPORTANT)

  @override
  void initState() {
    super.initState();

    timer = Timer.periodic(const Duration(milliseconds: 33), (_) {
      if (mounted) setState(() {});
    });
  }

  void initMatrix(Size size) {
    int columns = (size.width / fontSize).floor();

    drops = List.generate(
      columns,
      (_) => random.nextDouble() * size.height / fontSize,
    );

    speeds = List.generate(
      columns,
      (_) => random.nextInt(3) + 1,
    );
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    if (drops.isEmpty) {
      initMatrix(size);
    }

    return CustomPaint(
      size: Size.infinite,
      painter: MatrixPainter(
        drops: drops,
        speeds: speeds,
        chars: chars,
        fontSize: fontSize,
        progress: widget.progress,
        random: random,
      ),
    );
  }
}

class MatrixPainter extends CustomPainter {
  final List<double> drops;
  final List<int> speeds;
  final List<String> chars;
  final double fontSize;
  final double progress;
  final Random random;

  MatrixPainter({
    required this.drops,
    required this.speeds,
    required this.chars,
    required this.fontSize,
    required this.progress,
    required this.random,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // ✅ TRAIL FADE (like your website)
    final fadePaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.05);

    canvas.drawRect(Offset.zero & size, fadePaint);

    for (int i = 0; i < drops.length; i++) {

      // ✅ SPEED SYNC WITH PROGRESS
      double speedBoost = progress * 4;

      drops[i] += speeds[i] + speedBoost;

      // ✅ RESET
      if (drops[i] * fontSize > size.height &&
          random.nextDouble() > 0.95) {
        drops[i] = 0;
      }

      // ✅ DRAW TRAILING STREAK (MULTI CHAR COLUMN 🔥)
      for (int trail = 0; trail < 10; trail++) {
        int index = (drops[i] - trail).toInt();
        if (index < 0) continue;

        String char = chars[random.nextInt(chars.length)];

        // ✅ TRAIL FADE GRADIENT
        double opacity = (1 - (trail / 10)).clamp(0.0, 1.0);

        Color color;

        if (trail == 0) {
          // ✅ BRIGHT HEAD (white glow)
          color = Colors.white;
        } else {
          color = const Color(0xFF39FF14)
              .withValues(alpha: opacity * 0.9);
        }

        final textPainter = TextPainter(
          text: TextSpan(
            text: char,
            style: TextStyle(
              color: color,
              fontSize: fontSize,
              fontFamily: 'monospace',
            ),
          ),
          textDirection: TextDirection.ltr,
        );

        textPainter.layout();

        textPainter.paint(
          canvas,
          Offset(i * (fontSize - 1), index * fontSize),
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}