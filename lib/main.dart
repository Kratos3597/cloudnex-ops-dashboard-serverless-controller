import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'services/dashboard_provider.dart';

void main() => runApp(ChangeNotifierProvider(create: (_) => DashboardProvider()..loadConfig(), child: const M365AdminCenterApp()));

class M365AdminCenterApp extends StatelessWidget {
  const M365AdminCenterApp({super.key});
  @override
  Widget build(BuildContext context) => const MaterialApp(debugShowCheckedModeBanner: false, home: AdminCenterShell());
}

class AdminCenterShell extends StatefulWidget {
  const AdminCenterShell({super.key});
  @override
  State<AdminCenterShell> createState() => _AdminCenterShellState();
}

class _AdminCenterShellState extends State<AdminCenterShell> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<DashboardProvider>(context);
    final metrics = provider.tenantMetrics;
    
    return Scaffold(
      backgroundColor: const Color(0xFF090D16),
      body: Row(
        children: [
          // Sidebar
          Container(width: 60, color: const Color(0xFF05070C)),
          // Workspace
          Expanded(
            child: ListView(
              children: [
                _buildGrid(provider, metrics),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGrid(DashboardProvider p, Map<String, dynamic> m) {
    return GridView.builder(
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
      itemCount: 3,
   itemBuilder: (context, i) {
        return Container(
          color: null, // Forcefully nullify any inherited color
          decoration: BoxDecoration(
            color: const Color(0xFF111827),
            border: Border.all(color: const Color(0xFF1F2937)),
          ),
        );
      },
    );
  }
}