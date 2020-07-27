import 'package:midi_player/core/errors/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:midi_player/core/usecase.dart';
import 'package:midi_player/features/player/domain/repositories/player_repository.dart';
import 'package:rxdart/rxdart.dart';

class Pause extends UseCase<void, BehaviorSubject<bool>> {
  final PlayerRepository _repository;

  Pause(this._repository);

  @override
  Future<Either<Failure, void>> call(BehaviorSubject<bool> params) {
    return _repository.pause(
      playButton: params,
    );
  }
}

// class PlayMusicParams {
//   // final List<Replic> replics;
//   final String songPath;
//   final BehaviorSubject<double> volumeMusic;
//   // final BehaviorSubject<double> volumeReplic;
//   // final BehaviorSubject<double> replicGap;
//   // final BehaviorSubject<bool> player;

//   PlayMusicParams({
//     // @required this.replics,
//     @required this.songPath,
//     @required this.volumeMusic,
//     // @required this.volumeReplic,
//     // @required this.replicGap,
//     // @required this.player,
//   });
// }
