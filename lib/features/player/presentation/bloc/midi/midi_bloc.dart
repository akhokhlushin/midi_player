import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:midi_player/core/constants.dart';
import 'package:midi_player/features/player/domain/entities/midi_event.dart';
import 'package:midi_player/features/player/domain/entities/music.dart';
import 'package:midi_player/features/player/domain/usecases/get_events_amount.dart';
import 'package:midi_player/features/player/domain/usecases/get_replics_path.dart';
import 'package:midi_player/features/player/domain/usecases/get_midi_events_stream.dart';
import 'package:rxdart/subjects.dart';

part 'midi_event.dart';
part 'midi_state.dart';

class MidiBloc extends Bloc<MidiEvent, MidiState> {
  final GetMidiEventsAmount _getMidiEventsAmount;
  final GetMusic _getMusic;
  final GetMidiEventsStream _getMidiEventsStream;

  MidiBloc(
      this._getMusic, this._getMidiEventsStream, this._getMidiEventsAmount);

  @override
  MidiState get initialState => MidiInitial();

  @override
  Stream<MidiState> mapEventToState(
    MidiEvent event,
  ) async* {
    if (event is InitialiseMidi) {
      yield MidiLoading();

      final eventsAmountOrFailure = await _getMidiEventsAmount(midiFilePath);

      yield await eventsAmountOrFailure.fold(
        (failure) => MidiFailure(failure.message),
        (amount) async {
          final musicOrFailure = await _getMusic(
            GetMusicParams(
              count: amount,
              midiFilePath: midiFilePath,
            ),
          );

          return await musicOrFailure.fold(
            (failure) => MidiFailure(failure.message),
            (music) async {
              final streamOrFailure = await _getMidiEventsStream(
                GetMidiEventsStreamParams(
                  midiFilePath: midiFilePath,
                  onReplicGapChange: event.replicGap,
                  playButton: event.playButton,
                ),
              );

              return await streamOrFailure.fold(
                (failure) => MidiFailure(failure.message),
                (stream) => MidiSuccess(music, stream),
              );
            },
          );
        },
      );
    }
  }
}
