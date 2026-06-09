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
/// BOOT SCREEN
///////////////////////////////////////////////////////////

class BootScreen extends StatefulWidget {
  const BootScreen({super.key});

  @override
  State<BootScreen> createState() => _BootScreenState();
}

class _BootScreenState extends State<BootScreen> {
  final logs = <String>[];

  final messages = [
    'BOOTING CLOUDNEX CORE...',
    'INJECTING MATRIX DRIVER...',
    'CONNECTING TO AZURE GRID...',
    'ENABLING ENTRA AUTH...',
    'SECURITY LAYERS: ACTIVE',
    'SYSTEM ONLINE ✅'
  ];

  int i = 0;

  @override
  void initState() {
    super.initState();
    runLogs();
  }

  void runLogs() {
    if (i < messages.length) {
      setState(() => logs.add(messages[i++]));
      Future.delayed(const Duration(milliseconds: 350), runLogs);
    } else {
      Future.delayed(const Duration(seconds: 1), () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const Login()),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFF05070C),
      body: Stack(
        children: [
          Positioned.fill(child: MatrixRain()),
          Positioned.fill(child: ScanLines()), // ✅ FIXED
          Padding(
            padding: EdgeInsets.all(20),
            child: ListView(
              children: logs
                  .map((e) => Text(
                        e,
                        style: const TextStyle(
                          color: Color(0xFF39FF14),
                          fontFamily: 'monospace',
                          shadows: [
                            Shadow(
                                color: Color(0xFF39FF14), blurRadius: 6)
                          ],
                        ),
                      ))
                  .toList(),
            ),
          )
        ],
      ),
    );
  }
}

///////////////////////////////////////////////////////////
/// LOGIN
///////////////////////////////////////////////////////////

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF090D16),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const Dashboard()),
            );
          },
          child: const Text('ACCESS SYSTEM'),
        ),
      ),
    );
  }
}

///////////////////////////////////////////////////////////
/// PROVIDER (FAKE DATA)
///////////////////////////////////////////////////////////

class FakeProvider extends ChangeNotifier {
  final data = {
    "users": 1532,
    "devices": 342,
    "alerts": 4,
    "vms": 58,
    "billing": "\$13,212"
  };
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
        title: const Text('CLOUDNEX CONTROL CORE'),
        backgroundColor: const Color(0xFF111827),
      ),
      body: const Stack(
        children: [
          Positioned.fill(child: MatrixRain(opacity: 0.05)),
          Positioned.fill(child: ScanLines()), // ✅ FIXED
          ListView(
            padding: EdgeInsets.all(12),
            children: [
              cyberCard('USERS', d['users'].toString()),
              cyberCard('DEVICES', d['devices'].toString()),
              cyberCard('ALERTS', d['alerts'].toString()),
              cyberCard('VMS', d['vms'].toString()),
              cyberCard('BILLING', d['billing']),
              SizedBox(height: 20),
              Text('LIVE EVENT STREAM',
                  style: TextStyle(color: Colors.orange)),
              ...List.generate(6, (i) => logItem(i)),
            ],
          )
        ],
      ),
    );
  }
}

///////////////////////////////////////////////////////////
/// CYBER CARD
///////////////////////////////////////////////////////////

Widget cyberCard(String title, String value) {
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
            shadows: [
              Shadow(blurRadius: 8, color: Color(0xFF39FF14))
            ],
          ),
        ),
      ],
    ),
  );
}

Widget logItem(int i) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Text(
      ':: EVENT $i → SYSTEM CHECK OK',
      style: const TextStyle(color: Colors.greenAccent, fontSize: 12),
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
    for (int i = 0; i < size.width / 10; i++) {
      final tp = TextPainter(
        text: TextSpan(
          text: rand.nextBool() ? '0' : '1',
          style: TextStyle(
              color: const Color(0xFF39FF14).withValues(alpha: opacity)),
        ),
        textDirection: TextDirection.ltr,
      )..layout();

      tp.paint(
        canvas,
        Offset(i * 10, rand.nextDouble() * size.height),
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

///////////////////////////////////////////////////////////
/// SCANLINES ✅ FIXED CONST CONSTRUCTOR
///////////////////////////////////////////////////////////

class ScanLines extends CustomPainter {
  const ScanLines(); // ✅ THIS FIXES YOUR ERROR

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black.withValues(alpha: 0.15)
      ..strokeWidth = 1;

    for (double y = 0; y < size.height; y += 4) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
``