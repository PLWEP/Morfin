import 'dart:async';
import 'package:flutter/foundation.dart';
import 'splash_contract.dart';

class SplashViewModel extends ValueNotifier<SplashState> {
  SplashViewModel() : super(SplashState.initial());

  Timer? _sequenceTimer;

  static const List<Map<String, dynamic>> _steps = [
    {'text': 'Establishing WebSocket Secure tunnel...', 'progress': 0.35},
    {'text': 'Synchronizing schema & metadata cache...', 'progress': 0.68},
    {'text': 'Validating operational auth token...', 'progress': 0.88},
    {'text': 'Connected. Initializing Workspace...', 'progress': 1.00},
  ];

  int _currentStep = 0;

  void dispatch(SplashAction action) {
    switch (action) {
      case SplashStartTelemetryAction():
        _startSequence();
      case SplashStepProgressAction(:final progress, :final statusText):
        value = value.copyWith(progress: progress, statusText: statusText);
      case SplashCompleteTelemetryAction():
        value = value.copyWith(isCompleted: true);
    }
  }

  void _startSequence() {
    _sequenceTimer?.cancel();
    _currentStep = 0;
    _sequenceTimer = Timer.periodic(const Duration(milliseconds: 700), (timer) {
      if (_currentStep < _steps.length) {
        final step = _steps[_currentStep];
        dispatch(SplashStepProgressAction(
          step['progress'] as double,
          step['text'] as String,
        ));
        _currentStep++;
      } else {
        timer.cancel();
        dispatch(const SplashCompleteTelemetryAction());
      }
    });
  }

  @override
  void dispose() {
    _sequenceTimer?.cancel();
    super.dispose();
  }
}
