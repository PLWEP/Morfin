import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class IndustrialFeedbackService {
  static final IndustrialFeedbackService instance = IndustrialFeedbackService._();
  final AudioPlayer _player = AudioPlayer();
  bool isSoundEnabled = true;
  bool isHapticsEnabled = true;

  IndustrialFeedbackService._() {
    _player.setReleaseMode(ReleaseMode.stop);
  }

  Future<void> playSuccess() async {
    if (isHapticsEnabled) {
      await HapticFeedback.lightImpact();
    }
    if (!isSoundEnabled) return;
    try {
      await _player.stop();
      await _player.play(AssetSource('audio/success.mp3'));
    } catch (e) {
      debugPrint('IndustrialFeedbackService.playSuccess fallback: $e');
      await SystemSound.play(SystemSoundType.click);
    }
  }

  Future<void> playError() async {
    if (isHapticsEnabled) {
      await HapticFeedback.heavyImpact();
    }
    if (!isSoundEnabled) return;
    try {
      await _player.stop();
      await _player.play(AssetSource('audio/error.mp3'));
    } catch (e) {
      debugPrint('IndustrialFeedbackService.playError fallback: $e');
      await SystemSound.play(SystemSoundType.alert);
    }
  }

  Future<void> playScan() async {
    if (isHapticsEnabled) {
      await HapticFeedback.selectionClick();
    }
    if (!isSoundEnabled) return;
    try {
      await _player.stop();
      await _player.play(AssetSource('audio/success.mp3'));
    } catch (e) {
      await SystemSound.play(SystemSoundType.click);
    }
  }

  void dispose() {
    _player.dispose();
  }
}
