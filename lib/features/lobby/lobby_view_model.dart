import 'package:flutter/foundation.dart';
import 'lobby_analytical_mock_data.dart';
import 'lobby_contract.dart';

class LobbyViewModel extends ValueNotifier<LobbyState> {
  LobbyViewModel()
      : super(LobbyAnalyticalMockData.stateForPeriod(DashboardPeriod.today));

  void dispatch(LobbyAction action) {
    switch (action) {
      case LobbyChangePeriodAction(:final period):
        value = LobbyAnalyticalMockData.stateForPeriod(period);
    }
  }
}
