import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'services/dashboard_provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => DashboardProvider()..loadConfig(),
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
      home: CyberDashboard(),
    );
  }
}

///////////////////////////////////////////////////////////
/// MAIN DASHBOARD
///////////////////////////////////////////////////////////

class CyberDashboard extends StatelessWidget {
  const CyberDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF090D16),
      body: Stack(
        children: [
          const Positioned.fill(child: CyberBackground()),

          Column(
            children: const [
              TopNavBar(),
              TelemetryRow(),
              Expanded(
                child: Row(
                  children: [
                    Expanded(flex: 3, child: LeftSelector()),
                    Expanded(flex: 7, child: TerminalPanel()),
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

///////////////////////////////////////////////////////////
/// TOP NAVBAR
///////////////////////////////////////////////////////////

class TopNavBar extends StatelessWidget {
  const TopNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFF1F2937))),
      ),
      child: Row(
        children: const [
          Text(
            "_CLOUDNEX",
            style: TextStyle(
              fontFamily: 'monospace',
              fontSize: 18,
              color: Colors.white,
            ),
          ),
          Spacer(),
          Text(
            "CAPABILITIES // ENGAGED",
            style: TextStyle(
              color: Color(0xFF39FF14),
              fontFamily: 'monospace',
            ),
          )
        ],
      ),
    );
  }
}

///////////////////////////////////////////////////////////
/// TELEMETRY ROW
///////////////////////////////////////////////////////////

class TelemetryRow extends StatelessWidget {
  const TelemetryRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        Expanded(child: TelemetryCard(Icons.shield, "100%", "Compliance")),
        Expanded(child: TelemetryCard(Icons.terminal, "4 ACTIVE", "Runbooks")),
        Expanded(child: TelemetryCard(Icons.favorite, "SCAN", "Health Check")),
      ],
    );
  }
}

class TelemetryCard extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;

  const TelemetryCard(this.icon, this.value, this.label, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF111827),
        border: Border.all(color: const Color(0xFF1F2937)),
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF00F0FF)),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: const TextStyle(
                  color: Color(0xFF39FF14),
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(label, style: const TextStyle(color: Colors.grey)),
            ],
          )
        ],
      ),
    );
  }
}

///////////////////////////////////////////////////////////
/// LEFT PANEL
///////////////////////////////////////////////////////////

class LeftSelector extends StatelessWidget {
  const LeftSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: const [
        CategoryCard("Cloud Engineering"),
        CategoryCard("Identity Architecture"),
        CategoryCard("Automation"),
      ],
    );
  }
}

class CategoryCard extends StatelessWidget {
  final String title;

  const CategoryCard(this.title, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF111827),
        border: Border.all(color: const Color(0xFF1F2937)),
      ),
      child: Text(
        title,
        style: const TextStyle(color: Colors.white),
      ),
    );
  }
}

///////////////////////////////////////////////////////////
/// TERMINAL PANEL
///////////////////////////////////////////////////////////

class TerminalPanel extends StatelessWidget {
  const TerminalPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF05070C),
        border: Border.all(color: const Color(0xFF1F2937)),
      ),
      child: Column(
        children: const [
          TerminalHeader(),
          Expanded(child: TerminalBody()),
        ],
      ),
    );
  }
}

class TerminalHeader extends StatelessWidget {
  const TerminalHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      color: const Color(0xFF0E131F),
      child: const Row(
        children: [
          CircleAvatar(radius: 4, backgroundColor: Colors.red),
          SizedBox(width: 4),
          CircleAvatar(radius: 4, backgroundColor: Colors.amber),
          SizedBox(width: 4),
          CircleAvatar(radius: 4, backgroundColor: Colors.green),
          SizedBox(width: 10),
          Text("capabilities.sh",
              style: TextStyle(color: Colors.grey, fontSize: 12))
        ],
      ),
    );
  }
}

class TerminalBody extends StatelessWidget {
  const TerminalBody({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(12),
      child: Text(
        "[NODE] Diagnostics Loading...\n> Awaiting input...\n> System ready.",
        style: TextStyle(
          color: Color(0xFF00F0FF),
          fontFamily: 'monospace',
        ),
      ),
    );
  }
}

///////////////////////////////////////////////////////////
/// BACKGROUND (HTML STYLE)
///////////////////////////////////////////////////////////

class CyberBackground extends StatelessWidget {
  const CyberBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(color: const Color(0xFF090D16)),

        // subtle grid
        Positioned.fill(
          child: Opacity(
            opacity: 0.04,
            child: GridPaper(
              color: const Color(0xFF00F0FF),
              interval: 24,
            ),
          ),
        ),

        // scanlines
        const Positioned.fill(child: ScanLines()),
      ],
    );
  }
}

class ScanLines extends StatelessWidget {
  const ScanLines({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(painter: _ScanPainter());
  }
}

class _ScanPainter extends CustomPainter {
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