import 'dart:async';

import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:rxdart/rxdart.dart';

abstract class PlayerDataSource {
  // Starts playing replic from assets

  Future<void> playReplic({
    String replicPath,
    BehaviorSubject<double> volumeReplic,
  });

  // Pauses replic in current location

  Future<void> pauseReplic();

  // Resumes replic

  Future<void> resumeReplic({
    BehaviorSubject<double> volumeReplic,
  });

  // Stops playing replic

  Future<void> stopReplic();

  // Gets current audioplayer state

  Future<AudioPlayerState> getAudioPlayerState();
}

class PlayerDataSourceImpl extends PlayerDataSource {
  final AudioPlayer _audioPlayer;
  AudioCache _audioCache;

  // Use of API
  // TODO: Change code for getting and playing music from API

  PlayerDataSourceImpl(
    this._audioPlayer,
  ) {
    _audioCache = AudioCache(fixedPlayer: _audioPlayer);
  }

  @override
  Future<void> pauseReplic() async {
    if (_audioPlayer.state == AudioPlayerState.PLAYING) {
      await _audioPlayer.pause();
    }
  }

  @override
  Future<void> playReplic(
      {String replicPath, BehaviorSubject<double> volumeReplic}) async {
    volumeReplic.listen((value) async {
      await _audioPlayer.setVolume(value);
    });

    final volume = volumeReplic.value;

    await _audioCache.play(replicPath);

    await _audioPlayer.setVolume(volume);
  }

  @override
  Future<void> resumeReplic({BehaviorSubject<double> volumeReplic}) async {
    volumeReplic.listen((value) async {
      await _audioPlayer.setVolume(value);
    });

    if (_audioPlayer.state == AudioPlayerState.PAUSED) {
      await _audioPlayer.resume();
    }
  }

  @override
  Future<void> stopReplic() async {
    await _audioPlayer.stop();
  }

  @override
  Future<AudioPlayerState> getAudioPlayerState() async {
    return _audioPlayer.state;
  }
}
