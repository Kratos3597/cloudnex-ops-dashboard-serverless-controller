import 'dart:async';
import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';

class MatrixRain extends StatefulWidget {
  final double progress; // ✅ synced with boot progress

  const MatrixRain({super.key, required this.progress});

  @override
  State<MatrixRain> createState() => _MatrixRainState();
}

class _MatrixRainState extends State<MatrixRain> {
  final Random random = Random();

  late Timer timer;

  List<double> drops = [];
  List<int> baseSpeeds = [];

  List<String> chars =
      "01ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789@#\$%&*+-/<>[]{}".split("");

  double fontSize = 14;
  int columnCount = 0;

  @override
  void initState() {
    super.initState();

    // ✅ 30 FPS (matches your website ~33ms)
    timer = Timer.periodic(const Duration(milliseconds: 33), (_) {
      if (mounted) setState(() {});
    });
  }

  void initMatrix(Size size) {
    columnCount = (size.width / fontSize).floor();

    drops = List.generate(
      columnCount,
      (_) => random.nextDouble() * size.height / fontSize,
    );

    // ✅ each column has its own base speed
    baseSpeeds = List.generate(
      columnCount,
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
        baseSpeeds: baseSpeeds,
        chars: chars,
        fontSize: fontSize,
        size: size,
        random: random,
        progress: widget.progress,
      ),
    );
  }
}

class MatrixPainter extends CustomPainter {
  final List<double> drops;
  final List<int> baseSpeeds;
  final List<String> chars;
  final double fontSize;
  final Size size;
  final Random random;
  final double progress;

  MatrixPainter({
    required this.drops,
    required this.baseSpeeds,
    required this.chars,
    required this.fontSize,
    required this.size,
    required this.random,
    required this.progress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // ✅ TRAIL FADE (matches your JS exactly)
    final fadePaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.08);

    canvas.drawRect(Offset.zero & size, fadePaint);

    for (int i = 0; i < drops.length; i++) {
      // ✅ character
      String char = chars[random.nextInt(chars.length)];

      // ✅ brightness variation (depth)
      double intensity = (progress + 0.2).clamp(0.2, 1.0);

      final textPainter = TextPainter(
        text: TextSpan(
          text: char,
          style: TextStyle(
            color: Colors.greenAccent.withValues(alpha: intensity),
            fontSize: fontSize,
            fontFamily: 'monospace',
          ),
        ),
        textDirection: TextDirection.ltr,
      );

      textPainter.layout();

      textPainter.paint(
        canvas,
        Offset(i * fontSize, drops[i] * fontSize),
      );

      // ✅ PROGRESS SYNC (MAIN FEATURE 🔥)
      double speedBoost = progress * 4; // grows over time

      drops[i] += baseSpeeds[i] + speedBoost;

      // ✅ reset like your JS
      if (drops[i] * fontSize > size.height &&
          random.nextDouble() > 0.95) {
        drops[i] = 0;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}