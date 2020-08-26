import 'package:flutter/cupertino.dart';
import 'package:midi_player/core/errors/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:midi_player/core/usecase.dart';
import 'package:midi_player/features/player/domain/entities/midi_event.dart';
import 'package:midi_player/features/player/domain/entities/replic.dart';
import 'package:midi_player/features/player/domain/repositories/player_repository.dart';
import 'package:rxdart/rxdart.dart';

class Play extends UseCase<void, PlayParams> {
  final PlayerRepository _repository;

  Play(this._repository);

  @override
  Future<Either<Failure, void>> call(PlayParams params) {
    return _repository.play(
        songPath: params.songPath,
        volumeMusic: params.volumeMusic,
        playButton: params.player,
        replicGap: params.replicGap,
        replics: params.replics,
        volumeReplic: params.volumeReplic,
        onMidiEvents: params.onMidiEvents);
  }
}

class PlayParams {
  final List<Replic> replics;
  final String songPath;
  final BehaviorSubject<double> volumeMusic;
  final BehaviorSubject<double> volumeReplic;
  final BehaviorSubject<int> replicGap;
  final BehaviorSubject<bool> player;
  final Stream<MidiEventEntity> onMidiEvents;

  PlayParams({
    @required this.replics,
    @required this.songPath,
    @required this.volumeMusic,
    @required this.volumeReplic,
    @required this.replicGap,
    @required this.player,
    @required this.onMidiEvents,
  });
}
