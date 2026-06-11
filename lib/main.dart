import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Add this package in pubspec.yaml
import 'screens/boot_screen.dart';
import 'theme/cyberpunk_theme.dart';
import 'services/dashboard_provider.dart'; // Import your orchestrator

void main() {
  // Ensure Flutter bindings are initialized before calling native storage
  WidgetsFlutterBinding.ensureInitialized();
  
  runApp(const CloudnexApp());
}

class CloudnexApp extends StatelessWidget {
  const CloudnexApp({super.key});

  @override
  Widget build(BuildContext context) {
    // MultiProvider allows you to inject multiple "brains" into the app
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => DashboardProvider()),
      ],
      child: MaterialApp(
        title: 'Cloudnex Control',
        debugShowCheckedModeBanner: false,
        theme: CyberpunkTheme.theme,
        home: const BootScreen(),
      ),
    );
  }
}