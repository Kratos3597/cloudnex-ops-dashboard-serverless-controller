import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Handles native click & cybernetic feedback sounds
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
      title: 'CloudNex Enterprise Cyber Management Ecosystem',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFF090D16),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF00F0FF),
          background: const Color(0xFF090D16),
        ),
        fontFamily: 'Courier New',
      ),
      home: const BootSequenceWrapper(),
    );
  }
}

// =========================================================================
// 🎬 CYBERPUNK TERMINAL BOOT SEQUENCE ENGINE
// =========================================================================
class BootSequenceWrapper extends StatefulWidget {
  const BootSequenceWrapper({super.key});

  @override
  State<BootSequenceWrapper> createState() => _BootSequenceWrapperState();
}

class _BootSequenceWrapperState extends State<BootSequenceWrapper> with TickerProviderStateMixin {
  bool _bootComplete = false;
  final List<String> _bootLogs = [];
  int _currentLogIndex = 0;

  final List<String> _rawDiagnostics = [
    ':: INITIALIZING CLOUDNEX ENVIRONMENT V2.6...',
    ':: LOADING NETWORK CONTROLLERS [OK]',
    ':: FETCHING EDGE TOKENS FROM SECURE VAULT...',
    ':: ALLOCATING RETRIEVAL-AUGMENTED GENERATION STORAGE TUNNELS...',
    ':: VERIFYING COMPLIANCE REGISTRIES WITH CLOUDFLARE D1...',
    ':: MOUNTING MULTI-TENANT PORTS (M365, ENTRA, INTUNE, VEEAM, AZURE)...',
    ':: SYSTEM PROFILE: 100% SECURE. ENGAGING TERMINAL GRAPHICS...'
  ];

  late AnimationController _fadeExitController;

  @override
  void initState() {
    super.initState();
    _fadeExitController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _executeLogCascade();
  }

  void _executeLogCascade() {
    if (_currentLogIndex < _rawDiagnostics.length) {
      setState(() {
        _bootLogs.add(_rawDiagnostics[_currentLogIndex]);
        _currentLogIndex++;
      });
      Future.delayed(const Duration(milliseconds: 400), () {
        _executeLogCascade();
      });
    } else {
      Future.delayed(const Duration(milliseconds: 600), () {
        _fadeExitController.forward().then((_) {
          setState(() {
            _bootComplete = true;
          });
        });
      });
    }
  }

