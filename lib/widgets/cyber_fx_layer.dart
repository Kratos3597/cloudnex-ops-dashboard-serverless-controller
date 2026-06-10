import 'package:flutter/material.dart';

class CyberFxLayer extends StatefulWidget {
  final double intensity;

  const CyberFxLayer({
    super.key,
    required this.intensity,
  });

  @override
  State<CyberFxLayer> createState() => _CyberFxLayerState();
}

class _CyberFxLayerState extends State<CyberFxLayer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  double _noise = 0.0;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (_, __) {
          return CustomPaint(
            size: Size.infinite,
            painter: _CyberFxPainter(
              intensity: widget.intensity,
              noise: _noise,
            ),
          );
        },
      ),
    );
  }
}

class _CyberFxPainter extends CustomPainter {
  final double intensity;
  final double noise;

  _CyberFxPainter({
    required this.intensity,
    required this.noise,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // 🧠 SCANLINES
    final scanPaint = Paint()
      ..color = Colors.white.withOpacity(0.03 * intensity);

    for (double y = 0; y < size.height; y += 6) {
      canvas.drawRect(
        Rect.fromLTWH(0, y, size.width, 1),
        scanPaint,
      );
    }

    // 💀 NOISE FLICKER
    final flicker = Paint()
      ..color = Colors.green.withOpacity(0.02 * noise * intensity);

    canvas.drawRect(
      Offset.zero & size,
      flicker,
    );
  }

  @override
bool shouldRepaint(covariant CustomPainter oldDelegate) {
  return oldDelegate is _CyberFxPainter &&
      oldDelegate.intensity != intensity;
}
}