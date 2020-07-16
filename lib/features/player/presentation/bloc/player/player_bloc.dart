import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:midi_player/features/player/data/model/replic_model.dart';
import 'package:midi_player/features/player/domain/usecases/get_time_codes_from_midi_file.dart';
import 'package:midi_player/features/player/domain/usecases/play_music_and_replics.dart';
import 'package:rxdart/rxdart.dart';

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
      final timeCodes = await _getTimeCodesFromMidiFile(
        GetTimeCodesFromMidiFileParams(
          midiFilePath: event.midiFilePath,
          songPath: event.songPath1,
        ),
      );

      yield await timeCodes.fold(
        (failure) => PlayerFailure(failure.message),
        (times) async {
          final List<ReplicModel> replics = [];

          for (int i = 0; i < times.length - 1; i += 2) {
            replics.add(
              ReplicModel(
                  replicPath: 'replics/replic.mp3',
                  timeBefore: times[i],
                  timeAfter: times[i + 1]),
            );
          }
          final playMusicOrFailure = await _playMusicAndReplics(
            PlayMusicAndReplicsParams(
              replics: replics,
              songPath: event.songPath2,
              volumeMusic: event.volumeMusic,
              volumeReplic: event.volumeReplic,
              replicGap: event.replicGap,
            ),
          );

          return playMusicOrFailure.fold(
            (failure) => PlayerFailure(failure.message),
            (success) => PlayerInitial(),
          );
        },
      );
    }
  }
}
