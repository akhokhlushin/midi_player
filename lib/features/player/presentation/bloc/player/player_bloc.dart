import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:midi_player/features/player/domain/entities/replic.dart';
import 'package:midi_player/features/player/domain/usecases/play_music.dart';
import 'package:midi_player/features/player/domain/usecases/play_replics.dart';
import 'package:rxdart/rxdart.dart';

part 'player_event.dart';
part 'player_state.dart';

class PlayerBloc extends Bloc<PlayerEvent, PlayerState> {
  final PlayMusic _playMusic;
  final PlayReplics _playReplics;

  PlayerBloc(
    this._playMusic,
    this._playReplics,
  );

  @override
  PlayerState get initialState => PlayerInitial();

  @override
  Stream<PlayerState> mapEventToState(
    PlayerEvent event,
  ) async* {
    if (event is Play) {
      await _playMusic(
        PlayMusicParams(
          songPath: event.songPath,
          volumeMusic: event.volumeMusic,
        ),
      );
      await _playReplics(
        PlayReplicsParams(
          replics: event.replics,
          volumeReplic: event.volumeReplic,
          replicGap: event.replicGap,
          player: event.player,
        ),
      );
    }
  }
}
