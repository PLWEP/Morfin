import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import 'components/lobby_bottom_nav.dart';
import 'components/lobby_dashboard_header.dart';
import 'components/lobby_kpi_drilldown_sheet.dart';
import 'components/lobby_kpi_metrics_grid.dart';
import 'components/lobby_line_drilldown_sheet.dart';
import 'components/lobby_line_performance_card.dart';
import 'components/lobby_oee_breakdown_card.dart';
import 'components/lobby_throughput_chart_card.dart';
import 'lobby_contract.dart';
import 'lobby_view_model.dart';

class LobbyScreen extends StatefulWidget {
  final bool showBottomNav;
  final VoidCallback? onAlertTap;

  const LobbyScreen({super.key, this.showBottomNav = false, this.onAlertTap});

  @override
  State<LobbyScreen> createState() => _LobbyScreenState();
}

class _LobbyScreenState extends State<LobbyScreen> {
  late final LobbyViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = LobbyViewModel();
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return ValueListenableBuilder<LobbyState>(
      valueListenable: _viewModel,
      builder: (context, state, _) {
        return Scaffold(
          backgroundColor: colors.surfaceDeep,
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  LobbyDashboardHeader(
                    selectedPeriod: state.period,
                    onPeriodChanged: (period) {
                      _viewModel.dispatch(LobbyChangePeriodAction(period));
                    },
                  ),
                  const SizedBox(height: 14),
                  LobbyKpiMetricsGrid(
                    kpis: state.kpis,
                    onKpiTap: (kpi) {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (_) => LobbyKpiDrilldownSheet(kpi: kpi),
                      );
                    },
                  ),
                  const SizedBox(height: 14),
                  LobbyThroughputChartCard(dataPoints: state.throughputChart),
                  const SizedBox(height: 14),
                  LobbyOeeBreakdownCard(factors: state.oeeFactors),
                  const SizedBox(height: 14),
                  LobbyLinePerformanceCard(
                    lines: state.linePerformances,
                    onLineTap: (line) {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (_) => LobbyLineDrilldownSheet(line: line),
                      );
                    },
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
          bottomNavigationBar: widget.showBottomNav
              ? LobbyBottomNav(
                  selectedIndex: 0,
                  onDestinationSelected: (index) {},
                )
              : null,
        );
      },
    );
  }
}
