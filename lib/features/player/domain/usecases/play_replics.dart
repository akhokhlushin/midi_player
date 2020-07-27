import 'package:flutter/cupertino.dart';
import 'package:midi_player/core/errors/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:midi_player/core/usecase.dart';
import 'package:midi_player/features/player/domain/entities/replic.dart';
import 'package:midi_player/features/player/domain/repositories/player_repository.dart';
import 'package:rxdart/rxdart.dart';

class PlayReplics extends UseCase<void, PlayReplicsParams> {
  final PlayerRepository _repository;

  PlayReplics(this._repository);

  @override
  Future<Either<Failure, void>> call(PlayReplicsParams params) {
    return _repository.playReplics(
      playButton: params.player,
      replicGap: params.replicGap,
      replics: params.replics,
      volumeReplic: params.volumeReplic,
    );
  }
}

class PlayReplicsParams {
  final List<Replic> replics;
  // final String songPath;
  // final BehaviorSubject<double> volumeMusic;
  final BehaviorSubject<double> volumeReplic;
  final BehaviorSubject<int> replicGap;
  final BehaviorSubject<bool> player;

  PlayReplicsParams({
    @required this.replics,
    @required this.volumeReplic,
    @required this.replicGap,
    @required this.player,
  });
}
