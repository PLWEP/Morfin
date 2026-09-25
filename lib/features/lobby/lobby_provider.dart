import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'lobby_contract.dart';

class LobbyNotifier extends Notifier<LobbyState> {
  @override
  LobbyState build() => LobbyState.empty();

  void changePeriod(DashboardPeriod period) {
    state = state.copyWith(period: period);
  }
}

final lobbyProvider = NotifierProvider<LobbyNotifier, LobbyState>(
  LobbyNotifier.new,
);
