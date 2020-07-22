import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:midi_player/features/player/data/model/replic_model.dart';
import 'package:midi_player/features/player/domain/usecases/get_replic_durations.dart';
import 'package:midi_player/features/player/domain/usecases/get_replics_path.dart';
import 'package:midi_player/features/player/domain/usecases/get_time_codes_from_midi_file.dart';
import 'package:midi_player/features/player/domain/usecases/play_music_and_replics.dart';
import 'package:rxdart/rxdart.dart';

part 'player_event.dart';
part 'player_state.dart';

class PlayerBloc extends Bloc<PlayerEvent, PlayerState> {
  final GetTimeCodesFromMidiFile _getTimeCodesFromMidiFile;
  final PlayMusicAndReplics _playMusicAndReplics;
  final GetReplicsPath _getReplicsPath;
  final GetReplicsDurations _getReplicsDurations;

  PlayerBloc(this._getTimeCodesFromMidiFile, this._playMusicAndReplics,
      this._getReplicsPath, this._getReplicsDurations);

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
        ),
      );

      yield await timeCodes.fold(
        (failure) => PlayerFailure(failure.message),
        (times) async {
          final List<ReplicModel> replics = [];

          final pathsOrFailure = await _getReplicsPath(times.length);

          return await pathsOrFailure.fold(
            (failure) => PlayerFailure(failure.message),
            (paths) async {
              final durationsOrFailure = await _getReplicsDurations(paths);

              return await durationsOrFailure.fold(
                (failure) => PlayerFailure(failure.message),
                (durations) async {
                  final List<ReplicModel> replics = List.generate(
                    durations.length,
                    (index) => ReplicModel(
                      replicPath: paths[index],
                      timeBefore: times[index][0],
                      timeAfter: times[index][1],
                      replicDuration: durations[index],
                    ),
                  );

                  final playOrFailure = await _playMusicAndReplics(
                    PlayMusicAndReplicsParams(
                      replics: replics,
                      songPath: event.songPath2,
                      volumeMusic: event.volumeMusic,
                      volumeReplic: event.volumeReplic,
                      replicGap: event.replicGap,
                      timeAfterStream: event.timeAfterStream,
                      timeBeforeStream: event.timeBeforeStream,
                    ),
                  );

                  return playOrFailure.fold(
                    (failure) => PlayerFailure(failure.message),
                    (success) => PlayerInitial(),
                  );
                },
              );
            },
          );
        },
      );
    }
  }
}
