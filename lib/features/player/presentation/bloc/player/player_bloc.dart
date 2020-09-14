import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:midi_player/features/catalog/domain/usecases/play_music.dart';
import 'package:midi_player/features/catalog/domain/usecases/resume_music.dart';
import 'package:midi_player/features/catalog/domain/usecases/stop_music.dart';
import 'package:midi_player/features/player/domain/entities/midi_event.dart';
import 'package:midi_player/features/player/domain/usecases/get_audio_player_state.dart';
import 'package:midi_player/features/catalog/domain/usecases/pause_music.dart';
import 'package:midi_player/features/player/domain/usecases/pause_replic.dart';
import 'package:midi_player/features/player/domain/usecases/play_replic.dart';
import 'package:midi_player/features/player/domain/usecases/resume_replic.dart';
import 'package:midi_player/features/player/domain/usecases/stop_replic.dart';
import 'package:rxdart/rxdart.dart';

part 'player_event.dart';
part 'player_state.dart';

class PlayerBloc extends Bloc<PlayerEvent, PlayerState> {
  final PlayReplic _playReplic;
  final PauseReplic _pauseReplic;
  final ResumeReplic _resumeReplic;
  final GetAudioPlayerState _getAudioPlayerState;
  final StopReplic _stopReplic;
  final PlayMusic _playMusic;
  final PauseMusic _pauseMusic;
  final ResumeMusic _resumeMusic;
  final StopMusic _stopMusic;

  // On play replic stream

  final BehaviorSubject<MidiEventEntity> _onPlayStream = BehaviorSubject();

  PlayerBloc(
    this._playReplic,
    this._pauseReplic,
    this._resumeReplic,
    this._getAudioPlayerState,
    this._stopReplic,
    this._playMusic,
    this._pauseMusic,
    this._resumeMusic,
    this._stopMusic,
  );

  @override
  Stream<PlayerState> mapEventToState(
    PlayerEvent event,
  ) async* {
    if (event is PlayReplicE) {
      final audioStateOrFailure = await _getAudioPlayerState(NoParams());

      yield await audioStateOrFailure.fold(
        (failure) => PlayerFailure(message: failure.message),
        (state) async {
          if (event.variousOfPlay.value) {
            if (!state.playing) {
              await _playReplic(
                PlayReplicParams(
                  replicIndex: event.replicIndex,
                  volume: event.volume,
                ),
              );

              _onPlayStream.add(MidiEventEntity());
            }
          } else {
            if (state.playing) {
              await _stopReplic(NoParams());

              await _playReplic(
                PlayReplicParams(
                  replicIndex: event.replicIndex,
                  volume: event.volume,
                ),
              );
            } else {
              await _playReplic(
                PlayReplicParams(
                  replicIndex: event.replicIndex,
                  volume: event.volume,
                ),
              );
            }

            _onPlayStream.add(MidiEventEntity());
          }
          return PlayerInitial();
        },
      );
    } else if (event is PlayMusicE) {
      final playOrFailure = await _playMusic(
        PlayMusicParams(
          songIndex: event.index,
          volume: event.volume,
        ),
      );

      yield playOrFailure.fold(
        (failure) => PlayerFailure(message: failure.message),
        (_) => PlayerPlaying(),
      );
    } else if (event is ResumeMusicE) {
      await _resumeMusic(
        ResumeMusicParams(
          volume: event.volume,
        ),
      );
    } else if (event is PauseE) {
      await _pauseReplic(NoParams());
      await _pauseMusic(NoParams());
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
