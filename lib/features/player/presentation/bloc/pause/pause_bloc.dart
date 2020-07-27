import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:midi_player/features/player/domain/usecases/pause.dart';
import 'package:rxdart/rxdart.dart';

part 'pause_event.dart';
part 'pause_state.dart';

class PauseBloc extends Bloc<PauseEvent, PauseState> {
  final Pause _pause;

  PauseBloc(this._pause);

  @override
  Stream<PauseState> mapEventToState(
    PauseEvent event,
  ) async* {
    if (event is PauseE) {
      await _pause(event.pause);
    }
  }

  @override
  PauseState get initialState => PauseInitial();
}
