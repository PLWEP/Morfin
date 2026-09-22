import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_colors.dart';
import '../widgets/sparkline_painter.dart';

class LobbyScreen extends StatefulWidget {
  const LobbyScreen({super.key});

  @override
  State<LobbyScreen> createState() => _LobbyScreenState();
}

class _LobbyScreenState extends State<LobbyScreen> {
  int _selectedNavIndex = 0;
  AppPalette get colors => AppColors.of(context);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colors.surfaceDeep,
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildGreetingHeader(),
            const SizedBox(height: 16),
            _buildKpiMetricGrid(),
            const SizedBox(height: 20),
            _buildTacticalActionsSlider(),
            const SizedBox(height: 20),
            _buildPriorityOperationalStream(),
            const SizedBox(height: 24),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: colors.surfaceDeep.withValues(alpha: 0.95),
      scrolledUnderElevation: 0,
      elevation: 0,
      toolbarHeight: 64,
      automaticallyImplyLeading: false,
      titleSpacing: 16,
      title: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: colors.surfaceCard,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: colors.surfaceBorder),
            ),
            child: Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: Image.network(
                  'https://lh3.googleusercontent.com/aida/AEtjO1XE5IqVYas3jIWiElWM7qe6FsSCZV0quXLVZleMrKIMfp7o4ZoKRFpfUxwqXMy90nY7BJvpt3ISnv93YVBV7IzUrUoPWNjYA1nLg3rla7ClDWV7Ocoul7IYxKfRN66_Pfpcm0NsAr3ahe1FG_H1VtiNYen3palwP4YfI0d5h8LYyPZWBUIhGeU1evCsl5mBVraUyZfOafgMlhh-8QZsLzcYBW6GcqTmUpjskomVfOPP1Lp_SLJZsVat8oTs',
                  width: 22,
                  height: 22,
                  fit: BoxFit.contain,
                  errorBuilder: (ctx, err, stack) => Icon(
                    Icons.hub_rounded,
                    size: 18,
                    color: colors.statusActive,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  Text(
                    'IFS CLOUD',
                    style: GoogleFonts.jetBrainsMono(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: colors.statusActive,
                      letterSpacing: 0.6,
                    ),
                  ),
                  Text(
                    ' / ',
                    style: GoogleFonts.jetBrainsMono(
                      fontSize: 11,
                      color: colors.onSurfaceVariant,
                    ),
                  ),
                  Text(
                    'Lobby',
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: colors.onSurface,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 2),
              Row(
                children: [
                  Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: colors.statusSuccess,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'US-EAST-01 • 24ms',
                    style: GoogleFonts.jetBrainsMono(
                      fontSize: 10,
                      color: colors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
      actions: [
        // Notification bell with unread badge
        Stack(
          alignment: Alignment.center,
          children: [
            IconButton(
              icon: Icon(Icons.notifications_none_rounded, color: colors.onSurfaceVariant, size: 22),
              onPressed: () {},
            ),
            Positioned(
              top: 14,
              right: 14,
              child: Container(
                width: 7,
                height: 7,
                decoration: BoxDecoration(
                  color: colors.statusActive,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: colors.statusActive,
                      blurRadius: 4,
                      spreadRadius: 1,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        // User Profile Avatar
        Padding(
          padding: const EdgeInsets.only(right: 16, left: 4),
          child: Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: colors.statusActive.withValues(alpha: 0.5),
                width: 1.5,
              ),
            ),
            child: ClipOval(
              child: Image.network(
                'https://lh3.googleusercontent.com/aida/AEtjO1VDYEQItSmUU2UWMZdC0owoXvE2iF4WvVU8NnGHAtEAUOp2lgzWlgW1aBP7HCTiVPSbWvIQG8dy6AQsTY2IDMFzLflU89SWvIN_fBcQPNruFCAfkmsJ33ijpfm2Pkd8ucUE-4DBRK6kAhDLN98plzlySbysVq5nVm-ojWzjuYVMx9gPWrMKI7b8ALW9ucFwxghkV3i58J0XH_nf7g_WZJs8AhMBBSM8Y15LqRl2Zs-3hdmHaY1ftuKdnLt0',
                fit: BoxFit.cover,
                errorBuilder: (ctx, err, stack) => Icon(
                  Icons.person_rounded,
                  size: 20,
                  color: colors.statusActive,
                ),
              ),
            ),
          ),
        ),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(
          color: colors.surfaceBorder.withValues(alpha: 0.8),
          height: 1,
        ),
      ),
    );
  }

  Widget _buildGreetingHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.surfaceCard,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: colors.surfaceBorder, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.35),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -20,
            top: -20,
            child: Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: colors.statusActive.withValues(alpha: 0.08),
              ),
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: colors.statusActive.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: colors.statusActive.withValues(alpha: 0.3),
                            ),
                          ),
                          child: Text(
                            'SHIFT A • PLANT ALPHA 01',
                            style: GoogleFonts.jetBrainsMono(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: colors.statusActive,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Today, 24 Oct',
                          style: GoogleFonts.jetBrainsMono(
                            fontSize: 11,
                            color: colors.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Good Morning, Commander Diana',
                      style: GoogleFonts.spaceGrotesk(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: colors.onSurface,
                        letterSpacing: -0.2,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.shield_outlined,
                          size: 14,
                          color: colors.statusActive,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Operations Director • Industrial Sector 4',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: colors.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: colors.surfaceContainer,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: colors.surfaceBorder),
                ),
                child: Icon(
                  Icons.terminal_rounded,
                  size: 20,
                  color: colors.statusActive,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildKpiMetricGrid() {
    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: 1.35,
      children: [
        // 1. Pending Approvals
        _buildKpiCard(
          title: 'APPROVALS',
          badgeText: null,
          badgeDotColor: colors.statusWarning,
          mainValue: '7',
          mainUnit: 'Orders',
          subValue: '\$142.5K Pending',
          subColor: colors.statusWarning,
          bottomIcon: Icons.schedule_rounded,
          bottomText: 'Action required',
        ),

        // 2. Active Work Orders
        _buildKpiCard(
          title: 'WORK ORDERS',
          badgeText: '4 CRIT',
          badgeColor: colors.statusActive,
          mainValue: '24',
          mainUnit: 'Active',
          subValue: 'Field Teams Engaged',
          subColor: colors.statusActive,
          bottomIcon: Icons.crisis_alert_rounded,
          bottomText: '3 awaiting sign-off',
        ),

        // 3. Plant OEE (with vector sparkline)
        _buildOeeKpiCard(),

        // 4. Stock Alerts
        _buildKpiCard(
          title: 'STOCK ALERTS',
          badgeText: 'Depleted',
          badgeColor: colors.statusCritical,
          mainValue: '3',
          mainUnit: 'Low Stock',
          subValue: 'Spares Warehouse',
          subColor: colors.statusCritical,
          bottomIcon: Icons.warning_amber_rounded,
          bottomText: 'Auto-PO drafted',
        ),
      ],
    );
  }

  Widget _buildKpiCard({
    required String title,
    String? badgeText,
    Color? badgeColor,
    Color? badgeDotColor,
    required String mainValue,
    required String mainUnit,
    required String subValue,
    required Color subColor,
    required IconData bottomIcon,
    required String bottomText,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colors.surfaceCard,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: colors.surfaceBorder, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: GoogleFonts.jetBrainsMono(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: colors.onSurfaceVariant,
                  letterSpacing: 0.5,
                ),
              ),
              if (badgeText != null && badgeColor != null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                  decoration: BoxDecoration(
                    color: badgeColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    badgeText,
                    style: GoogleFonts.jetBrainsMono(
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                      color: badgeColor,
                    ),
                  ),
                )
              else if (badgeDotColor != null)
                Container(
                  width: 7,
                  height: 7,
                  decoration: BoxDecoration(
                    color: badgeDotColor,
                    shape: BoxShape.circle,
                  ),
                ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                textBaseline: TextBaseline.alphabetic,
                crossAxisAlignment: CrossAxisAlignment.baseline,
                children: [
                  Text(
                    mainValue,
                    style: GoogleFonts.spaceGrotesk(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: colors.onSurface,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    mainUnit,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: colors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
              Text(
                subValue,
                style: GoogleFonts.jetBrainsMono(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: subColor,
                ),
              ),
            ],
          ),
          Row(
            children: [
              Icon(bottomIcon, size: 12, color: colors.onSurfaceVariant),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  bottomText,
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    color: colors.onSurfaceVariant,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOeeKpiCard() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colors.surfaceCard,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: colors.surfaceBorder, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'PLANT OEE',
                style: GoogleFonts.jetBrainsMono(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: colors.onSurfaceVariant,
                  letterSpacing: 0.5,
                ),
              ),
              Text(
                '+1.8%',
                style: GoogleFonts.jetBrainsMono(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: colors.statusSuccess,
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '94.2%',
                    style: GoogleFonts.spaceGrotesk(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: colors.onSurface,
                    ),
                  ),
                  Text(
                    'Target Exceeded',
                    style: GoogleFonts.jetBrainsMono(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: colors.statusSuccess,
                    ),
                  ),
                ],
              ),
              SizedBox(
                width: 48,
                height: 24,
                child: CustomPaint(
                  painter: SparklinePainter(
                    data: const [24, 20, 22, 14, 16, 4],
                    lineColor: colors.statusSuccess,
                    strokeWidth: 2,
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Icon(Icons.bolt_rounded, size: 12, color: colors.statusSuccess),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  'Optimal Telemetry',
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    color: colors.onSurfaceVariant,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTacticalActionsSlider() {
    final actions = [
      {'icon': Icons.qr_code_scanner_rounded, 'label': 'Scan QR Barcode', 'color': colors.statusActive},
      {'icon': Icons.add_task_rounded, 'label': 'Create Work Order', 'color': colors.statusActive},
      {'icon': Icons.task_alt_rounded, 'label': 'Quick PR Approval', 'color': colors.statusWarning},
      {'icon': Icons.report_problem_outlined, 'label': 'Report Incident', 'color': colors.statusCritical},
      {'icon': Icons.search_rounded, 'label': 'Asset Lookup', 'color': colors.primaryLight},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'TERMINAL DISPATCH',
              style: GoogleFonts.spaceGrotesk(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: colors.onSurface,
                letterSpacing: 0.5,
              ),
            ),
            Text(
              'Tactical Actions',
              style: GoogleFonts.jetBrainsMono(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: colors.statusActive,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 38,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: actions.length,
            separatorBuilder: (ctx, i) => const SizedBox(width: 8),
            itemBuilder: (ctx, i) {
              final act = actions[i];
              return InkWell(
                onTap: () {},
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: colors.surfaceCard,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: colors.surfaceBorder),
                  ),
                  child: Row(
                    children: [
                      Icon(act['icon'] as IconData, size: 16, color: act['color'] as Color),
                      const SizedBox(width: 6),
                      Text(
                        act['label'] as String,
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: colors.onSurface,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPriorityOperationalStream() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'PRIORITY OPERATIONAL STREAM',
              style: GoogleFonts.spaceGrotesk(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: colors.onSurface,
                letterSpacing: 0.5,
              ),
            ),
            Text(
              'LIVE // PRIO-1',
              style: GoogleFonts.jetBrainsMono(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: colors.onSurfaceVariant,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Feed Item 1: Critical WO
        _buildFeedCard(
          badgeTag: 'CRITICAL WO',
          badgeColor: colors.statusCritical,
          itemId: '#WO-8942',
          urgencyText: '18m remaining',
          urgencyColor: colors.statusWarning,
          urgencyIcon: Icons.timer_outlined,
          title: 'Turbine Coolant Pressure Loss',
          description: 'Sector 4 Generator B • Pressure dropped below 1.2 bar safety threshold.',
          footerMeta: 'Tech: Marc Chen • Assigned 24m ago',
          footerIcon: Icons.engineering_outlined,
        ),
        const SizedBox(height: 10),

        // Feed Item 2: Pending PO
        _buildFeedCard(
          badgeTag: 'PR APPROVAL',
          badgeColor: colors.statusWarning,
          itemId: '#PO-10499',
          urgencyText: '\$18,450.00',
          urgencyColor: colors.statusActive,
          urgencyIcon: Icons.payments_outlined,
          title: 'High-temp Ceramic Bearings',
          description: '12 Units • Vendor: SKF Precision Systems • Awaiting Director Clearance.',
          footerMeta: 'Requester: Sarah Jenkins (Maint Lead)',
          footerIcon: Icons.assignment_ind_outlined,
        ),
        const SizedBox(height: 10),

        // Feed Item 3: Machine Telemetry
        _buildFeedCard(
          badgeTag: 'TELEMETRY NOMINAL',
          badgeColor: colors.statusSuccess,
          itemId: '#NODE-204',
          urgencyText: '68.4°C • Stable',
          urgencyColor: colors.statusSuccess,
          urgencyIcon: Icons.thermostat_rounded,
          title: 'Continuous Rotary Compressor 03',
          description: 'Bearing vibration 0.42 mm/s • Airflow 420 CFM • Next inspection in 14 days.',
          footerMeta: 'SCADA Channel 8 • Live telemetry',
          footerIcon: Icons.sensors_rounded,
        ),
      ],
    );
  }

  Widget _buildFeedCard({
    required String badgeTag,
    required Color badgeColor,
    required String itemId,
    required String urgencyText,
    required Color urgencyColor,
    required IconData urgencyIcon,
    required String title,
    required String description,
    required String footerMeta,
    required IconData footerIcon,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colors.surfaceCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colors.surfaceBorder),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.25),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: badgeColor.withValues(alpha: 0.14),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      badgeTag,
                      style: GoogleFonts.jetBrainsMono(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: badgeColor,
                        letterSpacing: 0.4,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    itemId,
                    style: GoogleFonts.jetBrainsMono(
                      fontSize: 11,
                      color: colors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Icon(urgencyIcon, size: 13, color: urgencyColor),
                  const SizedBox(width: 4),
                  Text(
                    urgencyText,
                    style: GoogleFonts.jetBrainsMono(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: urgencyColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: GoogleFonts.spaceGrotesk(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: colors.onSurface,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            description,
            style: GoogleFonts.inter(
              fontSize: 12,
              color: colors.onSurfaceVariant,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.only(top: 8),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: colors.surfaceBorder.withValues(alpha: 0.6)),
              ),
            ),
            child: Row(
              children: [
                Icon(footerIcon, size: 14, color: colors.onSurfaceMuted),
                const SizedBox(width: 6),
                Text(
                  footerMeta,
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    color: colors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: BoxDecoration(
        color: colors.surfaceDeep,
        border: Border(
          top: BorderSide(color: colors.surfaceBorder, width: 1),
        ),
      ),
      child: NavigationBar(
        selectedIndex: _selectedNavIndex,
        onDestinationSelected: (idx) => setState(() => _selectedNavIndex = idx),
        backgroundColor: colors.surfaceDeep,
        indicatorColor: colors.primary.withValues(alpha: 0.2),
        height: 62,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        destinations: [
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined, color: colors.onSurfaceVariant, size: 22),
            selectedIcon: Icon(Icons.dashboard_rounded, color: colors.statusActive, size: 22),
            label: 'Lobby',
          ),
          NavigationDestination(
            icon: Icon(Icons.assignment_outlined, color: colors.onSurfaceVariant, size: 22),
            selectedIcon: Icon(Icons.assignment_rounded, color: colors.statusActive, size: 22),
            label: 'Work Orders',
          ),
          NavigationDestination(
            icon: Icon(Icons.precision_manufacturing_outlined, color: colors.onSurfaceVariant, size: 22),
            selectedIcon: Icon(Icons.precision_manufacturing_rounded, color: colors.statusActive, size: 22),
            label: 'Assets',
          ),
          NavigationDestination(
            icon: Icon(Icons.fact_check_outlined, color: colors.onSurfaceVariant, size: 22),
            selectedIcon: Icon(Icons.fact_check_rounded, color: colors.statusActive, size: 22),
            label: 'Approvals',
          ),
          NavigationDestination(
            icon: Icon(Icons.more_horiz_rounded, color: colors.onSurfaceVariant, size: 22),
            selectedIcon: Icon(Icons.more_horiz_rounded, color: colors.statusActive, size: 22),
            label: 'More',
          ),
        ],
      ),
    );
  }
}