  @override
  void dispose() {
    _fadeExitController.dispose();
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
        opacity: Tween<double>(begin: 1.0, end: 0.0).animate(
          CurvedAnimation(parent: _fadeExitController, curve: Curves.easeOut),
        ),
        child: Stack(
          children: [
            const Positioned.fill(child: MatrixRainCanvas()),
            Positioned.fill(child: CustomPaint(painter: CyberScanlinePainter())),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Text(
                          '_CLOUDNEX',
                          style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold, fontFamily: 'monospace', letterSpacing: 2),
                        ),
                        Text(
                          ' OS',
                          style: TextStyle(
                            color: const Color(0xFF00F0FF), 
                            fontSize: 22, 
                            fontWeight: FontWeight.bold, 
                            fontFamily: 'monospace', 
                            shadows: [
                              Shadow(color: const Color(0xFF00F0FF).withOpacity(0.5), blurRadius: 8)
                            ],
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 32, color: Color(0xFF1F2937)),
                    Expanded(
                      child: ListView.builder(
                        itemCount: _bootLogs.length,
                        itemBuilder: (context, index) {
                          bool isLast = index == _bootLogs.length - 1;
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.chevron_right_rounded,
                                  size: 14,
                                  color: isLast ? const Color(0xFF39FF14) : const Color(0xFF00F0FF),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    _bootLogs[index],
                                    style: TextStyle(
                                      color: isLast ? const Color(0xFF39FF14) : const Color(0xFF9CA3AF),
                                      fontFamily: 'monospace',
                                      fontSize: 12,
                                      fontWeight: isLast ? FontWeight.bold : FontWeight.normal,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    Row(
                      children: [
                        const SizedBox(
                          width: 12,
                          height: 12,
                          child: CircularProgressIndicator(strokeWidth: 1.5, color: Color(0xFFFFAA00)),
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          'COMPILING CORE MATRIX SUBMODULES...',
                          style: TextStyle(color: Color(0xFFFFAA00), fontFamily: 'monospace', fontSize: 10, letterSpacing: 1),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// =========================================================================
// MAIN INTERACTIVE CYBER COMMAND SHELL (FIXED CLIPPING & BRACKETS)
// =========================================================================
class AdminCenterShell extends StatefulWidget {
  const AdminCenterShell({super.key});

  @override
  State<AdminCenterShell> createState() => _AdminCenterShellState();
}

class _AdminCenterShellState extends State<AdminCenterShell> with SingleTickerProviderStateMixin {
  
  // Cybernetic Sound Executor Module
  void _playTerminalChime() {
    SystemSound.play(SystemSoundType.click);
    HapticFeedback.lightImpact();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<DashboardProvider>(context);
    final metrics = provider.tenantMetrics;

    if (metrics.isEmpty) {
      return const Scaffold(
        backgroundColor: Color(0xFF090D16),
        body: Center(child: CircularProgressIndicator(color: Color(0xFF00F0FF))),
      );
    }

    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isTablet = screenWidth >= 650;
    final bool isDesktop = screenWidth >= 1000;

    Color consoleAccent;
    Color topBarColor;
    String consoleTitle;

    switch (provider.activeConsole) {
      case 'Entra':
        consoleAccent = const Color(0xFF00F0FF);
        topBarColor = const Color(0xFF11171F); 
        consoleTitle = 'CLOUDNEX IDENTITY HUB';
        break;
      case 'Intune':
        consoleAccent = const Color(0xFF00F0FF);
        topBarColor = const Color(0xFF05070C); 
        consoleTitle = 'CLOUDNEX ENDPOINT CORE';
        break;
      case 'Veeam':
        consoleAccent = const Color(0xFF39FF14); 
        topBarColor = const Color(0xFF0B1109);
        consoleTitle = 'CLOUDNEX BACKUP SHIELD';
        break;
      case 'Azure':
        consoleAccent = const Color(0xFF008AD7);
        topBarColor = const Color(0xFF020408);
        consoleTitle = 'CLOUDNEX CLOUD GRID';
        break;
      default:
        consoleAccent = const Color(0xFF00F0FF);
        topBarColor = const Color(0xFF0A0F1D); 
        consoleTitle = 'CLOUDNEX OPS CORE';
    }

    return Scaffold(
      backgroundColor: const Color(0xFF090D16),
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            const Positioned.fill(child: MatrixRainCanvas()),
            Opacity(
              opacity: 0.04,
              child: GridPaper(
                color: consoleAccent,
                interval: 24,
                subdivisions: 1,
                child: Container(),
              ),
            ),
            Positioned.fill(child: CustomPaint(painter: CyberScanlinePainter())),

            Column(
              children: [
                // Top Master Controller Nav Bar
                Container(
                  height: 52,
                  color: topBarColor,
                  padding: EdgeInsets.symmetric(horizontal: isTablet ? 16 : 12),
                  decoration: const BoxDecoration(
                    border: Border(bottom: BorderSide(color: Color(0xFF1F2937), width: 1)),
                  ),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(2),
                        child: Image.network(
                          'https://cloudnex.co.za/assets/img/logo.png',
                          height: 22,
                          width: 22,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              width: 22,
                              height: 22,
                              color: consoleAccent.withOpacity(0.2),
                              child: const Center(
                                child: Text('CN', style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold)),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 200),
                          child: Text(
                            consoleTitle,
                            key: ValueKey(consoleTitle),
                            style: TextStyle(
                              color: const Color(0xFFF3F4F6),
                              fontFamily: 'monospace',
                              fontSize: isTablet ? 13 : 11,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: provider.isLoading
                            ? const SizedBox(width: 14, height: 14, child: CircularProgressIndicator(strokeWidth: 1.5, color: Color(0xFF00F0FF)))
                            : const Icon(Icons.refresh, color: Color(0xFF9CA3AF), size: 16),
                        onPressed: () {
                          _playTerminalChime(); 
                          provider.refreshDashboard();
                        },
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Row(
                    children: [
                      // Left Menu Access Rail
                      Container(
                        width: isTablet ? 56 : 48,
                        color: const Color(0xFF05070C),
                        decoration: const BoxDecoration(
                          border: Border(right: BorderSide(color: Color(0xFF1F2937), width: 1)),
                        ),
                        child: Column(
                          children: [
                            const SizedBox(height: 12),
                            _buildConsoleRailButton(context, 'M365', Icons.terminal_outlined, consoleAccent, isTablet),
                            _buildConsoleRailButton(context, 'Entra', Icons.fingerprint_outlined, consoleAccent, isTablet),
                            _buildConsoleRailButton(context, 'Intune', Icons.toggle_on_outlined, consoleAccent, isTablet),
                            _buildConsoleRailButton(context, 'Veeam', Icons.dns_outlined, consoleAccent, isTablet),
                            _buildConsoleRailButton(context, 'Azure', Icons.cloud_queue_outlined, consoleAccent, isTablet),
                          ],
                        ),
                      ),

                      // 🧠 FIXED BRACKETS HERE: Cleaned up trailing parameters inside the AnimatedSwitcher tree hierarchy
                      Expanded(
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 350),
                          switchInCurve: Curves.easeInOutCubic,
                          switchOutCurve: Curves.easeInOutCubic,
                          child: KeyedSubtree(
                            key: ValueKey<String>(provider.activeConsole),
                            child: _buildConsoleWorkspace(provider.activeConsole, metrics, provider, isTablet, isDesktop, consoleAccent),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConsoleWorkspace(String console, Map<String, dynamic> metrics, DashboardProvider provider, bool isTablet, bool isDesktop, Color activeAccent) {
    return ListView(
      padding: EdgeInsets.symmetric(horizontal: isTablet ? 28 : 16, vertical: 20),
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    ':: SYSTEM INFRASTRUCTURE GRID',
                    style: TextStyle(
                      fontSize: isTablet ? 15 : 12,
                      fontWeight: FontWeight.bold,
                      color: activeAccent,
                      fontFamily: 'monospace',
                      letterSpacing: 0.5,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'SCOPE_ID: ${metrics["tenantId"]}',
                    style: const TextStyle(fontSize: 10, color: Color(0xFF9CA3AF), fontFamily: 'monospace'),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            _buildPulseStatusIndicator(),
          ],
        ),
        const SizedBox(height: 20),

        LayoutBuilder(
          builder: (context, constraints) {
            int gridCount = 1;
            if (isDesktop) {
              gridCount = 3;
            } else if (isTablet) {
              gridCount = 2;
            }

            return GridView.count(
              crossAxisCount: gridCount,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: isTablet ? 1.45 : 1.6,
              children: [
                if (console == 'M365') ..._buildM365Cards(metrics),
                if (console == 'Entra') ..._buildEntraCards(metrics),
                if (console == 'Intune') ..._buildIntuneCards(metrics),
                if (console == 'Veeam') ..._buildVeeamCards(metrics),
                if (console == 'Azure') ..._buildAzureCards(metrics),
              ],
            );
          },
        ),

        const SizedBox(height: 28),
        Row(
          children: [
            const Icon(Icons.code, size: 14, color: Color(0xFFFFAA00)),
            const SizedBox(width: 8),
            Text(
              'DIAGNOSTIC AUTOMATION LOGSTREAM',
              style: TextStyle(fontSize: isTablet ? 12 : 11, fontWeight: FontWeight.bold, color: const Color(0xFFFFAA00), fontFamily: 'monospace', letterSpacing: 0.5),
            ),
          ],
        ),
        const SizedBox(height: 12),

        Container(
          decoration: BoxDecoration(
            color: const Color(0xFF05070C).withOpacity(0.85), 
            borderRadius: BorderRadius.circular(2),
            border: Border.all(color: const Color(0xFF1F2937)),
          ),
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: provider.infrastructureLogs.length,
            separatorBuilder: (context, index) => const Divider(height: 1, color: Color(0xFF1F2937)),
            itemBuilder: (context, index) {
              final log = provider.infrastructureLogs[index];
              return InkWell(
                onTap: () => _playTerminalChime(), 
                child: ListTile(
                  dense: true,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  leading: const Icon(Icons.terminal, color: Color(0xFF39FF14), size: 14),
                  title: Text(
                    log["event"],
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: isTablet ? 12 : 11, color: const Color(0xFFF3F4F6), fontFamily: 'monospace'),
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Text(
                    log["details"],
                    style: const TextStyle(fontSize: 10, color: Color(0xFF9CA3AF), fontFamily: 'monospace'),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: Text(
                    log["timestamp"],
                    style: const TextStyle(fontSize: 9, color: Color(0xFF4B5563), fontFamily: 'monospace'),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  List<Widget> _buildM365Cards(Map<String, dynamic> metrics) {
    return [
      _buildCyberCard('SYS_CAT_01 // COMPUTE POOLS', 'Local Cluster Optimization Status', Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text('${metrics["serverSpace"]["usedTB"]} / ${metrics["serverSpace"]["totalTB"]} TB', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.white, fontFamily: 'monospace'), overflow: TextOverflow.ellipsis),
              ),
              const Text('[NOMINAL]', style: TextStyle(color: Color(0xFF39FF14), fontSize: 10, fontWeight: FontWeight.bold, fontFamily: 'monospace')),
            ],
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(value: metrics["serverSpace"]["usedTB"] / metrics["serverSpace"]["totalTB"], color: const Color(0xFF00F0FF), backgroundColor: const Color(0xFF1F2937)),
        ],
      )),
      _buildCyberCard('SYS_CAT_02 // AD TOPOLOGY', 'Domain Federation Telemetry Node', Row(
        children: [
          Expanded(child: _buildCyberMetricBlock(metrics["entraId"]["users"].toString(), 'AD OBJECTS')),
          Container(width: 1, height: 24, color: const Color(0xFF1F2937)),
          Expanded(child: _buildCyberMetricBlock(metrics["entraId"]["groups"].toString(), 'SEC_GROUPS')),
        ],
      )),
      _buildCyberCard('SYS_CAT_03 // DEFENSE ANCHOR', 'Global Tenant Improvement Target', Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('${metrics["securityScore"]["current"]}%', style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF39FF14), fontFamily: 'monospace')),
          const Text('COMPLIANCE MATCHED', style: TextStyle(fontSize: 9, color: Color(0xFF9CA3AF), fontFamily: 'monospace'), overflow: TextOverflow.ellipsis),
        ],
      )),
    ];
  }

  List<Widget> _buildEntraCards(Map<String, dynamic> metrics) {
    return [
      _buildCyberCard('SYS_CAT_01 // IDENTITY RISK', 'Conditional Access Access Logs Vector', Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(metrics["entraId"]["riskyUsers"].toString(), style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF39FF14), fontFamily: 'monospace')),
          const Text('ZERO SEC VECTORS LOGGED', style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Color(0xFF39FF14), fontFamily: 'monospace'), overflow: TextOverflow.ellipsis),
        ],
      )),
      _buildCyberCard('SYS_CAT_02 // APP REGISTRY', 'OAuth Ingestion Application Binding Tunnels', Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(metrics["entraId"]["appRegistrations"].toString(), style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Color(0xFF00F0FF), fontFamily: 'monospace')),
          const Text('GRAPH AUTHENTICATION ACTIVE', style: TextStyle(fontSize: 9, color: Color(0xFF9CA3AF), fontFamily: 'monospace'), overflow: TextOverflow.ellipsis),
        ],
      )),
      _buildCyberCard('SYS_CAT_03 // CONNECT MATRIX', 'Delta Sync Synchronization Engine Pipeline', Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.cloud_sync_rounded, size: 28, color: Color(0xFF0078D4)),
          const SizedBox(height: 4),
          Text('SYNC TOPOLOGY: NOMINAL', style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Color(0xFF00F0FF)), overflow: TextOverflow.ellipsis),
        ],
      )),
    ];
  }

  List<Widget> _buildIntuneCards(Map<String, dynamic> metrics) {
    return [
      _buildCyberCard('SYS_CAT_01 // MDM COMPLIANCE', 'Device Configuration Baselines Profiles', Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('COMPLIANT: ${metrics["intune"]["compliantDevices"]}', style: const TextStyle(color: Color(0xFF39FF14), fontWeight: FontWeight.bold, fontSize: 11, fontFamily: 'monospace')),
              const Spacer(),
              Text('ALERT: ${metrics["intune"]["nonCompliant"]}', style: const TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold, fontSize: 11, fontFamily: 'monospace')),
            ],
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(value: metrics["intune"]["compliantDevices"] / metrics["intune"]["totalDevices"], color: const Color(0xFF39FF14), backgroundColor: const Color(0xFF1F2937)),
        ],
      )),
      _buildCyberCard('SYS_CAT_02 // SYSTEM PLATFORMS', 'Managed Hardware Distribution Spread', Row(
        children: [
          Expanded(child: _buildCyberMetricBlock(metrics["intune"]["windows"].toString(), 'WIN11')),
          Expanded(child: _buildCyberMetricBlock(metrics["intune"]["iOS"].toString(), 'APPLE_IOS')),
          Expanded(child: _buildCyberMetricBlock(metrics["intune"]["android"].toString(), 'ANDROID_ENT')),
        ],
      )),
    ];
  }

  List<Widget> _buildVeeamCards(Map<String, dynamic> metrics) {
    return [
      _buildCyberCard('SYS_CAT_01 // DATA INSURANCE', 'Veeam Scale-Out Storage Configurations', Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('${metrics["veeam"]["successRate"]}%', style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF39FF14), fontFamily: 'monospace')),
          const Text('IMMUTABLE CHANNELS VALID', style: TextStyle(fontSize: 9, color: Color(0xFF9CA3AF), fontFamily: 'monospace'), overflow: TextOverflow.ellipsis),
        ],
      )),
      _buildCyberCard('SYS_CAT_02 // REPO POOLS', 'Scale-Out Backup Storage Volumes Capacity', Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('${metrics["veeam"]["sobrCapacity"]}% Volume Array Capacity', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white), overflow: TextOverflow.ellipsis),
          const SizedBox(height: 8),
          LinearProgressIndicator(value: metrics["veeam"]["sobrCapacity"] / 100, color: const Color(0xFF39FF14), backgroundColor: const Color(0xFF1F2937)),
        ],
      )),
    ];
  }

  List<Widget> _buildAzureCards(Map<String, dynamic> metrics) {
    return [
      _buildCyberCard('SYS_CAT_01 // COMPUTE MATRIX', 'Active Hyper-V Server Cluster Mapping', Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('${metrics["azure"]["activeVMs"]} HOSTS ONLINE', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF00F0FF), fontFamily: 'monospace')),
          const Text('SNAPSHOT TUNNELS CONNECTED', style: TextStyle(fontSize: 9, color: Color(0xFF9CA3AF), fontFamily: 'monospace'), overflow: TextOverflow.ellipsis),
        ],
      )),
      _buildCyberCard('SYS_CAT_02 // RUNTIME BILLING', 'Azure Resource Group Account Burn Optimization', Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(metrics["azure"]["monthlyBurn"], style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white, fontFamily: 'monospace')),
          ),
          const Text('METERED INFRASTRUCTURE RES', style: TextStyle(fontSize: 9, color: Color(0xFF4B5563)), overflow: TextOverflow.ellipsis),
        ],
      )),
    ];
  }

  Widget _buildCyberCard(String headerCode, String description, Widget internalNode) {
    return InkWell(
      onTap: () => _playTerminalChime(), 
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF111827).withOpacity(0.9), 
          borderRadius: BorderRadius.circular(2),
          border: Border.all(color: const Color(0xFF1F2937), width: 1),
        ),
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(child: Text(headerCode, style: const TextStyle(fontFamily: 'monospace', fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF00F0FF)), overflow: TextOverflow.ellipsis)),
                const Text('[ONLINE]', style: TextStyle(fontFamily: 'monospace', fontSize: 8, color: Color(0xFF9CA3AF))),
              ],
            ),
            Text(description, style: const TextStyle(fontSize: 9, color: Color(0xFF9CA3AF)), overflow: TextOverflow.ellipsis),
            const Divider(height: 12, color: Color(0xFF1F2937)),
            Expanded(child: internalNode),
          ],
        ),
      ),
    );
  }

  Widget _buildConsoleRailButton(BuildContext context, String consoleId, IconData systemIcon, Color accentGlow, bool isTablet) {
    final provider = Provider.of<DashboardProvider>(context);
    bool isActive = provider.activeConsole == consoleId;

    return Tooltip(
      message: '/$consoleId',
      preferBelow: false,
      child: InkWell(
        onTap: () {
          _playTerminalChime(); 
          provider.changeConsole(consoleId);
        },
        child: Container(
          width: isTablet ? 56 : 48,
          height: isTablet ? 48 : 44,
          decoration: BoxDecoration(
            border: isActive ? Border(left: BorderSide(color: accentGlow, width: 2)) : null,
            color: isActive ? const Color(0xFF111827) : Colors.transparent,
          ),
          child: Icon(systemIcon, color: isActive ? accentGlow : const Color(0xFF9CA3AF), size: isTablet ? 16 : 14),
        ),
      ),
    );
  }

  Widget _buildPulseStatusIndicator() {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.3, end: 1.0),
      duration: const Duration(seconds: 1),
      builder: (context, value, child) {
        return Opacity(
          opacity: 1.3 - value,
          child: Transform.scale(
            scale: value,
            child: Container(
              width: 6,
              height: 6,
              decoration: const BoxDecoration(color: Color(0xFF39FF14), shape: BoxShape.circle),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCyberMetricBlock(String telemetryVal, String telemetryLbl) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(telemetryVal, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF39FF14), fontFamily: 'monospace')),
        Text(telemetryLbl, style: const TextStyle(fontSize: 9, color: Color(0xFF9CA3AF), fontFamily: 'monospace')),
      ],
    );
  }
}

