import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:rxdart/rxdart.dart';

abstract class MusicDataSource {
  // Starts playing music from assets (or from NOT IMPLEMENTED API)
  Future<void> playMusic({
    String songPath,
    BehaviorSubject<double> volumeMusic,
  });

  // Pauses music in current location

  Future<void> pauseMusic();

  // Resumes music

  Future<void> resumeMusic({
    BehaviorSubject<double> volumeMusic,
  });

// Stops playing music

  Future<void> stopMusic();

  // Gets state of playing music

  Future<Stream<Duration>> getOnDurationChangeStream();
}

class MusicDataSourceImpl extends MusicDataSource {
  final AudioPlayer _audioPlayer;
  AudioCache _audioCache;

  // Use of API
  // TODO: Change code for getting and playing music from API

  MusicDataSourceImpl(
    this._audioPlayer,
  ) {
    _audioCache = AudioCache(fixedPlayer: _audioPlayer);
  }

  @override
  Future<void> pauseMusic() async {
    await _audioPlayer.pause();
  }

  @override
  Future<void> playMusic(
      {String songPath, BehaviorSubject<double> volumeMusic}) async {
    volumeMusic.listen((value) async {
      await _audioPlayer.setVolume(value);
    });

    final path =
        songPath.startsWith('assets/') ? songPath.substring(7) : songPath;

    final volume = volumeMusic.value;

    await _audioCache.play(path);

    await _audioPlayer.setVolume(volume);
  }

  @override
  Future<void> resumeMusic({BehaviorSubject<double> volumeMusic}) async {
    volumeMusic.listen((value) async {
      await _audioPlayer.setVolume(value);
    });

    await _audioPlayer.resume();
  }

  @override
  Future<void> stopMusic() async {
    await _audioPlayer.stop();
  }

  @override
  Future<Stream<Duration>> getOnDurationChangeStream() async {
    return _audioPlayer.onAudioPositionChanged;
  }
}
