import 'dart:async';

import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:rxdart/rxdart.dart';

abstract class PlayerDataSource {
  // Starts playing music from assets
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

// Stops playing music

  Future<void> stopMusic();

  // Gets current audioplayer state

  Future<AudioPlayerState> getAudioPlayerState();
}

class PlayerDataSourceImpl extends PlayerDataSource {
  final AudioPlayer _audioPlayer1;
  final AudioPlayer _audioPlayer2;
  AudioCache _audioCache1;
  AudioCache _audioCache2;

  PlayerDataSourceImpl(
    this._audioPlayer1,
    this._audioPlayer2,
  ) {
    _audioCache1 = AudioCache(fixedPlayer: _audioPlayer1);
    _audioCache2 = AudioCache(fixedPlayer: _audioPlayer2);
  }

  @override
  Future<void> pauseMusic() async {
    await _audioPlayer1.pause();
  }

  @override
  Future<void> pauseReplic() async {
    if (_audioPlayer2.state == AudioPlayerState.PLAYING) {
      await _audioPlayer2.pause();
    }
  }

  @override
  Future<void> playMusic(
      {String songPath, BehaviorSubject<double> volumeMusic}) async {
    volumeMusic.listen((value) async {
      await _audioPlayer1.setVolume(value);
    });

    await _audioCache1.play(songPath);
  }

  @override
  Future<void> playReplic(
      {String replicPath, BehaviorSubject<double> volumeReplic}) async {
    volumeReplic.listen((value) async {
      await _audioPlayer1.setVolume(value);
    });

    await _audioCache2.play(replicPath);
  }

  @override
  Future<void> resumeMusic({BehaviorSubject<double> volumeMusic}) async {
    volumeMusic.listen((value) async {
      await _audioPlayer1.setVolume(value);
    });

    await _audioPlayer1.resume();
  }

  @override
  Future<void> resumeReplic({BehaviorSubject<double> volumeReplic}) async {
    volumeReplic.listen((value) async {
      await _audioPlayer1.setVolume(value);
    });

    if (_audioPlayer2.state == AudioPlayerState.PAUSED) {
      await _audioPlayer2.resume();
    }
  }

  @override
  Future<void> stopReplic() async {
    await _audioPlayer2.stop();
  }

  @override
  Future<AudioPlayerState> getAudioPlayerState() async {
    return _audioPlayer2.state;
  }

  @override
  Future<void> stopMusic() async {
    await _audioPlayer1.stop();
  }
}
