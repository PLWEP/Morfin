import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import 'components/lobby_app_bar.dart';
import 'components/lobby_bottom_nav.dart';
import 'components/lobby_greeting_header.dart';
import 'components/lobby_kpi_grid.dart';
import 'components/lobby_operational_stream.dart';
import 'components/lobby_tactical_actions.dart';
import 'lobby_contract.dart';
import 'lobby_view_model.dart';

class LobbyScreen extends StatefulWidget {
  const LobbyScreen({super.key});

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
          appBar: LobbyAppBar(
            connectionNode: state.connectionNode,
            unreadAlertCount: state.unreadAlertCount,
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const LobbyGreetingHeader(),
                const SizedBox(height: 16),
                LobbyKpiGrid(kpis: state.kpis),
                const SizedBox(height: 20),
                LobbyTacticalActions(
                  onActionTriggered: (actionId) {
                    _viewModel.dispatch(LobbyTriggerTacticalAction(actionId));
                  },
                ),
                const SizedBox(height: 20),
                LobbyOperationalStream(feeds: state.feeds),
                const SizedBox(height: 24),
              ],
            ),
          ),
          bottomNavigationBar: LobbyBottomNav(
            selectedIndex: state.selectedNavIndex,
            onDestinationSelected: (index) {
              _viewModel.dispatch(LobbySelectNavAction(index));
            },
          ),
        );
      },
    );
  }
}
