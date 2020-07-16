import 'package:flutter/cupertino.dart';
import 'package:midi_player/core/errors/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:midi_player/core/usecase.dart';
import 'package:midi_player/features/player/domain/entities/replic.dart';
import 'package:midi_player/features/player/domain/repositories/player_repository.dart';
import 'package:rxdart/rxdart.dart';

class PlayMusicAndReplics extends UseCase<void, PlayMusicAndReplicsParams> {
  final PlayerRepository _repository;

  PlayMusicAndReplics(this._repository);

  @override
  Future<Either<Failure, void>> call(PlayMusicAndReplicsParams params) {
    return _repository.playMusicAndReplics(
      replics: params.replics,
      songPath: params.songPath,
      volumeMusic: params.volumeMusic,
      volumeReplic: params.volumeReplic,
      replicGap: params.replicGap,
    );
  }
}

class PlayMusicAndReplicsParams {
  final List<Replic> replics;
  final String songPath;
  final BehaviorSubject<double> volumeMusic;
  final BehaviorSubject<double> volumeReplic;
  final BehaviorSubject<double> replicGap;

  PlayMusicAndReplicsParams({
    @required this.replics,
    @required this.songPath,
    @required this.volumeMusic,
    @required this.volumeReplic,
    @required this.replicGap,
  });
}
