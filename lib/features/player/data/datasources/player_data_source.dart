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
    BehaviorSubject<bool> playButton,
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
    BehaviorSubject<bool> playButton,
  }) async {
    _audioPlayer1.stop();

    volumeMusic.stream.listen((value) {
      _audioPlayer1.setVolume(value);
    });

    return Future.wait([
      if (_audioPlayer1.state == AudioPlayerState.PAUSED)
        _audioPlayer1.resume()
      else
        _audioCache1.play(songPath),
    ]);
  }

  @override
  Future<void> pause({
    BehaviorSubject<bool> playButton,
  }) {
    playButton.add(!playButton.value);

    return Future.wait([
      _audioPlayer1.pause(),
      if (_audioPlayer2.state == AudioPlayerState.PLAYING)
        _audioPlayer2.pause(),
    ]);
  }

  int lastReplicCount = 0;

  @override
  Future<void> playReplics({
    List<Replic> replics,
    BehaviorSubject<double> volumeReplic,
    BehaviorSubject<int> replicGap,
    BehaviorSubject<bool> playButton,
  }) async {
    _audioPlayer2.stop();

    volumeReplic.stream.listen((value) {
      _audioPlayer2.setVolume(value);
    });

    playButton.add(!playButton.value);

    for (int i = lastReplicCount; i < replics.length; i++) {
      final replic = replics[i];

      lastReplicCount = i;

      await _audioCache2.load(replic.replicPath);

      int replicIndex = 0;

      for (int count = 0; count <= replicGap.value; count++) {
        final replicCurrentIndex = i + replicIndex < replics.length
            ? i + replicIndex
            : (replics.length * (replics.length ~/ (i + replicIndex))) -
                (i + replicIndex);

        final currentReplic = replics[replicCurrentIndex];

        if (count == replicGap.value) {
          if (playButton.value) {
            break;
          }

          await Future.delayed(currentReplic.timeBefore);

          final volume = volumeReplic.value;

          if (_audioPlayer2.state == AudioPlayerState.PLAYING) {
            _audioPlayer2.resume();
          } else {
            await _audioCache2.play(replic.replicPath);
          }
          await _audioPlayer2.setVolume(volume);

          await Future.delayed(currentReplic.timeAfter);

          replicIndex = 0;

          break;
        } else {
          if (playButton.value) {
            break;
          }
          logger.d(count);
          await Future.delayed(currentReplic.timeBefore);
          await Future.delayed(currentReplic.timeAfter);

          replicIndex++;
          if (playButton.value) {
            break;
          }
        }
      }
      if (playButton.value) {
        break;
      }
    }

    playButton.add(true);

    if (_audioPlayer1.state == AudioPlayerState.PLAYING) {
      _audioPlayer1.stop();
    }
  }
}
