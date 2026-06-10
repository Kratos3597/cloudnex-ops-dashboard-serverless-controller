import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

class MatrixRain extends StatefulWidget {
  const MatrixRain({super.key});

  @override
  State<MatrixRain> createState() => _MatrixRainState();
}

class _MatrixRainState extends State<MatrixRain> {
  final Random random = Random();

  final List<String> chars =
      "01ABCDEFGHIJKLMNOPQRSTUVWXYZ@#\$%&".split("");

  late Timer timer;

  List<List<String>> columns = [];

  @override
  void initState() {
    super.initState();
    generateColumns();

    timer = Timer.periodic(const Duration(milliseconds: 100), (_) {
      setState(() {
        updateColumns();
      });
    });
  }

  void generateColumns() {
    columns = List.generate(
      40,
      (_) => List.generate(25, (_) => chars[random.nextInt(chars.length)]),
    );
  }

  void updateColumns() {
    for (var column in columns) {
      column.removeAt(0);
      column.add(chars[random.nextInt(chars.length)]);
    }
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: 0.2,
      child: CustomPaint(
        painter: MatrixPainter(columns),
        size: Size.infinite,
      ),
    );
  }
}

class MatrixPainter extends CustomPainter {
  final List<List<String>> columns;

  MatrixPainter(this.columns);

  @override
  void paint(Canvas canvas, Size size) {
    const textStyle = TextStyle(
      fontSize: 12,
      color: Colors.greenAccent,
      fontFamily: 'Courier',
    );

    for (int x = 0; x < columns.length; x++) {
      for (int y = 0; y < columns[x].length; y++) {
        final textPainter = TextPainter(
          text: TextSpan(text: columns[x][y], style: textStyle),
          textDirection: TextDirection.ltr,
        );

        textPainter.layout();

        textPainter.paint(
          canvas,
          Offset(x * 14.0, y * 14.0),
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}