import 'package:flutter/material.dart';
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

// =========================================================================
// 🛡️ THE NEW FIX: COMPILER-SAFE CONTAINERS TO ELIMINATE ASSERTION CRASHES
// =========================================================================
class SafeContainer extends StatelessWidget {
  final EdgeInsetsGeometry? padding;
  final Widget? child;
  final double? width;
  final double? height;
  final Color? color;
  final BoxDecoration? decoration;

  const SafeContainer({
    super.key,
    this.padding,
    this.child,
    this.width,
    this.height,
    this.color,
    this.decoration,
  });

  @override
  Widget build(BuildContext context) {
    // If a decoration exists, we safely absorb the top-level color into it
    BoxDecoration? finalDecoration = decoration;
    if (color != null) {
      finalDecoration = (decoration ?? const BoxDecoration()).copyWith(color: color);
    }

    return Container(
      width: width,
      height: height,
      padding: padding,
      decoration: finalDecoration,
      child: child,
    );
  }
}

class SafeAnimatedContainer extends StatelessWidget {
  final EdgeInsetsGeometry? padding;
  final Widget? child;
  final double? width;
  final double? height;
  final Color? color;
  final BoxDecoration? decoration;
  final Duration duration;

  const SafeAnimatedContainer({
    super.key,
    this.padding,
    this.child,
    this.width,
    this.height,
    this.color,
    this.decoration,
    required this.duration,
  });

  @override
  Widget build(BuildContext context) {
    BoxDecoration? finalDecoration = decoration;
    if (color != null) {
      finalDecoration = (decoration ?? const BoxDecoration()).copyWith(color: color);
    }

    return AnimatedContainer(
      duration: duration,
      width: width,
      height: height,
      padding: padding,
      decoration: finalDecoration,
      child: child,
    );
  }
}

// =========================================================================
// MAIN APPLICATION LAYOUT
// =========================================================================
class M365AdminCenterApp extends StatelessWidget {
  const M365AdminCenterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CloudNex Enterprise Management Ecosystem',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF3F2F1),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF0078D4),
          background: const Color(0xFFF3F2F1),
        ),
        fontFamily: 'Segoe UI',
      ),
      home: const AdminCenterShell(),
    );
  }
}

class AdminCenterShell extends StatefulWidget {
  const AdminCenterShell({super.key});

  @override
  State<AdminCenterShell> createState() => _AdminCenterShellState();
}

class _AdminCenterShellState extends State<AdminCenterShell> with SingleTickerProviderStateMixin {
  late AnimationController _backgroundController;