// =========================================================================
// HARDWARE ACCELERATED MATRIX DIGITAL RAIN ENGINE
// =========================================================================
class MatrixRainCanvas extends StatefulWidget {
  const MatrixRainCanvas({super.key});

  @override
  State<MatrixRainCanvas> createState() => _MatrixRainCanvasState();
}

class _MatrixRainCanvasState extends State<MatrixRainCanvas> {
  late Timer _timer;
  List<double> _drops = [];
  final double _fontSize = 14.0;
  final String _chars = "010101XYZABCDEFGHIJKLMNOPQRSTUVW0123456789%&#@+=-<>";
  final math.Random _random = math.Random();

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(milliseconds: 45), (timer) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    int columnCount = (size.width / _fontSize).floor();

    if (_drops.length != columnCount) {
      _drops = List<double>.generate(columnCount, (_) => _random.nextDouble() * -size.height / _fontSize);
    }

    return CustomPaint(
      painter: MatrixRainPainter(
        drops: _drops,
        fontSize: _fontSize,
        chars: _chars,
        random: _random,
      ),
    );
  }
}

class MatrixRainPainter extends CustomPainter {
  final List<double> drops;
  final double fontSize;
  final String chars;
  final math.Random random;

  MatrixRainPainter({
    required this.drops,
    required this.fontSize,
    required this.chars,
    required this.random,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final backgroundPaint = Paint()..color = const Color(0xFF090D16).withOpacity(0.08);
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), backgroundPaint);

    for (int i = 0; i < drops.length; i++) {
      String char = chars[random.nextInt(chars.length)];
      double x = i * fontSize;
      double y = drops[i] * fontSize;

      if (y > 0 && y < size.height) {
        final textPainter = TextPainter(
          text: TextSpan(
            text: char,
            style: TextStyle(
              color: random.nextDouble() > 0.96 ? Colors.white : const Color(0xFF39FF14).withOpacity(0.24), 
              fontFamily: 'monospace',
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
            ),
          ),
          textDirection: TextDirection.ltr,
        )..layout();

        textPainter.paint(canvas, Offset(x, y));
      }

      if (y > size.height && random.nextDouble() > 0.975) {
        drops[i] = 0;
      } else {
        drops[i] += 0.65; 
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class CyberScanlinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black.withOpacity(0.12)
      ..strokeWidth = 1.0;

    for (double y = 0; y < size.height; y += 4) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}