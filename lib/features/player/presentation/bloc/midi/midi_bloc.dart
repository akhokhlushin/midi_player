import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:midi_player/features/player/domain/entities/music.dart';
import 'package:midi_player/features/player/domain/entities/replic.dart';
import 'package:midi_player/features/player/domain/usecases/get_bit_amount.dart';
import 'package:midi_player/features/player/domain/usecases/get_replic_durations.dart';
import 'package:midi_player/features/player/domain/usecases/get_replics_path.dart';
import 'package:midi_player/features/player/domain/usecases/get_time_codes_from_midi_file.dart';

part 'midi_event.dart';
part 'midi_state.dart';

class MidiBloc extends Bloc<MidiEvent, MidiState> {
  final GetReplicsDurations _getReplicsDurations;
  final GetReplicsPath _getReplicsPath;
  final GetTimeCodesFromMidiFile _getTimeCodesFromMidiFile;
  final GetBitAmount _getBitAmount;

  MidiBloc(this._getReplicsDurations, this._getReplicsPath,
      this._getTimeCodesFromMidiFile, this._getBitAmount);

  @override
  MidiState get initialState => MidiInitial();

  @override
  Stream<MidiState> mapEventToState(
    MidiEvent event,
  ) async* {
    if (event is InitialiseMidi) {
      yield MidiLoading();

      final timeCodes = await _getTimeCodesFromMidiFile(event.midiFilePath);

      yield await timeCodes.fold(
        (failure) => MidiFailure(failure.message),
        (times) async {
          final pathsOrFailure = await _getReplicsPath(times.length);

          return await pathsOrFailure.fold(
            (failure) => MidiFailure(failure.message),
            (paths) async {
              final durationsOrFailure = await _getReplicsDurations(paths);

              return await durationsOrFailure.fold(
                (failure) => MidiFailure(failure.message),
                (durations) async {
                  final bitsOrFailure = await _getBitAmount(event.midiFilePath);

                  return bitsOrFailure.fold(
                      (failure) => MidiFailure(failure.message), (bitAmount) {
                    final List<Replic> replics = List.generate(
                      durations.length,
                      (index) => Replic(
                        replicPath: paths[index],
                        timeBefore: times[index][0],
                        timeAfter: times[index][1],
                        replicDuration: durations[index],
                      ),
                    );

                    final music = Music(bitAmount: bitAmount, replics: replics);

                    return MidiSuccess(music);
                  });
                },
              );
            },
          );
        },
      );
    }
  }
}
