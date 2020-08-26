import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:midi_player/features/player/domain/entities/midi_event.dart';
import 'package:midi_player/features/player/domain/entities/replic.dart';
import 'package:midi_player/features/player/domain/usecases/resume.dart';
import 'package:rxdart/rxdart.dart';

part 'resume_event.dart';
part 'resume_state.dart';

class ResumeBloc extends Bloc<ResumeEvent, ResumeState> {
  final Resume _resume;

  ResumeBloc(this._resume);

  @override
  Stream<ResumeState> mapEventToState(
    ResumeEvent event,
  ) async* {
    if (event is Restart) {
      await _resume(
        ResumeParams(
          replics: event.replics,
          onMidiEvents: event.onMidiEvents,
          songPath: event.songPath,
          volumeMusic: event.volumeMusic,
          volumeReplic: event.volumeReplic,
          replicGap: event.replicGap,
          player: event.player,
        ),
      );
    }
  }

  @override
  ResumeState get initialState => ResumeInitial();
}
