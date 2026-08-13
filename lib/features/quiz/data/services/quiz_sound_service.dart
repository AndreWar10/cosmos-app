import 'package:audioplayers/audioplayers.dart';

import '../../../../core/cache/app_cache.dart';

class QuizSoundService {
  QuizSoundService(this._cache);

  final AppCache _cache;
  static const _soundEnabledKey = 'quiz_sound_enabled';

  final _correctPlayer = AudioPlayer();
  final _wrongPlayer = AudioPlayer();
  final _tickPlayer = AudioPlayer();
  final _completePlayer = AudioPlayer();

  bool get isEnabled => _cache.getString(_soundEnabledKey) != 'false';

  Future<void> setEnabled(bool enabled) async {
    await _cache.setString(_soundEnabledKey, enabled.toString());
  }

  Future<void> playCorrect() async {
    if (!isEnabled) return;
    await _correctPlayer.stop();
    await _correctPlayer.play(AssetSource('sounds/correct.mp3'));
  }

  Future<void> playWrong() async {
    if (!isEnabled) return;
    await _wrongPlayer.stop();
    await _wrongPlayer.play(AssetSource('sounds/wrong.mp3'));
  }

  Future<void> playTick() async {
    if (!isEnabled) return;
    await _tickPlayer.stop();
    await _tickPlayer.play(AssetSource('sounds/tick.mp3'));
  }

  Future<void> playComplete() async {
    if (!isEnabled) return;
    await _completePlayer.stop();
    await _completePlayer.play(AssetSource('sounds/complete.mp3'));
  }

  Future<void> dispose() async {
    await _correctPlayer.dispose();
    await _wrongPlayer.dispose();
    await _tickPlayer.dispose();
    await _completePlayer.dispose();
  }
}
