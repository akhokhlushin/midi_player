import 'dart:async';

import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:midi_player/core/constants.dart';
import 'package:midi_player/features/player/domain/entities/replic.dart';
import 'package:rxdart/rxdart.dart';

abstract class PlayerDataSource {
  /// Play music in assets
  Future<void> playMusic({
    String songPath,
    BehaviorSubject<double> volumeMusic,
  });

  // Wait timeBefore, plays replic and waits timeAfter
  Future<void> playReplics({
    List<Replic> replics,
    BehaviorSubject<double> volumeReplic,
    BehaviorSubject<int> replicGap,
    BehaviorSubject<bool> playButton,
  });

  // Pauses both music and replics. Can continue via 2 recent functions call
  Future<void> pause({
    BehaviorSubject<bool> playButton,
  });
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
  Future<void> playMusic({
    String songPath,
    BehaviorSubject<double> volumeMusic,
  }) async {
    final streamMusic = volumeMusic.stream.listen((value) {
      _audioPlayer1.setVolume(value);
    });

    return Future.wait([
      if (_audioPlayer1.state == AudioPlayerState.PAUSED)
        _audioPlayer1.resume()
      else
        _audioCache1.play(songPath),
      streamMusic.cancel(),
    ]);
  }

  @override
  Future<void> pause({
    BehaviorSubject<bool> playButton,
  }) {
    playButton.add(true);

    return Future.wait([
      _audioPlayer1.pause(),
      if (_audioPlayer2.state == AudioPlayerState.PLAYING)
        _audioPlayer2.pause(),
    ]);
  }

  @override
  Future<void> playReplics({
    List<Replic> replics,
    BehaviorSubject<double> volumeReplic,
    BehaviorSubject<int> replicGap,
    BehaviorSubject<bool> playButton,
  }) async {
    volumeReplic.stream.listen((value) {
      _audioPlayer2.setVolume(value);
    });

    playButton.listen((value) {
      if (value) {
        throw 'stop';
      }
    });

    for (int i = 0; i < replics.length; i++) {
      final replic = replics[i];

      await _audioCache2.load(replic.replicPath);

      for (int count = 0; count <= replicGap.value; count++) {
        if (count == replicGap.value) {
          final stopwatch = Stopwatch();

          stopwatch.start();

          await Future.delayed(replic.timeBefore);

          final volume = volumeReplic.value;

          await _audioCache2.play(replic.replicPath);
          await _audioPlayer2.setVolume(volume);

          stopwatch.stop();

          logger.d('Execution time: ${stopwatch.elapsed}');

          await Future.delayed(
              replic.timeAfter - (stopwatch.elapsed - replic.timeBefore));

          break;
        } else {
          logger.d(count);
          await Future.delayed(replic.timeBefore);
          await Future.delayed(replic.replicDuration);
          await Future.delayed(replic.timeAfter);
        }
      }
    }
  }
}
