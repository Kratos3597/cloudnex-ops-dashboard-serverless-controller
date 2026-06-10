import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

class MatrixRain extends StatefulWidget {
  final double progress;
  final double depth;

  const MatrixRain({
    super.key,
    required this.progress,
    this.depth = 1.0,
  });

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

  late double fontSize;

  // 🔥 HACK MODE STATE
  double hackIntensity = 0.0; // 0 = normal, 1 = full hack mode

  @override
  void initState() {
    super.initState();

    fontSize = widget.depth > 0.5 ? 9 : 12;

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
      (_) => random.nextInt(2) + 1,
    );
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  void _setHackMode(bool active) {
    setState(() {
      hackIntensity = active ? 1.0 : 0.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    if (drops.isEmpty) {
      initMatrix(size);
    }

    return GestureDetector(
      onTapDown: (_) => _setHackMode(true),
      onTapUp: (_) => _setHackMode(false),
      onTapCancel: () => _setHackMode(false),

      child: Stack(
        children: [
          // 🌌 MATRIX RAIN
          CustomPaint(
            size: Size.infinite,
            painter: MatrixPainter(
              drops: drops,
              speeds: speeds,
              chars: chars,
              fontSize: fontSize,
              progress: widget.progress * (1.0 + hackIntensity * 2),
              depth: widget.depth,
              hackIntensity: hackIntensity,
            ),
          ),

          // 🔥 HACK MODE OVERLAY GLOW
          IgnorePointer(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              color: Colors.green.withValues(alpha: hackIntensity * 0.08),
            ),
          ),
        ],
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
  final double depth;
  final double hackIntensity;

  MatrixPainter({
    required this.drops,
    required this.speeds,
    required this.chars,
    required this.fontSize,
    required this.progress,
    required this.depth,
    required this.hackIntensity,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // 🌑 fade trail (stronger in hack mode)
    final fadeAlpha = depth < 0.5 ? 0.03 : 0.05;
    final paint = Paint()
      ..color = Colors.black.withValues(
        alpha: fadeAlpha + (hackIntensity * 0.08),
      );

    canvas.drawRect(Offset.zero & size, paint);

    for (int i = 0; i < drops.length; i++) {
      double speedBoost = progress * 1.2;

      drops[i] += speeds[i] + speedBoost;

      if (drops[i] * fontSize > size.height &&
          Random().nextDouble() > 0.97) {
        drops[i] = 0;
      }

      int trailLength = (depth > 0.5 ? 10 : 6) + (hackIntensity * 6).toInt();

      for (int trail = 0; trail < trailLength; trail++) {
        int y = (drops[i] - trail).toInt();
        if (y < 0) continue;

        String char = chars[(i + trail) % chars.length];

        double opacity = (1 - (trail / trailLength)).clamp(0.1, 1.0);

        Color color;

        if (trail == 0) {
          color = Color.lerp(
            const Color(0xFF39FF14),
            Colors.white,
            hackIntensity,
          )!;
        } else {
          color = const Color(0xFF39FF14)
              .withValues(alpha: opacity + hackIntensity * 0.3);
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
          Offset(i * (fontSize - 1), y * fontSize),
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}