import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:midi_player/features/player/domain/usecases/get_audio_player_state.dart';
import 'package:midi_player/features/player/domain/usecases/pause_music.dart';
import 'package:midi_player/features/player/domain/usecases/pause_replic.dart';
import 'package:midi_player/features/player/domain/usecases/play_music.dart';
import 'package:midi_player/features/player/domain/usecases/play_replic.dart';
import 'package:midi_player/features/player/domain/usecases/resume_music.dart';
import 'package:midi_player/features/player/domain/usecases/resume_replic.dart';
import 'package:midi_player/features/player/domain/usecases/stop_music.dart';
import 'package:midi_player/features/player/domain/usecases/stop_replic.dart';
import 'package:rxdart/rxdart.dart';

part 'player_event.dart';
part 'player_state.dart';

class PlayerBloc extends Bloc<PlayerEvent, PlayerState> {
  final PlayMusic _playMusic;
  final PlayReplic _playReplic;
  final PauseMusic _pauseMusic;
  final PauseReplic _pauseReplic;
  final ResumeMusic _resumeMusic;
  final ResumeReplic _resumeReplic;
  final GetAudioPlayerState _getAudioPlayerState;
  final StopReplic _stopReplic;
  final StopMusic _stopMusic;

  PlayerBloc(
    this._playMusic,
    this._playReplic,
    this._pauseMusic,
    this._pauseReplic,
    this._resumeMusic,
    this._resumeReplic,
    this._getAudioPlayerState,
    this._stopReplic,
    this._stopMusic,
  );

  @override
  Stream<PlayerState> mapEventToState(
    PlayerEvent event,
  ) async* {
    if (event is PlayMusicE) {
      await _playMusic(
        PlayMusicParams(
          songPath: event.songPath,
          volume: event.volume,
        ),
      );
    } else if (event is PlayReplicE) {
      final audioStateOrFailure = await _getAudioPlayerState(NoParams());

      yield await audioStateOrFailure.fold(
        (failure) => PlayerFailure(message: failure.message),
        (state) async {
          if (event.variousOfPlay.value) {
            if (state != AudioPlayerState.PLAYING) {
              await _playReplic(
                PlayReplicParams(
                  path: event.replicPath,
                  volume: event.volume,
                ),
              );
            }
          } else {
            if (state == AudioPlayerState.PLAYING) {
              await _stopReplic(NoParams());

              await _playReplic(
                PlayReplicParams(
                  path: event.replicPath,
                  volume: event.volume,
                ),
              );
            } else {
              await _playReplic(
                PlayReplicParams(
                  path: event.replicPath,
                  volume: event.volume,
                ),
              );
            }
          }
          return PlayerInitial();
        },
      );
    } else if (event is PauseE) {
      await _pauseMusic(NoParams());
      await _pauseReplic(NoParams());
    } else if (event is ResumeMusicE) {
      await _resumeMusic(event.volume);
    } else if (event is ResumeReplicE) {
      await _resumeReplic(event.volume);
    } else if (event is StopE) {
      await _stopReplic(NoParams());
      await _stopMusic(NoParams());
    }
  }

  @override
  PlayerState get initialState => PlayerInitial();
}
