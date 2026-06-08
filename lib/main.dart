import 'package:flutter/material.dart';

void main() {
  runApp(const GitOpsControllerApp());
}

class GitOpsControllerApp extends StatelessWidget {
  const GitOpsControllerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CloudNex GitOps',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF121214),
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blueGrey,
          brightness: Brightness.dark,
        ),
      ),
      home: const DashboardShell(),
    );
  }
}

class DashboardShell extends StatelessWidget {
  const DashboardShell({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CloudNex Ops Node'),
        backgroundColor: const Color(0xFF1A1A1E),
        elevation: 0,
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              color: Colors.blueGrey,
            ),
            SizedBox(height: 24),
            Text(
              'Initializing Secure DevOps Pipeline...',
              style: TextStyle(
                color: Colors.grey, 
                letterSpacing: 1.2,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}