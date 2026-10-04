import 'package:audioplayers/audioplayers.dart';

class AlarmAudioService {
  AlarmAudioService._();

  static final AlarmAudioService instance = AlarmAudioService._();

  final AudioPlayer _player = AudioPlayer();

  Future<void> initialize() async {
    await _player.setReleaseMode(ReleaseMode.loop);
  }

  Future<void> play(String sound) async {
    await _player.stop();
    await _player.setReleaseMode(ReleaseMode.loop);
    await _player.play(
      AssetSource('sounds/$sound'),
    );
  }

  Future<void> stop() async {
    await _player.stop();
  }
}