  @override
  void initState() {
    super.initState();
    _backgroundController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _backgroundController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<DashboardProvider>(context);
    final metrics = provider.tenantMetrics;

    if (metrics.isEmpty) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator(color: Color(0xFF0078D4), strokeWidth: 3)),
      );
    }

    bool isDesktop = MediaQuery.of(context).size.width > 850;

    Color consoleAccent;
    Color topBarColor;
    String consoleTitle;

    switch (provider.activeConsole) {
      case 'Entra':
        consoleAccent = const Color(0xFF0078D4);
        topBarColor = const Color(0xFF11171F);
        consoleTitle = 'Microsoft Entra admin center';
        break;
      case 'Intune':
        consoleAccent = const Color(0xFF0078D4);
        topBarColor = const Color(0xFF242424);
        consoleTitle = 'Microsoft Intune admin center';
        break;
      case 'Veeam':
        consoleAccent = const Color(0xFF00B159);
        topBarColor = const Color(0xFF1A1A1A);
        consoleTitle = 'Veeam Availability Console';
        break;
      case 'Azure':
        consoleAccent = const Color(0xFF008AD7);
        topBarColor = const Color(0xFF004578);
        consoleTitle = 'Microsoft Azure Portal';
        break;
      default:
        consoleAccent = const Color(0xFF0078D4);
        topBarColor = const Color(0xFF004578);
        consoleTitle = 'Microsoft 365 admin center';
    }

    return Scaffold(
      body: Stack(
        children: [
          AnimatedBuilder(
            animation: _backgroundController,
            builder: (context, child) {
              return Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      const Color(0xFFF3F2F1),
                      Color.lerp(const Color(0xFFF3F2F1), const Color(0xFFE1DFDD), _backgroundController.value)!,
                      Color.lerp(const Color(0xFFEFF6FC), const Color(0xFFDEECF9), _backgroundController.value)!,
                    ],
                  ),
                ),
              );
            },
          ),
          Opacity(
            opacity: 0.02,
            child: GridPaper(
              color: Colors.black,
              interval: 32,
              subdivisions: 1,
              child: Container(),
            ),
          ),
          Column(
            children: [
              SafeAnimatedContainer(
                duration: const Duration(milliseconds: 300),
                height: 48,
                color: topBarColor,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    const Icon(Icons.apps, color: Colors.white, size: 20),
                    const SizedBox(width: 16),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 250),
                      child: Text(
                        consoleTitle,
                        key: ValueKey(consoleTitle),
                        style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600, letterSpacing: -0.1),
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: provider.isLoading
                          ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                          : const Icon(Icons.refresh, color: Colors.white, size: 18),
                      onPressed: () => provider.refreshDashboard(),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  children: [
                    SafeContainer(
                      width: 56,
                      color: Colors.white,
                      decoration: const BoxDecoration(
                        border: Border(right: BorderSide(color: Color(0xFFEDEBE9), width: 1)),
                      ),
                      child: Column(
                        children: [
                          const SizedBox(height: 12),
                          _buildConsoleRailButton(context, 'M365', Icons.dashboard_customize_outlined, 'M365 Admin Center', consoleAccent),
                          _buildConsoleRailButton(context, 'Entra', Icons.badge_outlined, 'Entra ID Management', consoleAccent),
                          _buildConsoleRailButton(context, 'Intune', Icons.phonelink_setup_outlined, 'Intune Device Node', consoleAccent),
                          _buildConsoleRailButton(context, 'Veeam', Icons.shield_outlined, 'Veeam Backup Core', consoleAccent),
                          _buildConsoleRailButton(context, 'Azure', Icons.cloud_done_outlined, 'Azure Infrastructure', consoleAccent),
                        ],
                      ),
                    ),
                    Expanded(
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 400),
                        switchInCurve: Curves.easeInOutCubic,
                        switchOutCurve: Curves.easeInOutCubic,
                        transitionBuilder: (Widget child, Animation<double> animation) {
                          return FadeTransition(
                            opacity: animation,
                            child: SlideTransition(
                              position: Tween<Offset>(
                                begin: const Offset(0.01, 0.0),
                                end: Offset.zero,
                              ).animate(animation),
                              child: child,
                            ),
                          );
                        },
                        child: KeyedSubtree(
                          key: ValueKey<String>(provider.activeConsole),
                          child: _buildConsoleWorkspace(provider.activeConsole, metrics, provider, isDesktop),
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
    );
  }

  Widget _buildConsoleWorkspace(String console, Map<String, dynamic> metrics, DashboardProvider provider, bool isDesktop) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
      children: [
        Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  metrics["tenantName"] ?? 'CloudNex Solutions',
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF323130), letterSpacing: -0.5),
                ),
                Text(
                  'Directory Scope ID: ${metrics["tenantId"]}',
                  style: const TextStyle(fontSize: 11, color: Color(0xFF797775)),
                ),
              ],
            ),
            const Spacer(),
            _buildPulseStatusIndicator(),
          ],
        ),
        const SizedBox(height: 24),
        if (console == 'M365') ...[
          _buildM365Workspace(metrics, isDesktop),
        ] else if (console == 'Entra') ...[
          _buildEntraWorkspace(metrics, isDesktop),
        ] else if (console == 'Intune') ...[
          _buildIntuneWorkspace(metrics, isDesktop),
        ] else if (console == 'Veeam') ...[
          _buildVeeamWorkspace(metrics, isDesktop),
        ] else if (console == 'Azure') ...[
          _buildAzureWorkspace(metrics, isDesktop),
        ],
        const SizedBox(height: 32),
        const Text(
          'Tenant Infrastructure Live Audit Stream',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF323130)),
        ),
        const SizedBox(height: 12),
        SafeContainer(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(2),
            border: Border.all(color: const Color(0xFFEDEBE9)),
          ),
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: provider.infrastructureLogs.length,
            separatorBuilder: (context, index) => const Divider(height: 1, color: Color(0xFFEDEBE9)),
            itemBuilder: (context, index) {
              final log = provider.infrastructureLogs[index];
              return ListTile(
                dense: true,
                leading: const Icon(Icons.security_update_good_outlined, color: Color(0xFF0078D4), size: 16),
                title: Text(log["event"], style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12, color: Color(0xFF323130))),
                subtitle: Text(log["details"], style: const TextStyle(fontSize: 11, color: Color(0xFF605E5C))),
                trailing: Text(log["timestamp"], style: const TextStyle(fontSize: 10, color: Color(0xFFA19F9D))),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildM365Workspace(Map<String, dynamic> metrics, bool isDesktop) {
    return GridView.count(
      crossAxisCount: isDesktop ? 3 : 1,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 1.4,
      children: [
        _buildHighDensityCard('Hybrid Compute & Storage Pools', 'Local Datacenter Cluster Optimization', Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('${metrics["serverSpace"]["usedTB"]} / ${metrics["serverSpace"]["totalTB"]} TB Allocated', style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                const Text('Healthy Status', style: TextStyle(color: Color(0xFF107C41), fontSize: 11, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(value: metrics["serverSpace"]["usedTB"] / metrics["serverSpace"]["totalTB"], color: const Color(0xFF0078D4), backgroundColor: const Color(0xFFEDEBE9)),
          ],
        )),
        _buildHighDensityCard('Identity Cloud Topology', 'Entra ID Domain Federation Engine', Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildMetricBlock(metrics["entraId"]["users"].toString(), 'Active Directory Objects'),
            _buildMetricBlock(metrics["entraId"]["groups"].toString(), 'Federated Groups'),
          ],
        )),
        _buildHighDensityCard('Global Tenant Defense Summary', 'Microsoft Secure Score Metrics', Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('${metrics["securityScore"]["current"]}%', style: const TextStyle(fontSize: 34, fontWeight: FontWeight.bold, color: Color(0xFF107C41))),
            const Text('Security Profile Optimization Active', style: TextStyle(fontSize: 11, color: Color(0xFF605E5C))),
          ],
        )),
      ],
    );
  }

  Widget _buildEntraWorkspace(Map<String, dynamic> metrics, bool isDesktop) {
    return GridView.count(
      crossAxisCount: isDesktop ? 3 : 1,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 1.4,
      children: [
        _buildHighDensityCard('Identity Risk & Attack Surface', 'Conditional Access Real-Time Mitigations', Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(metrics["entraId"]["riskyUsers"].toString(), style: const TextStyle(fontSize: 38, fontWeight: FontWeight.bold, color: Color(0xFF107C41))),
            const Text('Zero Flagged Identity Threats Active', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF107C41))),
          ],
        ), borderHighlight: const Color(0xFF0078D4)),
        _buildHighDensityCard('Application Security Registry', 'Enterprise OAuth App Registrations Tokens', Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(metrics["entraId"]["appRegistrations"].toString(), style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Color(0xFF0078D4))),
            const Text('All Graph API Client Tokens Valid', style: TextStyle(fontSize: 11, color: Color(0xFF605E5C))),
          ],
        ), borderHighlight: const Color(0xFF0078D4)),
        _buildHighDensityCard('Directory Replication Pipelines', 'Microsoft Entra Connect Sync Engine', const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.cloud_sync_rounded, size: 36, color: Color(0xFF0078D4)),
            SizedBox(height: 4),
            Text('Delta Sync Cycle Completed: In Sync', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
          ],
        ), borderHighlight: const Color(0xFF0078D4)),
      ],
    );
  }

  Widget _buildIntuneWorkspace(Map<String, dynamic> metrics, bool isDesktop) {
    return GridView.count(
      crossAxisCount: isDesktop ? 3 : 1,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 1.4,
      children: [
        _buildHighDensityCard('MDM Profile Compliance', 'Corporate Device Policy Matrices', Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Compliant: ${metrics["intune"]["compliantDevices"]}', style: const TextStyle(color: Color(0xFF107C41), fontWeight: FontWeight.bold, fontSize: 12)),
                Text('Halt/Alert: ${metrics["intune"]["nonCompliant"]}', style: const TextStyle(color: Color(0xFFA80000), fontWeight: FontWeight.bold, fontSize: 12)),
              ],
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: metrics["intune"]["compliantDevices"] / metrics["intune"]["totalDevices"],
                color: const Color(0xFF107C41),
                backgroundColor: const Color(0xFFA80000),
                minHeight: 6,
              ),
            )
          ],
        )),
        _buildHighDensityCard('Managed Endpoint OS Spread', 'Platform OS Distribution Registry', Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildMetricBlock(metrics["intune"]["windows"].toString(), 'Windows 11'),
            _buildMetricBlock(metrics["intune"]["iOS"].toString(), 'Apple iOS'),
            _buildMetricBlock(metrics["intune"]["android"].toString(), 'Android Ent'),
          ],
        )),
      ],
    );
  }

  Widget _buildVeeamWorkspace(Map<String, dynamic> metrics, bool isDesktop) {
    return GridView.count(
      crossAxisCount: isDesktop ? 3 : 1,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 1.4,
      children: [
        _buildHighDensityCard('Immutable Replication Security', 'Veeam Backup Cluster Integrity Status', Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('${metrics["veeam"]["successRate"]}%', style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Color(0xFF00B159))),
            const Text('Synthetic Full Backups Verified (24h Window)', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500)),
          ],
        ), borderHighlight: const Color(0xFF00B159)),
        _buildHighDensityCard('Scale-Out Storage Repositories', 'Veeam SOBR Arrays Capacity Pools', Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${metrics["veeam"]["sobrCapacity"]}% Volume Capacity Pool Used', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            LinearProgressIndicator(value: metrics["veeam"]["sobrCapacity"] / 100, color: const Color(0xFF00B159), backgroundColor: const Color(0xFFEDEBE9)),
          ],
        ), borderHighlight: const Color(0xFF00B159)),
      ],
    );
  }

  Widget _buildAzureWorkspace(Map<String, dynamic> metrics, bool isDesktop) {
    return GridView.count(
      crossAxisCount: isDesktop ? 3 : 1,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 1.4,
      children: [
        _buildHighDensityCard('Virtual Infrastructure Cluster', 'Azure Compute Engine Resource Groups', Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('${metrics["azure"]["activeVMs"]} Active Running Hosts', style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Color(0xFF008AD7))),
            const Text('All Hyper-V Virtual Machines Reporting Nominal', style: TextStyle(fontSize: 11, color: Color(0xFF605E5C))),
          ],
        ), borderHighlight: const Color(0xFF008AD7)),
        _buildHighDensityCard('Cloud Tenant Consumption Ledger', 'Azure Cost Management Burn Optimization', Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(metrics["azure"]["monthlyBurn"], style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF323130))),
            const Text('Metered Resource Group Allocation Profile', style: TextStyle(fontSize: 11, color: Color(0xFF797775))),
          ],
        ), borderHighlight: const Color(0xFF008AD7)),
      ],
    );
  }

  Widget _buildHighDensityCard(String title, String subtitle, Widget child, {Color? borderHighlight}) {
    return StatefulBuilder(
      builder: (context, setState) {
        bool isHovered = false;
        return MouseRegion(
          onEnter: (_) => setState(() => isHovered = true),
          onExit: (_) => setState(() => isHovered = false),
          child: SafeAnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(2),
              border: Border.all(
                color: isHovered ? (borderHighlight ?? const Color(0xFF0078D4)) : const Color(0xFFE0E0E0), 
                width: isHovered ? 1.5 : 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(isHovered ? 0.05 : 0.01),
                  blurRadius: isHovered ? 4 : 1,
                  offset: Offset(0, isHovered ? 2 : 0),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF323130))),
                Text(subtitle, style: const TextStyle(fontSize: 10, color: Color(0xFF797775))),
                const Divider(height: 12, color: Color(0xFFF3F2F1)),
                Expanded(child: child),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildConsoleRailButton(BuildContext context, String consoleId, IconData icon, String label, Color highlightColor) {
    final provider = Provider.of<DashboardProvider>(context);
    bool isActive = provider.activeConsole == consoleId;

    return Tooltip(
      message: label,
      preferBelow: false,
      child: InkWell(
        onTap: () => provider.changeConsole(consoleId),
        child: SafeAnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 56,
          height: 48,
          decoration: BoxDecoration(
            border: isActive ? Border(left: BorderSide(color: highlightColor, width: 3)) : null,
            color: isActive ? const Color(0xFFEFF6FC) : Colors.transparent,
          ),
          child: Icon(icon, color: isActive ? highlightColor : const Color(0xFF605E5C), size: 18),
        ),
      ),
    );
  }

  Widget _buildPulseStatusIndicator() {
    return StatefulBuilder(
      builder: (context, setState) {
        return TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.3, end: 1.0),
          duration: const Duration(seconds: 1),
          builder: (context, value, child) {
            return Opacity(
              opacity: 1.3 - value,
              child: Transform.scale(
                scale: value,
                child: SafeContainer(
                  width: 7,
                  height: 7,
                  decoration: const BoxDecoration(color: Color(0xFF107C41), shape: BoxShape.circle),
                ),
              ),
            );
          },
          onEnd: () => setState(() {}),
        );
      },
    );
  }

  Widget _buildMetricBlock(String value, String label) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF0078D4))),
        const SizedBox(height: 1),
        Text(label, style: const TextStyle(fontSize: 10, color: Color(0xFF605E5C))),
      ],
    );
  }
}