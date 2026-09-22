import 'package:flutter/foundation.dart';

@immutable
class SplashState {
  final double progress;
  final String statusText;
  final bool isCompleted;

  const SplashState({
    required this.progress,
    required this.statusText,
    required this.isCompleted,
  });

  factory SplashState.initial() => const SplashState(
        progress: 0.0,
        statusText: 'Initializing Secure Runtime...',
        isCompleted: false,
      );

  SplashState copyWith({
    double? progress,
    String? statusText,
    bool? isCompleted,
  }) {
    return SplashState(
      progress: progress ?? this.progress,
      statusText: statusText ?? this.statusText,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}

sealed class SplashAction {
  const SplashAction();
}

class SplashStartTelemetryAction extends SplashAction {
  const SplashStartTelemetryAction();
}

class SplashStepProgressAction extends SplashAction {
  final double progress;
  final String statusText;
  const SplashStepProgressAction(this.progress, this.statusText);
}

class SplashCompleteTelemetryAction extends SplashAction {
  const SplashCompleteTelemetryAction();
}
