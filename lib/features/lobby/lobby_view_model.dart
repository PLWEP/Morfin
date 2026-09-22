import 'package:flutter/foundation.dart';
import 'lobby_contract.dart';

class LobbyViewModel extends ValueNotifier<LobbyState> {
  LobbyViewModel() : super(LobbyState.initial());

  void dispatch(LobbyAction action) {
    switch (action) {
      case LobbySelectNavAction(:final index):
        value = value.copyWith(selectedNavIndex: index);

      case LobbyTriggerTacticalAction(:final actionId):
        // Handles tactical dispatch intent
        if (kDebugMode) {
          print('Tactical Action triggered: $actionId');
        }
    }
  }
}
