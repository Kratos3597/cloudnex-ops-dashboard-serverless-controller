import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => FakeProvider(),
      child: const App(),
    ),
  );
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: BootScreen(),
    );
  }
}

///////////////////////////////////////////////////////////
/// PROVIDER
///////////////////////////////////////////////////////////

class FakeProvider extends ChangeNotifier {
  final data = {
    "users": 1500,
    "devices": 320,
    "alerts": 3,
    "vms": 45,
    "billing": "\$12,300"
  };
}

///////////////////////////////////////////////////////////
/// BOOT SCREEN
///////////////////////////////////////////////////////////

class BootScreen extends StatefulWidget {
  const BootScreen({super.key});

  @override
  State<BootScreen> createState() => _BootScreenState();
}

class _BootScreenState extends State<BootScreen> {
  final logs = <String>[];
  int i = 0;

  final messages = [
    'BOOTING CLOUDNEX CORE...',
    'CONNECTING TO CLOUD...',
    'INITIALIZING SECURITY...',
    'LOADING MODULES...',
    'SYSTEM ONLINE ✅'
  ];

  @override
  void initState() {
    super.initState();
    _runLogs();
  }

  void _runLogs() {
    if (i < messages.length) {
      setState(() => logs.add(messages[i++]));
      Future.delayed(const Duration(milliseconds: 300), _runLogs);
    } else {
      Future.delayed(const Duration(seconds: 1), () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const Dashboard()),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF05070C),
      body: Stack(
        children: [
          const Positioned.fill(child: MatrixRain()),
          Positioned.fill(
            child: CustomPaint(painter: ScanLines()),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: ListView(
              children: logs
                  .map((e) => Text(
                        e,
                        style: const TextStyle(
                          color: Color(0xFF39FF14),
                          fontFamily: 'monospace',
                        ),
                      ))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}

///////////////////////////////////////////////////////////
/// DASHBOARD
///////////////////////////////////////////////////////////

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final d = context.watch<FakeProvider>().data;

    return Scaffold(
      backgroundColor: const Color(0xFF090D16),
      appBar: AppBar(
        title: const Text('CLOUDNEX CORE'),
        backgroundColor: const Color(0xFF111827),
      ),
      body: Stack(
        children: [
          const Positioned.fill(child: MatrixRain(opacity: 0.05)),
          Positioned.fill(
            child: CustomPaint(painter: ScanLines()),
          ),
          ListView(
            padding: const EdgeInsets.all(12),
            children: [
              card("Users", d["users"].toString()),
              card("Devices", d["devices"].toString()),
              card("Alerts", d["alerts"].toString()),
              card("VMs", d["vms"].toString()),
              card("Billing", d["billing"]),
            ],
          ),
        ],
      ),
    );
  }
}

///////////////////////////////////////////////////////////
/// CARD
///////////////////////////////////////////////////////////

Widget card(String title, String value) {
  return Container(
    margin: const EdgeInsets.only(bottom: 10),
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: const Color(0xFF05070C),
      border: Border.all(color: const Color(0xFF00F0FF)),
    ),
    child: Row(
      children: [
        Text(title, style: const TextStyle(color: Colors.white70)),
        const Spacer(),
        Text(
          value,
          style: const TextStyle(
            color: Color(0xFF39FF14),
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    ),
  );
}

///////////////////////////////////////////////////////////
/// MATRIX RAIN
///////////////////////////////////////////////////////////

class MatrixRain extends StatefulWidget {
  final double opacity;
  const MatrixRain({super.key, this.opacity = 0.2});

  @override
  State<MatrixRain> createState() => _MatrixRainState();
}

class _MatrixRainState extends State<MatrixRain> {
  late Timer timer;

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(const Duration(milliseconds: 60), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(painter: MatrixPainter(widget.opacity));
  }
}

class MatrixPainter extends CustomPainter {
  final double opacity;
  MatrixPainter(this.opacity);

  final rand = math.Random();

  @override
  void paint(Canvas canvas, Size size) {
    for (int i = 0; i < size.width / 12; i++) {
      final tp = TextPainter(
        text: TextSpan(
          text: rand.nextBool() ? '0' : '1',
          style: TextStyle(color: const Color(0xFF39FF14).withOpacity(opacity)),
        ),
        textDirection: TextDirection.ltr,
      )..layout();

      tp.paint(canvas, Offset(i * 12, rand.nextDouble() * size.height));
    }
  }

  @override
  bool shouldRepaint(_) => true;
}

///////////////////////////////////////////////////////////
/// SCANLINES (FIXED)
///////////////////////////////////////////////////////////

class ScanLines extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black.withOpacity(0.15)
      ..strokeWidth = 1;

    for (double y = 0; y < size.height; y += 4) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(_) => false;
}