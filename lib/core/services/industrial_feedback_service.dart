import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class IndustrialFeedbackService {
  static final IndustrialFeedbackService instance = IndustrialFeedbackService._();
  AudioPlayer? _player;
  bool isSoundEnabled = true;
  bool isHapticsEnabled = true;

  IndustrialFeedbackService._();

  AudioPlayer get _audioPlayer {
    if (_player == null) {
      _player = AudioPlayer();
      try {
        _player!.setReleaseMode(ReleaseMode.stop);
      } catch (_) {}
    }
    return _player!;
  }

  Future<void> playSuccess() async {
    if (isHapticsEnabled) {
      try {
        await HapticFeedback.lightImpact();
      } catch (_) {}
    }
    if (!isSoundEnabled) return;
    try {
      await _audioPlayer.stop();
      await _audioPlayer.play(AssetSource('audio/success.mp3'));
    } catch (e) {
      debugPrint('IndustrialFeedbackService.playSuccess fallback: $e');
      try {
        await SystemSound.play(SystemSoundType.click);
      } catch (_) {}
    }
  }

  Future<void> playError() async {
    if (isHapticsEnabled) {
      try {
        await HapticFeedback.heavyImpact();
      } catch (_) {}
    }
    if (!isSoundEnabled) return;
    try {
      await _audioPlayer.stop();
      await _audioPlayer.play(AssetSource('audio/error.mp3'));
    } catch (e) {
      debugPrint('IndustrialFeedbackService.playError fallback: $e');
      try {
        await SystemSound.play(SystemSoundType.alert);
      } catch (_) {}
    }
  }

  Future<void> playScan() async {
    if (isHapticsEnabled) {
      try {
        await HapticFeedback.selectionClick();
      } catch (_) {}
    }
    if (!isSoundEnabled) return;
    try {
      await _audioPlayer.stop();
      await _audioPlayer.play(AssetSource('audio/success.mp3'));
    } catch (e) {
      try {
        await SystemSound.play(SystemSoundType.click);
      } catch (_) {}
    }
  }

  void dispose() {
    try {
      _player?.dispose();
    } catch (_) {}
  }
}
