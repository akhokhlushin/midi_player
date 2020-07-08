import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:midi_player/features/player/data/model/replic_model.dart';
import 'package:midi_player/features/player/domain/usecases/get_time_codes_from_midi_file.dart';
import 'package:midi_player/features/player/domain/usecases/play_music_and_replics.dart';

part 'player_event.dart';
part 'player_state.dart';

class PlayerBloc extends Bloc<PlayerEvent, PlayerState> {

  final GetTimeCodesFromMidiFile _getTimeCodesFromMidiFile;
  final PlayMusicAndReplics _playMusicAndReplics;

  PlayerBloc(this._getTimeCodesFromMidiFile, this._playMusicAndReplics);

  @override
  PlayerState get initialState => PlayerInitial();

  @override
  Stream<PlayerState> mapEventToState(
    PlayerEvent event,
  ) async* {
    if (event is InitialisePlayer) {

      yield PlayerLoading();

      final timeCodes = await _getTimeCodesFromMidiFile(
        GetTimeCodesFromMidiFileParams(
          midiFilePath: event.midiFilePath,
          songPath: event.songPath1,
          songP: event.songPath2,
        ),
      );

      yield await timeCodes.fold(
        (failure) => PlayerFailure(failure.message),
        (times) async {
          final playMusicOrFailure = await _playMusicAndReplics(
            PlayMusicAndReplicsParams(
              replics: List.generate(
                times.length,
                (index) => ReplicModel(
                  replicPath: 'replics/replic.mp3',
                  time: times[index],
                ),
              ),
              songPath: event.songPath2,
            ),
          );

          return playMusicOrFailure.fold(
            (failure) => PlayerFailure(failure.message),
            (success) => PlayerSuccess(),
          );
        },
      );
    }
  }
}
