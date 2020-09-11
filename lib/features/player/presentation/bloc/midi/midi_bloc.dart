import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:midi_player/features/catalog/domain/entities/song.dart';
import 'package:midi_player/features/player/domain/entities/player_data.dart';
import 'package:midi_player/features/player/domain/usecases/get_events_amount.dart';
import 'package:midi_player/features/player/domain/usecases/get_replics_path.dart';

part 'midi_event.dart';
part 'midi_state.dart';

class MidiBloc extends Bloc<MidiEvent, MidiState> {
  final GetMidiEventsAmount _getMidiEventsAmount;
  final GetMusic _getMusic;

  MidiBloc(this._getMusic, this._getMidiEventsAmount);

  @override
  MidiState get initialState => MidiInitial();

  @override
  Stream<MidiState> mapEventToState(
    MidiEvent event,
  ) async* {
    if (event is InitialiseMidi) {
      yield MidiLoading();

      final eventsAmountOrFailure =
          await _getMidiEventsAmount(event.song.midiFilePath);

      yield await eventsAmountOrFailure.fold(
        (failure) => MidiFailure(failure.message),
        (amount) async {
          final musicOrFailure = await _getMusic(
            GetMusicParams(
              count: amount,
              midiFilePath: event.song.midiFilePath,
            ),
          );

          return await musicOrFailure.fold(
            (failure) => MidiFailure(failure.message),
            (music) => MidiSuccess(
              music,
              event.song,
              event.index,
            ),
          );
        },
      );
    }
  }
}
