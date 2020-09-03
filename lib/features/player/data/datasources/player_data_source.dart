import 'dart:async';

import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:midi_player/features/player/domain/entities/midi_event.dart';
import 'package:midi_player/features/player/domain/entities/replic.dart';
import 'package:rxdart/rxdart.dart';

abstract class PlayerDataSource {
  Future<void> play({
    List<Replic> replics,
    BehaviorSubject<double> volumeReplic,
    BehaviorSubject<int> replicGap,
    BehaviorSubject<bool> playButton,
    String songPath,
    BehaviorSubject<double> volumeMusic,
    Stream<MidiEventEntity> onMidiEvents,
  });

  // Pauses both music and replics. Can continue via 2 recent functions call
  Future<void> pause({
    BehaviorSubject<bool> playButton,
  });

  /// Continue to play music and replics
  Future<void> resume({
    List<Replic> replics,
    BehaviorSubject<double> volumeReplic,
    BehaviorSubject<int> replicGap,
    BehaviorSubject<bool> playButton,
    String songPath,
    BehaviorSubject<double> volumeMusic,
    Stream<MidiEventEntity> onMidiEvents,
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

  int lastReplicCount = 0;
  int lastReplicGap = 0;
  Stopwatch stopwatch = Stopwatch();
  Duration lastDurationOf1AudioPlayer = Duration.zero;

  @override
  Future<void> pause({
    BehaviorSubject<bool> playButton,
  }) async {
    playButton.add(true);

    await _audioPlayer1.pause();

    if (_audioPlayer2.state == AudioPlayerState.PLAYING) {
      await _audioPlayer2.pause();
    }
  }

  @override
  Future<void> play({
    List<Replic> replics,
    BehaviorSubject<double> volumeReplic,
    BehaviorSubject<int> replicGap,
    BehaviorSubject<bool> playButton,
    String songPath,
    BehaviorSubject<double> volumeMusic,
    Stream<MidiEventEntity> onMidiEvents,
  }) async {
    _audioPlayer1.stop();
    _audioPlayer2.stop();

    lastReplicCount = 0;

    playButton.add(false);

    volumeMusic.stream.listen((value) {
      _audioPlayer1.setVolume(value);
    });

    volumeReplic.stream.listen((value) {
      _audioPlayer2.setVolume(value);
    });

    playButton.listen((value) {
      if (value) {
        stopwatch.stop();
      }
    });

    await _audioCache1.play(songPath);

    await _playReplics(
      0,
      playButton,
      replics,
      volumeReplic,
      replicGap,
      onMidiEvents,
    );
  }

  @override
  Future<void> resume({
    List<Replic> replics,
    BehaviorSubject<double> volumeReplic,
    BehaviorSubject<int> replicGap,
    BehaviorSubject<bool> playButton,
    String songPath,
    BehaviorSubject<double> volumeMusic,
    Stream<MidiEventEntity> onMidiEvents,
  }) async {
    playButton.add(false);

    playButton.listen((value) {
      if (value) {
        stopwatch.stop();
      }
    });

    await _audioCache1.play(songPath);

    volumeMusic.stream.listen((value) {
      _audioPlayer1.setVolume(value);
    });

    volumeReplic.stream.listen((value) {
      _audioPlayer2.setVolume(value);
    });

    final lastDurationPassed = stopwatch.elapsed;

    final lastPlayedReplic = replics[lastReplicCount];

    if (lastPlayedReplic.timeBefore + lastPlayedReplic.timeAfter >
        lastDurationPassed) {
      if ((lastPlayedReplic.timeBefore * lastReplicGap) < lastDurationPassed) {
        await Future.delayed(
            lastDurationPassed - (lastPlayedReplic.timeBefore * lastReplicGap));
      } else {
        await Future.delayed(lastDurationPassed -
            ((lastPlayedReplic.timeBefore * lastReplicGap) +
                (lastPlayedReplic.timeAfter * lastReplicGap)));
      }
    } else {
      if (lastPlayedReplic.timeBefore < lastDurationPassed) {
        await Future.delayed(lastDurationPassed - lastPlayedReplic.timeBefore);
      } else {
        await Future.delayed(lastDurationPassed -
            (lastPlayedReplic.timeBefore + lastPlayedReplic.timeAfter));
      }
    }

    if (_audioPlayer2.state == AudioPlayerState.PAUSED) {
      await _audioPlayer2.resume();
    }

    await _playReplics(lastReplicCount + 1, playButton, replics, volumeReplic,
        replicGap, onMidiEvents);
  }

  Future<void> _playReplic(String replicPath, double volume) async {
    await _audioCache2.play(replicPath);

    await _audioPlayer2.setVolume(volume);
  }

  Future<void> _playReplics(
    int lastCount,
    BehaviorSubject<bool> playButton,
    List<Replic> replics,
    BehaviorSubject<double> volumeReplic,
    BehaviorSubject<int> replicGap,
    Stream<MidiEventEntity> onMidiEvents,
  ) async {
    int i = lastCount;
    int replicCount = lastCount;
    int replicCountForFive = 0;

    await for (final _ in onMidiEvents) {
      final replic = replics[replicCount];

      lastReplicCount = i;

      if (playButton.value) {
        break;
      }

      final volume = volumeReplic.value;

      if (replicGap.value != 1) {
        if (replicGap.value != 5) {
          if ((i + 1) % replicGap.value != 0) {
            await _playReplic(replic.replicPath, volume);
          } else {
            replicCount--;
          }
        } else {
          if ((i + 1) - (4 * replicCountForFive) == 1) {
            await _playReplic(replic.replicPath, volume);
          }
        }
      } else {
        await _playReplic(replic.replicPath, volume);
      }

      if (playButton.value) {
        break;
      }

      if ((i + 1) - (4 * replicCountForFive) == 1) {
        replicCountForFive++;
      }

      i++;
      replicCount++;
    }

    playButton.add(true);

    _audioPlayer1.stop();
  }
}
