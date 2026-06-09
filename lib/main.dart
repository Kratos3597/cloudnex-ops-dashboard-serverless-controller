import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'services/dashboard_provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => DashboardProvider()..loadConfig(),
      child: const M365AdminCenterApp(),
    ),
  );
}

class M365AdminCenterApp extends StatelessWidget {
  const M365AdminCenterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CloudNex Enterprise',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFF090D16),
        fontFamily: 'Courier New',
      ),
      home: const BootSequenceWrapper(),
    );
  }
}

///////////////////////////////////////////////////////////
/// BOOT SEQUENCE (UNCHANGED LOGIC)
///////////////////////////////////////////////////////////

class BootSequenceWrapper extends StatefulWidget {
  const BootSequenceWrapper({super.key});

  @override
  State<BootSequenceWrapper> createState() => _BootSequenceWrapperState();
}

class _BootSequenceWrapperState extends State<BootSequenceWrapper>
    with TickerProviderStateMixin {
  bool _bootComplete = false;
  final List<String> _bootLogs = [];
  int _index = 0;

  final logs = [
    ':: INITIALIZING CLOUDNEX...',
    ':: LOADING SYSTEM...',
    ':: VERIFYING SERVICES...',
    ':: AUTH MODULE READY...',
    ':: SYSTEM ONLINE'
  ];

  late AnimationController fade;

  @override
  void initState() {
    super.initState();

    fade = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    runLogs();
  }

  void runLogs() {
    if (_index < logs.length) {
      setState(() {
        _bootLogs.add(logs[_index++]);
      });

      Future.delayed(const Duration(milliseconds: 350), runLogs);
    } else {
      Future.delayed(const Duration(milliseconds: 600), () {
        fade.forward().then((_) {
          setState(() => _bootComplete = true);
        });
      });
    }
  }

  @override
  void dispose() {
    fade.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_bootComplete) {
      return const AdminCenterShell();
    }

    return Scaffold(
      backgroundColor: const Color(0xFF05070C),
      body: FadeTransition(
        opacity: Tween(begin: 1.0, end: 0.0).animate(fade),
        child: Stack(
          children: [
            const Positioned.fill(child: MatrixRainCanvas()),
            Positioned.fill(
              child: CustomPaint(painter: CyberScanlinePainter()),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: ListView(
                children: _bootLogs
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
      ),
    );
  }
}

///////////////////////////////////////////////////////////
/// MAIN UI (UNCHANGED STRUCTURE)
///////////////////////////////////////////////////////////

class AdminCenterShell extends StatelessWidget {
  const AdminCenterShell({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<DashboardProvider>(context);
    final data = provider.tenantMetrics;

    if (data.isEmpty) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      body: Stack(
        children: [
          const Positioned.fill(child: MatrixRainCanvas()),
          Positioned.fill(
            child: CustomPaint(painter: CyberScanlinePainter()),
          ),
          ListView(
            padding: const EdgeInsets.all(12),
            children: [
              card("Users", data["entraId"]["users"].toString()),
              card("Devices", data["intune"]["totalDevices"].toString()),
              card("VMs", data["azure"]["activeVMs"].toString()),
              card("Billing", data["azure"]["monthlyBurn"].toString()),
            ],
          )
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
    margin: const EdgeInsets.only(bottom: 12),
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: const Color(0xFF05070C),
      border: Border.all(color: const Color(0xFF00F0FF)),
    ),
    child: Row(
      children: [
        Text(title,
            style: const TextStyle(color: Colors.white70, fontSize: 14)),
        const Spacer(),
        Text(
          value,
          style: const TextStyle(
              color: Color(0xFF39FF14),
              fontWeight: FontWeight.bold),
        ),
      ],
    ),
  );
}

///////////////////////////////////////////////////////////
/// MATRIX ENGINE (UNCHANGED)
///////////////////////////////////////////////////////////

class MatrixRainCanvas extends StatefulWidget {
  const MatrixRainCanvas({super.key});

  @override
  State<MatrixRainCanvas> createState() => _MatrixRainCanvasState();
}

class _MatrixRainCanvasState extends State<MatrixRainCanvas> {
  late Timer timer;
  final random = math.Random();

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
    return CustomPaint(
      painter: MatrixPainter(random),
    );
  }
}

class MatrixPainter extends CustomPainter {
  final math.Random random;

  MatrixPainter(this.random);

  @override
  void paint(Canvas canvas, Size size) {
    for (int i = 0; i < size.width / 12; i++) {
      final tp = TextPainter(
        text: TextSpan(
          text: random.nextBool() ? "0" : "1",
          style: const TextStyle(color: Color(0xFF39FF14)),
        ),
        textDirection: TextDirection.ltr,
      )..layout();

      tp.paint(
        canvas,
        Offset(i * 12, random.nextDouble() * size.height),
      );
    }
  }

  @override
  bool shouldRepaint(_) => true;
}

///////////////////////////////////////////////////////////
/// SCANLINES
///////////////////////////////////////////////////////////

class CyberScanlinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black.withOpacity(0.12);

    for (double y = 0; y < size.height; y += 4) {
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(_) => false;
}