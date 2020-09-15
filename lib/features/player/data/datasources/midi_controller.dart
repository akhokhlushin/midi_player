import 'package:flutter/cupertino.dart';
import 'package:flutter/scheduler.dart';
import 'package:just_audio/just_audio.dart';
import 'package:midi_player/features/player/domain/entities/player_data.dart';
import 'package:rxdart/rxdart.dart';
import 'package:midi_player/core/extensions/duration.dart';
import 'package:midi_player/core/extensions/list.dart';

class MidiController {
  final AudioPlayer _audioPlayer;

  PlayerData _playerData;

  BehaviorSubject<bool> _playVariation;
  BehaviorSubject<int> _gap;
  BehaviorSubject<double> _volume;

  int _replicIndex = 0;

  List<Duration> _durations;

  Ticker _ticker;

  MidiController(this._audioPlayer);

  Future<void> setup({
    @required PlayerData data,
    @required BehaviorSubject<int> gap,
    @required BehaviorSubject<double> volume,
    @required BehaviorSubject<bool> playVariation,
  }) async {
    _playerData ??= data;
    _gap = gap;
    _playVariation = playVariation;
    _volume = volume;

    Duration d = Duration.zero;

    final replics = data.replics;

    _durations = List.generate(replics.length, (index) {
      if (index == 0) {
        return d += replics[index].timeBefore;
      } else {
        return d += replics[index - 1].timeAfter + replics[index].timeBefore;
      }
    });

    _volume.listen((value) {
      _audioPlayer.setVolume(value);
    });

    _ticker = Ticker((elapsed) async {
      if (_durations.containsNearest(elapsed)) {
        await _playReplic();
      }
    });

    await _audioPlayer.load(
      ConcatenatingAudioSource(
        children: data.replics
            .map(
              (e) => AudioSource.uri(
                Uri.parse(
                  'asset:///${e.replicPath}',
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  Future<void> play() async {
    _ticker.start();
  }

  Future<void> resume() async {
    _ticker.start();

    if (_borders.containsBinary(_replicIndex)) {
      await _audioPlayer.play();
    }

    _audioPlayer.stop();
  }

  Future<void> pause() async {
    _ticker.stop();

    await _audioPlayer.pause();
  }

  Future<void> reset() async {
    _replicIndex = 0;

    _ticker.stop(canceled: true);

    _ticker.start();

    await _audioPlayer.stop();
  }

  List<int> get _borders => _playerData.getBordersByIndex(_gap.value);

  Future<void> _playReplic() async {
    await _audioPlayer.seek(Duration.zero, index: _replicIndex);

    if (_borders.containsBinary(_replicIndex)) {
      if (_playVariation.value) {
        if (!_audioPlayer.playerState.playing) {
          await _audioPlayer.play();
        }
      } else {
        if (_audioPlayer.playerState.playing) {
          await _audioPlayer.stop();
        }

        await _audioPlayer.play();
      }
    }

    _audioPlayer.stop();

    _replicIndex++;
  }
}
