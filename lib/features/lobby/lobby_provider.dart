import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'lobby_analytical_mock_data.dart';
import 'lobby_contract.dart';

class LobbyNotifier extends Notifier<LobbyState> {
  @override
  LobbyState build() => LobbyAnalyticalMockData.stateForPeriod(DashboardPeriod.today);

  void changePeriod(DashboardPeriod period) {
    state = LobbyAnalyticalMockData.stateForPeriod(period);
  }
}

final lobbyProvider = NotifierProvider<LobbyNotifier, LobbyState>(
  LobbyNotifier.new,
);
