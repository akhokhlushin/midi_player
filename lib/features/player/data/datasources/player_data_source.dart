import 'dart:async';

import 'package:just_audio/just_audio.dart';
import 'package:midi_player/features/player/domain/entities/replic.dart';
import 'package:rxdart/rxdart.dart';

abstract class PlayerDataSource {
  /// Starts playing replic from assets
  Future<void> playReplic({
    int replicIndex,
    BehaviorSubject<double> volumeReplic,
  });

  /// Pauses replic in current location
  Future<void> pauseReplic();

  /// Resumes replic
  Future<void> resumeReplic({
    BehaviorSubject<double> volumeReplic,
  });

  /// Stops playing replic
  Future<void> stopReplic();

  /// Gets current audioplayer state
  Future<PlayerState> getAudioPlayerState();

  /// Sets all replics to be ready for playing
  Future<void> loadAllReplics({List<Replic> replics});
}

class PlayerDataSourceImpl extends PlayerDataSource {
  final AudioPlayer _audioPlayer;

  // Use of API
  // TODO: Change code for getting and playing music from API

  PlayerDataSourceImpl(
    this._audioPlayer,
  );

  @override
  Future<void> pauseReplic() async {
    await _audioPlayer.pause();
  }

  @override
  Future<void> playReplic(
      {int replicIndex, BehaviorSubject<double> volumeReplic}) async {
    volumeReplic.listen((value) async {
      await _audioPlayer.setVolume(value);
    });

    final volume = volumeReplic.value;

    await _audioPlayer.seek(Duration.zero, index: replicIndex);

    _audioPlayer.play();

    await _audioPlayer.setVolume(volume);

    _audioPlayer.currentIndexStream.listen((event) async {
      if (event == replicIndex + 1) {
        await _audioPlayer.pause();
      }
    });
  }

  @override
  Future<void> resumeReplic({BehaviorSubject<double> volumeReplic}) async {
    volumeReplic.listen((value) async {
      await _audioPlayer.setVolume(value);
    });

    _audioPlayer.play();
  }

  @override
  Future<void> stopReplic() async {
    await _audioPlayer.stop();
  }

  @override
  Future<PlayerState> getAudioPlayerState() async {
    return _audioPlayer.playerState;
  }

  @override
  Future<void> loadAllReplics({List<Replic> replics}) async {
    await _audioPlayer.load(
      ConcatenatingAudioSource(
        children: replics
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
}
